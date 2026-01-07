// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:convert'; // For base64Encode/Decode

import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter/foundation.dart'; // For compute()
import 'package:protobuf/protobuf.dart'; // For GeneratedMessage

abstract class BaseReplayBloc<S extends GeneratedMessage>
    extends HydratedBloc<CommonReplayBlocEvent, S> {
  BaseReplayBloc(
    super.initialState, {
    FirebaseFirestore? firestore,
    required FutureOr<Uint8List> Function(Map<String, dynamic> payload)
    replayIsolateHandler,
    required FutureOr<Uint8List> Function(Map<int, String>)
    hydrateIsolateHandler,

    // Whether to use Flutter isolates via `compute()` for heavy CPU work.
    bool useIsolate = true,
  }) : _initialState = initialState,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _replayIsolateHandler = replayIsolateHandler,
       _hydrateIsolateHandler = hydrateIsolateHandler {
    _useIsolate = useIsolate;
    on<CommonReplayBlocEvent>(_onEvent);
  }

  Map<int, String> _hydratedEvents = {};
  S? _hydratedState;
  int _lastVersion = 0;

  StreamSubscription? _subscription;
  final S _initialState;
  final FirebaseFirestore _firestore;
  final FutureOr<Uint8List> Function(Map<String, dynamic> payload)
  _replayIsolateHandler;

  final FutureOr<Uint8List> Function(Map<int, String>) _hydrateIsolateHandler;
  // Whether to use compute() to run handlers in isolates. Default true.
  late final bool _useIsolate;

  // --- Abstract methods and getters to be implemented by subclasses ---

  /// Provides the Firestore collection path.
  Future<String?> getCollectionPath();

  // for the firebase collection name (i.e. after the path)
  String get collectionName;

  // for hydrated storage
  @override
  String get id => ':$collectionName:${HyttaHubOptions.firebaseRootCollection}';

  /// Field name for the version in Firestore documents (e.g., 'v' or 'fbVersion').
  String get versionField => fbVersion;

  /// Field name for the payload in Firestore documents (e.g., 'p' or 'fbPayload').
  String get payloadField => fbPayload;

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

  Future<DocumentSnapshot<Map<String, dynamic>>> getFirstEventDocument(
    String collectionPath,
  ) {
    return _firestore
        .collection(collectionPath)
        .doc(firstCollectionEventVersion.toString())
        .get();
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
    // remove all events before the last version
    // do this because firebase fires off many events from its cache at times
    eventsData.removeWhere((key, value) => key <= _lastVersion);

    if (kDebugMode) {
      print(
        "BaseReplayBloc: _onNewEvents $eventsData _lastVersion: $_lastVersion",
      );
    }

    final S newState = eventsData.isEmpty
        ? state
        : await _runReplay(state, eventsData);

    // set last version to the largest key of eventsData
    if (eventsData.isNotEmpty) {
      _lastVersion = eventsData.keys.fold<int>(0, (p, e) => e > p ? e : p);
    }

    if (kDebugMode) {
      print("BaseReplayBloc: new _lastVersion: $_lastVersion");
    }

    if (isClosed) {
      return;
    }

    // still listening if we got a new event
    emit(
      stateCopyWithStatus(newState.deepCopy(), CommonReplayStateEnum.listening)
        ..freeze(),
    );
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
      if (!firstEventDoc.exists) {
        _hydratedEvents.clear();
        _hydratedState = null;

        emit(
          stateCopyWithStatus(
            _initialState.deepCopy(),
            // start listening for events on empty collection
            CommonReplayStateEnum.uninitializedListening,
          )..freeze(),
        );
      } else {
        // check that the local and remote event streams are consistent
        final firstCloudEvent = firstEventDoc.data()?[payloadField] as String?;
        if (_hydratedEvents.isNotEmpty &&
            _hydratedEvents.containsKey(firstCollectionEventVersion)) {
          final firstCachedEvent = _hydratedEvents[firstCollectionEventVersion];
          if (firstCloudEvent != firstCachedEvent) {
            // the event stream has changed, clear local cache and continue
            // for example, a user has removed their account and then re-added it
            // in a different app instance
            _hydratedEvents.clear();
            _hydratedState = null;
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

      if (kDebugMode) {
        print('BaseReplayBloc: listen after event version: $_lastVersion');
      }

      // Setup listener for subsequent changes
      _subscription = _firestore
          .collection(path)
          .where(versionField, isGreaterThan: _lastVersion)
          .orderBy(versionField, descending: false)
          .snapshots()
          .listen(
            (items) {
              final newEventsList = items.docs
                  .map((doc) {
                    try {
                      return MapEntry(
                        doc[versionField] as int,
                        doc[payloadField] as String,
                      );
                    } catch (e) {
                      return null;
                    }
                  })
                  .where((e) => e != null)
                  .cast<MapEntry<int, String>>()
                  .toList();

              if (newEventsList.isNotEmpty) {
                if (!isClosed) {
                  add(
                    CommonReplayBlocEvent(
                      newEvents: CommonReplayBlocEvent_NewEvents(
                        events: Map<int, String>.fromEntries(newEventsList),
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
      if (e is FirebaseException && e.code == 'permission-denied') {
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
          json[HyttaHubOptions.appBuildNumber.toString()] as String?;
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
      final eventMapProto = EventMapProto(events: eventsToSerialize);
      final serializedEventsMap = base64Encode(eventMapProto.writeToBuffer());

      final serializedState = base64Encode(toBuffer(state));

      return {
        'events_map': serializedEventsMap,
        HyttaHubOptions.appBuildNumber.toString(): serializedState,
      };
    } catch (e, _) {
      return null; // Prevents corrupt data from being saved
    }
  }
}
