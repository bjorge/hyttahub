import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/common_blocs/base_replay_bloc.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';

class _MockReplayBloc extends BaseReplayBloc<SiteReplayBlocState> {
  _MockReplayBloc(this.firestore) : super(SiteReplayBlocState());

  final FakeFirebaseFirestore firestore;

  @override
  String get collectionName => 'test';

  @override
  Future<String?> getCollectionPath() async => 'test';

  @override
  void handleEmptyInitialSnapshot(
      Emitter<SiteReplayBlocState> emit, SiteReplayBlocState currentState) {
    emit(currentState..status = CommonReplayStateEnum.ok);
  }

  @override
  SiteReplayBlocState replayEvents(
      SiteReplayBlocState currentState, Map<int, String> newEventsData) {
    final newState = currentState.deepCopy();
    newState.events.addAll(newEventsData);
    return newState;
  }

  @override
  Map<int, String> stateGetEventsMap(SiteReplayBlocState state) {
    return state.events;
  }

  @override
  CommonReplayStateEnum stateGetStatusEnum(SiteReplayBlocState state) {
    return state.status;
  }

  @override
  SiteReplayBlocState stateCopyWithStatus(
      SiteReplayBlocState currentState, CommonReplayStateEnum newStatusEnum) {
    return currentState.deepCopy()..status = newStatusEnum;
  }

  @override
  SiteReplayBlocState stateFromJson(
      Map<String, dynamic> json, Map<int, String> hydratedEvents) {
    return SiteReplayBlocState()..events.addAll(hydratedEvents);
  }

  @override
  Map<String, dynamic> stateToJson(SiteReplayBlocState state) {
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

    blocTest<_MockReplayBloc, SiteReplayBlocState>(
      'emits [fetching, ok] when listen is added and no events are fetched',
      build: () => _MockReplayBloc(firestore),
      act: (bloc) => bloc.add(CommonReplayBlocEvent(listen: true)),
      expect: () => [
        isA<SiteReplayBlocState>().having(
          (s) => s.status,
          'status',
          CommonReplayStateEnum.fetchingConfig,
        ),
        isA<SiteReplayBlocState>().having(
          (s) => s.status,
          'status',
          CommonReplayStateEnum.ok,
        ),
      ],
    );

    blocTest<_MockReplayBloc, SiteReplayBlocState>(
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
        isA<SiteReplayBlocState>().having(
          (s) => s.status,
          'status',
          CommonReplayStateEnum.fetchingConfig,
        ),
        isA<SiteReplayBlocState>()
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
