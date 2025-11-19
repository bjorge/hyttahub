// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protobuf/protobuf.dart';

abstract class BaseSubmitDartEvent<T> {
  T? updatedPayload;
  final CommonSubmitBlocEvent submission;

  BaseSubmitDartEvent({this.updatedPayload, required this.submission});
}

class BaseSubmitDartState<T> {
  final T? payload;
  final CommonSubmitBlocState submissionState;

  BaseSubmitDartState({required this.payload, required this.submissionState});

  BaseSubmitDartState<T> copyWith({
    T? payload,
    CommonSubmitBlocState? submissionState,
  }) {
    return BaseSubmitDartState<T>(
      payload: payload ?? this.payload,
      submissionState: submissionState ?? this.submissionState,
    );
  }
}

abstract class BaseSubmitDartBloc<T>
    extends Bloc<BaseSubmitDartEvent<T>, BaseSubmitDartState<T>> {
  BaseSubmitDartBloc({required this.initialPayload})
      : isFormValid = false,
        payloadChanged = false,
        super(
          BaseSubmitDartState<T>(
            submissionState: CommonSubmitBlocState(
              state: CommonSubmitBlocState_State.ready,
              errorCode: CommonSubmitBlocState_ErrorCode.none,
            ),
            payload: initialPayload,
          ),
        ) {
    on<BaseSubmitDartEvent<T>>(_onEvent);
  }

  T initialPayload;
  bool payloadChanged;
  bool isFormValid;

  FutureOr<void> _onEvent(
    BaseSubmitDartEvent<T> event,
    Emitter<BaseSubmitDartState<T>> emit,
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
          submissionState: newSubmissionState,
        ),
      );
    } else if (event.submission.hasSubmit()) {
      final submittingState = state.submissionState.deepCopy()
        ..state = CommonSubmitBlocState_State.submitting;

      emit(state.copyWith(submissionState: submittingState));

      try {
        var getAuthorState = await getAuthor(state);
        final submitResult = await submit(getAuthorState, emit);
        emit(submitResult);
      } catch (e) {
        if (kDebugMode) {
          print("submit error: ${e.toString()}");
        }
        final errorState = state.submissionState.deepCopy()
          ..state = CommonSubmitBlocState_State.error;
        if (e is FirebaseException && e.code == 'permission-denied') {
          errorState.errorCode =
              CommonSubmitBlocState_ErrorCode.permissionDenied;
        } else {
          errorState.errorCode = CommonSubmitBlocState_ErrorCode.networkError;
        }
        emit(state.copyWith(submissionState: errorState));
      }
    }
  }

  /// Implement in subclasses
  Future<BaseSubmitDartState<T>> getAuthor(BaseSubmitDartState<T> state);
  Future<BaseSubmitDartState<T>> submit(
    BaseSubmitDartState<T> state,
    Emitter<BaseSubmitDartState<T>> emit,
  );
}
