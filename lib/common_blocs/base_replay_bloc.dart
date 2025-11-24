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
  /// Optional top-level isolate handler that performs the replay operation.
  ///
  /// If provided, this must be a top-level or static function with signature
  /// `FutureOr<String> handler(Map<String, dynamic> payload)` where `payload`
  /// contains keys `state_proto_base64` (the base64-encoded protobuf bytes of
  /// the current state) and `events` (the Map\<int, String> of new events).
  /// The handler must return the new state's protobuf bytes encoded as a
  /// base64 `String`. The main isolate will decode those bytes and call
  /// `stateFromProtoBytes` (implemented by the subclass) to reconstruct `S`.
  BaseReplayBloc(
    super.initialState, {
    FirebaseFirestore? firestore,
    FutureOr<String> Function(Map<String, dynamic>)? replayIsolateHandler,
    FutureOr<String> Function(Map<String, dynamic>)? hydrateIsolateHandler,
  }) : _initialState = initialState,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _replayIsolateHandler = replayIsolateHandler,
       _hydrateIsolateHandler = hydrateIsolateHandler {
    on<CommonReplayBlocEvent>(_onEvent);
  }

  StreamSubscription? _subscription;
  final S _initialState;
  final FirebaseFirestore _firestore;
  final FutureOr<String> Function(Map<String, dynamic>)? _replayIsolateHandler;
  // This field is reserved for an optional async hydrate handler that cannot
  // be used synchronously inside `fromJson`. It's kept for future async
  // rehydration workflows. Suppress unused-field analyzer warning.
  // ignore: unused_field
  final FutureOr<String> Function(Map<String, dynamic>)? _hydrateIsolateHandler;

  // (removed) per-bloc hydration-complete callback — unused

  /// If a hydrate isolate handler was provided, schedule running it in a
  /// background isolate to reconstruct a full protobuf-based state from the
  /// given `hydratedEvents` map. When reconstruction completes, the resulting
  /// state will be applied to this bloc via `applyHydratedStateFromProtoBytes`.
  ///
  /// This method is safe to call from synchronous `fromJson` implementations.
  void scheduleAsyncHydration(Map<int, String> hydratedEvents) {
    if (_hydrateIsolateHandler == null) return;

    final Map<String, dynamic> payload = {'hydrated_events': hydratedEvents};

    compute(_hydrateIsolateHandler, payload)
        .then((String resultB64) {
          try {
            final List<int> resultBytes = base64Decode(resultB64);
            applyHydratedStateFromProtoBytes(resultBytes);
          } catch (e) {
            if (kDebugMode) {
              print(
                'scheduleAsyncHydration: failed to apply hydrated bytes: $e',
              );
            }
          }
        })
        .catchError((e) {
          if (kDebugMode) {
            print('scheduleAsyncHydration: isolate handler failed: $e');
          }
        });
  }

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

  /// Gets the current status enum value from the state S.
  CommonReplayStateEnum stateGetStatusEnum(S state);

  /// Handles the scenario when the initial snapshot from Firestore is empty.
  /// Subclasses implement this to emit their specific state (e.g., uninitialized or ok).
  void handleEmptyInitialSnapshot(Emitter<S> emit, S currentState);

  /// Creates an instance of state S from a JSON map and hydrated events.
  /// Subclasses implement this to reconstruct their specific state parts.
  S stateFromJson(Map<String, dynamic> json, Map<int, String> hydratedEvents);

  /// Creates an instance of state S from protobuf bytes.
  /// Subclasses must implement this to parse their generated message from
  /// `bytes` (e.g., `MyState.fromBuffer(bytes`).
  S stateFromProtoBytes(List<int> bytes);

  /// Converts state S to a JSON map for persistence (excluding the event map).
  Map<String, dynamic> stateToJson(S state);

  /// Validates if the local state is consistent with the server state.
  ///
  /// The default implementation checks if the first event (version 1) exists on
  /// the server when the local state is not empty. This detects cases where
  /// the backend data has been cleared while the client still has hydrated state.
  /// This assumes that event versions are used as document IDs.
  ///
  /// Returns `true` if the state is valid, `false` otherwise.
  /// Subclasses can override this for more specific validation logic.
  Future<bool> validateLocalEventCache(
    S localState,
    String collectionPath,
  ) async {
    final int maxVersion = stateGetEventsMap(
      localState,
    ).keys.fold<int>(0, (p, e) => e > p ? e : p);
    if (maxVersion > 0) {
      final firstEventDoc = await getFirstEventDocument(collectionPath);
      return firstEventDoc.exists;
    }
    return true; // Local state is empty, so it's valid by default.
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getFirstEventDocument(
    String collectionPath,
  ) {
    return _firestore
        .collection(collectionPath)
        .doc('1') // Assumes version '1' is the document ID for the first event.
        .get(const GetOptions(source: Source.server));
  }

  // --- Common BLoC Logic ---

  FutureOr<void> _onEvent(CommonReplayBlocEvent event, Emitter<S> emit) async {
    if (event.hasListen()) {
      await _onListenForEvents(event.listen, emit);
    } else if (event.hasNewEvents()) {
      await _onNewEvents(event.newEvents.events, emit);
    } else if (event.hasErrorOccurred()) {
      await _onErrorOccurred(event.errorOccurred, emit);
    }
  }

  Future<void> _onNewEvents(
    Map<int, String> eventsData,
    Emitter<S> emit,
  ) async {
    final S newState = await _runReplay(state, eventsData);
    emit(newState..freeze());
  }

  Future<void> _onErrorOccurred(String errorText, Emitter<S> emit) async {
    final S newState = stateCopyWithStatus(
      state.deepCopy(),
      CommonReplayStateEnum.networkError,
    );
    emit(newState..freeze());
  }

  Future<void> _onListenForEvents(bool listen, Emitter<S> emit) async {
    try {
      await _subscription?.cancel();
      _subscription = null;

      if (!listen) {
        return;
      }

      emit(
        stateCopyWithStatus(
          state.deepCopy(),
          CommonReplayStateEnum.fetchingConfig,
        )..freeze(),
      );

      final path = await getCollectionPath();
      if (path == null || path.isEmpty) {
        emit(
          stateCopyWithStatus(
            state.deepCopy(),
            CommonReplayStateEnum.networkError,
          )..freeze(),
        );
        return;
      }

      // --- State Validation ---
      // Before proceeding, validate that our hydrated local state is not stale
      // compared to the server (e.g., server was wiped).
      final bool isStateValid = await validateLocalEventCache(state, path);
      if (!isStateValid) {
        await clear();
        emit(
          _initialState,
        ); // This resets the in-memory state for the current run.
      }
      // The `state` getter will now reflect `initialState` if it was reset.

      // state here is the hydrated state or the initial state if no hydration occurred.
      S currentProcessingState = state
          .deepCopy(); // Work on a copy for initial fetch
      int maxVersionFromLocalState = stateGetEventsMap(
        state, // Use the potentially reset state
      ).keys.fold<int>(0, (p, e) => e > p ? e : p);

      // 1. Initial fetch for events newer than what we have locally
      Query query = _firestore
          .collection(path)
          .orderBy(versionField, descending: false);
      if (maxVersionFromLocalState > 0) {
        query = query.where(
          versionField,
          isGreaterThan: maxVersionFromLocalState,
        );
      }
      // If maxVersionFromLocalState is 0, this fetches all documents, which is correct for the first ever fetch.

      final querySnapshot = await query.get(
        const GetOptions(source: Source.server),
      );

      final List<MapEntry<int, String>> newEventsFromServer = querySnapshot.docs
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

      if (newEventsFromServer.isNotEmpty) {
        currentProcessingState = await _runReplay(
          currentProcessingState,
          Map.fromEntries(newEventsFromServer),
        );
        emit(
          stateCopyWithStatus(currentProcessingState, CommonReplayStateEnum.ok)
            ..freeze(),
        );
      } else {
        // No new events from server.
        if (maxVersionFromLocalState == 0) {
          // Local state was empty, and server is also empty (or returned no new events)
          handleEmptyInitialSnapshot(emit, currentProcessingState);
        } else {
          // We have local events, and no new ones from server. State is already OK.
          // Ensure status is OK if it was fetchingConfig
          if (stateGetStatusEnum(currentProcessingState) ==
                  CommonReplayStateEnum.fetchingConfig ||
              stateGetStatusEnum(currentProcessingState) !=
                  CommonReplayStateEnum.ok) {
            emit(
              stateCopyWithStatus(
                currentProcessingState,
                CommonReplayStateEnum.ok,
              )..freeze(),
            );
          }
        }
      }

      // Use the latest state (after potential emit) for the snapshot listener's starting point
      final int versionForSnapshotListener = stateGetEventsMap(
        state,
      ).keys.fold<int>(0, (p, e) => e > p ? e : p);

      // 2. Setup listener for subsequent changes
      _subscription = _firestore
          .collection(path)
          .where(versionField, isGreaterThan: versionForSnapshotListener)
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

                    // createNewEventsBlocEvent(
                    //   Map<int, String>.fromEntries(newEventsList),
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

  /// Helper that runs the replay either on the main isolate (by calling
  /// `replayEvents`) or on a background isolate using the provided
  /// `_replayIsolateHandler` and `compute()`.
  Future<S> _runReplay(S currentState, Map<int, String> eventsData) async {
    if (_replayIsolateHandler == null) {
      return replayEvents(currentState, eventsData);
    }

    try {
      // Encode current state's protobuf bytes as base64 so it can be sent to
      // the isolate. This avoids JSON serialization and preserves the
      // protobuf binary representation.
      final String stateProtoB64 = base64Encode(currentState.writeToBuffer());
      final Map<String, dynamic> arg = {
        'state_proto_base64': stateProtoB64,
        'events': eventsData,
      };

      final String resultBase64 = await compute(_replayIsolateHandler, arg);

      final List<int> resultBytes = base64Decode(resultBase64);

      return stateFromProtoBytes(resultBytes);
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
      Map<int, String> hydratedEvents = {};
      if (serializedEventsMap != null && serializedEventsMap.isNotEmpty) {
        final eventMapProto = EventMapProto.fromBuffer(
          base64Decode(serializedEventsMap),
        );
        hydratedEvents = eventMapProto.events.map(
          (key, value) => MapEntry(key, value),
        );
      }
      // The rest of the state is reconstructed by the subclass
      return stateFromJson(json, hydratedEvents);
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

      final subclassJson = stateToJson(
        state,
      ); // Get JSON from subclass for its specific fields
      return {...subclassJson, 'events_map': serializedEventsMap};
    } catch (e, _) {
      return null; // Prevents corrupt data from being saved
    }
  }

  /// Apply a hydrated state constructed from protobuf bytes.
  ///
  /// This is intended for use by an async bootstrap that reconstructs state
  /// in a background isolate and then applies it to the running bloc.
  Future<void> applyHydratedStateFromProtoBytes(List<int> bytes) async {
    if (isClosed) return;
    try {
      final S restored = stateFromProtoBytes(bytes);
      (this as dynamic).emit(restored..freeze());
    } catch (e) {
      // If applying fails, keep existing state.
      if (kDebugMode) {
        print('applyHydratedStateFromProtoBytes failed: $e');
      }
    }
  }

  /// Apply a hydrated state instance directly.
  Future<void> applyHydratedState(S newState) async {
    if (isClosed) return;
    (this as dynamic).emit(newState..freeze());
  }
}
