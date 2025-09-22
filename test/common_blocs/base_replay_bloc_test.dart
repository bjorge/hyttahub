import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/common_blocs/base_replay_bloc.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hyttahub/firebase_paths.dart';

class _MockReplayBloc extends BaseReplayBloc<CommonReplayState> {
  _MockReplayBloc(this.firestore) : super(CommonReplayState());

  final FakeFirebaseFirestore firestore;

  @override
  String get collectionName => 'test';

  @override
  Future<String?> getCollectionPath() async => 'test';

  @override
  void handleEmptyInitialSnapshot(
      Emitter<CommonReplayState> emit, CommonReplayState currentState) {
    emit(currentState..status = CommonReplayStateEnum.ok);
  }

  @override
  CommonReplayState replayEvents(
      CommonReplayState currentState, Map<int, String> newEventsData) {
    final newState = currentState.deepCopy();
    newState.events.addAll(newEventsData);
    return newState;
  }

  @override
  Map<int, String> stateGetEventsMap(CommonReplayState state) {
    return state.events;
  }

  @override
  CommonReplayStateEnum stateGetStatusEnum(CommonReplayState state) {
    return state.status;
  }

  @override
  CommonReplayState stateCopyWithStatus(
      CommonReplayState currentState, CommonReplayStateEnum newStatusEnum) {
    return currentState.deepCopy()..status = newStatusEnum;
  }

  @override
  CommonReplayState stateFromJson(
      Map<String, dynamic> json, Map<int, String> hydratedEvents) {
    return CommonReplayState()..events.addAll(hydratedEvents);
  }

  @override
  Map<String, dynamic> stateToJson(CommonReplayState state) {
    return {};
  }

  @override
  FirebaseFirestore get firestoreInstance => firestore;
}

void main() {
  group('BaseReplayBloc', () {
    late FakeFirebaseFirestore firestore;

    setUp(() {
      firestore = FakeFirebaseFirestore();
    });

    blocTest<_MockReplayBloc, CommonReplayState>(
      'emits [fetching, ok] when listen is added and no events are fetched',
      build: () => _MockReplayBloc(firestore),
      act: (bloc) => bloc.add(CommonReplayBlocEvent(listen: true)),
      expect: () => [
        CommonReplayState(status: CommonReplayStateEnum.fetchingConfig),
        CommonReplayState(status: CommonReplayStateEnum.ok),
      ],
    );

    blocTest<_MockReplayBloc, CommonReplayState>(
      'emits [fetching, ok] with events when listen is added and events are fetched',
      build: () {
        firestore.collection('test').doc('1').set({
          fbVersion: 1,
          fbPayload: 'event1',
        });
        return _MockReplayBloc(firestore);
      },
      act: (bloc) => bloc.add(CommonReplayBlocEvent(listen: true)),
      expect: () => [
        CommonReplayState(status: CommonReplayStateEnum.fetchingConfig),
        isA<CommonReplayState>()
            .having(
              (s) => s.status,
              'status',
              CommonReplayStateEnum.ok,
            )
            .having(
              (s) => s.events,
              'events',
              {1: 'event1'},
            ),
      ],
    );
  });
}

extension on BaseReplayBloc {
  FirebaseFirestore get firestoreInstance => FirebaseFirestore.instance;
}
