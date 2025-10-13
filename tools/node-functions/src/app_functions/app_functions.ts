import * as admin from "firebase-admin";
import archiver from "archiver";
import * as logger from "firebase-functions/logger";
import * as unzipper from "unzipper";
import { SiteEvent, SiteEventRecord } from "../ts/site_events";
import { AccountEvent } from "../ts/account_events";

import {
  fbPayload,
  fbTimeStamp,
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

export const exportSite = onCall({ cors: true }, async (request) => {
  logger.info("exportSite function called");

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

  logger.info("exportSite function called, siteId:", siteId, "email:", email, "appName:", appName);

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

  // Return immediately and perform the export in the background
  // eslint-disable-next-line @typescript-eslint/no-floating-promises
  (async () => {
    const bucket = admin.storage().bucket();
    const photoPrefix = firebasePhotosPath(appName, siteId, "");
    const [files] = await bucket.getFiles({ prefix: photoPrefix });

    const eventsCollectionRef = admin
      .firestore()
      .collection(firebaseSiteEventsPath(appName, siteId));
    const eventsSnapshot = await eventsCollectionRef.get();
    const events = eventsSnapshot.docs
      .map((doc) => {
        const docData = doc.data();
        const payload = docData[fbPayload];
        const timestamp = docData[fbTimeStamp] as admin.firestore.Timestamp;
        const siteEvent = SiteEvent.decode(Buffer.from(payload, "base64"));

        const record: SiteEventRecord = {
          isoDate: timestamp.toDate().toISOString(),
          version: siteEvent.version,
          siteEvent: siteEvent,
        };

        const buffer = SiteEventRecord.encode(record).finish();
        return Buffer.from(buffer).toString("base64");
      })
      .join("\n");

    if (files.length === 0 && events.length === 0) {
      logger.info(`No data found for site ${siteId} to export.`);
      return;
    }

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
        archive.append(file.createReadStream(), { name: fileName });
      }
    }

    await archive.finalize();

    logger.info(
      `Successfully created site export for site ${siteId} at ${exportFilePath}`
    );
  })();

  return { status: "Export started" };
});

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

    let eventsContent = "";
    const photoUploadPromises: Promise<void>[] = [];

    for (const file of directory.files) {
      if (file.path === "events.txt") {
        eventsContent = await file.buffer().then((buffer) => buffer.toString());
      } else {
        const photoUploadPromise = file.buffer().then(async (buffer) => {
          const photoPath = firebasePhotosPath(appName, newSiteId, file.path);
          const gcsFile = bucket.file(photoPath);
          await gcsFile.save(buffer);
        });
        photoUploadPromises.push(photoUploadPromise);
      }
    }

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
      const docRef = siteEventsCollection.doc();
      writeBatch.set(docRef, {
        [fbPayload]: Buffer.from(
          SiteEvent.encode(eventRecord.siteEvent).finish()
        ).toString("base64"),
        [fbTimeStamp]: admin.firestore.Timestamp.fromDate(
          new Date(eventRecord.isoDate)
        ),
      });

      if (
        eventRecord.siteEvent?.addMember?.isAdmin ||
        eventRecord.siteEvent?.updateMember?.newIsAdmin
      ) {
        let memberId;
        let name;
        if (eventRecord.siteEvent.addMember) {
          memberId = eventRecord.siteEvent.addMember.id;
          name = eventRecord.siteEvent.addMember.name;
        } else if (eventRecord.siteEvent.updateMember) {
          memberId = eventRecord.siteEvent.updateMember.id;
          name = eventRecord.siteEvent.updateMember.newName;
        }
        if (memberId && name) {
          adminMembers.push({ memberId, name });
        }
      }
    }

    await writeBatch.commit();
    logger.info("All events imported successfully");

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
    [fbUserId]: memberId,
    [fbTimeStamp]: admin.firestore.FieldValue.serverTimestamp(),
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
    [fbTimeStamp]: admin.firestore.FieldValue.serverTimestamp(),
    [fbVersion]: newVersion,
  });

  await writeBatch.commit();

  return { success: true };
});