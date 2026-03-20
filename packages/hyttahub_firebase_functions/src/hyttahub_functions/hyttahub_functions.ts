import { admin } from "../shared/firebase";
import * as logger from "firebase-functions/logger";
import { FieldValue } from "firebase-admin/firestore";
import { SiteEvent } from "../ts/site_events";
import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { AccountEvent } from "../ts/account_events";
import {
  MarkForCopy,
  MarkForDeletion,
  MarkForDeletion_DeleteReason,
} from "../ts/site_util";
import { SiteEvent_ImportEvent } from "../ts/site_events";
import { getArchiveBucketName } from "../shared/config";
import {
  firebaseAccountEventsPath,
  firebaseSiteEventsPath,
  firebaseSitesPath,
  firebaseSiteUsersPath,
  isRunningInEmulator,
  docSiteMemberMarkedForDeletion,
  docSiteMemberMarkedForCopy,
  docUserId,
  docVersion,
  docPayload,
  docTimeStamp,
  firebaseFilesPath,
  firebaseEmulatorArchiveFilesPath,
} from "../shared/constants";


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

    if (data[docSiteMemberMarkedForDeletion] && typeof data[docSiteMemberMarkedForDeletion] === "string") {
      try {
        // The 'm' field contains the base64-encoded protobuf data.
        // We first decode it into a buffer.
        const buffer = Buffer.from(data[docSiteMemberMarkedForDeletion], "base64");

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

          if (!afterData || typeof afterData[docUserId] !== "number") {
            logger.error(
              `Could not find memberId for user ${email} in site ${siteId}. After data:`,
              afterData
            );
            return;
          }
          const memberId = afterData[docUserId];

          // 1. Add LeaveSite to Site Events
          const siteEventsRef = admin
            .firestore()
            .collection(firebaseSiteEventsPath(appPathSegment, siteId));

          const lastSiteEventSnapshot = await siteEventsRef
            .orderBy(docVersion, "desc")
            .limit(1)
            .get();
          let newVersion = 1;
          if (!lastSiteEventSnapshot.empty) {
            const lastEventData = lastSiteEventSnapshot.docs[0].data();
            if (lastEventData[docVersion] && typeof lastEventData[docVersion] === "number") {
              newVersion = lastEventData[docVersion] + 1;
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
              [docPayload]: base64SiteEvent,
              [docVersion]: newVersion,
              [docTimeStamp]: FieldValue.serverTimestamp(),
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
            .orderBy(docVersion, "desc")
            .limit(1)
            .get();
          let newAccVersion = 1;
          if (!lastAccEventSnapshot.empty) {
            const lastAccEventData = lastAccEventSnapshot.docs[0].data();
            if (lastAccEventData[docVersion] && typeof lastAccEventData[docVersion] === "number") {
              newAccVersion = lastAccEventData[docVersion] + 1;
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
              [docPayload]: base64AccEvent,
              [docVersion]: newAccVersion,
              [docTimeStamp]: FieldValue.serverTimestamp(),
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
          const memberId = afterData[docUserId];

          // 1. Add RemoveMember to Site Events
          const siteEventsRef = admin
            .firestore()
            .collection(firebaseSiteEventsPath(appPathSegment, siteId));

          const lastSiteEventSnapshot = await siteEventsRef
            .orderBy(docVersion, "desc")
            .limit(1)
            .get();
          let newVersion = 1;
          if (!lastSiteEventSnapshot.empty) {
            const lastEventData = lastSiteEventSnapshot.docs[0].data();
            if (lastEventData[docVersion] && typeof lastEventData[docVersion] === "number") {
              newVersion = lastEventData[docVersion] + 1;
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
              [docPayload]: base64SiteEvent,
              [docVersion]: newVersion,
              [docTimeStamp]: FieldValue.serverTimestamp(),
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
            .orderBy(docVersion, "desc")
            .limit(1)
            .get();
          let newAccVersion = 1;
          if (!lastAccEventSnapshot.empty) {
            const lastAccEventData = lastAccEventSnapshot.docs[0].data();
            if (lastAccEventData[docVersion] && typeof lastAccEventData[docVersion] === "number") {
              newAccVersion = lastAccEventData[docVersion] + 1;
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
              [docPayload]: base64AccEvent,
              [docVersion]: newAccVersion,
              [docTimeStamp]: FieldValue.serverTimestamp(),
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
          logger.info(
            `Site ${event.params.siteId} has no remaining users. Executing immediate cleanup.`
          );
          await cleanupSiteInternal(appPathSegment, event.params.siteId);
        }
      } catch (error) {
        logger.error("Failed to decode MarkForDeletion protobuf:", error);
      }
    } else if (data[docSiteMemberMarkedForCopy] && typeof data[docSiteMemberMarkedForCopy] === "string") {
      try {
        const buffer = Buffer.from(data[docSiteMemberMarkedForCopy], "base64");
        const copyInfo = MarkForCopy.decode(buffer);
        const appName = event.params.appPathSegment;
        const oldSiteId = event.params.siteId;
        const email = event.params.email;
        const docUserIdValue = data[docUserId];

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
          const version = eventData[docVersion];
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
          author: Number(docUserIdValue),
        });
        const batchIndexEvent = Math.floor(operationCounter / 400);
        if (batchArray.length <= batchIndexEvent) { batchArray.push(db.batch()); }
        batchArray[batchIndexEvent].set(newEventsRef.doc(newSiteEventVersion.toString()), {
          [docPayload]: Buffer.from(SiteEvent.encode(importSiteEvent).finish()).toString("base64"),
          [docTimeStamp]: FieldValue.serverTimestamp(),
          [docVersion]: newSiteEventVersion,
        });
        operationCounter++;

        // 3. Add current user to new site_users
        const newUserRef = db.collection(firebaseSiteUsersPath(appName, newSiteId)).doc(email);
        const batchIndexUser = Math.floor(operationCounter / 400);
        if (batchArray.length <= batchIndexUser) { batchArray.push(db.batch()); }
        batchArray[batchIndexUser].set(newUserRef, {
          [docUserId]: docUserIdValue,
          [docTimeStamp]: FieldValue.serverTimestamp(),
        });
        operationCounter++;

        // 4. Add joinSite event to account events
        const accountEventsRef = db.collection(firebaseAccountEventsPath(appName, email));
        const lastAccountEventSnapshot = await accountEventsRef.orderBy(docVersion, "desc").limit(1).get();
        let newAccountEventVersion = 1;
        if (!lastAccountEventSnapshot.empty) {
          const lastEventData = lastAccountEventSnapshot.docs[0].data();
          if (lastEventData[docVersion] && typeof lastEventData[docVersion] === "number") {
            newAccountEventVersion = lastEventData[docVersion] + 1;
          }
        }
        const joinSiteEvent = AccountEvent.create({
          joinSite: newSiteId,
          version: newAccountEventVersion,
        });
        const batchIndexAccount = Math.floor(operationCounter / 400);
        if (batchArray.length <= batchIndexAccount) { batchArray.push(db.batch()); }
        batchArray[batchIndexAccount].set(accountEventsRef.doc(newAccountEventVersion.toString()), {
          [docPayload]: Buffer.from(AccountEvent.encode(joinSiteEvent).finish()).toString("base64"),
          [docTimeStamp]: FieldValue.serverTimestamp(),
          [docVersion]: newAccountEventVersion,
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
        await after.ref.update({ [docSiteMemberMarkedForCopy]: FieldValue.delete() });

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

/**
 * Internal function to perform the actual cleanup of a site's Firestore data and files.
 */
async function cleanupSiteInternal(appPathSegment: string, siteId: string) {
  const db = admin.firestore();
  const bucket = admin.storage().bucket();
  const archiveBucketName = getArchiveBucketName();

  // 1. Recursively delete the site document and all its subcollections
  //    (site_events, site_users, and any future subcollections)
  const siteDocRef = db.doc(`${firebaseSitesPath(appPathSegment)}/${siteId}`);
  await db.recursiveDelete(siteDocRef);
  logger.info(`cleanupSiteInternal: Recursively deleted site ${siteId} and all subcollections.`);

  // 2. Delete active files for this site
  const filePrefix = firebaseFilesPath(appPathSegment, siteId, "");
  logger.info(`cleanupSiteInternal: Deleting files for site ${siteId} with prefix: ${filePrefix}`);
  await bucket.deleteFiles({ prefix: filePrefix });
  logger.info(`cleanupSiteInternal: Files for site ${siteId} deleted.`);

  // 3. GDPR: Delete archive copies of site files
  if (isRunningInEmulator()) {
    // Emulator: archive files live in the default bucket under archive_files/
    const archivePrefix = firebaseEmulatorArchiveFilesPath(appPathSegment, siteId, "");
    logger.info(`cleanupSiteInternal: Deleting emulator archive files for site ${siteId} with prefix: ${archivePrefix}`);
    await bucket.deleteFiles({ prefix: archivePrefix });
    logger.info(`cleanupSiteInternal: Emulator archive files for site ${siteId} deleted.`);
  } else if (archiveBucketName) {
    // Production: archive files live in a separate bucket with the same path structure
    const archiveBucket = admin.storage().bucket(archiveBucketName);
    const archivePrefix = firebaseFilesPath(appPathSegment, siteId, "");
    logger.info(`cleanupSiteInternal: Deleting production archive bucket files for site ${siteId} with prefix: ${archivePrefix}`);
    await archiveBucket.deleteFiles({ prefix: archivePrefix });
    logger.info(`cleanupSiteInternal: Production archive bucket files for site ${siteId} deleted.`);
  }

  logger.info(`cleanupSiteInternal: Fully cleaned up site ${siteId}.`);
}

