// Copyright (c) 2025 bjorge

import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/auth_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:protobuf/protobuf.dart';

const Duration firebaseTimeout = Duration(seconds: 15);

class AuthEventSubmission extends BaseSubmitEvent<AuthBlocEvent> {
  AuthEventSubmission({super.updatedPayload, required super.submission});
}

AuthEventSubmission authEventSubmissionFactory({
  AuthBlocEvent? updatedPayload,
  required CommonSubmitBlocEvent submission,
}) {
  return AuthEventSubmission(
    updatedPayload: updatedPayload,
    submission: submission,
  );
}

class AuthSubmitBloc extends BaseSubmitBloc<AuthBlocEvent> {
  AuthSubmitBloc(this.email, AuthBlocEvent initialPayload)
    : super(initialPayload: initialPayload);
  final String email;

  @override
  Future<BaseSubmitState<AuthBlocEvent>> submit(
    BaseSubmitState<AuthBlocEvent> state,
    Emitter<BaseSubmitState<AuthBlocEvent>> emitter,
  ) async {
    return submitAuthEvent(state, email);
  }

  static Future<BaseSubmitState<AuthBlocEvent>> submitAuthEvent(
    BaseSubmitState<AuthBlocEvent> state,
    String email,
  ) async {
    final submitAuthEvent = state.payload!;

    if (submitAuthEvent.hasRemoveAccount()) {
      // Delete all documents in the account events collection.
      final collectionRef = FirebaseFirestore.instance.collection(
        firebaseAccountEventsPath(email),
      );
      final snapshot = await collectionRef.get().timeout(firebaseTimeout);
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Handle remove account event
      GetIt.instance<AuthBloc>().add(
        AuthBlocEvent(removeAccount: AuthBlocEvent_RemoveAccount()),
      );
    }

    if (submitAuthEvent.hasEmailSignup() || submitAuthEvent.hasEmailLogin()) {
      // Handle create account event
      GetIt.instance<AuthBloc>().add(submitAuthEvent);
    }

    final successState = state.submissionState.deepCopy();
    successState.state = CommonSubmitBlocState_State.success;
    return state.copyWith(submissionState: successState..freeze());
  }

  @override
  Future<BaseSubmitState<AuthBlocEvent>> getAuthor(
    BaseSubmitState<AuthBlocEvent> state,
  ) async {
    // There is no author in auth events, so just return the same state
    return state;
  }
}
