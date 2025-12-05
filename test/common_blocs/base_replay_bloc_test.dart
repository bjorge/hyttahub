// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/common_blocs/base_replay_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:hyttahub/service_blocs/service_replay.dart';
import 'package:protobuf/protobuf.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class MockStorage implements Storage {
  final Map<String, dynamic> _data = <String, dynamic>{};

  @override
  dynamic read(String key) => _data[key];

  @override
  Future<void> write(String key, dynamic value) async => _data[key] = value;

  @override
  Future<void> delete(String key) async => _data.remove(key);

  @override
  Future<void> clear() async => _data.clear();

  @override
  Future<void> close() {
    return Future.value();
  }
}

// Top-level isolate handler for tests. Compatible with BaseReplayBloc's
// `replayIsolateHandler` — decodes protobuf state bytes, applies events,
// and returns base64-encoded protobuf bytes of the new state.
FutureOr<String> testReplayIsolateHandler(Map<String, dynamic> payload) {
  final String stateB64 = payload['state_proto_base64'] as String;
  final dynamic eventsDynamic = payload['events'];

  final Map<int, String> eventsMap = <int, String>{};
  if (eventsDynamic is Map) {
    eventsDynamic.forEach((k, v) {
      final int key = int.tryParse(k.toString()) ?? (k is int ? k : 0);
      eventsMap[key] = v as String;
    });
  }

  final List<int> stateBytes = base64Decode(stateB64);
  final ServiceReplayBlocState state = ServiceReplayBlocState.fromBuffer(
    stateBytes,
  );

  // For tests we simply merge the events into the state's events map.
  final ServiceReplayBlocState newState = state.deepCopy();
  newState.events.addAll(eventsMap);

  return base64Encode(newState.writeToBuffer());
}

// Top-level isolate handler for service replay. Runs in a background isolate
// via `compute()` and must be a top-level function.
FutureOr<Uint8List> serviceReplayIsolateHandler(Map<String, dynamic> payload) {
  final Uint8List serializedState = payload['serialized_state'] as Uint8List;
  final Map<int, String> eventsMap = payload['events'];

  final ServiceReplayBlocState state = ServiceReplayBlocState.fromBuffer(
    serializedState,
  );

  final ServiceReplayBlocState newState = serviceReplay(state, eventsMap);

  return newState.writeToBuffer();
}

// Top-level isolate handler for constructing initial state from hydrated events.
FutureOr<Uint8List> serviceHydrateIsolateHandler(Map<int, String> eventsMap) {
  // print('[test] serviceHydrateIsolateHandler eventsMap: $eventsMap');

  final ServiceReplayBlocState newState = serviceReplay(
    ServiceReplayBlocState(),
    eventsMap,
  );

  return newState.writeToBuffer();
}

// Simpler hydrate handler for tests that does not assume events are base64
// encoded protobufs - useful when events are simple string placeholders.
FutureOr<Uint8List> testHydrateIsolateHandler(Map<int, String> eventsMap) {
  final ServiceReplayBlocState newState = ServiceReplayBlocState();
  newState.events.addAll(eventsMap);
  return newState.writeToBuffer();
}

// A concrete implementation of BaseReplayBloc for testing purposes
class TestReplayBloc extends BaseReplayBloc<ServiceReplayBlocState> {
  TestReplayBloc(
    this.collectionPath, {
    required FirebaseFirestore firestore,
    this.validationResult = true,
    FutureOr<Uint8List> Function(Map<String, dynamic>)?
    replayIsolateHandlerOverride,
    FutureOr<Uint8List> Function(Map<int, String>)?
    hydrateIsolateHandlerOverride,
    this.handleEmptySnapshotCompleter,
  }) : super(
         ServiceReplayBlocState(),
         firestore: firestore,
         replayIsolateHandler:
             replayIsolateHandlerOverride ?? serviceReplayIsolateHandler,
         hydrateIsolateHandler:
             hydrateIsolateHandlerOverride ?? serviceHydrateIsolateHandler,
       );

  final String collectionPath;
  final bool validationResult;
  final Completer? handleEmptySnapshotCompleter;

  @override
  String get collectionName => collectionPath;

  @override
  Future<String?> getCollectionPath() async => collectionPath;

  @override
  ServiceReplayBlocState replayEvents(
    ServiceReplayBlocState currentState,
    Map<int, String> newEventsData,
  ) {
    final newState = currentState.deepCopy();
    newState.events.addAll(newEventsData);
    return newState;
  }

  @override
  ServiceReplayBlocState stateCopyWithStatus(
    ServiceReplayBlocState currentState,
    CommonReplayStateEnum newStatusEnum,
  ) {
    return currentState.deepCopy()..state = newStatusEnum;
  }

