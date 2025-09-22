// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:protobuf/protobuf.dart';

abstract class BaseSubmitEvent<T extends GeneratedMessage> {
  T? updatedPayload;
  final CommonSubmitBlocEvent submission;

  BaseSubmitEvent({this.updatedPayload, required this.submission});
}

class BaseSubmitState<T extends GeneratedMessage> {
  final T? payload;
  final CommonSubmitBlocState submissionState;

  BaseSubmitState({required this.payload, required this.submissionState});

  BaseSubmitState<T> copyWith({
    T? payload,
    CommonSubmitBlocState? submissionState,
  }) {
    return BaseSubmitState<T>(
      payload: payload ?? this.payload,
      submissionState: submissionState ?? this.submissionState,
    );
  }
}

abstract class BaseSubmitBloc<T extends GeneratedMessage>
    extends Bloc<BaseSubmitEvent<T>, BaseSubmitState<T>> {
  BaseSubmitBloc({required this.initialPayload})
    : isFormValid = false,
      payloadChanged = false,
      super(
        BaseSubmitState<T>(
          submissionState: CommonSubmitBlocState(
            state: CommonSubmitBlocState_State.ready,
            // payloadChanged: false,
            // isFormValid: false, // Initialize form validity
            errorCode: CommonSubmitBlocState_ErrorCode.none,
          ),
          payload: initialPayload,
        ),
      ) {
    on<BaseSubmitEvent<T>>(_onEvent);
  }

  T initialPayload;
  bool payloadChanged;
  bool isFormValid;

  FutureOr<void> _onEvent(
    BaseSubmitEvent<T> event,
    Emitter<BaseSubmitState<T>> emit,
  ) async {
    if (event.updatedPayload != null || event.submission.hasIsFormValid()) {
      if (state.submissionState.state != CommonSubmitBlocState_State.ready &&
          state.submissionState.state !=
              CommonSubmitBlocState_State.canSubmit) {
        return;
      }

      final newSubmissionState = state.submissionState.deepCopy();
      if (event.updatedPayload != null) {
        payloadChanged = event.updatedPayload != initialPayload;
      }
      if (event.submission.hasIsFormValid()) {
        isFormValid = event.submission.isFormValid;
      }

      newSubmissionState.state = payloadChanged && isFormValid
          ? CommonSubmitBlocState_State.canSubmit
          : CommonSubmitBlocState_State.ready;

      emit(
        state.copyWith(
          payload: event.updatedPayload ?? state.payload,
          submissionState: newSubmissionState..freeze(),
        ),
      );
    } else if (event.submission.hasSubmit()) {
      final submittingState = state.submissionState.deepCopy();
      submittingState.state = CommonSubmitBlocState_State.submitting;

      emit(state.copyWith(submissionState: submittingState..freeze()));

      try {
        var getAuthorState = await getAuthor(state);

        final submitResult = await submit(getAuthorState, emit);

        emit(submitResult);
      } catch (e) {
        if (kDebugMode) {
          print("submit error: ${e.toString()}");
        }
        final errorState = state.submissionState.deepCopy();
        errorState.state = CommonSubmitBlocState_State.error;
        if (e is FirebaseException && e.code == 'permission-denied') {
          errorState.errorCode =
              CommonSubmitBlocState_ErrorCode.permissionDenied;
        } else {
          errorState.errorCode = CommonSubmitBlocState_ErrorCode.networkError;
        }
        emit(state.copyWith(submissionState: errorState..freeze()));
      }
    }
  }

  /// Implement in subclasses
  Future<BaseSubmitState<T>> getAuthor(BaseSubmitState<T> state);
  Future<BaseSubmitState<T>> submit(
    BaseSubmitState<T> state,
    Emitter<BaseSubmitState<T>> emit,
  );
}
