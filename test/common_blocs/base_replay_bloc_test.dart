import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/common_blocs/base_replay_bloc.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hyttahub/firebase_paths.dart';

class _MockReplayBloc extends BaseReplayBloc<CommonSubmitBlocState> {
  _MockReplayBloc(this.firestore) : super(CommonSubmitBlocState());

  final FakeFirebaseFirestore firestore;

  @override
  String get collectionName => 'test';

  @override
  Future<String?> getCollectionPath() async => 'test';

  @override
  void handleEmptyInitialSnapshot(
      Emitter<CommonSubmitBlocState> emit, CommonSubmitBlocState currentState) {
    emit(currentState..status = CommonReplayStateEnum.ok);
  }

  @override
  CommonSubmitBlocState replayEvents(
      CommonSubmitBlocState currentState, Map<int, String> newEventsData) {
    final newState = currentState.deepCopy();
    // newState.events.addAll(newEventsData); // CommonSubmitBlocState has no events
    return newState;
  }

  @override
  Map<int, String> stateGetEventsMap(CommonSubmitBlocState state) {
    return {}; // CommonSubmitBlocState has no events
  }

  @override
  CommonReplayStateEnum stateGetStatusEnum(CommonSubmitBlocState state) {
    return state.status;
  }

  @override
  CommonSubmitBlocState stateCopyWithStatus(
      CommonSubmitBlocState currentState, CommonReplayStateEnum newStatusEnum) {
    return currentState.deepCopy()..status = newStatusEnum;
  }

  @override
  CommonSubmitBlocState stateFromJson(
      Map<String, dynamic> json, Map<int, String> hydratedEvents) {
    return CommonSubmitBlocState();
  }

  @override
  Map<String, dynamic> stateToJson(CommonSubmitBlocState state) {
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

    blocTest<_MockReplayBloc, CommonSubmitBlocState>(
      'emits [fetching, ok] when listen is added and no events are fetched',
      build: () => _MockReplayBloc(firestore),
      act: (bloc) => bloc.add(CommonReplayBlocEvent(listen: true)),
      expect: () => [
        isA<CommonSubmitBlocState>().having(
          (s) => s.status,
          'status',
          CommonReplayStateEnum.fetchingConfig,
        ),
        isA<CommonSubmitBlocState>().having(
          (s) => s.status,
          'status',
          CommonReplayStateEnum.ok,
        ),
      ],
    );

    blocTest<_MockReplayBloc, CommonSubmitBlocState>(
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
        isA<CommonSubmitBlocState>().having(
          (s) => s.status,
          'status',
          CommonReplayStateEnum.fetchingConfig,
        ),
        isA<CommonSubmitBlocState>().having(
          (s) => s.status,
          'status',
          CommonReplayStateEnum.ok,
        ),
      ],
    );
  });
}

extension on BaseReplayBloc {
  FirebaseFirestore get firestoreInstance => FirebaseFirestore.instance;
}
