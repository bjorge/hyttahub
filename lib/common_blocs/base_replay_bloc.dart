// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:convert'; // For base64Encode/Decode

import 'package:hyttahub/collection_paths.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter/foundation.dart'; // For compute()
import 'package:protobuf/protobuf.dart'; // For GeneratedMessageneratedMessage

abstract class BaseReplayBloc<S extends GeneratedMessage>
    extends HydratedBloc<CommonReplayBlocEvent, S> {
  BaseReplayBloc(
    super.initialState, {
    BaseHyttaHubStorage? storage,
    required FutureOr<Uint8List> Function(Map<String, dynamic> payload)
    replayIsolateHandler,
    required FutureOr<Uint8List> Function(Map<int, String>)
    hydrateIsolateHandler,

    // Whether to use Flutter isolates via `compute()` for heavy CPU work.
    bool useIsolate = true,
    this.gapTimeout = const Duration(seconds: 5),
  }) : _initialState = initialState,
       _replayIsolateHandler = replayIsolateHandler,
       _hydrateIsolateHandler = hydrateIsolateHandler {
    _useIsolate = useIsolate;

    if (storage != null) {
      _storageOverride = storage;
    }

    on<CommonReplayBlocEvent>(_onEvent);
  }

  final Map<int, String> _eventBuffer = {};
  Timer? _gapTimer;
  Map<int, String> _hydratedEvents = {};
  S? _hydratedState;
  int _lastVersion = 0;

  StreamSubscription? _subscription;
  final S _initialState;
  BaseHyttaHubStorage? _storageOverride;
  BaseHyttaHubStorage get _storage =>
      _storageOverride ?? HyttaHubStorageFactory.getStorage(storageType);
  final FutureOr<Uint8List> Function(Map<String, dynamic> payload)
  _replayIsolateHandler;

  final FutureOr<Uint8List> Function(Map<int, String>) _hydrateIsolateHandler;
  // Whether to use compute() to run handlers in isolates. Default true.
  late final bool _useIsolate;

  final Duration gapTimeout;

  /// Provides the storage type to use for this BLoC.
  StorageEnum get storageType;

  /// Provides the Cloud collection path.
  Future<String?> getCollectionPath();

  // for the firebase collection name (i.e. after the path)
  String get collectionName;

  // for hydrated storage
  @override
  String get id => ':$storageType:$collectionName:${HyttaHubOptions.implementation?.cloudRootCollection}';

  /// Field name for the version in Cloud documents (e.g., 'v' or 'docVersion').
  String get versionField => docVersion;

  /// Field name for the payload in Cloud documents (e.g., 'p' or 'docPayload').
  String get payloadField => docPayload;

  /// Replays new events onto the current state and returns the new state.
  S replayEvents(S currentState, Map<int, String> newEventsData);

  /// Creates a new state S by copying `currentState` and updating its status enum.
  S stateCopyWithStatus(S currentState, CommonReplayStateEnum newStatusEnum);

  /// Gets the events map (Map\<int, String\>) from the state S.
  Map<int, String> stateGetEventsMap(S state);

  /// Creates an instance of state S from protobuf bytes.
  S fromBuffer(Uint8List bytes);

  /// Serializes the state S to protobuf bytes.
  Uint8List toBuffer(S state);

  Future<Map<String, dynamic>?> getFirstEventDocument(
    String collectionPath,
  ) {
    return _storage.getDocument(
      collectionPath,
      firstCollectionEventVersion.toString(),
    );
  }

  // --- Common BLoC Logic ---

  FutureOr<void> _onEvent(CommonReplayBlocEvent event, Emitter<S> emit) async {
    if (event.hasListen()) {
      await _onListenForEvents(event.listen, emit);
    } else if (event.hasNewEvents()) {
      await _onNewEvents(event.newEvents.events, emit);
    }
  }

  Future<void> _onNewEvents(
    Map<int, String> eventsData,
    Emitter<S> emit,
  ) async {
    if (eventsData.remove(0) != null) {
      await _handleGapTimeout(emit);
    }

    // remove all events before the last version
    // do this because firebase fires off many events from its cache at times
    eventsData.removeWhere((key, value) => key <= _lastVersion);

    if (eventsData.isEmpty) {
      return;
    }

    if (kDebugMode) {
      print(
        "BaseReplayBloc: _onNewEvents $S $eventsData _lastVersion: $_lastVersion",
      );
    }

    _eventBuffer.addAll(eventsData);
    await _processBuffer(emit);
  }

  Future<void> _processBuffer(Emitter<S> emit) async {
    final Map<int, String> contiguousEvents = {};
    int nextVersion = _lastVersion + 1;

    while (_eventBuffer.containsKey(nextVersion)) {
      contiguousEvents[nextVersion] = _eventBuffer.remove(nextVersion)!;
      nextVersion++;
    }

    if (contiguousEvents.isNotEmpty) {
      final S newState = await _runReplay(state, contiguousEvents);
      _lastVersion = nextVersion - 1;

      if (isClosed) {
        return;
      }

      // still listening if we got a new event
      emit(
        stateCopyWithStatus(newState.deepCopy(), CommonReplayStateEnum.listening)
          ..freeze(),
      );
    }

    // Handle gaps
    if (_eventBuffer.isNotEmpty) {
      final int minInBuffer =
          _eventBuffer.keys.fold(_eventBuffer.keys.first, (p, e) => e < p ? e : p);

      if (minInBuffer > _lastVersion + 1) {
        if (kDebugMode) {
          print(
            "BaseReplayBloc: Starting gap timer for $gapTimeout",
          );
        }
        _gapTimer ??= Timer(gapTimeout, () {
          if (!isClosed) {
            add(
              CommonReplayBlocEvent(
                newEvents: CommonReplayBlocEvent_NewEvents(events: {0: ''}.entries),
              ),
            );
          }
        });
      }
    } else {
      _gapTimer?.cancel();
      _gapTimer = null;
    }
  }

  Future<void> _handleGapTimeout(Emitter<S> emit) async {
    if (isClosed || _eventBuffer.isEmpty) {
      _gapTimer = null;
      return;
    }

    final int minInBuffer =
        _eventBuffer.keys.fold(_eventBuffer.keys.first, (p, e) => e < p ? e : p);


    // Force progress by skipping the gap
    _lastVersion = minInBuffer - 1;
    _gapTimer = null;
    await _processBuffer(emit);
  }

  Future<void> _onListenForEvents(bool listen, Emitter<S> emit) async {
    try {
      await _subscription?.cancel();
      _subscription = null;

      if (!listen) {
        // turn off listening, and update hydrated events in case
        // listening is turned on again
        _hydratedEvents = stateGetEventsMap(state);
        _hydratedState = state;
        _eventBuffer.clear();
        _gapTimer?.cancel();
        _gapTimer = null;
        _lastVersion = 0;

        emit(
          stateCopyWithStatus(
            _initialState.deepCopy(),
            CommonReplayStateEnum.hydrating,
          )..freeze(),
        );
        return;
      }

      if (_hydratedState != null) {
        if (kDebugMode) {
          print('BaseReplayBloc: hydrate from state');
        }
        emit(
          stateCopyWithStatus(_hydratedState!, CommonReplayStateEnum.hydrating)
            ..freeze(),
        );
      } else if (_hydratedEvents.isNotEmpty) {
        try {
          if (kDebugMode) {
            print(
              'BaseReplayBloc: hydrate from events (${_hydratedEvents.length})',
            );
          }
          // Use `compute()` to offload heavy work if enabled; otherwise call
          // the handler directly on the current isolate.
          Uint8List serializedState;
          if (_useIsolate) {
            serializedState = await compute(
              _hydrateIsolateHandler,
              _hydratedEvents,
            );
          } else {
            serializedState = await _hydrateIsolateHandler(_hydratedEvents);
          }

          S resultState = fromBuffer(serializedState);

          if (isClosed) {
            return;
          }

          emit(
            stateCopyWithStatus(resultState, CommonReplayStateEnum.hydrating)
              ..freeze(),
          );
        } catch (e) {
          _hydratedEvents.clear();
          _hydratedState = null;
          if (kDebugMode) {
            print('BaseReplayBloc: onLoadFromHydrate processing failed: $e');
          }
          // continue processing, perhaps this version does not handle
          // some event correctly, just remove the hydrated events
        }
      }

      final path = await getCollectionPath();
      if (path == null || path.isEmpty) {
        // this would only happen if the implementation is broken
        // getCollectionPath() is required to be implemented
        emit(
          stateCopyWithStatus(
            _initialState.deepCopy(),
            CommonReplayStateEnum.networkError,
          )..freeze(),
        );
        return;
      }

      // check that the cloud event stream exists
      final firstEventDoc = await getFirstEventDocument(path);
      if (firstEventDoc == null) {
        _hydratedEvents.clear();
        _hydratedState = null;
        _eventBuffer.clear();
        _gapTimer?.cancel();
        _gapTimer = null;
        _lastVersion = 0;

        emit(
          stateCopyWithStatus(
            _initialState.deepCopy(),
            // start listening for events on empty collection
            CommonReplayStateEnum.uninitializedListening,
          )..freeze(),
        );
      } else {
        // check that the local and remote event streams are consistent
        final firstCloudEvent = firstEventDoc[payloadField] as String?;
        if (_hydratedEvents.isNotEmpty &&
            _hydratedEvents.containsKey(firstCollectionEventVersion)) {
          final firstCachedEvent = _hydratedEvents[firstCollectionEventVersion];
          if (firstCloudEvent != firstCachedEvent) {
            // the event stream has changed, clear local cache and continue
            // for example, a user has removed their account and then re-added it
            // in a different app instance
            _hydratedEvents.clear();
            _hydratedState = null;
            _eventBuffer.clear();
            _gapTimer?.cancel();
            _gapTimer = null;
            _lastVersion = 0;

            emit(
              stateCopyWithStatus(
                _initialState.deepCopy(),
                CommonReplayStateEnum.hydrating,
              )..freeze(),
            );
          }
        }

        emit(
          stateCopyWithStatus(
            state.deepCopy(),
            // start listening for events on non-empty collection
            CommonReplayStateEnum.listening,
          )..freeze(),
        );
      }

      // find the last cached version
      _lastVersion = _hydratedEvents.keys.fold<int>(0, (p, e) => e > p ? e : p);

      // Setup listener for subsequent changes
      _subscription = _storage
          .listenEvents(
            path,
            lastVersion: _lastVersion,
            versionField: versionField,
            payloadField: payloadField,
          )
          .listen(
            (eventsData) {
              if (eventsData.isNotEmpty) {
                if (!isClosed) {
                  add(
                    CommonReplayBlocEvent(
                      newEvents: CommonReplayBlocEvent_NewEvents(
                        events: eventsData.entries,
                      ),
                    ),
                  );
                }
              }
            },
            onError: (error) {
              if (!isClosed) {
                // do not emit an error state here, as it would be confusing to the UI, and might cause an exception
              }
            },
          );
    } catch (e, _) {
      CommonReplayStateEnum errorState = CommonReplayStateEnum.networkError;
      if (_storage.isPermissionDenied(e)) {
        errorState = CommonReplayStateEnum.permissionDenied;
      }
      emit(stateCopyWithStatus(state.deepCopy(), errorState)..freeze());
    }
  }

  Future<S> _runReplay(S currentState, Map<int, String> eventsData) async {
    try {
      final Uint8List serializedState = toBuffer(currentState);
      final Map<String, dynamic> arg = {
        'serialized_state': serializedState,
        'events': eventsData,
      };

      // Use `compute()` to offload heavy work into an isolate if requested by
      // constructor option; otherwise call the handler directly.
      final Uint8List resultBytes = _useIsolate
          ? await compute(_replayIsolateHandler, arg)
          : await _replayIsolateHandler(arg);

      return fromBuffer(resultBytes);
    } catch (e) {
      // Fall back to main isolate execution if anything fails.
      return replayEvents(currentState, eventsData);
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    _gapTimer?.cancel();
    return await super.close();
  }

  @override
  S? fromJson(Map<String, dynamic> json) {
    try {
      final serializedEventsMap = json['events_map'] as String?;
      if (serializedEventsMap != null && serializedEventsMap.isNotEmpty) {
        final eventMapProto = EventMapProto.fromBuffer(
          base64Decode(serializedEventsMap),
        );
        _hydratedEvents = eventMapProto.events.map(
          (key, value) => MapEntry(key, value),
        );
      }

      final serializedState =
          json[HyttaHubOptions.implementation?.appBuildNumber.toString()] as String?;
      if (serializedState != null && serializedState.isNotEmpty) {
        _hydratedState = fromBuffer(base64Decode(serializedState));
      } else {
        _hydratedState = null;
      }

      final restoringState = stateCopyWithStatus(
        state,
        CommonReplayStateEnum.hydrating,
      );

      return restoringState..freeze();
    } catch (e, _) {
      return null; // Or handle error appropriately, returning null will use initialState
    }
  }

  @override
  Map<String, dynamic>? toJson(S state) {
    try {
      final Map<int, String> eventsToSerialize = stateGetEventsMap(state);
      final eventMapProto = EventMapProto(events: eventsToSerialize.entries);
      final serializedEventsMap = base64Encode(eventMapProto.writeToBuffer());

      final serializedState = base64Encode(toBuffer(state));

      return {
        'events_map': serializedEventsMap,
        HyttaHubOptions.implementation?.appBuildNumber.toString() ?? '': serializedState,
      };
    } catch (e, _) {
      return null; // Prevents corrupt data from being saved
    }
  }
}
