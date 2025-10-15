import * as admin from "firebase-admin";
import { FieldValue, Timestamp } from "firebase-admin/firestore";
import archiver from "archiver";
import * as logger from "firebase-functions/logger";
import * as unzipper from "unzipper";
import { SiteEvent, SiteEventRecord } from "../ts/site_events";
import { AccountEvent } from "../ts/account_events";

import {
  fbPayload,
  fbTimeStamp,
  fbLastExportTime,
  firebaseAccountEventsPath,
  firebaseExportsPath,
  firebasePhotosPath,
  firebaseSiteEventsPath,
  firebaseSiteUsersPath,
  isRunningInEmulator,
  fbUserId,
  fbVersion,
} from "../shared/constants";

import { onCall, HttpsError } from "firebase-functions/v2/https";
import { onDocumentWritten } from "firebase-functions/v2/firestore";

// Helper to extract events.txt and photo buffers from an opened unzipper directory.
// Throws an HttpsError('invalid-argument', ...) if the archive contains any
// unexpected file that is neither `events.txt` at the root nor under `storage/`.
export async function extractEventsAndPhotosFromZip(directory: any): Promise<{
  eventsContent: string;
  photos: Array<{ relativePath: string; buffer: Buffer }>;
}> {
  let eventsContent = "";
  const photos: Array<{ relativePath: string; buffer: Buffer }> = [];

  const storagePrefix = "storage/";
  const rejectedFiles: string[] = [];

  for (const file of directory.files) {
    if (file.path === "events.txt") {
      eventsContent = await file.buffer().then((buffer: Buffer) => buffer.toString());
      continue;
    }

    if (file.path.startsWith(storagePrefix)) {
      const relativePath = file.path.substring(storagePrefix.length);
      const buffer = await file.buffer();
      photos.push({ relativePath, buffer });
      continue;
    }

    // Collect any unexpected files for logging and then reject.
    rejectedFiles.push(file.path);
  }

  if (rejectedFiles.length > 0) {
    logger.error('Import rejected due to unexpected files in archive:', JSON.stringify(rejectedFiles, null, 2));
    throw new HttpsError("invalid-argument", `Unexpected files in archive: ${rejectedFiles.join(', ')}`);
  }

  if (!eventsContent) {
    logger.error('Import rejected: events.txt missing from archive');
    throw new HttpsError('invalid-argument', 'Archive is missing events.txt');
  }

  return { eventsContent, photos };
}

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

export const uploadPhoto = onCall({ cors: true }, async (request) => {
  logger.info("uploadPhoto function called");

  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "User must be signed in");
  }

  // Example: enforce site membership
  const siteId = request.data.siteId;
  const appName = request.data.appName;
  const email =
    typeof request.auth?.token?.email === "string"
      ? request.auth.token.email
      : undefined;
  if (!email) {
    throw new HttpsError(
      "unauthenticated",
      "User email is required and must be a string"
    );
  }

  logger.info("uploadPhoto function called, siteId:", siteId, "email:", email);

  const emailRef = admin
    .firestore()
    .collection(firebaseSiteUsersPath(appName, siteId))
    .doc(email);

  const emailDoc = await emailRef.get();
  if (!emailDoc.exists) {
    throw new HttpsError(
      "permission-denied",
      "User is not a member of this site"
    );
  }

  const base64Data = request.data.base64Data;
  const fileName = request.data.fileName;

  const bucket = admin.storage().bucket();

  const filePath = firebasePhotosPath(appName, siteId, fileName);
  const file = bucket.file(filePath);

  await file.save(Buffer.from(base64Data, "base64"), {
    // contentType: "image/jpeg",
    // metadata: {
    //   firebaseStorageDownloadTokens: uid, // Optional: set download token for access control
    // },
  });
  logger.info(`Photo uploaded to ${file.name}`);

  if (isRunningInEmulator()) {
    logger.info(
      `Photo uploaded to ${file.name} in emulator mode, not generating signed URL`
    );
    return { uploadUrl: file.publicUrl() };
  } else {
    const [signedUrl] = await file.getSignedUrl({
      action: "write",
      expires: Date.now() + 15 * 60 * 1000, // 15 minutes
      contentType: "image/jpeg",
    });
    return { uploadUrl: signedUrl };
  }
});

