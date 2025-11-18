// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:formproto/proto/app_events.pb.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloc/bloc.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';
import 'package:protobuf/protobuf.dart';

const Duration firebaseTimeout = Duration(seconds: 15);

class AppEventSubmission extends BaseSubmitEvent<SubmitAppEvent> {
  AppEventSubmission({super.updatedPayload, required super.submission});
}

AppEventSubmission appEventSubmissionFactory({
  SubmitAppEvent? updatedPayload,
  required CommonSubmitBlocEvent submission,
}) {
  return AppEventSubmission(
    updatedPayload: updatedPayload,
    submission: submission,
  );
}

class AppSubmitBloc extends BaseSubmitBloc<SubmitAppEvent> {
  AppSubmitBloc(this.siteId, SubmitAppEvent initialPayload)
    : super(initialPayload: initialPayload);

  final String siteId;

  @override
  Future<BaseSubmitState<SubmitAppEvent>> submit(
    BaseSubmitState<SubmitAppEvent> state,
    Emitter<BaseSubmitState<SubmitAppEvent>> emit,
  ) async {
    final submitAppEvent = state.payload!;

    // now base64 encode the event part
    final siteEvent = SiteEvent(
      version: submitAppEvent.siteEvent.version,
      appEvent: packAppEventWrapper(submitAppEvent.appEvent.writeToBuffer()),
      author: submitAppEvent.siteEvent.author,
    );

    var encodedEvent = base64Encode(siteEvent.writeToBuffer());

    await FirebaseFirestore.instance
        .collection(firebaseSiteEventsPath(siteId))
        .doc(siteEvent.version.toString())
        .set({
          fbPayload: encodedEvent,
          fbVersion: siteEvent.version,
          fbTimeStamp: FieldValue.serverTimestamp(),
        })
        .timeout(firebaseTimeout);

    final successState = state.submissionState.deepCopy();
    successState.state = CommonSubmitBlocState_State.success;

    return state.copyWith(submissionState: successState..freeze());
  }

  @override
  Future<BaseSubmitState<SubmitAppEvent>> getAuthor(
    BaseSubmitState<SubmitAppEvent> state,
  ) async {
    final submitAppEvent = state.payload!.deepCopy();
    submitAppEvent.siteEvent = state.payload!.siteEvent.deepCopy();
    final email = state.payload!.authorEmail;

    if (email.isEmpty) {
      throw Exception("SubmitAppEvent has no email, cannot determine author.");
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
      submitAppEvent.siteEvent.author = userDoc.data()!['u'];
    } else {
      // This is an error case: an action is being performed by a non-site-user.
      throw Exception(
        "Author not found for email: $email in site $siteId. User is not a member or document is malformed.",
      );
    }
    return state.copyWith(payload: submitAppEvent);
  }
}
