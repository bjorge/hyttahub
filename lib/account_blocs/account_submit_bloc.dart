// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/collection_paths.dart';
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


const Duration submitTimeout = Duration(seconds: 15);

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
        collectionSiteUsersPath(siteId),
        email,
        {
          'u': siteEvent.version,
          docTimeStamp: storage.serverTimestamp,
        },
      );

      // Then write site event (sequential)
      if (kDebugMode) {
        print("write site event has version: ${siteEvent.version}");
      }
      await storage.setDocument(
        collectionSiteEventsPath(siteId),
        siteEvent.version.toString(),
        {
          docPayload: encodedSiteEvent,
          docVersion: siteEvent.version,
          docTimeStamp: storage.serverTimestamp,
        },
      );

      // Finally write account event (sequential)
      if (kDebugMode) {
        print("write account event version: ${submitAccountEvent.event.version}");
      }
      await storage.setDocument(
        collectionAccountEventsPath(email),
        submitAccountEvent.event.version.toString(),
        {
          docPayload: encodedAccountEvent,
          docVersion: submitAccountEvent.event.version,
          docTimeStamp: storage.serverTimestamp,
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
              await storage.getDocument(collectionSiteUsersPath(siteId), email);
          if (userDoc == null) {
            throw Exception('Error: Cannot join site, user does not exist.');
          }
        }

        if (submitAccountEvent.event.hasLeaveSite()) {
          final siteId = submitAccountEvent.event.leaveSite;
          final userDoc =
              await storage.getDocument(collectionSiteUsersPath(siteId), email);
          final authorId = (userDoc?[docUserId] as int?) ?? 0;
          final markForDeletionInfo = base64Encode(
            MarkForDeletion(
              deleteReason: MarkForDeletion_DeleteReason.memberLeftSite,
              author: authorId,
            ).writeToBuffer(),
          );

          batch.updateDocument(
            collectionSiteUsersPath(siteId),
            email,
            {
              docSiteMemberMarkedForDeletion: markForDeletionInfo,
              docTimeStamp: storage.serverTimestamp,
            },
          );
        }

        if (!submitAccountEvent.event.hasLeaveSite()) {
          batch.setDocument(
            collectionAccountEventsPath(email),
            submitAccountEvent.event.version.toString(),
            {
              docPayload: encodedAccountEvent,
              docVersion: submitAccountEvent.event.version,
              docTimeStamp: storage.serverTimestamp,
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
          collectionSiteUsersPath(siteId),
          email,
        );
        final memberId = userDoc?[docUserId] as int?;

        // 2. Add a LeaveSite event to the site's event log
        if (memberId != null) {
          final siteEventsPath = collectionSiteEventsPath(siteId);
          final siteEvents = await storage.getCollection(
            siteEventsPath,
            orderBy: docVersion,
            descending: true,
          );
          final nextSiteVersion = siteEvents.isEmpty
              ? 1
              : (siteEvents.first[docVersion] as int) + 1;

          final leaveSiteEvent = SiteEvent(
            version: nextSiteVersion,
            author: memberId,
            leaveSite: SiteEvent_LeaveSite(memberId: memberId),
          );
          await storage.setDocument(
            siteEventsPath,
            nextSiteVersion.toString(),
            {
              docPayload: base64Encode(leaveSiteEvent.writeToBuffer()),
              docVersion: nextSiteVersion,
              docTimeStamp: storage.serverTimestamp,
            },
          );
        }

        // 3. Delete the site_user document
        await memStorage.deleteDocument(
          collectionSiteUsersPath(siteId),
          email,
        );

        // 4. Check if site has no remaining members; if so, clean up
        final remainingMembers = await storage.getCollection(
          collectionSiteUsersPath(siteId),
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
