// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/service_events.pb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:protobuf/protobuf.dart';

class ServiceEventSubmission extends BaseSubmitEvent<SubmitServiceEvent> {
  ServiceEventSubmission({super.updatedPayload, required super.submission});
}

ServiceEventSubmission serviceEventSubmissionFactory({
  SubmitServiceEvent? updatedPayload,
  required CommonSubmitBlocEvent submission,
}) {
  return ServiceEventSubmission(
    updatedPayload: updatedPayload,
    submission: submission,
  );
}

class ServiceSubmitBloc extends BaseSubmitBloc<SubmitServiceEvent> {
  ServiceSubmitBloc(SubmitServiceEvent initialPayload)
    : super(initialPayload: initialPayload);

  @override
  Future<BaseSubmitState<SubmitServiceEvent>> submit(
    BaseSubmitState<SubmitServiceEvent> state,
    Emitter<BaseSubmitState<SubmitServiceEvent>> emit,
  ) async {
    final submitServiceEvent = state.payload!;

    // now base64 encode the event part
    final encodedEvent = base64Encode(submitServiceEvent.event.writeToBuffer());

    // now add it the a document in a firestore collection
    final firestore = FirebaseFirestore.instance;

    if (submitServiceEvent.event.hasInitialEvent()) {
      await firestore
          .collection(
            firebaseServiceServiceAdminsPath(firebaseServiceCollectionName),
          )
          .doc(submitServiceEvent.email)
          .set({
            'u': submitServiceEvent.event.version,
            fbTimeStamp: FieldValue.serverTimestamp(),
          });
    }

    if (submitServiceEvent.event.hasAddServiceAdmin()) {
      await firestore
          .collection(
            firebaseServiceServiceAdminsPath(firebaseServiceCollectionName),
          )
          .doc(submitServiceEvent.addServiceAdminEmail)
          .set({
            'u': submitServiceEvent.event.version,
            fbTimeStamp: FieldValue.serverTimestamp(),
          });
    }

    if (submitServiceEvent.event.hasRemoveServiceAdmin()) {
      await firestore
          .collection(
            firebaseServiceServiceAdminsPath(firebaseServiceCollectionName),
          )
          .doc(submitServiceEvent.removeServiceAdminEmail)
          .delete();
    }

    if (submitServiceEvent.event.hasUpdateServiceAdmin()) {
      if (submitServiceEvent.updateServiceAdminOriginalEmail !=
          submitServiceEvent.updateServiceAdminNewEmail) {
        // email changed, so delete old document and create new one
        await firestore
            .collection(
              firebaseServiceServiceAdminsPath(firebaseServiceCollectionName),
            )
            .doc(submitServiceEvent.updateServiceAdminOriginalEmail)
            .delete();
        await firestore
            .collection(
              firebaseServiceServiceAdminsPath(firebaseServiceCollectionName),
            )
            .doc(submitServiceEvent.updateServiceAdminNewEmail)
            .set({
              'u': submitServiceEvent.event.updateServiceAdmin.id,
              fbTimeStamp: FieldValue.serverTimestamp(),
            });
      }
    }

    if (submitServiceEvent.event.hasRestoreServiceAdmin()) {
      await firestore
          .collection(
            firebaseServiceServiceAdminsPath(firebaseServiceCollectionName),
          )
          .doc(submitServiceEvent.addServiceAdminEmail)
          .set({
            'u': submitServiceEvent.event.restoreServiceAdmin.id,
            fbTimeStamp: FieldValue.serverTimestamp(),
          });
    }

    if (state.payload!.event.hasBetaUsersFilter()) {
      final docPath = firebaseServiceBetaUsersPath();
      await firestore.doc(docPath).set({
        fbBetaUsers: submitServiceEvent.betaUsers,
        fbTimeStamp: FieldValue.serverTimestamp(),
      });
    }

    await firestore
        .collection(firebaseServiceEventsPath(firebaseServiceCollectionName))
        .doc(submitServiceEvent.event.version.toString())
        .set({
          fbPayload: encodedEvent,
          fbVersion: submitServiceEvent.event.version,
          fbTimeStamp: FieldValue.serverTimestamp(),
        });

    final submittingState = state.submissionState.deepCopy();
    submittingState.state = CommonSubmitBlocState_State.success;

    return state.copyWith(submissionState: submittingState..freeze());
  }

  @override
  Future<BaseSubmitState<SubmitServiceEvent>> getAuthor(
    BaseSubmitState<SubmitServiceEvent> state,
  ) async {
    final submitServiceEvent = state.payload!.deepCopy();
    final email = state.payload!.email;

    // For the initial event, the author is the first service admin, with ID 1.
    // The user document will be created in the submit step.
    if (submitServiceEvent.event.hasInitialEvent()) {
      submitServiceEvent.event.author = 1;
      return state.copyWith(payload: submitServiceEvent);
    }

    if (email.isEmpty) {
      throw Exception(
        "SubmitServiceEvent has no email, cannot determine author for non-initial event.",
      );
    }

    // For other events, the author must be an existing service admin.
    final firestore = FirebaseFirestore.instance;
    final userDoc = await firestore
        .collection(
          firebaseServiceServiceAdminsPath(firebaseServiceCollectionName),
        )
        .doc(email)
        .get();

    if (userDoc.exists && userDoc.data()?.containsKey('u') == true) {
      // The 'u' field holds the author ID.
      submitServiceEvent.event.author = userDoc.data()!['u'];
    } else {
      // This is an error case: an action is being performed by a non-service-admin.
      throw Exception(
        "Author not found for email: $email. User is not a service admin or document is malformed.",
      );
    }

    return state.copyWith(payload: submitServiceEvent);
  }
}
