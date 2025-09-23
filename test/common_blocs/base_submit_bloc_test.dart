import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/service_events.pb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Mock Event
class TestSubmitEvent extends BaseSubmitEvent<SubmitServiceEvent> {
  TestSubmitEvent({
    SubmitServiceEvent? updatedPayload,
    required CommonSubmitBlocEvent submission,
  }) : super(updatedPayload: updatedPayload, submission: submission);
}

// Mock Bloc for testing
class TestSubmitBloc extends BaseSubmitBloc<SubmitServiceEvent> {
  TestSubmitBloc(
    SubmitServiceEvent initialPayload, {
    this.submitError,
  }) : super(initialPayload: initialPayload);

  final Exception? submitError;

  @override
  Future<BaseSubmitState<SubmitServiceEvent>> getAuthor(
    BaseSubmitState<SubmitServiceEvent> state,
  ) async {
    return state;
  }

  @override
  Future<BaseSubmitState<SubmitServiceEvent>> submit(
    BaseSubmitState<SubmitServiceEvent> state,
    Emitter<BaseSubmitState<SubmitServiceEvent>> emit,
  ) async {
    if (submitError != null) {
      throw submitError!;
    }
    final successState = state.submissionState.deepCopy()
      ..state = CommonSubmitBlocState_State.success;
    return state.copyWith(submissionState: successState);
  }
}

void main() {
  group('BaseSubmitBloc', () {
    late SubmitServiceEvent initialPayload;
    late SubmitServiceEvent updatedPayload;

    setUp(() {
      initialPayload = SubmitServiceEvent();
      updatedPayload = SubmitServiceEvent()
        ..addServiceAdminEmail = 'test@test.com';
    });

    test('initial state is correct', () {
      final bloc = TestSubmitBloc(initialPayload);
      expect(
          bloc.state.submissionState.state, CommonSubmitBlocState_State.ready);
      expect(bloc.state.payload, initialPayload);
    });

    blocTest<TestSubmitBloc, BaseSubmitState<SubmitServiceEvent>>(
      'emits [canSubmit] when form is valid and payload is changed',
      build: () => TestSubmitBloc(initialPayload),
      act: (bloc) => bloc.add(
        TestSubmitEvent(
          updatedPayload: updatedPayload,
          submission: CommonSubmitBlocEvent(isFormValid: true),
        ),
      ),
      expect: () => [
        isA<BaseSubmitState<SubmitServiceEvent>>().having(
          (s) => s.submissionState.state,
          'state',
          CommonSubmitBlocState_State.canSubmit,
        ),
      ],
    );

    blocTest<TestSubmitBloc, BaseSubmitState<SubmitServiceEvent>>(
      'emits [ready] when form is invalid',
      build: () => TestSubmitBloc(initialPayload),
      act: (bloc) => bloc.add(
        TestSubmitEvent(
          updatedPayload: updatedPayload,
          submission: CommonSubmitBlocEvent(isFormValid: false),
        ),
      ),
      expect: () => [
        isA<BaseSubmitState<SubmitServiceEvent>>().having(
          (s) => s.submissionState.state,
          'state',
          CommonSubmitBlocState_State.ready,
        ),
      ],
    );

    blocTest<TestSubmitBloc, BaseSubmitState<SubmitServiceEvent>>(
      'emits [ready] when payload is unchanged',
      build: () => TestSubmitBloc(initialPayload),
      act: (bloc) => bloc.add(
        TestSubmitEvent(
          updatedPayload: initialPayload,
          submission: CommonSubmitBlocEvent(isFormValid: true),
        ),
      ),
      expect: () => [
        isA<BaseSubmitState<SubmitServiceEvent>>().having(
          (s) => s.submissionState.state,
          'state',
          CommonSubmitBlocState_State.ready,
        ),
      ],
    );

    blocTest<TestSubmitBloc, BaseSubmitState<SubmitServiceEvent>>(
      'emits [submitting, success] on successful submission',
      build: () => TestSubmitBloc(initialPayload),
      act: (bloc) {
        bloc.isFormValid = true;
        bloc.payloadChanged = true;
        bloc.add(
          TestSubmitEvent(
            submission: CommonSubmitBlocEvent(
              submit: CommonSubmitBlocEvent_SubmitNow(),
            ),
          ),
        );
      },
      expect: () => [
        isA<BaseSubmitState<SubmitServiceEvent>>().having(
          (s) => s.submissionState.state,
          'state',
          CommonSubmitBlocState_State.submitting,
        ),
        isA<BaseSubmitState<SubmitServiceEvent>>().having(
          (s) => s.submissionState.state,
          'state',
          CommonSubmitBlocState_State.success,
        ),
      ],
    );

    blocTest<TestSubmitBloc, BaseSubmitState<SubmitServiceEvent>>(
      'emits [submitting, error] with permissionDenied on FirebaseException',
      build: () => TestSubmitBloc(
        initialPayload,
        submitError:
            FirebaseException(plugin: 'firestore', code: 'permission-denied'),
      ),
      act: (bloc) {
        bloc.isFormValid = true;
        bloc.payloadChanged = true;
        bloc.add(
          TestSubmitEvent(
            submission: CommonSubmitBlocEvent(
              submit: CommonSubmitBlocEvent_SubmitNow(),
            ),
          ),
        );
      },
      expect: () => [
        isA<BaseSubmitState<SubmitServiceEvent>>().having(
          (s) => s.submissionState.state,
          'state',
          CommonSubmitBlocState_State.submitting,
        ),
        isA<BaseSubmitState<SubmitServiceEvent>>()
            .having(
              (s) => s.submissionState.state,
              'state',
              CommonSubmitBlocState_State.error,
            )
            .having(
              (s) => s.submissionState.errorCode,
              'errorCode',
              CommonSubmitBlocState_ErrorCode.permissionDenied,
            ),
      ],
    );

    blocTest<TestSubmitBloc, BaseSubmitState<SubmitServiceEvent>>(
      'emits [submitting, error] with networkError on generic exception',
      build: () => TestSubmitBloc(
        initialPayload,
        submitError: Exception('Network error'),
      ),
      act: (bloc) {
        bloc.isFormValid = true;
        bloc.payloadChanged = true;
        bloc.add(
          TestSubmitEvent(
            submission: CommonSubmitBlocEvent(
              submit: CommonSubmitBlocEvent_SubmitNow(),
            ),
          ),
        );
      },
      expect: () => [
        isA<BaseSubmitState<SubmitServiceEvent>>().having(
          (s) => s.submissionState.state,
          'state',
          CommonSubmitBlocState_State.submitting,
        ),
        isA<BaseSubmitState<SubmitServiceEvent>>()
            .having(
              (s) => s.submissionState.state,
              'state',
              CommonSubmitBlocState_State.error,
            )
            .having(
              (s) => s.submissionState.errorCode,
              'errorCode',
              CommonSubmitBlocState_ErrorCode.networkError,
            ),
      ],
    );
  });
}
