import { admin } from "../shared/firebase";
import * as logger from "firebase-functions/logger";
import { FieldValue } from "firebase-admin/firestore";
import { onRequest } from "firebase-functions/v2/https";
import { SiteEvent } from "../ts/site_events";
import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { AccountEvent } from "../ts/account_events";
import {
  MarkForDeletion,
  MarkForDeletion_DeleteReason,
} from "../ts/site_email";
import { onSchedule } from "firebase-functions/scheduler";
import { getArchiveBucketName } from "../shared/config";
import {
  firebaseAccountEventsPath,
  firebaseSiteEventsPath,
  firebaseSitesPath,
  firebaseSiteUsersPath,
  isRunningInEmulator,
  fbMarkedForDeletion,
  fbMemberCount,
  fbUserId,
  fbVersion,
  fbPayload,
  fbTimeStamp,
  firebaseFilesPath,
  firebaseEmulatorArchiveFilesPath,
} from "../shared/constants";

export const executetask = onRequest({}, async (req, res) => {
  if (req.query.name === "cleanup" && isRunningInEmulator()) {
    // Execute the cleanup function
    logger.info("Cleanup function called");
    await cleanUp();
    logger.info("Cleanup function executed");
    res.send("Cleanup executed successfully!");
  } else {
    res.send("Cloud function works!");
  }
});

export const processMarkForDeleteRecords = onDocumentUpdated(
  `hyttahub/{appPathSegment}/sites/{siteId}/site_users/{email}`,
  async (event) => {
    // const before = event.data?.before;
    const after = event.data?.after;

    if (!after) {
      logger.info(
        "No updated data associated with the event for site ${event.params.siteId}, email: ${event.params.email}"
      );
      return;
    }

    // const beforeData = before?.data();
    const afterData = after.data();

    logger.info(
      `User document updated in site ${event.params.siteId}, email: ${event.params.email}`
    );
    // logger.info("Before:", beforeData);
    logger.info("After:", afterData);

    // Grab the new document snapshot.
    const data = afterData;
    const appPathSegment = event.params.appPathSegment;

    if (data[fbMarkedForDeletion] && typeof data[fbMarkedForDeletion] === "string") {
      try {
        // The 'm' field contains the base64-encoded protobuf data.
        // We first decode it into a buffer.
        const buffer = Buffer.from(data[fbMarkedForDeletion], "base64");

        // Then, we use the MarkForDeletion definition to decode the buffer.
        const markForDeletionInfo = MarkForDeletion.decode(buffer);

        if (
          markForDeletionInfo.deleteReason ===
          MarkForDeletion_DeleteReason.memberLeftSite
        ) {
          logger.info(
            `User ${event.params.email} left site ${event.params.siteId}`
          );

          const siteId = event.params.siteId;
          const email = event.params.email;

          if (!afterData || typeof afterData[fbUserId] !== "number") {
            logger.error(
              `Could not find memberId for user ${email} in site ${siteId}. After data:`,
              afterData
            );
            return;
          }
          const memberId = afterData[fbUserId];

          const siteEventsRef = admin
            .firestore()
            .collection(firebaseSiteEventsPath(appPathSegment, siteId));

          // Get the latest event version to increment it.
          const lastEventSnapshot = await siteEventsRef
            .orderBy(fbVersion, "desc")
            .limit(1)
            .get();
          let newVersion = 1;
          if (!lastEventSnapshot.empty) {
            const lastEventData = lastEventSnapshot.docs[0].data();
            if (lastEventData[fbVersion] && typeof lastEventData[fbVersion] === "number") {
              newVersion = lastEventData[fbVersion] + 1;
            }
          }

          if (newVersion <= 1) {
            logger.info(
              `No site events exist for site ${siteId}, perhaps an admin has removed this site...`
            );
          } else {
            // A member leaving is effectively removing themselves.
            const siteEvent: SiteEvent = {
              version: newVersion,
              author: memberId,
              leaveSite: {
                memberId: memberId,
              },
            };

            const buffer = SiteEvent.encode(siteEvent).finish();
            const base64Event = Buffer.from(buffer).toString("base64");

            await siteEventsRef.doc(String(newVersion)).set({
              [fbPayload]: base64Event,
              [fbVersion]: newVersion,
              [fbTimeStamp]: FieldValue.serverTimestamp(),
            });

            logger.info(
              `Added LeaveSite event for member ${memberId} in site ${siteId} with version ${newVersion}.`
            );
          }
        } else if (
          markForDeletionInfo.deleteReason ===
          MarkForDeletion_DeleteReason.memberEmailUpdated
        ) {
          logger.info(
            `User ${event.params.email} was removed from site ${event.params.siteId} because their email was updated.`
          );
        } else if (
          markForDeletionInfo.deleteReason ===
          MarkForDeletion_DeleteReason.memberRemovedFromSite
        ) {
          logger.info(
            `User ${event.params.email} was removed from site ${event.params.siteId}`
          );

          const siteId = event.params.siteId;
          const email = event.params.email;

          const accountEventsRef = admin
            .firestore()
            .collection(firebaseAccountEventsPath(appPathSegment, email));

          // Get the latest event version to increment it.
          const lastEventSnapshot = await accountEventsRef
            .orderBy(fbVersion, "desc")
            .limit(1)
            .get();
          let newVersion = 1;
          if (!lastEventSnapshot.empty) {
            const lastEventData = lastEventSnapshot.docs[0].data();
            if (lastEventData[fbVersion] && typeof lastEventData[fbVersion] === "number") {
              newVersion = lastEventData[fbVersion] + 1;
            }
          }

          if (newVersion <= 1) {
            logger.info(`No account document exists for ${email}, this is ok.`);
          } else {
            // Create an AccountEvent to signify the user has been removed from the site.
            const accountEvent: AccountEvent = {
              version: newVersion,
              removeSite: siteId,
            };

            const buffer = AccountEvent.encode(accountEvent).finish();
            const base64Event = Buffer.from(buffer).toString("base64");

            await accountEventsRef.add({
              [fbPayload]: base64Event,
              [fbVersion]: newVersion,
              [fbTimeStamp]: FieldValue.serverTimestamp(),
            });

            logger.info(
              `Added remove account event for user ${email} from site ${siteId} with version ${newVersion}.`
            );
          }
        } else {
          logger.warn(
            `Unknown delete reason for user ${event.params.email} in site ${event.params.siteId}:`,
            markForDeletionInfo.deleteReason
          );
        }

        // Now delete this document since it was marked for deletion.
        await after.ref.delete();
        logger.info(
          `Deleted user document for ${event.params.email} in site ${event.params.siteId} after processing MarkForDeletion.`
        );

        // Check if the site now has no remaining users
        const remainingUsers = await admin
          .firestore()
          .collection(firebaseSiteUsersPath(appPathSegment, event.params.siteId))
          .limit(1)
          .get();

        if (remainingUsers.empty) {
          // Mark the site as having no members so cleanup can find it efficiently
          const siteDocRef = admin
            .firestore()
            .doc(`${firebaseSitesPath(appPathSegment)}/${event.params.siteId}`);
          await siteDocRef.set({ [fbMemberCount]: 0 }, { merge: true });
          logger.info(
            `Site ${event.params.siteId} has no remaining users. Marked for cleanup.`
          );
        }
      } catch (error) {
        logger.error("Failed to decode MarkForDeletion protobuf:", error);
      }
    }
  }
);

