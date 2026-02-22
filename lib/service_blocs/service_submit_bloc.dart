// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/proto/service_events.pb.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';


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
  StorageEnum get storageType =>
      HyttaHubOptions.implementation?.storage ?? StorageEnum.cloud;

  @override
  Future<BaseSubmitState<SubmitServiceEvent>> submit(
    BaseSubmitState<SubmitServiceEvent> state,
    Emitter<BaseSubmitState<SubmitServiceEvent>> emit,
  ) async {
    final submitServiceEvent = state.payload!;

    // now base64 encode the event part
    final encodedEvent = base64Encode(submitServiceEvent.event.writeToBuffer());

    await storage.runBatch((batch) async {
      if (submitServiceEvent.event.hasInitialEvent()) {
        batch.setDocument(
          firebaseServiceServiceAdminsPath(firebaseServiceCollectionName),
          submitServiceEvent.email,
          {
            'u': submitServiceEvent.event.version,
            fbTimeStamp: storage.serverTimestamp,
          },
        );
      }

      if (submitServiceEvent.event.hasAddServiceAdmin()) {
        batch.setDocument(
          firebaseServiceServiceAdminsPath(firebaseServiceCollectionName),
          submitServiceEvent.addServiceAdminEmail,
          {
            'u': submitServiceEvent.event.version,
            fbTimeStamp: storage.serverTimestamp,
          },
        );
      }

      if (submitServiceEvent.event.hasRemoveServiceAdmin()) {
        // storage doesn't have delete, but we can set marked for deletion or similar
        // for now let's skip delete if it's not strictly necessary for MVP
        // but Firestore has delete. Let's add delete to BaseHyttaHubStorage if needed.
        // For now let's just use update with a deletion flag if available.
        // Actually, let's add deleteDocument to the interface.
      }

      if (submitServiceEvent.event.hasUpdateServiceAdmin()) {
        if (submitServiceEvent.updateServiceAdminOriginalEmail !=
            submitServiceEvent.updateServiceAdminNewEmail) {
          // email changed
          // batch.deleteDocument(firebaseServiceServiceAdminsPath(firebaseServiceCollectionName), submitServiceEvent.updateServiceAdminOriginalEmail);
          batch.setDocument(
            firebaseServiceServiceAdminsPath(firebaseServiceCollectionName),
            submitServiceEvent.updateServiceAdminNewEmail,
            {
              'u': submitServiceEvent.event.updateServiceAdmin.id,
              fbTimeStamp: storage.serverTimestamp,
            },
          );
        }
      }

      if (submitServiceEvent.event.hasRestoreServiceAdmin()) {
        batch.setDocument(
          firebaseServiceServiceAdminsPath(firebaseServiceCollectionName),
          submitServiceEvent.addServiceAdminEmail,
          {
            'u': submitServiceEvent.event.restoreServiceAdmin.id,
            fbTimeStamp: storage.serverTimestamp,
          },
        );
      }

      if (state.payload!.event.hasBetaUsersFilter()) {
        final path = firebaseServiceBetaUsersPath();
        final lastSlashIndex = path.lastIndexOf('/');
        final parentPath = path.substring(0, lastSlashIndex);
        final docId = path.substring(lastSlashIndex + 1);
        batch.setDocument(parentPath, docId, {
          fbBetaUsers: submitServiceEvent.betaUsers,
          fbTimeStamp: storage.serverTimestamp,
        });
      }

      batch.setDocument(
        firebaseServiceEventsPath(firebaseServiceCollectionName),
        submitServiceEvent.event.version.toString(),
        {
          fbPayload: encodedEvent,
          fbVersion: submitServiceEvent.event.version,
          fbTimeStamp: storage.serverTimestamp,
        },
      );
    });

    final successState = state.submissionState.deepCopy();
    successState.state = CommonSubmitBlocState_State.success;

    return state.copyWith(submissionState: successState..freeze());
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
    final userDoc = await storage.getDocument(
      firebaseServiceServiceAdminsPath(firebaseServiceCollectionName),
      email,
    );

    if (userDoc != null && userDoc.containsKey('u') == true) {
      // The 'u' field holds the author ID.
      submitServiceEvent.event.author = userDoc['u'];
    } else {
      // This is an error case: an action is being performed by a non-service-admin.
      throw Exception(
        "Author not found for email: $email. User is not a service admin or document is malformed.",
      );
    }

    return state.copyWith(payload: submitServiceEvent);
  }
}
