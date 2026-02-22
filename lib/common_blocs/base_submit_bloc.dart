// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
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
  BaseSubmitBloc({
    required this.initialPayload,
    BaseHyttaHubStorage? storage,
  }) : isFormValid = false,
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
    if (storage != null) {
      _storage = storage;
    }
    on<BaseSubmitEvent<T>>(_onEvent);
  }

  BaseHyttaHubStorage? _storage;
  BaseHyttaHubStorage get storage =>
      _storage ?? HyttaHubStorageFactory.getStorage(storageType);

  T initialPayload;
  bool payloadChanged;
  bool isFormValid;

  /// Whether to allow payload updates and new submissions after a successful submission.
  /// Defaults to false to prevent accidental double-submissions or state divergence.
  bool get allowResubmission => false;

  FutureOr<void> _onEvent(
    BaseSubmitEvent<T> event,
    Emitter<BaseSubmitState<T>> emit,
  ) async {
    if (event.updatedPayload != null || event.submission.hasIsFormValid()) {
      // Always block updates if currently submitting
      if (state.submissionState.state ==
          CommonSubmitBlocState_State.submitting) {
        return;
      }

      // If strict mode (allowResubmission == false), block updates if not in ready/canSubmit state
      if (!allowResubmission &&
          state.submissionState.state != CommonSubmitBlocState_State.ready &&
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
          print("submit error: $T ${e.toString()}");
        }
        final errorState = state.submissionState.deepCopy();
        errorState.state = CommonSubmitBlocState_State.error;
        if (storage.isPermissionDenied(e)) {
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
  StorageEnum get storageType;

  /// Implement in subclasses
  Future<BaseSubmitState<T>> getAuthor(BaseSubmitState<T> state);
  Future<BaseSubmitState<T>> submit(
    BaseSubmitState<T> state,
    Emitter<BaseSubmitState<T>> emit,
  );
}