async function cleanUp() {
  // Dynamically discover all app path segments under the top-level `hyttahub` collection
  const hyttahubRoot = admin.firestore().collection('hyttahub');
  const appDocs = await hyttahubRoot.listDocuments();

  if (appDocs.length === 0) {
    logger.info('cleanUp: No app documents found under hyttahub.');
    return;
  }

  for (const appDoc of appDocs) {
    const appPathSegment = appDoc.id;
    logger.info(`App path segment for cleanup: ${appPathSegment}`);

    try {
      logger.info("cleanUp: Starting cleanup for orphaned sites...");

      // Query for sites explicitly marked as having no members
      const orphanedSitesSnapshot = await admin
        .firestore()
        .collection(firebaseSitesPath(appPathSegment))
        .where(fbMemberCount, "==", 0)
        .get();

      if (orphanedSitesSnapshot.empty) {
        logger.info("cleanUp: No orphaned sites found.");
        continue;
      }

      const orphanedSiteIds: string[] = [];

      for (const siteDoc of orphanedSitesSnapshot.docs) {
        const siteId = siteDoc.id;
        orphanedSiteIds.push(siteId);

        logger.info(
          `cleanUp: Site ${siteId} marked as orphaned. Deleting site document and all subcollections.`
        );

        // Recursively delete the site document and all its subcollections
        // (site_events, site_users, and any future subcollections)
        await admin.firestore().recursiveDelete(siteDoc.ref);
        logger.info(`cleanUp: Recursively deleted site ${siteId} and all subcollections.`);
      }

      // Now delete all the photos for orphaned sites
      if (orphanedSiteIds.length > 0) {
        logger.info(
          `cleanUp: Deleting photos for ${orphanedSiteIds.length} orphaned sites.`
        );
        const bucket = admin.storage().bucket();
        for (const siteId of orphanedSiteIds) {
          // Pass an empty string for photoId to get the directory path.
          const prefix = firebaseFilesPath(appPathSegment, siteId, "");
          logger.info(
            `cleanUp: Deleting files for site ${siteId} with prefix: ${prefix}`
          );
          await bucket.deleteFiles({ prefix });
          logger.info(`cleanUp: Files for site ${siteId} deleted.`);
        }
        // GDPR: Also delete archive copies of site files
        const archiveBucketName = getArchiveBucketName();
        for (const siteId of orphanedSiteIds) {
          if (archiveBucketName) {
            // Production: archive files live in a separate bucket with the same path structure
            const archiveBucket = admin.storage().bucket(archiveBucketName);
            const prefix = firebaseFilesPath(appPathSegment, siteId, "");
            logger.info(
              `cleanUp: Deleting archive bucket files for site ${siteId} with prefix: ${prefix}`
            );
            await archiveBucket.deleteFiles({ prefix });
            logger.info(`cleanUp: Archive bucket files for site ${siteId} deleted.`);
          } else {
            // Emulator: archive files live in the default bucket under archive_files/
            const prefix = firebaseEmulatorArchiveFilesPath(appPathSegment, siteId, "");
            logger.info(
              `cleanUp: Deleting archive files for site ${siteId} with prefix: ${prefix}`
            );
            await bucket.deleteFiles({ prefix });
            logger.info(`cleanUp: Archive files for site ${siteId} deleted.`);
          }
        }

      }
    } catch (error) {
      logger.error("cleanUp: Error executing cleanup:", error);
    }
  }
  return null;
}

// Runs every day at midnight UTC (adjust as needed)
export const cleanupOrphanedSites = onSchedule(
  { schedule: "every 24 hours", timeZone: "UTC" },
  async () => {
    logger.info("Running cleanupOrphanedSites...");
    await cleanUp();
    logger.info("cleanupOrphanedSites completed.");
  }
);