export const getPhoto = onCall({ cors: true }, async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "User must be signed in");
  }

  const siteId = request.data.siteId;
  const appName = request.data.appName;
  const fileName = request.data.fileName;

  const bucket = admin.storage().bucket();

  // Enforce site membership
  const email =
    typeof request.auth?.token?.email === "string"
      ? request.auth.token.email
      : undefined;
  if (!email) {
    throw new HttpsError(
      "unauthenticated",
      "User email is required and must be a string"
    );
  }

  logger.info("uploadPhoto function called, siteId:", siteId, "email:", email);

  const emailRef = admin
    .firestore()
    .collection(firebaseSiteUsersPath(appName, siteId))
    .doc(email);

  const emailDoc = await emailRef.get();
  if (!emailDoc.exists) {
    throw new HttpsError(
      "permission-denied",
      "User is not a member of this site"
    );
  }

  const filePath = firebasePhotosPath(appName, siteId, fileName);
  const file = bucket.file(filePath);

  if (isRunningInEmulator()) {
    return { downloadUrl: file.publicUrl() };
  } else {
    const [signedUrl] = await file.getSignedUrl({
      action: "read",
      expires: Date.now() + 15 * 60 * 1000, // 15 minutes
    });
    return { downloadUrl: signedUrl };
  }

  // const bucket = admin.storage().bucket();
  // const file = bucket.file(`sites/${siteId}/photos/${fileName}`);

  // const [signedUrl] = await file.getSignedUrl({
  //   action: "read",
  //   expires: Date.now() + 15 * 60 * 1000, // 15 minutes
  // });

  // return { downloadUrl: signedUrl };
});

export const deletePhoto = onCall({ cors: true }, async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "User must be signed in");
  }

  const siteId = request.data.siteId;
  const appName = request.data.appName;
  const fileName = request.data.fileName;

  const bucket = admin.storage().bucket();

  // Enforce site membership
  const email =
    typeof request.auth?.token?.email === "string"
      ? request.auth.token.email
      : undefined;
  if (!email) {
    throw new HttpsError(
      "unauthenticated",
      "User email is required and must be a string"
    );
  }

  logger.info("deletePhoto function called, siteId:", siteId, "email:", email);

  const emailRef = admin
    .firestore()
    .collection(firebaseSiteUsersPath(appName, siteId))
    .doc(email);

  const emailDoc = await emailRef.get();
  if (!emailDoc.exists) {
    throw new HttpsError(
      "permission-denied",
      "User is not a member of this site"
    );
  }

  const filePath = firebasePhotosPath(appName, siteId, fileName);
  const file = bucket.file(filePath);

  try {
    await file.delete();
    logger.info(`Successfully deleted photo: ${filePath}`);
    return { success: true };
  } catch (error) {
    logger.error(`Failed to delete photo: ${filePath}`, error);
    throw new HttpsError("internal", "Failed to delete photo");
  }
});

