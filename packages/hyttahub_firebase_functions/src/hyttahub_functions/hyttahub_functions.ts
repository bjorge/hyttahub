import { admin } from "../shared/firebase";
import * as logger from "firebase-functions/logger";
import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { onRequest } from "firebase-functions/v2/https";
import { SiteEvent } from "../ts/site_events";
import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { AccountEvent } from "../ts/account_events";
import {
  MarkForCopy,
  MarkForDeletion,
  MarkForDeletion_DeleteReason,
} from "../ts/site_util";
import { SiteEvent_ImportEvent } from "../ts/site_events";
import { onSchedule } from "firebase-functions/scheduler";
import { getArchiveBucketName } from "../shared/config";
import {
  firebaseAccountEventsPath,
  firebaseSiteEventsPath,
  firebaseSitesPath,
  firebaseSiteUsersPath,
  isRunningInEmulator,
  fbSiteMemberMarkedForDeletion,
  fbSiteMemberMarkedForCopy,
  fbSiteMarkedForDeletion,
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

    if (data[fbSiteMemberMarkedForDeletion] && typeof data[fbSiteMemberMarkedForDeletion] === "string") {
      try {
        // The 'm' field contains the base64-encoded protobuf data.
        // We first decode it into a buffer.
        const buffer = Buffer.from(data[fbSiteMemberMarkedForDeletion], "base64");

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

          // 1. Add LeaveSite to Site Events
          const siteEventsRef = admin
            .firestore()
            .collection(firebaseSiteEventsPath(appPathSegment, siteId));

          const lastSiteEventSnapshot = await siteEventsRef
            .orderBy(fbVersion, "desc")
            .limit(1)
            .get();
          let newVersion = 1;
          if (!lastSiteEventSnapshot.empty) {
            const lastEventData = lastSiteEventSnapshot.docs[0].data();
            if (lastEventData[fbVersion] && typeof lastEventData[fbVersion] === "number") {
              newVersion = lastEventData[fbVersion] + 1;
            }
          }

          if (newVersion > 1) {
            const siteEvent: SiteEvent = {
              version: newVersion,
              author: markForDeletionInfo.author || memberId,
              leaveSite: {
                memberId: memberId,
              },
            };

            const siteBuffer = SiteEvent.encode(siteEvent).finish();
            const base64SiteEvent = Buffer.from(siteBuffer).toString("base64");

            await siteEventsRef.doc(String(newVersion)).set({
              [fbPayload]: base64SiteEvent,
              [fbVersion]: newVersion,
              [fbTimeStamp]: FieldValue.serverTimestamp(),
            });

            logger.info(
              `Added LeaveSite site event for member ${memberId} in site ${siteId} with version ${newVersion}.`
            );
          }

          // 2. Add LeaveSite to Account Events
          const accountEventsRef = admin
            .firestore()
            .collection(firebaseAccountEventsPath(appPathSegment, email));

          const lastAccEventSnapshot = await accountEventsRef
            .orderBy(fbVersion, "desc")
            .limit(1)
            .get();
          let newAccVersion = 1;
          if (!lastAccEventSnapshot.empty) {
            const lastAccEventData = lastAccEventSnapshot.docs[0].data();
            if (lastAccEventData[fbVersion] && typeof lastAccEventData[fbVersion] === "number") {
              newAccVersion = lastAccEventData[fbVersion] + 1;
            }
          }

          if (newAccVersion > 1) {
            const accountEvent: AccountEvent = {
              version: newAccVersion,
              leaveSite: siteId,
            };

            const accBuffer = AccountEvent.encode(accountEvent).finish();
            const base64AccEvent = Buffer.from(accBuffer).toString("base64");

            await accountEventsRef.doc(String(newAccVersion)).set({
              [fbPayload]: base64AccEvent,
              [fbVersion]: newAccVersion,
              [fbTimeStamp]: FieldValue.serverTimestamp(),
            });

            logger.info(
              `Added LeaveSite account event for user ${email} in site ${siteId} with version ${newAccVersion}.`
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
          const memberId = afterData[fbUserId];

          // 1. Add RemoveMember to Site Events
          const siteEventsRef = admin
            .firestore()
            .collection(firebaseSiteEventsPath(appPathSegment, siteId));

          const lastSiteEventSnapshot = await siteEventsRef
            .orderBy(fbVersion, "desc")
            .limit(1)
            .get();
          let newVersion = 1;
          if (!lastSiteEventSnapshot.empty) {
            const lastEventData = lastSiteEventSnapshot.docs[0].data();
            if (lastEventData[fbVersion] && typeof lastEventData[fbVersion] === "number") {
              newVersion = lastEventData[fbVersion] + 1;
            }
          }

          if (newVersion > 1) {
            const siteEvent: SiteEvent = {
              version: newVersion,
              author: markForDeletionInfo.author,
              removeMember: {
                memberId: memberId,
              },
            };

            const siteBuffer = SiteEvent.encode(siteEvent).finish();
            const base64SiteEvent = Buffer.from(siteBuffer).toString("base64");

            await siteEventsRef.doc(String(newVersion)).set({
              [fbPayload]: base64SiteEvent,
              [fbVersion]: newVersion,
              [fbTimeStamp]: FieldValue.serverTimestamp(),
            });

            logger.info(
              `Added RemoveMember site event for member ${memberId} in site ${siteId} with version ${newVersion}.`
            );
          }

          // 2. Add RemoveSite to Account Events
          const accountEventsRef = admin
            .firestore()
            .collection(firebaseAccountEventsPath(appPathSegment, email));

          const lastAccEventSnapshot = await accountEventsRef
            .orderBy(fbVersion, "desc")
            .limit(1)
            .get();
          let newAccVersion = 1;
          if (!lastAccEventSnapshot.empty) {
            const lastAccEventData = lastAccEventSnapshot.docs[0].data();
            if (lastAccEventData[fbVersion] && typeof lastAccEventData[fbVersion] === "number") {
              newAccVersion = lastAccEventData[fbVersion] + 1;
            }
          }

          if (newAccVersion > 1) {
            const accountEvent: AccountEvent = {
              version: newAccVersion,
              removeSite: siteId,
            };

            const accBuffer = AccountEvent.encode(accountEvent).finish();
            const base64AccEvent = Buffer.from(accBuffer).toString("base64");

            await accountEventsRef.doc(String(newAccVersion)).set({
              [fbPayload]: base64AccEvent,
              [fbVersion]: newAccVersion,
              [fbTimeStamp]: FieldValue.serverTimestamp(),
            });

            logger.info(
              `Added removeSite account event for user ${email} from site ${siteId} with version ${newAccVersion}.`
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
          await siteDocRef.set({ [fbSiteMarkedForDeletion]: FieldValue.serverTimestamp() }, { merge: true });
          logger.info(
            `Site ${event.params.siteId} has no remaining users. Marked for cleanup.`
          );
        }
      } catch (error) {
        logger.error("Failed to decode MarkForDeletion protobuf:", error);
      }
    } else if (data[fbSiteMemberMarkedForCopy] && typeof data[fbSiteMemberMarkedForCopy] === "string") {
      try {
        const buffer = Buffer.from(data[fbSiteMemberMarkedForCopy], "base64");
        const copyInfo = MarkForCopy.decode(buffer);
        const appName = event.params.appPathSegment;
        const oldSiteId = event.params.siteId;
        const email = event.params.email;
        const fbUserIdValue = data[fbUserId];

        logger.info(`Copysite triggered for ${email} in site ${oldSiteId}`);

        const newSiteId = generateId();
        const db = admin.firestore();
        const bucket = admin.storage().bucket();

        // 1. Copy events
        const oldEventsRef = db.collection(firebaseSiteEventsPath(appName, oldSiteId));
        const newEventsRef = db.collection(firebaseSiteEventsPath(appName, newSiteId));
        const oldEventsSnapshot = await oldEventsRef.get();

        let lastVersion = 0;
        const batchArray: admin.firestore.WriteBatch[] = [db.batch()];
        let operationCounter = 0;

        oldEventsSnapshot.docs.forEach((doc) => {
          const eventData = doc.data();
          const version = eventData[fbVersion];
          if (copyInfo.upToVersion !== 0 && typeof version === "number" && version > copyInfo.upToVersion) {
            return;
          }
          if (typeof version === "number" && version > lastVersion) {
            lastVersion = version;
          }
          const batchIndex = Math.floor(operationCounter / 400);
          if (batchArray.length <= batchIndex) { batchArray.push(db.batch()); }
          batchArray[batchIndex].set(newEventsRef.doc(doc.id), eventData);
          operationCounter++;
        });

        // 2. Add ImportEvent
        const newSiteEventVersion = lastVersion + 1;
        const importSiteEvent = SiteEvent.create({
          importEvent: SiteEvent_ImportEvent.create({}),
          version: newSiteEventVersion,
          author: Number(fbUserIdValue),
        });
        const batchIndexEvent = Math.floor(operationCounter / 400);
        if (batchArray.length <= batchIndexEvent) { batchArray.push(db.batch()); }
        batchArray[batchIndexEvent].set(newEventsRef.doc(newSiteEventVersion.toString()), {
          [fbPayload]: Buffer.from(SiteEvent.encode(importSiteEvent).finish()).toString("base64"),
          [fbTimeStamp]: FieldValue.serverTimestamp(),
          [fbVersion]: newSiteEventVersion,
        });
        operationCounter++;

        // 3. Add current user to new site_users
        const newUserRef = db.collection(firebaseSiteUsersPath(appName, newSiteId)).doc(email);
        const batchIndexUser = Math.floor(operationCounter / 400);
        if (batchArray.length <= batchIndexUser) { batchArray.push(db.batch()); }
        batchArray[batchIndexUser].set(newUserRef, {
          [fbUserId]: fbUserIdValue,
          [fbTimeStamp]: FieldValue.serverTimestamp(),
        });
        operationCounter++;

        // 4. Add joinSite event to account events
        const accountEventsRef = db.collection(firebaseAccountEventsPath(appName, email));
        const lastAccountEventSnapshot = await accountEventsRef.orderBy(fbVersion, "desc").limit(1).get();
        let newAccountEventVersion = 1;
        if (!lastAccountEventSnapshot.empty) {
          const lastEventData = lastAccountEventSnapshot.docs[0].data();
          if (lastEventData[fbVersion] && typeof lastEventData[fbVersion] === "number") {
            newAccountEventVersion = lastEventData[fbVersion] + 1;
          }
        }
        const joinSiteEvent = AccountEvent.create({
          joinSite: newSiteId,
          version: newAccountEventVersion,
        });
        const batchIndexAccount = Math.floor(operationCounter / 400);
        if (batchArray.length <= batchIndexAccount) { batchArray.push(db.batch()); }
        batchArray[batchIndexAccount].set(accountEventsRef.doc(newAccountEventVersion.toString()), {
          [fbPayload]: Buffer.from(AccountEvent.encode(joinSiteEvent).finish()).toString("base64"),
          [fbTimeStamp]: FieldValue.serverTimestamp(),
          [fbVersion]: newAccountEventVersion,
        });

        for (const batch of batchArray) { await batch.commit(); }

        // 5. Copy storage items
        const archiveBucketName = getArchiveBucketName();
        let sourceBucket = bucket;
        let sourcePrefix = firebaseFilesPath(appName, oldSiteId, "");

        if (isRunningInEmulator()) {
          const archivePrefix = firebaseEmulatorArchiveFilesPath(appName, oldSiteId, "");
          const [archiveFiles] = await bucket.getFiles({ prefix: archivePrefix, maxResults: 1 });
          if (archiveFiles.length > 0) { sourcePrefix = archivePrefix; }
        } else if (archiveBucketName) {
          const archiveSourceBucket = admin.storage().bucket(archiveBucketName);
          const archivePrefix = firebaseFilesPath(appName, oldSiteId, "");
          const [archiveFiles] = await archiveSourceBucket.getFiles({ prefix: archivePrefix, maxResults: 1 });
          if (archiveFiles.length > 0) {
            sourceBucket = archiveSourceBucket;
            sourcePrefix = archivePrefix;
          }
        }

        const query: any = { prefix: sourcePrefix, autoPaginate: false };
        let pageToken: string | undefined;
        do {
          if (pageToken) { query.pageToken = pageToken; }
          const [files, nextQuery] = await sourceBucket.getFiles(query);
          const copyPromises = [];
          for (const file of files) {
            const relativePath = file.name.substring(sourcePrefix.length);
            const newPath = firebaseFilesPath(appName, newSiteId, relativePath);
            copyPromises.push(file.copy(bucket.file(newPath)));
            if (isRunningInEmulator()) {
              const archivePath = firebaseEmulatorArchiveFilesPath(appName, newSiteId, relativePath);
              copyPromises.push(file.copy(bucket.file(archivePath)));
            } else if (archiveBucketName) {
              const archiveBucket = admin.storage().bucket(archiveBucketName);
              const archivePath = firebaseFilesPath(appName, newSiteId, relativePath);
              copyPromises.push(file.copy(archiveBucket.file(archivePath)));
            }
          }
          await Promise.all(copyPromises);
          pageToken = nextQuery?.pageToken;
        } while (pageToken);

        logger.info(`Successfully completed site copy: ${oldSiteId} -> ${newSiteId}`);

        // Clear the MarkForCopy field
        await after.ref.update({ [fbSiteMemberMarkedForCopy]: FieldValue.delete() });

      } catch (error) {
        logger.error("Failed to process MarkForCopy:", error);
      }
    }
  }
);

function generateId(): string {
  const validChars = "123456789ABCDE";
  const allValidChars = "123456789ABCDEFG";
  const firstChar = validChars.charAt(Math.floor(Math.random() * validChars.length));
  let remainingChars = "";
  for (let i = 0; i < 7; i++) {
    remainingChars += allValidChars.charAt(Math.floor(Math.random() * allValidChars.length));
  }
  return firstChar + remainingChars;
}

async function cleanUp() {
  // Cloud Functions have a 540-second (9 min) timeout.
  // Exit after 50% of the budget to leave a safety margin.
  const maxExecutionMs = 540 * 1000;
  const timeBudgetMs = maxExecutionMs * 0.5;
  const startTime = Date.now();

  // Dynamically discover all app path segments under the top-level `hyttahub` collection
  const hyttahubRoot = admin.firestore().collection('hyttahub');
  const appDocs = await hyttahubRoot.listDocuments();

  if (appDocs.length === 0) {
    logger.info('cleanUp: No app documents found under hyttahub.');
    return;
  }

  let sitesProcessed = 0;
  let timedOut = false;

  for (const appDoc of appDocs) {
    if (timedOut) break;

    const appPathSegment = appDoc.id;
    logger.info(`App path segment for cleanup: ${appPathSegment}`);

    try {
      logger.info("cleanUp: Starting cleanup for orphaned sites...");

      // Query for sites explicitly marked as having no members
      const orphanedSitesSnapshot = await admin
        .firestore()
        .collection(firebaseSitesPath(appPathSegment))
        .where(fbSiteMarkedForDeletion, ">", new Timestamp(0, 0))
        .orderBy(fbSiteMarkedForDeletion, "asc")
        .get();

      if (orphanedSitesSnapshot.empty) {
        logger.info("cleanUp: No orphaned sites found.");
        continue;
      }

      logger.info(
        `cleanUp: Found ${orphanedSitesSnapshot.size} orphaned site(s) to process.`
      );

      const bucket = admin.storage().bucket();
      const archiveBucketName = getArchiveBucketName();

      for (const siteDoc of orphanedSitesSnapshot.docs) {
        // Check time budget before processing the next site
        const elapsedMs = Date.now() - startTime;
        if (elapsedMs >= timeBudgetMs) {
          logger.warn(
            `cleanUp: Time budget exceeded (${Math.round(elapsedMs / 1000)}s / ${Math.round(timeBudgetMs / 1000)}s). ` +
            `Processed ${sitesProcessed} site(s). Exiting to avoid timeout; remaining sites will be cleaned up on the next run.`
          );
          timedOut = true;
          break;
        }

        const siteId = siteDoc.id;
        logger.info(
          `cleanUp: Processing orphaned site ${siteId} (${sitesProcessed + 1} so far, ${Math.round(elapsedMs / 1000)}s elapsed)...`
        );

        try {
          // 1. Recursively delete the site document and all its subcollections
          //    (site_events, site_users, and any future subcollections)
          await admin.firestore().recursiveDelete(siteDoc.ref);
          logger.info(`cleanUp: Recursively deleted site ${siteId} and all subcollections.`);

          // 2. Delete active files for this site
          const filePrefix = firebaseFilesPath(appPathSegment, siteId, "");
          logger.info(`cleanUp: Deleting files for site ${siteId} with prefix: ${filePrefix}`);
          await bucket.deleteFiles({ prefix: filePrefix });
          logger.info(`cleanUp: Files for site ${siteId} deleted.`);

          // 3. GDPR: Delete archive copies of site files
          if (archiveBucketName) {
            // Production: archive files live in a separate bucket with the same path structure
            const archiveBucket = admin.storage().bucket(archiveBucketName);
            const archivePrefix = firebaseFilesPath(appPathSegment, siteId, "");
            logger.info(`cleanUp: Deleting archive bucket files for site ${siteId} with prefix: ${archivePrefix}`);
            await archiveBucket.deleteFiles({ prefix: archivePrefix });
            logger.info(`cleanUp: Archive bucket files for site ${siteId} deleted.`);
          } else {
            // Emulator: archive files live in the default bucket under archive_files/
            const archivePrefix = firebaseEmulatorArchiveFilesPath(appPathSegment, siteId, "");
            logger.info(`cleanUp: Deleting archive files for site ${siteId} with prefix: ${archivePrefix}`);
            await bucket.deleteFiles({ prefix: archivePrefix });
            logger.info(`cleanUp: Archive files for site ${siteId} deleted.`);
          }

          sitesProcessed++;
          logger.info(`cleanUp: Fully cleaned up site ${siteId}.`);
        } catch (siteError) {
          logger.error(`cleanUp: Error cleaning up site ${siteId}:`, siteError);
          // Continue to the next site rather than aborting the entire cleanup
        }
      }
    } catch (error) {
      logger.error("cleanUp: Error executing cleanup:", error);
    }
  }

  const totalElapsedMs = Date.now() - startTime;
  logger.info(
    `cleanUp: Finished. Processed ${sitesProcessed} site(s) in ${Math.round(totalElapsedMs / 1000)}s.` +
    (timedOut ? " Exited early due to time budget." : "")
  );
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
