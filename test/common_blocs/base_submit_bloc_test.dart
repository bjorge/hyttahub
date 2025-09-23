import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:bloc_test/bloc_test.dart';

class _MockSubmitBloc extends BaseSubmitBloc<CommonSubmitBlocState> {
  _MockSubmitBloc({required this.shouldSucceed})
      : super(initialPayload: CommonSubmitBlocState());

  final bool shouldSucceed;

  @override
  Future<BaseSubmitState<CommonSubmitBlocState>> getAuthor(
      BaseSubmitState<CommonSubmitBlocState> state) async {
    return state;
  }

  @override
  Future<BaseSubmitState<CommonSubmitBlocState>> submit(
      BaseSubmitState<CommonSubmitBlocState> state,
      Emitter<BaseSubmitState<CommonSubmitBlocState>> emit) async {
    if (shouldSucceed) {
      return state.copyWith(
        submissionState: CommonSubmitBlocState(
          state: CommonSubmitBlocState_State.success,
        ),
      );
    } else {
      return state.copyWith(
        submissionState: CommonSubmitBlocState(
          state: CommonSubmitBlocState_State.error,
        ),
      );
    }
  }
}

class _MockSubmitEvent extends BaseSubmitEvent<CommonSubmitBlocState> {
  _MockSubmitEvent({
    required CommonSubmitBlocEvent submission,
    CommonSubmitBlocState? updatedPayload,
  }) : super(submission: submission, updatedPayload: updatedPayload);
}

void main() {
  group('BaseSubmitBloc', () {
    blocTest<_MockSubmitBloc, BaseSubmitState<CommonSubmitBlocState>>(
      'emits [submitting, success] when submit is added and submission succeeds',
      build: () => _MockSubmitBloc(shouldSucceed: true),
      act: (bloc) => bloc.add(
        _MockSubmitEvent(
          submission: CommonSubmitBlocEvent(submitNow: CommonSubmitBlocEvent_SubmitNow()),
        ),
      ),
      expect: () => [
        isA<BaseSubmitState<CommonSubmitBlocState>>().having(
          (s) => s.submissionState.state,
          'state',
          CommonSubmitBlocState_State.submitting,
        ),
        isA<BaseSubmitState<CommonSubmitBlocState>>().having(
          (s) => s.submissionState.state,
          'state',
          CommonSubmitBlocState_State.success,
        ),
      ],
    );

    blocTest<_MockSubmitBloc, BaseSubmitState<CommonSubmitBlocState>>(
      'emits [submitting, error] when submit is added and submission fails',
      build: () => _MockSubmitBloc(shouldSucceed: false),
      act: (bloc) => bloc.add(
        _MockSubmitEvent(
          submission: CommonSubmitBlocEvent(submitNow: CommonSubmitBlocEvent_SubmitNow()),
        ),
      ),
      expect: () => [
        isA<BaseSubmitState<CommonSubmitBlocState>>().having(
          (s) => s.submissionState.state,
          'state',
          CommonSubmitBlocState_State.submitting,
        ),
        isA<BaseSubmitState<CommonSubmitBlocState>>().having(
          (s) => s.submissionState.state,
          'state',
          CommonSubmitBlocState_State.error,
        ),
      ],
    );
  });
}
