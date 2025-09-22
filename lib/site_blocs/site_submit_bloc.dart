// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/site_email.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloc/bloc.dart';
import 'package:protobuf/protobuf.dart';

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

  final String siteId;

  @override
  Future<BaseSubmitState<SubmitSiteEvent>> submit(
    BaseSubmitState<SubmitSiteEvent> state,
    Emitter<BaseSubmitState<SubmitSiteEvent>> emit,
  ) async {
    final submitSiteEvent = state.payload!;

    // now base64 encode the event part
    var encodedEvent = base64Encode(submitSiteEvent.event.writeToBuffer());

    if (submitSiteEvent.event.hasRemoveMember()) {
      if (kDebugMode) {
        print("Removing member: ${submitSiteEvent.toProto3Json()}");
      }
      final markForDeletionInfo = base64Encode(
        MarkForDeletion(
          deleteReason: MarkForDeletion_DeleteReason.memberRemovedFromSite,
        ).writeToBuffer(),
      );
      try {
        await FirebaseFirestore.instance
            .collection(firebaseSiteUsersPath(siteId))
            .doc(submitSiteEvent.removeMemberEmail)
            .update({
              fbMarkedForDeletion: markForDeletionInfo,
              fbTimeStamp: FieldValue.serverTimestamp(),
            })
            .timeout(firebaseTimeout);
      } catch (e) {
        if (kDebugMode) {
          print("Removing member error: e: $e");
        }

        // Best effort: ignore errors
      }
    }

    if (submitSiteEvent.event.hasAddMember()) {
      // add this user (email) to the site
      await FirebaseFirestore.instance
          .collection(firebaseSiteUsersPath(siteId))
          .doc(submitSiteEvent.addMemberEmail)
          .set({
            'u': submitSiteEvent.event.version,
            fbTimeStamp: FieldValue.serverTimestamp(),
          })
          .timeout(firebaseTimeout);
    }

    if (submitSiteEvent.event.hasUpdateMember()) {
      if (kDebugMode) {
        print("Updating member: ${submitSiteEvent.toProto3Json()}");
      }
      final originalEmail = submitSiteEvent.updateMemberOriginalEmail;
      final newEmail = submitSiteEvent.updateMemberNewEmail;

      if (originalEmail != newEmail) {
        // Emails have changed, so update the allowed_emails collection
        final batch = FirebaseFirestore.instance.batch();

        // Mark the old email for deletion
        final oldEmailRef = FirebaseFirestore.instance
            .collection(firebaseSiteUsersPath(siteId))
            .doc(originalEmail);
        final markForDeletionInfo = base64Encode(
          MarkForDeletion(
            deleteReason: MarkForDeletion_DeleteReason.memberEmailUpdated,
          ).writeToBuffer(),
        );
        batch.update(oldEmailRef, {
          fbMarkedForDeletion: markForDeletionInfo,
          fbTimeStamp: FieldValue.serverTimestamp(),
        });

        // Add the new email
        final newEmailRef = FirebaseFirestore.instance
            .collection(firebaseSiteUsersPath(siteId))
            .doc(newEmail);
        batch.set(newEmailRef, {
          'u': submitSiteEvent.event.updateMember.memberId,
          fbTimeStamp: FieldValue.serverTimestamp(),
        });

        await batch.commit().timeout(firebaseTimeout);
      }
    }

    if (submitSiteEvent.event.hasRestoreMember()) {
      if (kDebugMode) {
        print("Restoring member: ${submitSiteEvent.toProto3Json()}");
      }
      await FirebaseFirestore.instance
          .collection(firebaseSiteUsersPath(siteId))
          .doc(submitSiteEvent.addMemberEmail)
          .set({
            'u': submitSiteEvent.event.restoreMember.memberId,
            fbTimeStamp: FieldValue.serverTimestamp(),
          })
          .timeout(firebaseTimeout);
    }

    // update the events immutable collection with the event
    await FirebaseFirestore.instance
        .collection(firebaseSiteEventsPath(siteId))
        .doc(submitSiteEvent.event.version.toString())
        .set({
          fbPayload: encodedEvent,
          fbVersion: submitSiteEvent.event.version,
          fbTimeStamp: FieldValue.serverTimestamp(),
        })
        .timeout(firebaseTimeout);

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
    final userDoc = await FirebaseFirestore.instance
        .collection(firebaseSiteUsersPath(siteId))
        .doc(email)
        .get()
        .timeout(firebaseTimeout);

    if (userDoc.exists && userDoc.data()?.containsKey('u') == true) {
      // The 'u' field holds the author ID.
      submitSiteEvent.event.author = userDoc.data()!['u'];
    } else {
      // This is an error case: an action is being performed by a non-site-user.
      throw Exception(
        "Author not found for email: $email in site $siteId. User is not a member or document is malformed.",
      );
    }
    return state.copyWith(payload: submitSiteEvent);
  }
}