export const deleteAlbumPhotos = onCall({ cors: true }, async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "User must be signed in");
  }

  const siteId = request.data.siteId;
  const appName = request.data.appName;
  const fileNames = request.data.fileNames as string[];

  const bucket = admin.storage().bucket();

  // Enforce site membership
  const email =
    typeof request.auth?.token?.email === "string"
      ? request.auth.token.email
      : undefined;
  if (!email) {
    throw new HttpsError(
      "unauthenticated",
      "User email is required and must be a string"
    );
  }

  logger.info("deleteAlbumPhotos function called, siteId:", siteId, "email:", email);

  const emailRef = admin
    .firestore()
    .collection(firebaseSiteUsersPath(appName, siteId))
    .doc(email);

  const emailDoc = await emailRef.get();
  if (!emailDoc.exists) {
    throw new HttpsError(
      "permission-denied",
      "User is not a member of this site"
    );
  }

  const deletePromises: Promise<any>[] = [];
  for (const fileName of fileNames) {
    const filePath = firebasePhotosPath(appName, siteId, fileName);
    const file = bucket.file(filePath);
    deletePromises.push(
      file.delete().catch((err) => {
        // Ignore "file not found" errors (best effort delete)
        if (err.code === 404) {
          logger.info(`Photo not found for deletion: ${filePath}`);
          return;
        }
        throw err;
      })
    );
  }

  try {
    await Promise.all(deletePromises);
    logger.info(`Successfully deleted ${fileNames.length} photos.`);
    return { success: true };
  } catch (error) {
    logger.error(`Failed to delete photos`, error);
    throw new HttpsError("internal", "Failed to delete photos");
  }
});

export const exportSite = onDocumentWritten(
  `hyttahub/{appPathSegment}/sites/{siteId}/site_exports/export_request`,
  async (event) => {
    logger.info("exportSite trigger called for export_request document");

    const after = event.data?.after;
    if (!after) {
      logger.info("exportSite: No document data available (deleted?). Skipping.");
      return null;
    }

    const appName = event.params.appPathSegment;
    const siteId = event.params.siteId;

    // Try to infer a requester email if the client wrote one into the request doc.
    const docData = after.data() || {};

    // Check fbLastExportTime ('l'). If empty, perform export and merge fbLastExportTime as now.
    // If present, only perform export if at least 5 minutes have passed since fbTimeStamp on the request.
    let authorId = 0;
    try {
      const lastExport = (docData as any)[fbLastExportTime];
      const reqTsRaw = (docData as any)[fbTimeStamp];
      authorId = (docData as any)[fbUserId];

      logger.info("Author ID for export request:", authorId);


      const now = new Date();

      if (!lastExport) {
        // No previous export recorded: write fbLastExportTime and proceed
        await admin
          .firestore()
          .doc(`hyttahub/${appName}/sites/${siteId}/site_exports/export_request`)
          .set({ [fbLastExportTime]: FieldValue.serverTimestamp() }, { merge: true });
      } else {
        // lastExport exists; require request timestamp to be at least 5 minutes older than now
        if (!reqTsRaw) {
          logger.info('exportSite: fbTimeStamp not present on request doc; skipping export.');
          return null;
        }

        const reqTs = reqTsRaw.toDate ? reqTsRaw.toDate() : new Date(reqTsRaw);
        const elapsedMs = now.getTime() - reqTs.getTime();
        if (elapsedMs < 5 * 60 * 1000) {
          logger.info(`exportSite: request timestamp is only ${elapsedMs}ms old (<5min). Skipping export.`);
          return null;
        }

        // Update fbLastExportTime to now (merge) before starting export
        await admin
          .firestore()
          .doc(`hyttahub/${appName}/sites/${siteId}/site_exports/export_request`)
          .set({ [fbLastExportTime]: FieldValue.serverTimestamp() }, { merge: true });
      }
    } catch (err) {
      logger.warn('exportSite: failed to read or write fbLastExportTime; proceeding', err);
    }

    // Run the export in the background
    // eslint-disable-next-line @typescript-eslint/no-floating-promises
    (async () => {
      const bucket = admin.storage().bucket();
      const photoPrefix = firebasePhotosPath(appName, siteId, "");
      const [files] = await bucket.getFiles({ prefix: photoPrefix });

      const eventsCollectionRef = admin
        .firestore()
        .collection(firebaseSiteEventsPath(appName, siteId));
      const eventsSnapshot = await eventsCollectionRef.get();
      let lastEventVersion = 0;
      let events = eventsSnapshot.docs
        .map((doc) => {
          const docData = doc.data();
          const payload = docData[fbPayload];
          const timestamp = docData[fbTimeStamp] as admin.firestore.Timestamp;
          const siteEvent = SiteEvent.decode(Buffer.from(payload, "base64"));
          const version = docData[fbVersion] as number;

          const record: SiteEventRecord = {
            isoDate: timestamp.toDate().toISOString(),
            version: version,
            siteEvent: siteEvent,
          };

          logger.info("Event record to export:", SiteEventRecord.toJSON(record));

          lastEventVersion = Math.max(lastEventVersion, version || 0);

          const buffer = SiteEventRecord.encode(record).finish();
          return Buffer.from(buffer).toString("base64");
        })
        .join("\n");

      if (files.length === 0 && events.length === 0) {
        logger.info(`No data found for site ${siteId} to export.`);
        return;
      }

      const lastEvent: SiteEvent = {
        version: lastEventVersion + 1,
        author: authorId,
        exportEvent: { previousSiteId: siteId },
      };

      const lastRecord: SiteEventRecord = {
        isoDate: new Date().toISOString(),
        version: lastEventVersion + 1,
        siteEvent: lastEvent,
      };

      const lastEncodedRecord = SiteEventRecord.encode(lastRecord).finish();
      const lastBase64Record = Buffer.from(lastEncodedRecord).toString("base64");
      events += "\n" + lastBase64Record;

      const archive = archiver("zip", {
        zlib: { level: 9 }, // Sets the compression level.
      });

      archive.on("warning", (err) => {
        if (err.code === "ENOENT") {
          logger.warn("Archiver warning:", err);
        } else {
          throw err;
        }
      });

      archive.on("error", (err) => {
        throw err;
      });

      const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
      const zipFileName = `export-${siteId}-${timestamp}.zip`;
      const exportFilePath = firebaseExportsPath(appName, siteId, zipFileName);
      const exportFile = bucket.file(exportFilePath);
      const stream = exportFile.createWriteStream({
        gzip: true,
        contentType: "application/zip",
      });

      archive.pipe(stream);

      if (events.length > 0) {
        archive.append(events, { name: "events.txt" });
      }

      for (const file of files) {
        const fileName = file.name.split("/").pop();
        if (fileName) {
          // Put photos inside a storage/ folder in the zip so imports map them
          // to storage paths and events.txt remains at the archive root.
          archive.append(file.createReadStream(), { name: `storage/${fileName}` });
        }
      }

      await archive.finalize();

      logger.info(
        `Successfully created site export for site ${siteId} at ${exportFilePath}`
      );
    })();

    return null;
  }
);

