// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/common_blocs/base_replay_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:protobuf/protobuf.dart';

// A concrete implementation of BaseReplayBloc for testing purposes
class TestReplayBloc extends BaseReplayBloc<ServiceReplayBlocState> {
  TestReplayBloc(
    this.collectionPath, {
    required this.firestore,
    this.validationResult = true,
    this.handleEmptySnapshotCompleter,
  }) : super(ServiceReplayBlocState());

  final String collectionPath;
  final FirebaseFirestore firestore;
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
  CommonReplayStateEnum stateGetStatusEnum(ServiceReplayBlocState state) =>
      state.state;

  @override
  void handleEmptyInitialSnapshot(
    Emitter<ServiceReplayBlocState> emit,
    ServiceReplayBlocState currentState,
  ) {
    emit(
      currentState.deepCopy()..state = CommonReplayStateEnum.uninitialized,
    );
    handleEmptySnapshotCompleter?.complete();
  }

  @override
  ServiceReplayBlocState stateFromJson(
    Map<String, dynamic> json,
    Map<int, String> hydratedEvents,
  ) {
    return ServiceReplayBlocState(events: hydratedEvents);
  }

  @override
  Map<String, dynamic> stateToJson(ServiceReplayBlocState state) {
    return {};
  }

  @override
  Future<bool> validateServerState(
    ServiceReplayBlocState localState,
    String collectionPath,
  ) async {
    return validationResult;
  }

  // Override to use the test instance of firestore
  @override
  FirebaseFirestore get _firestore => firestore;
}

void main() {
  group('BaseReplayBloc', () {
    late FakeFirebaseFirestore fakeFirestore;
    const collectionPath = 'test_collection';

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
    });

    TestReplayBloc buildBloc({
      bool validationResult = true,
      Completer? emptySnapshotCompleter,
    }) {
      return TestReplayBloc(
        collectionPath,
        firestore: fakeFirestore,
        validationResult: validationResult,
        handleEmptySnapshotCompleter: emptySnapshotCompleter,
      );
    }

    test('initial state is correct', () {
      final bloc = buildBloc();
      expect(bloc.state, ServiceReplayBlocState());
      expect(bloc.state.state, CommonReplayStateEnum.ok);
    });

    group('Listen Event', () {
      blocTest<TestReplayBloc, ServiceReplayBlocState>(
        'emits [fetching, ok] when fetching initial data',
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
        expect: () => [
          isA<ServiceReplayBlocState>().having(
            (s) => s.state,
            'state',
            CommonReplayStateEnum.fetchingConfig,
          ),
          isA<ServiceReplayBlocState>()
              .having((s) => s.state, 'state', CommonReplayStateEnum.ok)
              .having(
                (s) => s.events,
                'events',
                {1: 'event1', 2: 'event2'},
              ),
        ],
      );

      blocTest<TestReplayBloc, ServiceReplayBlocState>(
        'emits [fetching, uninitialized] on empty initial snapshot',
        build: buildBloc,
        act: (bloc) => bloc.add(CommonReplayBlocEvent(listen: true)),
        expect: () => [
          isA<ServiceReplayBlocState>().having(
            (s) => s.state,
            'state',
            CommonReplayStateEnum.fetchingConfig,
          ),
          isA<ServiceReplayBlocState>().having(
            (s) => s.state,
            'state',
            CommonReplayStateEnum.uninitialized,
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
          await Future.delayed(const Duration(milliseconds: 100));
          await fakeFirestore.collection(collectionPath).doc('2').set({
            fbVersion: 2,
            fbPayload: 'event2',
          });
        },
        expect: () => [
          isA<ServiceReplayBlocState>().having(
            (s) => s.state,
            'state',
            CommonReplayStateEnum.fetchingConfig,
          ),
          isA<ServiceReplayBlocState>()
              .having((s) => s.state, 'state', CommonReplayStateEnum.ok)
              .having((s) => s.events, 'events', {1: 'event1'}),
          isA<ServiceReplayBlocState>()
              .having((s) => s.state, 'state', CommonReplayStateEnum.ok)
              .having(
                (s) => s.events,
                'events',
                {1: 'event1', 2: 'event2'},
              ),
        ],
      );

      blocTest<TestReplayBloc, ServiceReplayBlocState>(
        'emits [fetching, permissionDenied] on permission-denied error',
        build: () {
          final erroringFirestore = FakeFirebaseFirestore(
            securityRules: '''
              rules_version = '2';
              service cloud.firestore {
                match /databases/{database}/documents {
                  match /{document=**} {
                    allow read, write: if false;
                  }
                }
              }
            ''',
          );
          return TestReplayBloc(collectionPath, firestore: erroringFirestore);
        },
        act: (bloc) => bloc.add(CommonReplayBlocEvent(listen: true)),
        expect: () => [
          isA<ServiceReplayBlocState>().having(
            (s) => s.state,
            'state',
            CommonReplayStateEnum.fetchingConfig,
          ),
          isA<ServiceReplayBlocState>().having(
            (s) => s.state,
            'state',
            CommonReplayStateEnum.permissionDenied,
          ),
        ],
      );

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
        expect: () => [
          isA<ServiceReplayBlocState>().having(
            (s) => s.state,
            'state',
            CommonReplayStateEnum.fetchingConfig,
          ),
          isA<ServiceReplayBlocState>()
              .having((s) => s.state, 'state', CommonReplayStateEnum.ok)
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
        expect: () => [
          isA<ServiceReplayBlocState>().having(
            (s) => s.events,
            'events',
            {1: 'event1', 2: 'event2', 3: 'event3'},
          ),
        ],
      );
    });

    group('ErrorOccurred Event', () {
      blocTest<TestReplayBloc, ServiceReplayBlocState>(
        'emits a networkError state',
        build: buildBloc,
        act: (bloc) => bloc.add(
          CommonReplayBlocEvent(errorOccurred: 'Something went wrong'),
        ),
        expect: () => [
          isA<ServiceReplayBlocState>().having(
            (s) => s.state,
            'state',
            CommonReplayStateEnum.networkError,
          ),
        ],
      );
    });

    group('Hydration', () {
      test('toJson and fromJson work correctly', () {
        final bloc = buildBloc();
        final state = ServiceReplayBlocState(events: {
          1: 'event1',
          2: 'event2',
        });

        final json = bloc.toJson(state);
        final newState = bloc.fromJson(json!);

        expect(newState?.events, state.events);
      });

      test('fromJson returns null on error', () {
        final bloc = buildBloc();
        final json = {'events_map': 'invalid data'};
        final newState = bloc.fromJson(json);
        expect(newState, isNull);
      });

      test('toJson handles empty events map', () {
        final bloc = buildBloc();
        final state = ServiceReplayBlocState(); // Empty events map
        final json = bloc.toJson(state);
        final newState = bloc.fromJson(json!);
        expect(newState?.events, isEmpty);
      });
    });
  });
}
