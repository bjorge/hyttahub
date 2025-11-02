// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:familytree/proto/app_events.pb.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:hyttahub/utilities/pack_any.dart';
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

    if (submitAppEvent.appEvent.hasAddPhoto() &&
        submitAppEvent.images.isNotEmpty) {
      var version = submitAppEvent.siteEvent.version;
      var uploadedCount = 0;
      final totalCount = submitAppEvent.images.length;

      for (var image in submitAppEvent.images) {
        if (!image.hasBase64Data()) {
          throw Exception("Image data is empty for version $version");
        }

        // Upload to Firebase Storage
        final callable = FirebaseFunctions.instance.httpsCallable(
          'uploadPhoto',
        );

        // final base64Data = base64Encode(image.data);

        await callable.call({
          'appName': HyttaHubOptions.firebaseRootCollection,
          'siteId': siteId,
          'fileName': version.toString(),
          'base64Data': image.base64Data,
        });

        // result.data is a Map<String, dynamic>
        // final data = result.data as Map<String, dynamic>;

        // Extract your field
        // final uploadUrl = data['uploadUrl'] as String;

        final newEvent = submitAppEvent.appEvent.deepCopy();
        newEvent.addPhoto.name = image.name;
        newEvent.addPhoto.size = image.size;

        final siteEvent = SiteEvent(
          version: version,
          appEvent: packAppEventWrapper(newEvent.writeToBuffer()),
          author: submitAppEvent.siteEvent.author,
        );

        encodedEvent = base64Encode(siteEvent.writeToBuffer());

        // also add the event to the site events
        await FirebaseFirestore.instance
            .collection(firebaseSiteEventsPath(siteId))
            .doc(version.toString())
            .set({
              fbPayload: encodedEvent,
              fbVersion: version,
              fbTimeStamp: FieldValue.serverTimestamp(),
            })
            .timeout(firebaseTimeout);
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
    } else if (submitAppEvent.appEvent.hasDeletePhoto()) {
      // Delete photo from storage
      if (submitAppEvent.deletePhotoUrl.isNotEmpty) {
        try {
          final photoRef = FirebaseStorage.instance.refFromURL(
            submitAppEvent.deletePhotoUrl,
          );
          await photoRef.delete();
        } catch (e) {
          // Log error but continue, as the event is more important.
          // The photo might already be deleted or URL is invalid.
          if (kDebugMode) {
            // ignore: avoid_print
            print('Failed to delete photo from storage: $e');
          }
        }
      }

      // also add the event to the site event

      await FirebaseFirestore.instance
          .collection(firebaseSiteEventsPath(siteId))
          .doc(siteEvent.version.toString())
          .set({
            fbPayload: encodedEvent,
            fbVersion: siteEvent.version,
            fbTimeStamp: FieldValue.serverTimestamp(),
          })
          .timeout(firebaseTimeout);
    } else if (submitAppEvent.appEvent.hasDeleteTree()) {
      // Delete photos from storage
      if (submitAppEvent.photoUrls.isNotEmpty) {
        for (final photoUrl in submitAppEvent.photoUrls.values) {
          if (photoUrl.isNotEmpty) {
            try {
              final photoRef = FirebaseStorage.instance.refFromURL(photoUrl);
              await photoRef.delete();
            } catch (e) {
              // Log error but continue, as the event is more important.
              if (kDebugMode) {
                // ignore: avoid_print
                print('Failed to delete photo from storage: $e');
              }
            }
          }
        }
      }
      // also add the event to the site events
      await FirebaseFirestore.instance
          .collection(firebaseSiteEventsPath(siteId))
          .doc(siteEvent.version.toString())
          .set({
            fbPayload: encodedEvent,
            fbVersion: siteEvent.version,
            fbTimeStamp: FieldValue.serverTimestamp(),
          })
          .timeout(firebaseTimeout);
    } else {
      await FirebaseFirestore.instance
          .collection(firebaseSiteEventsPath(siteId))
          .doc(siteEvent.version.toString())
          .set({
            fbPayload: encodedEvent,
            fbVersion: siteEvent.version,
            fbTimeStamp: FieldValue.serverTimestamp(),
          })
          .timeout(firebaseTimeout);
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
