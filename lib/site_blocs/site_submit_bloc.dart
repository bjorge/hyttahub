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
import 'package:hyttahub/storage/in_memory_hyttahub_storage.dart';
import 'package:bloc/bloc.dart';


const Duration submitTimeout = Duration(seconds: 15);

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
            author: submitSiteEvent.event.author,
          ).writeToBuffer(),
        );

        batch.updateDocument(
          collectionSiteUsersPath(siteId),
          submitSiteEvent.removeMemberEmail,
          {
            docSiteMemberMarkedForDeletion: markForDeletionInfo,
            docTimeStamp: storage.serverTimestamp,
          },
        );
      }

      if (submitSiteEvent.event.hasAddMember()) {
        batch.setDocument(
          collectionSiteUsersPath(siteId),
          submitSiteEvent.addMemberEmail,
          {
            'u': submitSiteEvent.event.version,
            docTimeStamp: storage.serverTimestamp,
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
              author: submitSiteEvent.event.author,
            ).writeToBuffer(),
          );
          batch.updateDocument(
            collectionSiteUsersPath(siteId),
            originalEmail,
            {
              docSiteMemberMarkedForDeletion: markForDeletionInfo,
              docTimeStamp: storage.serverTimestamp,
            },
          );
          batch.setDocument(
            collectionSiteUsersPath(siteId),
            newEmail,
            {
              'u': submitSiteEvent.event.updateMember.memberId,
              docTimeStamp: storage.serverTimestamp,
            },
          );
        }
      }

      if (submitSiteEvent.event.hasRestoreMember()) {
        batch.setDocument(
          collectionSiteUsersPath(siteId),
          submitSiteEvent.addMemberEmail,
          {
            'u': submitSiteEvent.event.restoreMember.memberId,
            docTimeStamp: storage.serverTimestamp,
          },
        );
      }

      // update the events immutable collection with the event
      // skipping for events handled by server cascading effects
      if (!submitSiteEvent.event.hasRemoveMember() &&
          !submitSiteEvent.event.hasLeaveSite()) {
        batch.setDocument(
          collectionSiteEventsPath(siteId),
          submitSiteEvent.event.version.toString(),
          {
            docPayload: encodedEvent,
            docVersion: submitSiteEvent.event.version,
            docTimeStamp: storage.serverTimestamp,
          },
        );
      }
    });

    // In-memory/local storage: perform inline cleanup that the Firebase
    // cloud function (processMarkForDeleteRecords) would normally handle.
    if (storage is InMemoryHyttaHubStorage) {
      final memStorage = storage as InMemoryHyttaHubStorage;

      if (submitSiteEvent.event.hasRemoveMember()) {
        final removedEmail = submitSiteEvent.removeMemberEmail;

        // 1. Delete the site_user document (cloud function does this)
        await memStorage.deleteDocument(
          collectionSiteUsersPath(siteId),
          removedEmail,
        );

        // 2. Add a RemoveSite account event for the removed member
        final accountPath = collectionAccountEventsPath(removedEmail);
        final accountEvents = await storage.getCollection(
          accountPath,
          orderBy: docVersion,
          descending: true,
        );
        final nextVersion = accountEvents.isEmpty
            ? 1
            : (accountEvents.first[docVersion] as int) + 1;

        final accountEvent = AccountEvent(
          version: nextVersion,
          removeSite: siteId,
        );
        await storage.setDocument(
          accountPath,
          nextVersion.toString(),
          {
            docPayload: base64Encode(accountEvent.writeToBuffer()),
            docVersion: nextVersion,
            docTimeStamp: storage.serverTimestamp,
          },
        );

        // 3. Check if site has no remaining members; if so, clean up
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

      if (submitSiteEvent.event.hasUpdateMember()) {
        final originalEmail = submitSiteEvent.updateMemberOriginalEmail;
        final newEmail = submitSiteEvent.updateMemberNewEmail;
        if (originalEmail != newEmail) {
          // Delete the old member doc (cloud function does this)
          await memStorage.deleteDocument(
            collectionSiteUsersPath(siteId),
            originalEmail,
          );
        }
      }
    }

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
      collectionSiteUsersPath(siteId),
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