export const listExports = onCall({ cors: true }, async (request) => {
  logger.info("listExports function called");

  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "User must be signed in");
  }

  const siteId = request.data.siteId;
  const appName = request.data.appName;
  const email =
    typeof request.auth?.token?.email === "string"
      ? request.auth.token.email
      : undefined;
  if (!email) {
    throw new HttpsError(
      "unauthenticated",
      "User email is required and must be a string"
    );
  }

  logger.info("exportPhotos function called, siteId:", siteId, "email:", email, "appName:", appName);


  const emailRef = admin
    .firestore()
    .collection(firebaseSiteUsersPath(appName, siteId))
    .doc(email);

  const emailDoc = await emailRef.get();
  if (!emailDoc.exists) {
    throw new HttpsError(
      "permission-denied",
      "User is not a member of this site"
    );
  }


  const bucket = admin.storage().bucket();
  const filePath = firebaseExportsPath(appName, siteId, "");

  const [files] = await bucket.getFiles({
    prefix: filePath,
  });

  const signedUrlConfig = {
    action: 'read' as const,
    expires: Date.now() + 15 * 60 * 1000, // 15 minutes
  };

  const exportFiles = await Promise.all(
    files.map(async (file) => {
      const url = isRunningInEmulator() ? file.publicUrl() : (await file.getSignedUrl(signedUrlConfig))[0];
      logger.info("exportPhotos function iteration, url:", url);
      return {
        name: file.name.split('/').pop(),
        url: url,
      };
    })
  );

  logger.info("exportPhotos function returned, exportFiles:", JSON.stringify(exportFiles, null, 2));


  return { files: exportFiles };
});

