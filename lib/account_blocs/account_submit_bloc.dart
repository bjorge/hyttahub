// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/functions/site_cleanup.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/account_events.pb.dart';
import 'package:hyttahub/proto/site_util.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';
import 'package:hyttahub/storage/in_memory_hyttahub_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hyttahub/utilities/ids.dart';


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

  @override
  StorageEnum get storageType =>
      HyttaHubOptions.implementation?.storage ?? StorageEnum.cloud;

  final String email;

  @override
  Future<BaseSubmitState<SubmitAccountEvent>> submit(
    BaseSubmitState<SubmitAccountEvent> state,
    Emitter<BaseSubmitState<SubmitAccountEvent>> emitter,
  ) async {
    return submitSiteEvent(state, email, storage);
  }

  static Future<BaseSubmitState<SubmitAccountEvent>> submitSiteEvent(
    BaseSubmitState<SubmitAccountEvent> state,
    String email,
    BaseHyttaHubStorage storage,
  ) async {
    final submitAccountEvent = state.payload!;

    final encodedAccountEvent = base64Encode(
      submitAccountEvent.event.writeToBuffer(),
    );

    if (submitAccountEvent.event.hasCreateSite()) {
      final siteId = submitAccountEvent.event.createSite;
      final siteName = submitAccountEvent.createSiteName;
      final siteUserName = submitAccountEvent.createSiteUserName;

      final siteEvent = SiteEvent(
        version: 1,
        newSite: SiteEvent_NewSite(
          siteName: siteName,
          memberName: siteUserName,
          instance: generateId(),
        ),
      );
      final encodedSiteEvent = base64Encode(siteEvent.writeToBuffer());

      // Write site user first (sequential)
      if (kDebugMode) {
        print("write site user has version: ${siteEvent.version}");
      }
      await storage.setDocument(
        firebaseSiteUsersPath(siteId),
        email,
        {
          'u': siteEvent.version,
          fbTimeStamp: storage.serverTimestamp,
        },
      );

      // Then write site event (sequential)
      if (kDebugMode) {
        print("write site event has version: ${siteEvent.version}");
      }
      await storage.setDocument(
        firebaseSiteEventsPath(siteId),
        siteEvent.version.toString(),
        {
          fbPayload: encodedSiteEvent,
          fbVersion: siteEvent.version,
          fbTimeStamp: storage.serverTimestamp,
        },
      );

      // Finally write account event (sequential)
      if (kDebugMode) {
        print("write account event version: ${submitAccountEvent.event.version}");
      }
      await storage.setDocument(
        firebaseAccountEventsPath(email),
        submitAccountEvent.event.version.toString(),
        {
          fbPayload: encodedAccountEvent,
          fbVersion: submitAccountEvent.event.version,
          fbTimeStamp: storage.serverTimestamp,
        },
      );
    } else {
      if (kDebugMode) {
        print("non-create site event: ${submitAccountEvent.event.version}");
      }
      await storage.runBatch((batch) async {
        if (submitAccountEvent.event.hasJoinSite()) {
          final siteId = submitAccountEvent.event.joinSite;
          final userDoc =
              await storage.getDocument(firebaseSiteUsersPath(siteId), email);
          if (userDoc == null) {
            throw Exception('Error: Cannot join site, user does not exist.');
          }
        }

        if (submitAccountEvent.event.hasLeaveSite()) {
          final siteId = submitAccountEvent.event.leaveSite;
          final userDoc =
              await storage.getDocument(firebaseSiteUsersPath(siteId), email);
          final authorId = (userDoc?[fbUserId] as int?) ?? 0;
          final markForDeletionInfo = base64Encode(
            MarkForDeletion(
              deleteReason: MarkForDeletion_DeleteReason.memberLeftSite,
              author: authorId,
            ).writeToBuffer(),
          );

          batch.updateDocument(
            firebaseSiteUsersPath(siteId),
            email,
            {
              fbSiteMemberMarkedForDeletion: markForDeletionInfo,
              fbTimeStamp: storage.serverTimestamp,
            },
          );
        }

        if (!submitAccountEvent.event.hasLeaveSite()) {
          batch.setDocument(
            firebaseAccountEventsPath(email),
            submitAccountEvent.event.version.toString(),
            {
              fbPayload: encodedAccountEvent,
              fbVersion: submitAccountEvent.event.version,
              fbTimeStamp: storage.serverTimestamp,
            },
          );
        }
      });

      // In-memory/local storage: perform inline cleanup that the Firebase
      // cloud function (processMarkForDeleteRecords) would normally handle.
      if (storage is InMemoryHyttaHubStorage &&
          submitAccountEvent.event.hasLeaveSite()) {
        final memStorage = storage;
        final siteId = submitAccountEvent.event.leaveSite;

        // 1. Get the user's memberId before deleting the doc
        final userDoc = await storage.getDocument(
          firebaseSiteUsersPath(siteId),
          email,
        );
        final memberId = userDoc?[fbUserId] as int?;

        // 2. Add a LeaveSite event to the site's event log
        if (memberId != null) {
          final siteEventsPath = firebaseSiteEventsPath(siteId);
          final siteEvents = await storage.getCollection(
            siteEventsPath,
            orderBy: fbVersion,
            descending: true,
          );
          final nextSiteVersion = siteEvents.isEmpty
              ? 1
              : (siteEvents.first[fbVersion] as int) + 1;

          final leaveSiteEvent = SiteEvent(
            version: nextSiteVersion,
            author: memberId,
            leaveSite: SiteEvent_LeaveSite(memberId: memberId),
          );
          await storage.setDocument(
            siteEventsPath,
            nextSiteVersion.toString(),
            {
              fbPayload: base64Encode(leaveSiteEvent.writeToBuffer()),
              fbVersion: nextSiteVersion,
              fbTimeStamp: storage.serverTimestamp,
            },
          );
        }

        // 3. Delete the site_user document
        await memStorage.deleteDocument(
          firebaseSiteUsersPath(siteId),
          email,
        );

        // 4. Check if site has no remaining members; if so, clean up
        final remainingMembers = await storage.getCollection(
          firebaseSiteUsersPath(siteId),
        );
        if (remainingMembers.isEmpty) {
          await cleanUpOrphanedSite(
            storage: memStorage,
            siteId: siteId,
          );
        }
      }
    }

    final successState = state.submissionState.deepCopy();
    successState.state = CommonSubmitBlocState_State.success;

    return state.copyWith(submissionState: successState..freeze());
  }

  @override
  Future<BaseSubmitState<SubmitAccountEvent>> getAuthor(
    BaseSubmitState<SubmitAccountEvent> state,
  ) async {
    // There is no author in account events, so just return the same state
    if (kDebugMode) {
      print("account submit bloc getAuthor has verison: ${state.payload?.event.version}");
    }
    return state;
  }
}
