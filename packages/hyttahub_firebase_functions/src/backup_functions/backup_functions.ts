import { FieldValue } from "firebase-admin/firestore";
import { admin } from "../shared/firebase";
import * as logger from "firebase-functions/logger";

import { SiteEvent, SiteEvent_ImportEvent } from "../ts/site_events";
import { AccountEvent } from "../ts/account_events";


import { firebaseAccountEventsPath, firebaseSiteEventsPath, firebaseSiteUsersPath, fbUserId, fbVersion, firebaseFilesPath, firebaseArchiveFilesPath, fbPayload, fbTimeStamp, isRunningInEmulator } from "../shared/constants";
import { getArchiveBucketName } from "../shared/config";

import { onCall, HttpsError } from "firebase-functions/v2/https";



function generateId(): string {
  const validChars = "123456789ABCDE";
  const allValidChars = "123456789ABCDEFG";

  const firstChar = validChars.charAt(
    Math.floor(Math.random() * validChars.length)
  );

  let remainingChars = "";
  for (let i = 0; i < 7; i++) {
    remainingChars += allValidChars.charAt(
      Math.floor(Math.random() * allValidChars.length)
    );
  }

  return firstChar + remainingChars;
}


export const copySite = onCall({
  cors: true,
  memory: '4GiB',
  timeoutSeconds: 540,
}, async (request) => {
  const startTime = Date.now();
  logger.info("copySite function called");

  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "User must be signed in");
  }

  const { appName, siteId: oldSiteId } = request.data;
  const upToVersion = request.data.upToVersion as number | undefined;

  const email = typeof request.auth?.token?.email === "string" ? request.auth.token.email : undefined;

  if (!email) {
    throw new HttpsError("unauthenticated", "User email is required");
  }

  // 1. Verify user is in old site's site_users
  const oldSiteUserRef = admin.firestore().collection(firebaseSiteUsersPath(appName, oldSiteId)).doc(email);
  const oldSiteUserDoc = await oldSiteUserRef.get();
  if (!oldSiteUserDoc.exists) {
    throw new HttpsError("permission-denied", "User is not a member of the site to copy");
  }
  const fbUserIdValue = oldSiteUserDoc.data()?.[fbUserId];

  const newSiteId = generateId();
  const db = admin.firestore();
  const bucket = admin.storage().bucket();

  // 2. Copy events
  const oldEventsRef = db.collection(firebaseSiteEventsPath(appName, oldSiteId));
  const newEventsRef = db.collection(firebaseSiteEventsPath(appName, newSiteId));
  const oldEventsSnapshot = await oldEventsRef.get();

  let lastVersion = 0;
  // Firestore batches can only have 500 operations.
  const batchArray: admin.firestore.WriteBatch[] = [db.batch()];
  let operationCounter = 0;

  oldEventsSnapshot.docs.forEach((doc) => {
    const data = doc.data();
    const version = data[fbVersion];
    
    // Skip events after upToVersion if specified
    if (upToVersion !== undefined && typeof version === "number" && version > upToVersion) {
      return;
    }

    if (typeof version === "number" && version > lastVersion) {
      lastVersion = version;
    }
    
    // add to batch
    const batchIndex = Math.floor(operationCounter / 400);
    if (batchArray.length <= batchIndex) {
      batchArray.push(db.batch());
    }
    batchArray[batchIndex].set(newEventsRef.doc(doc.id), data);
    operationCounter++;
  });

  // 3. Add ImportEvent (Copy Event) to new site
  const newSiteEventVersion = lastVersion + 1;
  const importSiteEvent = SiteEvent.create({
    importEvent: SiteEvent_ImportEvent.create({}),
    version: newSiteEventVersion,
    author: Number(fbUserIdValue),
  });
  
  const batchIndexEvent = Math.floor(operationCounter / 400);
  if (batchArray.length <= batchIndexEvent) {
    batchArray.push(db.batch());
  }
  batchArray[batchIndexEvent].set(newEventsRef.doc(newSiteEventVersion.toString()), {
    [fbPayload]: Buffer.from(SiteEvent.encode(importSiteEvent).finish()).toString("base64"),
    [fbTimeStamp]: FieldValue.serverTimestamp(),
    [fbVersion]: newSiteEventVersion,
  });
  operationCounter++;

  // 4. Add current user to new site_users
  const newUserRef = db.collection(firebaseSiteUsersPath(appName, newSiteId)).doc(email);
  const batchIndexUser = Math.floor(operationCounter / 400);
  if (batchArray.length <= batchIndexUser) {
    batchArray.push(db.batch());
  }
  batchArray[batchIndexUser].set(newUserRef, {
    [fbUserId]: fbUserIdValue,
    [fbTimeStamp]: FieldValue.serverTimestamp(),
  });
  operationCounter++;

  // 5. Add joinSite event to account events
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
  if (batchArray.length <= batchIndexAccount) {
    batchArray.push(db.batch());
  }
  batchArray[batchIndexAccount].set(accountEventsRef.doc(newAccountEventVersion.toString()), {
    [fbPayload]: Buffer.from(AccountEvent.encode(joinSiteEvent).finish()).toString("base64"),
    [fbTimeStamp]: FieldValue.serverTimestamp(),
    [fbVersion]: newAccountEventVersion,
  });

  // Commit all batches
  for (const batch of batchArray) {
    await batch.commit();
  }

  logger.info(`Successfully created site copy metadata: ${newSiteId}`);

  // 6. Copy storage items — prefer archive source, fall back to main bucket
  const archiveBucketName = getArchiveBucketName();
  let sourceBucket = bucket;
  let sourcePrefix: string;

  if (isRunningInEmulator()) {
    // Emulator: try archive path in default bucket first
    const archivePrefix = firebaseArchiveFilesPath(appName, oldSiteId, "");
    const [archiveFiles] = await bucket.getFiles({ prefix: archivePrefix, maxResults: 1 });
    if (archiveFiles.length > 0) {
      sourcePrefix = archivePrefix;
      logger.info(`Copying from archive path (emulator): ${archivePrefix}`);
    } else {
      sourcePrefix = firebaseFilesPath(appName, oldSiteId, "");
      logger.info(`Archive path empty, falling back to main path: ${sourcePrefix}`);
    }
  } else if (archiveBucketName) {
    // Production with archive bucket configured: try archive bucket first
    const archiveSourceBucket = admin.storage().bucket(archiveBucketName);
    const archivePrefix = firebaseFilesPath(appName, oldSiteId, "");
    const [archiveFiles] = await archiveSourceBucket.getFiles({ prefix: archivePrefix, maxResults: 1 });
    if (archiveFiles.length > 0) {
      sourceBucket = archiveSourceBucket;
      sourcePrefix = archivePrefix;
      logger.info(`Copying from archive bucket: ${archiveBucketName}`);
    } else {
      sourcePrefix = firebaseFilesPath(appName, oldSiteId, "");
      logger.info(`Archive bucket empty for site, falling back to main bucket`);
    }
  } else {
    sourcePrefix = firebaseFilesPath(appName, oldSiteId, "");
    logger.info("Archive bucket not configured, copying from main bucket");
  }

  const query: any = { prefix: sourcePrefix, autoPaginate: false };
  let pageToken: string | undefined;

  do {
    if (pageToken) {
      query.pageToken = pageToken;
    }

    const [files, nextQuery] = await sourceBucket.getFiles(query);
    const copyPromises = [];

    for (const file of files) {
      const relativePath = file.name.substring(sourcePrefix.length);
      // Copy to new site in main bucket
      const newPath = firebaseFilesPath(appName, newSiteId, relativePath);
      copyPromises.push(file.copy(bucket.file(newPath)));

      // Also copy to archive for the new site
      if (isRunningInEmulator()) {
        const archivePath = firebaseArchiveFilesPath(appName, newSiteId, relativePath);
        copyPromises.push(file.copy(bucket.file(archivePath)));
      } else if (archiveBucketName) {
        const archiveBucket = admin.storage().bucket(archiveBucketName);
        const archivePath = firebaseFilesPath(appName, newSiteId, relativePath);
        copyPromises.push(file.copy(archiveBucket.file(archivePath)));
      }
    }

    // Await the batch before moving to the next. 
    // This caps concurrent HTTP connections and limits memory usage.
    await Promise.all(copyPromises);

    pageToken = nextQuery?.pageToken;
  } while (pageToken);

  const endTime = Date.now();
  logger.info(`copySite completed in ${endTime - startTime}ms for site ${oldSiteId} -> ${newSiteId}`);

  return { siteId: newSiteId };
});