  @override
  Map<int, String> stateGetEventsMap(ServiceReplayBlocState state) =>
      state.events;

  @override
  ServiceReplayBlocState fromBuffer(Uint8List bytes) {
    return ServiceReplayBlocState.fromBuffer(bytes);
  }

  @override
  Uint8List toBuffer(ServiceReplayBlocState state) {
    return state.writeToBuffer();
  }
}

void main() {
  group('BaseReplayBloc', () {
    late FakeFirebaseFirestore fakeFirestore;
    const collectionPath = 'test_collection';

    setUp(() {
      HydratedBloc.storage = MockStorage();
      fakeFirestore = FakeFirebaseFirestore();
    });

    TestReplayBloc buildBloc({
      bool validationResult = true,
      Completer? emptySnapshotCompleter,
      FutureOr<Uint8List> Function(Map<int, String>)?
      hydrateIsolateHandlerOverride,
      FutureOr<Uint8List> Function(Map<String, dynamic>)?
      replayIsolateHandlerOverride,
    }) {
      return TestReplayBloc(
        collectionPath,
        firestore: fakeFirestore,
        validationResult: validationResult,
        handleEmptySnapshotCompleter: emptySnapshotCompleter,
        hydrateIsolateHandlerOverride: hydrateIsolateHandlerOverride,
        replayIsolateHandlerOverride: replayIsolateHandlerOverride,
      );
    }

    test('initial state is correct', () {
      final bloc = buildBloc();
      expect(bloc.state, ServiceReplayBlocState());
      expect(bloc.state.state, CommonReplayStateEnum.hydrating);
    });

    group('Listen Event', () {
      blocTest<TestReplayBloc, ServiceReplayBlocState>(
        'emits ok with combined events when fetching initial data',
        setUp: () async {
          await fakeFirestore.collection(collectionPath).doc('1').set({
            fbVersion: 1,
            fbPayload: 'event1',
          });
          await fakeFirestore.collection(collectionPath).doc('2').set({
            fbVersion: 2,
            fbPayload: 'event2',
          });
        },
        build: buildBloc,
        act: (bloc) => bloc.add(CommonReplayBlocEvent(listen: true)),
        // The bloc emits an initial listening state with empty events,
        // then processes all initial events in a batch.
        wait: const Duration(milliseconds: 200),
        expect: () => [
          isA<ServiceReplayBlocState>()
              .having((s) => s.state, 'state', CommonReplayStateEnum.listening)
              .having((s) => s.events, 'events', {}),
          isA<ServiceReplayBlocState>()
              .having((s) => s.state, 'state', CommonReplayStateEnum.listening)
              .having((s) => s.events, 'events', {1: 'event1', 2: 'event2'}),
        ],
      );

      blocTest<TestReplayBloc, ServiceReplayBlocState>(
        'emits [uninitialized] on empty initial snapshot (new ordering)',
        build: buildBloc,
        act: (bloc) => bloc.add(CommonReplayBlocEvent(listen: true)),
        wait: const Duration(milliseconds: 200),
        expect: () => [
          isA<ServiceReplayBlocState>().having(
            (s) => s.state,
            'state',
            CommonReplayStateEnum.uninitializedListening,
          ),
        ],
      );

      blocTest<TestReplayBloc, ServiceReplayBlocState>(
        'correctly processes new events after initial fetch',
        setUp: () async {
          await fakeFirestore.collection(collectionPath).doc('1').set({
            fbVersion: 1,
            fbPayload: 'event1',
          });
        },
        build: buildBloc,
        act: (bloc) async {
          bloc.add(CommonReplayBlocEvent(listen: true));
          // Allow Firebase listener to initialize and apply the first event
          await Future.delayed(const Duration(milliseconds: 150));
          await fakeFirestore.collection(collectionPath).doc('2').set({
            fbVersion: 2,
            fbPayload: 'event2',
          });
        },
        wait: const Duration(milliseconds: 300),
        // The listener emits an initial listening state with empty events,
        // then a state with event1 (processed as a batch), then event2 added.
        expect: () => [
          isA<ServiceReplayBlocState>()
              .having((s) => s.state, 'state', CommonReplayStateEnum.listening)
              .having((s) => s.events, 'events', {}),
          isA<ServiceReplayBlocState>()
              .having((s) => s.state, 'state', CommonReplayStateEnum.listening)
              .having((s) => s.events, 'events', {1: 'event1'}),
          isA<ServiceReplayBlocState>()
              .having((s) => s.state, 'state', CommonReplayStateEnum.listening)
              .having((s) => s.events, 'events', {1: 'event1', 2: 'event2'}),
        ],
      );

      // issues with fake_firestore package and security rules
      // blocTest<TestReplayBloc, ServiceReplayBlocState>(
      //   'emits [fetching, permissionDenied] on permission-denied error',
      //   build: () {
      //     final erroringFirestore = FakeFirebaseFirestore(
      //       securityRules: '''
      //         rules_version = '2';
      //         service cloud.firestore {
      //           match /databases/{database}/documents {
      //             match /{document=**} {
      //               allow read, write: if false;
      //             }
      //           }
      //         }
      //       ''',
      //     );
      //     return TestReplayBloc(collectionPath, firestore: erroringFirestore);
      //   },
      //   act: (bloc) => bloc.add(CommonReplayBlocEvent(listen: true)),
      //   expect: () => [
      //     isA<ServiceReplayBlocState>().having(
      //       (s) => s.state,
      //       'state',
      //       CommonReplayStateEnum.fetchingConfig,
      //     ),
      //     isA<ServiceReplayBlocState>().having(
      //       (s) => s.state,
      //       'state',
      //       CommonReplayStateEnum.permissionDenied,
      //     ),
      //   ],
      // );

      blocTest<TestReplayBloc, ServiceReplayBlocState>(
        'clears local state and refetches when validation fails',
        build: () => buildBloc(validationResult: false),
        seed: () => ServiceReplayBlocState(events: {1: 'stale_event'}),
        act: (bloc) {
          // Add some data to firestore that should be fetched after clearing
          fakeFirestore.collection(collectionPath).doc('2').set({
            fbVersion: 2,
            fbPayload: 'fresh_event',
          });
          bloc.add(CommonReplayBlocEvent(listen: true));
        },
        wait: const Duration(milliseconds: 300),
        // The validation failure path should first emit an uninitialized
        // state, and then the refreshed OK state with the fresh event.
        expect: () => [
          isA<ServiceReplayBlocState>().having(
            (s) => s.state,
            'state',
            CommonReplayStateEnum.uninitializedListening,
          ),
          isA<ServiceReplayBlocState>()
              .having((s) => s.state, 'state', CommonReplayStateEnum.listening)
              .having((s) => s.events, 'events', {2: 'fresh_event'}),
        ],
      );
    });

    group('NewEvents Event', () {
      blocTest<TestReplayBloc, ServiceReplayBlocState>(
        'correctly replays new events onto the current state',
        build: buildBloc,
        seed: () => ServiceReplayBlocState(events: {1: 'event1'}),
        act: (bloc) => bloc.add(
          CommonReplayBlocEvent(
            newEvents: CommonReplayBlocEvent_NewEvents(
              events: {2: 'event2', 3: 'event3'},
            ),
          ),
        ),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          isA<ServiceReplayBlocState>().having((s) => s.events, 'events', {
            1: 'event1',
            2: 'event2',
            3: 'event3',
          }),
        ],
      );
    });

    group('Hydration', () {
      test('toJson and fromJson work correctly', () async {
        final bloc = buildBloc(
          hydrateIsolateHandlerOverride: testHydrateIsolateHandler,
        );
        // `state` not used here; we'll construct the serializable state below

        // Build a state that uses simple string events since we're using
        // testHydrateIsolateHandler which doesn't decode base64.
        final json = bloc.toJson(
          ServiceReplayBlocState(events: {1: 'test_event'}),
        );
        final restoringState = bloc.fromJson(json!);
        expect(restoringState?.state, CommonReplayStateEnum.hydrating);
        // The fromJson stores events in _hydratedEvents and returns a copy of
        // the current state (which is the initial empty state). The actual
        // hydration happens later when listen is triggered.
        expect(restoringState?.events, isEmpty);
      });

      test('fromJson returns null on error', () {
        final bloc = buildBloc(
          hydrateIsolateHandlerOverride: testHydrateIsolateHandler,
        );
        final json = {'events_map': 'invalid data'};
        final newState = bloc.fromJson(json);
        expect(newState, isNull);
      });

      test('toJson handles empty events map', () async {
        final bloc = buildBloc(
          hydrateIsolateHandlerOverride: testHydrateIsolateHandler,
        );
        final state = ServiceReplayBlocState(); // Empty events map
        final json = bloc.toJson(state);
        final restoringState = bloc.fromJson(json!);
        expect(restoringState?.state, CommonReplayStateEnum.hydrating);

        await Future.delayed(const Duration(milliseconds: 100));
        expect(bloc.state.events, isEmpty);
      });
    });
  });
}
