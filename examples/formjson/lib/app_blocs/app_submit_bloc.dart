// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:formjson/models/app_events.dart';
import 'package:hyttahub/common_blocs/base_submit_dart_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';

const Duration firebaseTimeout = Duration(seconds: 15);

class AppEventSubmission extends BaseSubmitDartEvent<SubmitAppEvent> {
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

class AppSubmitBloc extends BaseSubmitDartBloc<SubmitAppEvent> {
  AppSubmitBloc(this.siteId, SubmitAppEvent initialPayload)
      : super(initialPayload: initialPayload);

  final String siteId;

  @override
  Future<BaseSubmitDartState<SubmitAppEvent>> submit(
    BaseSubmitDartState<SubmitAppEvent> state,
    Emitter<BaseSubmitDartState<SubmitAppEvent>> emit,
  ) async {
    final submitAppEvent = state.payload!;

    // now base64 encode the event part
    final siteEvent = SiteEvent(
      version: submitAppEvent.siteEvent!.version,
      appEvent: packAppEventWrapper(
        utf8.encode(
          jsonEncode(
            submitAppEvent.appEvent!.toJson(),
          ),
        ),
      ),
      author: submitAppEvent.siteEvent!.author,
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

    final successState = state.submissionState.deepCopy()
      ..state = CommonSubmitBlocState_State.success;

    return state.copyWith(submissionState: successState);
  }

  @override
  Future<BaseSubmitDartState<SubmitAppEvent>> getAuthor(
    BaseSubmitDartState<SubmitAppEvent> state,
  ) async {
    final email = state.payload!.authorEmail;

    if (email == null || email.isEmpty) {
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
      final authorId = userDoc.data()!['u'] as int;
      final updatedSiteEvent = state.payload!.siteEvent!.copyWith(
        author: authorId,
      );
      return state.copyWith(
        payload: state.payload!.copyWith(
          siteEvent: updatedSiteEvent,
        ),
      );
    } else {
      // This is an error case: an action is being performed by a non-site-user.
      throw Exception(
        "Author not found for email: $email in site $siteId. User is not a member or document is malformed.",
      );
    }
  }
}
