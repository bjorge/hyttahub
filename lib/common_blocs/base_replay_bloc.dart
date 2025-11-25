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
  }) : _initialState = initialState,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _replayIsolateHandler = replayIsolateHandler,
       _hydrateIsolateHandler = hydrateIsolateHandler {
    on<CommonReplayBlocEvent>(_onEvent);
  }

  Map<int, String> _hydratedEvents = {};

  StreamSubscription? _subscription;
  final S _initialState;
  final FirebaseFirestore _firestore;
  final FutureOr<Uint8List> Function(Map<String, dynamic> payload)
  _replayIsolateHandler;

  final FutureOr<Uint8List> Function(Map<int, String>) _hydrateIsolateHandler;

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
        .doc('1') // Assumes version '1' is the document ID for the first event.
        .get();
  }

  // --- Common BLoC Logic ---

  FutureOr<void> _onEvent(CommonReplayBlocEvent event, Emitter<S> emit) async {
    if (event.hasLoadFromHydrate()) {
      await _onLoadFromHydrate(emit);
    } else if (event.hasListen()) {
      await _onListenForEvents(event.listen, emit);
    } else if (event.hasNewEvents()) {
      await _onNewEvents(event.newEvents.events, emit);
    } else if (event.hasErrorOccurred()) {
      await _onErrorOccurred(event.errorOccurred, emit);
    }
  }

  Future<void> _onLoadFromHydrate(Emitter<S> emit) async {
    if (_hydratedEvents.isNotEmpty) {
      try {
        Uint8List serializedState = await compute(
          _hydrateIsolateHandler,
          _hydratedEvents,
        );

        S resultState = fromBuffer(serializedState);

        if (isClosed) {
          return;
        }

        // todo: set to hydrated first...
        emit(resultState..freeze());
      } catch (e) {
        _hydratedEvents.clear();
        if (kDebugMode) {
          print('onLoadFromHydrate compute failed: $e');
        }
      }
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
        // turn off listening
        _hydratedEvents.clear();
        return;
      }

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

      // check that the cloud event stream exists
      final firstEventDoc = await getFirstEventDocument(path);
      if (!firstEventDoc.exists) {
        _hydratedEvents.clear();
        emit(
          stateCopyWithStatus(
            _initialState.deepCopy(),
            CommonReplayStateEnum.uninitialized,
          )..freeze(),
        );
      }

      // check that the local and remote event streams are consistent
      final firstCloudEvent = firstEventDoc.data()?[payloadField] as String?;
      if (_hydratedEvents.isNotEmpty && _hydratedEvents.containsKey(1)) {
        final firstCachedEvent = _hydratedEvents[1];
        if (firstCloudEvent != firstCachedEvent) {
          // somehow the event stream has changed, clear local cache and continue
          _hydratedEvents.clear();
          emit(
            stateCopyWithStatus(
              _initialState.deepCopy(),
              CommonReplayStateEnum.hydrating,
            )..freeze(),
          );
        }
      }

      // find the last cached version
      int maxVersionFromLocalState = _hydratedEvents.keys.fold<int>(
        0,
        (p, e) => e > p ? e : p,
      );

      // Initial fetch for events newer than what we have locally
      Query query = _firestore
          .collection(path)
          .orderBy(versionField, descending: false);
      if (maxVersionFromLocalState > 0) {
        query = query.where(
          versionField,
          isGreaterThan: maxVersionFromLocalState,
        );
      }

      final querySnapshot = await query.get();

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

      var versionForSnapshotListener = maxVersionFromLocalState;
      var currentProcessingState = state;
      if (newEventsFromServer.isNotEmpty) {
        // ok, there are some newer events in the service
        final mapOfEvents = Map.fromEntries(newEventsFromServer);
        versionForSnapshotListener = mapOfEvents.keys.fold<int>(
          maxVersionFromLocalState,
          (p, e) => e > p ? e : p,
        );

        currentProcessingState = await _runReplay(state, mapOfEvents);
      }

      emit(
        stateCopyWithStatus(currentProcessingState, CommonReplayStateEnum.ok)
          ..freeze(),
      );

      // Setup listener for subsequent changes
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
    try {
      // Encode current state's protobuf bytes as base64 so it can be sent to
      // the isolate. This avoids JSON serialization and preserves the
      // protobuf binary representation.
      final Uint8List serializedState = toBuffer(currentState);
      final Map<String, dynamic> arg = {
        'serialized_state': serializedState,
        'events': eventsData,
      };

      final Uint8List resultBytes = await compute(_replayIsolateHandler, arg);

      return fromBuffer(resultBytes);
    } catch (e) {
      // Fall back to main isolate execution if anything fails.
      return replayEvents(currentState, eventsData);
    }
  }

  @override
  Future<void> close() async {
    // No special hydration lifecycle to wait for anymore.
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

      return {'events_map': serializedEventsMap};
    } catch (e, _) {
      return null; // Prevents corrupt data from being saved
    }
  }
}
