// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:template/proto/app_events.pb.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:bloc/bloc.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';
import 'package:hyttahub/hyttahub_options.dart';

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

  @override
  StorageEnum get storageType =>
      HyttaHubOptions.implementation?.storage ?? StorageEnum.cloud;

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

    // Check if there are images to upload for this event
    if (submitAppEvent.images.isNotEmpty) {
      var version = submitAppEvent.siteEvent.version;
      var uploadedCount = 0;
      final totalCount = submitAppEvent.images.length;

      for (var image in submitAppEvent.images) {
        if (!image.hasBase64Data()) {
          throw Exception("Image data is empty for version $version");
        }

        await storage.uploadFile(
          appName:
              HyttaHubOptions.implementation?.firebaseRootCollection ?? '',
          siteId: siteId,
          fileName: version.toString(),
          base64Data: image.base64Data,
        );

        final newEvent = submitAppEvent.appEvent.deepCopy();
        // Update the event with the storage reference details
        if (newEvent.hasUpdatePhoto()) {
          newEvent.updatePhoto.version = version;
          newEvent.updatePhoto.name = image.name;
          newEvent.updatePhoto.size = image.size;
        }

        final siteEvent = SiteEvent(
          version: version,
          appEvent: packAppEventWrapper(newEvent.writeToBuffer()),
          author: submitAppEvent.siteEvent.author,
        );

        encodedEvent = base64Encode(siteEvent.writeToBuffer());

        await storage.setDocument(
          firebaseSiteEventsPath(siteId),
          version.toString(),
          {
            fbPayload: encodedEvent,
            fbVersion: version,
            fbTimeStamp: storage.serverTimestamp,
          },
        );

        version++;
        uploadedCount++;

        final progress =
            CommonSubmitBlocState_SubmitProgress()
              ..count = uploadedCount
              ..total = totalCount;

        final progressState =
            state.submissionState.deepCopy()
              ..state = CommonSubmitBlocState_State.submitting
              ..progress = progress;

        emit(state.copyWith(submissionState: progressState..freeze()));
      }
    } else {
      await storage.setDocument(
        firebaseSiteEventsPath(siteId),
        siteEvent.version.toString(),
        {
          fbPayload: encodedEvent,
          fbVersion: siteEvent.version,
          fbTimeStamp: storage.serverTimestamp,
        },
      );
    }

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
    final userDoc = await storage.getDocument(
      firebaseSiteUsersPath(siteId),
      email,
    );

    if (userDoc != null && userDoc.containsKey('u') == true) {
      // The 'u' field holds the author ID.
      submitAppEvent.siteEvent.author = userDoc['u'] as int;
    } else {
      // This is an error case: an action is being performed by a non-site-user.
      throw Exception(
        "Author not found for email: $email in site $siteId. User is not a member or document is malformed.",
      );
    }
    return state.copyWith(payload: submitAppEvent);
  }
}
