// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/account_events.pb.dart';
import 'package:hyttahub/proto/site_email.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:protobuf/protobuf.dart';

const Duration firebaseTimeout = Duration(seconds: 15);

class AccountEventSubmission extends BaseSubmitEvent<SubmitAccountEvent> {
  AccountEventSubmission({super.updatedPayload, required super.submission});
}

AccountEventSubmission accountEventSubmissionFactory({
  SubmitAccountEvent? updatedPayload,
  required CommonSubmitBlocEvent submission,
}) {
  return AccountEventSubmission(
    updatedPayload: updatedPayload,
    submission: submission,
  );
}

class AccountSubmitBloc extends BaseSubmitBloc<SubmitAccountEvent> {
  AccountSubmitBloc(this.email, SubmitAccountEvent initialPayload)
    : super(initialPayload: initialPayload);
  final String email;

  @override
  Future<BaseSubmitState<SubmitAccountEvent>> submit(
    BaseSubmitState<SubmitAccountEvent> state,
    Emitter<BaseSubmitState<SubmitAccountEvent>> emitter,
  ) async {
    return submitSiteEvent(state, email);
  }

  static Future<BaseSubmitState<SubmitAccountEvent>> submitSiteEvent(
    BaseSubmitState<SubmitAccountEvent> state,
    String email,
  ) async {
    final submitAccountEvent = state.payload!;

    final encodedAccountEvent = base64Encode(
      submitAccountEvent.event.writeToBuffer(),
    );

    final firestore = FirebaseFirestore.instance;

    if (submitAccountEvent.event.hasCreateSite()) {
      // Handle add site event

      final siteId = submitAccountEvent.event.createSite;
      final siteName = submitAccountEvent.createSiteName;
      final siteUserName = submitAccountEvent.createSiteUserName;

      final siteEvent = SiteEvent(
        version: 1,
        newSite: SiteEvent_NewSite(
          siteName: siteName,
          memberName: siteUserName,
        ),
      );
      final encodedSiteEvent = base64Encode(siteEvent.writeToBuffer());

      // add this user (email) to the site as the first user
      await firestore
          .collection(firebaseSiteUsersPath(siteId))
          .doc(email)
          .set({
            'u': siteEvent.version,
            fbTimeStamp: FieldValue.serverTimestamp(),
          })
          .timeout(firebaseTimeout);

      // now that this use is allowed into the site, add the site first event
      await firestore
          .collection(firebaseSiteEventsPath(siteId))
          .doc(siteEvent.version.toString())
          .set({
            fbPayload: encodedSiteEvent,
            fbVersion: siteEvent.version,
            fbTimeStamp: FieldValue.serverTimestamp(),
          })
          .timeout(firebaseTimeout);
    }

    if (submitAccountEvent.event.hasJoinSite()) {
      final siteId = submitAccountEvent.event.joinSite;

      // check if the user is allowed to join the site
      final userDoc = await firestore
          .collection(firebaseSiteUsersPath(siteId))
          .doc(email)
          .get()
          .timeout(firebaseTimeout);

      if (!userDoc.exists) {
        throw Exception('Error: Cannot join site, user does not exist.');
      }
    }

    if (submitAccountEvent.event.hasLeaveSite()) {
      final siteId = submitAccountEvent.event.leaveSite;

      final markForDeletionInfo = base64Encode(
        MarkForDeletion(
          deleteReason: MarkForDeletion_DeleteReason.memberLeftSite,
        ).writeToBuffer(),
      );

      // Try to remove the user from the site
      try {
        await firestore
            .collection(firebaseSiteUsersPath(siteId))
            .doc(email)
            .update({
              fbMarkedForDeletion: markForDeletionInfo,
              fbTimeStamp: FieldValue.serverTimestamp(),
            })
            .timeout(firebaseTimeout);
      } catch (e) {
        // Best effort: ignore errors
      }
    }

    await firestore
        .collection(firebaseAccountEventsPath(email))
        .doc(submitAccountEvent.event.version.toString())
        .set({
          fbPayload: encodedAccountEvent,
          fbVersion: submitAccountEvent.event.version,
          fbTimeStamp: FieldValue.serverTimestamp(),
        })
        .timeout(firebaseTimeout);

    final successState = state.submissionState.deepCopy();
    successState.state = CommonSubmitBlocState_State.success;

    return state.copyWith(submissionState: successState..freeze());
  }

  @override
  Future<BaseSubmitState<SubmitAccountEvent>> getAuthor(
    BaseSubmitState<SubmitAccountEvent> state,
  ) async {
    // There is no author in account events, so just return the same state
    return state;
  }
}