export const deleteExport = onCall({ cors: true }, async (request) => {

  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "User must be signed in");
  }

  const siteId = request.data.siteId;
  const appName = request.data.appName;
  const fileName = request.data.fileName;
  const email =
    typeof request.auth?.token?.email === "string"
      ? request.auth.token.email
      : undefined;
  if (!email) {
    throw new HttpsError(
      "unauthenticated",
      "User email is required and must be a string"
    );
  }
  logger.info("deleteExport function called, siteId:", siteId, "email:", email, "appName:", appName);

  const emailRef = admin
    .firestore()
    .collection(firebaseSiteUsersPath(appName, siteId))
    .doc(email);

  const emailDoc = await emailRef.get();
  if (!emailDoc.exists) {
    throw new HttpsError(
      "permission-denied",
      "User is not a member of this site"
    );
  }

  const bucket = admin.storage().bucket();
  const filePath = firebaseExportsPath(appName, siteId, fileName);

  const file = bucket.file(filePath);
  await file.delete();

  return { message: 'Export deleted successfully.' };
});

export const exportDetails = onCall({ cors: true }, async (request) => {
  logger.info("exportDetails function called");

  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "User must be signed in");
  }

  const siteId = request.data.siteId;
  const appName = request.data.appName;
  const fileName = request.data.fileName;
  const email =
    typeof request.auth?.token?.email === "string"
      ? request.auth.token.email
      : undefined;
  if (!email) {
    throw new HttpsError(
      "unauthenticated",
      "User email is required and must be a string"
    );
  }
  logger.info("exportDetails function called, siteId:", siteId, "email:", email, "appName:", appName, "fileName:", fileName);

  const emailRef = admin
    .firestore()
    .collection(firebaseSiteUsersPath(appName, siteId))
    .doc(email);

  const emailDoc = await emailRef.get();
  if (!emailDoc.exists) {
    throw new HttpsError(
      "permission-denied",
      "User is not a member of this site"
    );
  }

  const bucket = admin.storage().bucket();
  const filePath = firebaseExportsPath(appName, siteId, fileName);
  const file = bucket.file(filePath);

  return new Promise((resolve, reject) => {
    const stream = file.createReadStream();
    stream.pipe(unzipper.Parse())
      .on("entry", (entry) => {
        if (entry.path === "events.txt") {
          entry.buffer().then((buffer: { toString: () => any; }) => {
            resolve({ events: buffer.toString() });
          }).catch(reject);
        } else {
          entry.autodrain();
        }
      })
      .on("error", reject);
  });
});

