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
    bool? useIsolates,
    Duration? gapTimeout,
    this.resyncInterval,
  }) : _gapTimeout = gapTimeout,
       _initialState = initialState,
       _replayIsolateHandler = replayIsolateHandler,
       _hydrateIsolateHandler = hydrateIsolateHandler,
       _useIsolateOverride = useIsolates {

    if (storage != null) {
      _storageOverride = storage;
    }

    on<CommonReplayBlocEvent>(_onEvent);
  }

  final Map<int, String> _eventBuffer = {};
  Timer? _gapTimer;
  Timer? _resyncTimer;
  Map<int, String> _hydratedEvents = {};
  S? _hydratedState;
  int _lastVersion = 0;

  final Duration? resyncInterval;
  Duration? get _effectiveResyncInterval =>
      resyncInterval ?? HyttaHubOptions.resyncInterval;

  StreamSubscription? _subscription;
  final S _initialState;
  BaseHyttaHubStorage? _storageOverride;
  BaseHyttaHubStorage get _storage =>
      _storageOverride ?? HyttaHubStorageFactory.getStorage(storageType);
  final FutureOr<Uint8List> Function(Map<String, dynamic> payload)
  _replayIsolateHandler;

  final FutureOr<Uint8List> Function(Map<int, String>) _hydrateIsolateHandler;

  // Whether to use compute() to run handlers in isolates. Default true.
  final bool? _useIsolateOverride;
  bool get _useIsolate {
    if (_useIsolateOverride != null) return _useIsolateOverride;
    final impl = HyttaHubOptions.implementation;
    if (impl != null && impl.hasUseIsolates()) {
      return impl.useIsolates;
    }
    return true;
  }

  /// Explicit [gapTimeout] passed to the constructor, if any.
  final Duration? _gapTimeout;

  /// Fallback gap timeout used when no resync interval is configured and so
  /// there is no resync attempt to wait for.
  static const Duration _fallbackGapTimeout = Duration(seconds: 5);

  /// Headroom added on top of the resync interval. A resync needs two network
  /// round trips to recover a gap — the version probe, then the re-listen's
  /// seed fetch — so the gap timeout has to clear the interval by more than a
  /// moment.
  static const Duration _gapTimeoutSlack = Duration(seconds: 5);

  /// How long a missing version is waited for before [_handleGapTimeout]
  /// gives up on it.
  ///
  /// Defaults to one resync interval plus [_gapTimeoutSlack], so a resync
  /// always gets at least one attempt at fetching the missing event first.
  /// A shorter timeout silently pre-empts its own recovery: the skip advances
  /// `_lastVersion` past the hole, after which the resync's
  /// `latestVersion > _lastVersion` check can never fire.
  Duration get gapTimeout {
    final explicit = _gapTimeout;
    if (explicit != null) return explicit;
    final interval = _effectiveResyncInterval;
    if (interval == null) return _fallbackGapTimeout;
    return interval + _gapTimeoutSlack;
  }

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
    _resetResyncTimer();
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
      final int minInBuffer = _minBufferedVersion();

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

  /// Lowest version currently held in [_eventBuffer]. Only valid when the
  /// buffer is non-empty.
  int _minBufferedVersion() =>
      _eventBuffer.keys.fold(_eventBuffer.keys.first, (p, e) => e < p ? e : p);

  Future<void> _handleGapTimeout(Emitter<S> emit) async {
    _gapTimer = null;
    if (isClosed || _eventBuffer.isEmpty) {
      return;
    }

    if (_minBufferedVersion() > _lastVersion + 1) {
      // Read the collection directly before giving up on the gap. Skipping
      // replays the state without the missing event and advances _lastVersion
      // past it, so nothing can ever deliver it afterwards — a silent,
      // permanent divergence. The realtime stream can miss an event without
      // the connection ever failing, so a direct read is the only way to tell
      // "the event is genuinely not there" from "we never received it".
      await _fillGapFromStorage();

      if (isClosed || _eventBuffer.isEmpty) {
        return;
      }
    }

    final int minInBuffer = _minBufferedVersion();

    if (minInBuffer > _lastVersion + 1) {
      if (kDebugMode) {
        print(
          "BaseReplayBloc ($S): gap v${_lastVersion + 1}..v${minInBuffer - 1} "
          "not in storage either, skipping",
        );
      }
      // Force progress by skipping the gap
      _lastVersion = minInBuffer - 1;
    }

    await _processBuffer(emit);
  }

  /// Reads the event collection directly and buffers everything above
  /// [_lastVersion], filling any hole the realtime stream missed.
  ///
  /// Buffers rather than emits: the caller is inside an event handler and
  /// drains the buffer itself via [_processBuffer].
  Future<void> _fillGapFromStorage() async {
    try {
      final events = await _fetchEventsAbove(_lastVersion);
      var filled = 0;
      events.forEach((version, payload) {
        if (!_eventBuffer.containsKey(version)) {
          _eventBuffer[version] = payload;
          filled++;
        }
      });
      if (kDebugMode && filled > 0) {
        print("BaseReplayBloc ($S): gap refetch recovered $filled event(s)");
      }
    } catch (e) {
      if (kDebugMode) {
        print("BaseReplayBloc ($S): gap refetch failed: $e");
      }
    }
  }

  /// Reads the event log and returns everything newer than [version].
  ///
  /// The single place events are pulled from storage outside the realtime
  /// stream — both the gap filler and the resync go through it, and it is
  /// where a server-side version filter would slot in.
  Future<Map<int, String>> _fetchEventsAbove(int version) async {
    final path = await getCollectionPath();
    if (path == null || path.isEmpty) return const {};

    final docs = await _storage.getCollection(
      path,
      newerThan: VersionFilter(field: versionField, version: version),
    );
    final events = <int, String>{};
    for (final doc in docs) {
      final rawVersion = doc[versionField];
      final payload = doc[payloadField];
      if (rawVersion is! num || payload is! String) continue;
      final parsed = rawVersion.toInt();
      // Re-checked rather than assumed: a backend may not narrow the read.
      if (parsed > version) events[parsed] = payload;
    }
    return events;
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
            // Read on every seed and re-seed, so a reconnect picks up from
            // what has actually been processed rather than from a snapshot
            // of where we were when the stream was created.
            lastVersion: () => _lastVersion,
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
      _resetResyncTimer();
    } catch (e) {
      CommonReplayStateEnum errorState = CommonReplayStateEnum.networkError;
      if (_storage.isPermissionDenied(e)) {
        errorState = CommonReplayStateEnum.permissionDenied;
      }
      emit(stateCopyWithStatus(state.deepCopy(), errorState)..freeze());
    }
  }

  void _resetResyncTimer() {
    _resyncTimer?.cancel();
    _resyncTimer = null;
    final interval = _effectiveResyncInterval;
    if (interval == null) return;

    _resyncTimer = Timer(interval, () async {
      if (isClosed) return;
      final currentStatus = (state as dynamic).state;
      if (currentStatus != CommonReplayStateEnum.listening) {
        _resetResyncTimer();
        return;
      }

      try {
        final path = await getCollectionPath();
        if (path != null && path.isNotEmpty) {
          final latestDocs = await _storage.getCollection(
            path,
            orderBy: versionField,
            descending: true,
            limit: 1,
            fields: [versionField],
          );

          if (latestDocs.isNotEmpty) {
            final latestDoc = latestDocs.first;
            final v = latestDoc[versionField];
            final latestVersion = (v is num) ? v.toInt() : 0;

            if (latestVersion > _lastVersion) {
              if (kDebugMode) {
                print(
                  'BaseReplayBloc ($S): Auto-resync found missing events (latest v:$latestVersion > last v:$_lastVersion), catching up and reconnecting',
                );
              }

              // Pull what we missed through the normal event path, so it is
              // buffered, ordered and de-duplicated like anything else.
              final missed = await _fetchEventsAbove(_lastVersion);
              if (missed.isNotEmpty && !isClosed) {
                add(
                  CommonReplayBlocEvent(
                    newEvents: CommonReplayBlocEvent_NewEvents(
                      events: missed.entries,
                    ),
                  ),
                );
              }

              // Events existing in storage that never arrived is the evidence
              // that the realtime stream is stale. Ask for a fresh transport
              // rather than cancelling and re-listening, which left the
              // storage layer to infer the intent from the timing.
              await _storage.reconnectRealtime();
            }
          }
        }
      } catch (e) {
        // Silently ignore errors during background health check
      } finally {
        if (!isClosed) {
          _resetResyncTimer();
        }
      }
    });
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
    _resyncTimer?.cancel();
    _resyncTimer = null;
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
    } catch (e) {
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
    } catch (e) {
      return null; // Prevents corrupt data from being saved
    }
  }
}
