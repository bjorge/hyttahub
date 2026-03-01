// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/site_email.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:bloc/bloc.dart';


const Duration firebaseTimeout = Duration(seconds: 15);

class SiteEventSubmission extends BaseSubmitEvent<SubmitSiteEvent> {
  SiteEventSubmission({super.updatedPayload, required super.submission});
}

SiteEventSubmission siteEventSubmissionFactory({
  SubmitSiteEvent? updatedPayload,
  required CommonSubmitBlocEvent submission,
}) {
  return SiteEventSubmission(
    updatedPayload: updatedPayload,
    submission: submission,
  );
}

class SiteSubmitBloc extends BaseSubmitBloc<SubmitSiteEvent> {
  SiteSubmitBloc(this.siteId, SubmitSiteEvent initialPayload)
    : super(initialPayload: initialPayload);

  @override
  StorageEnum get storageType =>
      HyttaHubOptions.implementation?.storage ?? StorageEnum.cloud;

  final String siteId;

  @override
  Future<BaseSubmitState<SubmitSiteEvent>> submit(
    BaseSubmitState<SubmitSiteEvent> state,
    Emitter<BaseSubmitState<SubmitSiteEvent>> emit,
  ) async {
    final submitSiteEvent = state.payload!;

    // now base64 encode the event part
    var encodedEvent = base64Encode(submitSiteEvent.event.writeToBuffer());

    // Batch operations
    await storage.runBatch((batch) async {
      if (submitSiteEvent.event.hasRemoveMember()) {
        if (kDebugMode) {
          print("Removing member: ${submitSiteEvent.toProto3Json()}");
        }
        final markForDeletionInfo = base64Encode(
          MarkForDeletion(
            deleteReason: MarkForDeletion_DeleteReason.memberRemovedFromSite,
          ).writeToBuffer(),
        );

        batch.updateDocument(
          firebaseSiteUsersPath(siteId),
          submitSiteEvent.removeMemberEmail,
          {
            fbSiteMemberMarkedForDeletion: markForDeletionInfo,
            fbTimeStamp: storage.serverTimestamp,
          },
        );
      }

      if (submitSiteEvent.event.hasAddMember()) {
        batch.setDocument(
          firebaseSiteUsersPath(siteId),
          submitSiteEvent.addMemberEmail,
          {
            'u': submitSiteEvent.event.version,
            fbTimeStamp: storage.serverTimestamp,
          },
        );
      }

      if (submitSiteEvent.event.hasUpdateMember()) {
        final originalEmail = submitSiteEvent.updateMemberOriginalEmail;
        final newEmail = submitSiteEvent.updateMemberNewEmail;

        if (originalEmail != newEmail) {
          final markForDeletionInfo = base64Encode(
            MarkForDeletion(
              deleteReason: MarkForDeletion_DeleteReason.memberEmailUpdated,
            ).writeToBuffer(),
          );
          batch.updateDocument(
            firebaseSiteUsersPath(siteId),
            originalEmail,
            {
              fbSiteMemberMarkedForDeletion: markForDeletionInfo,
              fbTimeStamp: storage.serverTimestamp,
            },
          );
          batch.setDocument(
            firebaseSiteUsersPath(siteId),
            newEmail,
            {
              'u': submitSiteEvent.event.updateMember.memberId,
              fbTimeStamp: storage.serverTimestamp,
            },
          );
        }
      }

      if (submitSiteEvent.event.hasRestoreMember()) {
        batch.setDocument(
          firebaseSiteUsersPath(siteId),
          submitSiteEvent.addMemberEmail,
          {
            'u': submitSiteEvent.event.restoreMember.memberId,
            fbTimeStamp: storage.serverTimestamp,
          },
        );
      }

      // update the events immutable collection with the event
      batch.setDocument(
        firebaseSiteEventsPath(siteId),
        submitSiteEvent.event.version.toString(),
        {
          fbPayload: encodedEvent,
          fbVersion: submitSiteEvent.event.version,
          fbTimeStamp: storage.serverTimestamp,
        },
      );
    });

    final successState = state.submissionState.deepCopy();
    successState.state = CommonSubmitBlocState_State.success;

    return state.copyWith(submissionState: successState..freeze());
  }

  @override
  Future<BaseSubmitState<SubmitSiteEvent>> getAuthor(
    BaseSubmitState<SubmitSiteEvent> state,
  ) async {
    final submitSiteEvent = state.payload!.deepCopy();
    submitSiteEvent.event = state.payload!.event.deepCopy();
    final email = state.payload!.authorEmail;

    if (email.isEmpty) {
      throw Exception("SubmitSiteEvent has no email, cannot determine author.");
    }

    // The author must be an existing site user.
    // We look up their ID from the site's users collection.
    final userDoc = await storage.getDocument(
      firebaseSiteUsersPath(siteId),
      email,
    );

    if (userDoc != null && userDoc.containsKey('u') == true) {
      // The 'u' field holds the author ID.
      submitSiteEvent.event.author = userDoc['u'];
    } else {
      // This is an error case: an action is being performed by a non-site-user.
      throw Exception(
        "Author not found for email: $email in site $siteId. User is not a member or document is malformed.",
      );
    }
    return state.copyWith(payload: submitSiteEvent);
  }
}