export const importSite = onCall({ cors: true }, async (request) => {
  logger.info("importSite function called");

  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "User must be signed in");
  }

  const appName = request.data.appName;
  const base64Data = request.data.base64Data;
  const newSiteId = generateId();
  const bucket = admin.storage().bucket();

  try {
    const zipBuffer = Buffer.from(base64Data, "base64");
    const directory = await unzipper.Open.buffer(zipBuffer);

    // Extract events and photos from the zip. This will throw an HttpsError
    // with code 'invalid-argument' if the archive contains unexpected files.
    const { eventsContent, photos } = await extractEventsAndPhotosFromZip(directory);

    // Upload all photos returned by the extractor
    const photoUploadPromises: Promise<void>[] = photos.map(({ relativePath, buffer }) => {
      const photoPath = firebasePhotosPath(appName, newSiteId, relativePath);
      const gcsFile = bucket.file(photoPath);
      return gcsFile.save(buffer);
    });

    await Promise.all(photoUploadPromises);
    logger.info("All photos uploaded successfully");

    const eventLines = eventsContent.split("\n").filter((line) => line);
    const writeBatch = admin.firestore().batch();
    const siteEventsCollection = admin
      .firestore()
      .collection(firebaseSiteEventsPath(appName, newSiteId));

    const adminMembers: { memberId: string; name: string }[] = [];

    for (const line of eventLines) {
      const eventRecord = SiteEventRecord.decode(Buffer.from(line, "base64"));
      const docRef = siteEventsCollection.doc(eventRecord.version.toString());
      if (!eventRecord.siteEvent) {
        throw new HttpsError("invalid-argument", "Site event is missing in import data.");
      }


      logger.info("Event record to import:", SiteEventRecord.toJSON(eventRecord));

      writeBatch.set(docRef, {
        [fbPayload]: Buffer.from(
          SiteEvent.encode(eventRecord.siteEvent).finish()
        ).toString("base64"),
        [fbTimeStamp]: Timestamp.fromDate(new Date(eventRecord.isoDate)),
        [fbVersion]: eventRecord.version,
      });

      if (
        eventRecord.siteEvent?.addMember ||
        eventRecord.siteEvent?.updateMember ||
        eventRecord.siteEvent?.newSite ||
        eventRecord.siteEvent?.removeMember
      ) {
        let memberId;
        let name;
        if (eventRecord.siteEvent.addMember) {
          memberId = eventRecord.siteEvent.version;
          name = eventRecord.siteEvent.addMember.memberName;
        } else if (eventRecord.siteEvent.updateMember) {
          memberId = eventRecord.siteEvent.updateMember.memberId;
          name = eventRecord.siteEvent.updateMember.memberName;
        } else if (eventRecord.siteEvent.newSite) {
          memberId = eventRecord.siteEvent.version;
          name = eventRecord.siteEvent.newSite.memberName;
        }
        if (memberId && name) {
          adminMembers.push({ memberId: String(memberId), name: name });
        }
      }
    }

    await writeBatch.commit();
    logger.info("All events imported successfully");

    // log the admin members for debugging
    logger.info("Admin members identified during import:", adminMembers);

    // log the site id for debugging
    logger.info("New site ID generated:", newSiteId);

    return {
      siteId: newSiteId,
      adminMembers: adminMembers,
    };
  } catch (error) {
    logger.error("Error importing site:", error);
    throw new HttpsError("internal", "Failed to import site");
  }
});

export const assignUserToImportedSite = onCall({ cors: true }, async (request) => {
  logger.info("assignUserToImportedSite function called");

  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "User must be signed in");
  }

  const { siteId, memberId, appName } = request.data;
  const email =
    typeof request.auth?.token?.email === "string"
      ? request.auth.token.email
      : undefined;
  if (!email) {
    throw new HttpsError(
      "unauthenticated",
      "User email is required and must be a string"
    );
  }

  const siteUsersCollectionRef = admin
    .firestore()
    .collection(firebaseSiteUsersPath(appName, siteId));

  const accountEventsCollectionRef = admin
    .firestore()
    .collection(firebaseAccountEventsPath(appName, email));

  // Get the latest event version to increment it.
  const lastEventSnapshot = await accountEventsCollectionRef
    .orderBy(fbVersion, "desc")
    .limit(1)
    .get();
  let newVersion = 1;
  if (!lastEventSnapshot.empty) {
    const lastEventData = lastEventSnapshot.docs[0].data();
    if (
      lastEventData[fbVersion] &&
      typeof lastEventData[fbVersion] === "number"
    ) {
      newVersion = lastEventData[fbVersion] + 1;
    }
  }

  const writeBatch = admin.firestore().batch();

  const userDocRef = siteUsersCollectionRef.doc(email);
  writeBatch.set(userDocRef, {
    [fbUserId]: Number(memberId),
    [fbTimeStamp]: FieldValue.serverTimestamp(),
  });

  const newAccountEventRef = accountEventsCollectionRef.doc();
  const joinSiteEvent = AccountEvent.create({
    joinSite: siteId,
    version: newVersion,
  });
  writeBatch.set(newAccountEventRef, {
    [fbPayload]: Buffer.from(
      AccountEvent.encode(joinSiteEvent).finish()
    ).toString("base64"),
    [fbTimeStamp]: FieldValue.serverTimestamp(),
    [fbVersion]: newVersion,
  });

  await writeBatch.commit();

  return { success: true };
});