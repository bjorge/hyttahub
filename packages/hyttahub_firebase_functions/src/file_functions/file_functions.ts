import { admin } from "../shared/firebase";
import * as logger from "firebase-functions/logger";


import {
  firebaseFilesPath,
  firebaseEmulatorArchiveFilesPath,
  firebaseSiteUsersPath,
  isRunningInEmulator,
} from "../shared/constants";

import { getArchiveBucketName } from "../shared/config";

import { onCall, HttpsError } from "firebase-functions/v2/https";


export const uploadFile = onCall({ cors: true }, async (request) => {
  logger.info("uploadFile function called");

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

  logger.info("uploadFile function called, siteId:", siteId, "email:", email);

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

  const filePath = firebaseFilesPath(appName, siteId, fileName);
  const file = bucket.file(filePath);

  const fileBuffer = Buffer.from(base64Data, "base64");

  await file.save(fileBuffer, {
    // contentType: "image/jpeg",
    // metadata: {
    //   firebaseStorageDownloadTokens: uid, // Optional: set download token for access control
    // },
  });
  logger.info(`File uploaded to ${file.name}`);

  // Archive copy
  if (isRunningInEmulator()) {
    // Emulator: use path-based archive in default bucket
    const archiveFilePath = firebaseEmulatorArchiveFilesPath(appName, siteId, fileName);
    const archiveFile = bucket.file(archiveFilePath);
    await archiveFile.save(fileBuffer, {});
    logger.info(`File archived to ${archiveFile.name} (emulator path-based)`);
  } else {
    const archiveBucketName = getArchiveBucketName();
    if (archiveBucketName) {
      const archiveBucket = admin.storage().bucket(archiveBucketName);
      const archiveFile = archiveBucket.file(filePath);
      await archiveFile.save(fileBuffer, {});
      logger.info(`File archived to ${archiveFile.name} in bucket ${archiveBucketName}`);
    } else {
      logger.info("Archive bucket not configured, skipping archive copy");
    }
  }

  if (isRunningInEmulator()) {
    logger.info(
      `File uploaded to ${file.name} in emulator mode, not generating signed URL`
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

export const getFile = onCall({ cors: true }, async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "User must be signed in");
  }

  const siteId = request.data.siteId;
  const appName = request.data.appName;
  const fileName = request.data.fileName;
  const expirationDays = request.data.expirationDays as number | undefined;

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

  logger.info("getFile function called, siteId:", siteId, "email:", email);

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

  const filePath = firebaseFilesPath(appName, siteId, fileName);
  const file = bucket.file(filePath);

  if (isRunningInEmulator()) {
    return { downloadUrl: file.publicUrl() };
  } else {
    const expires = expirationDays 
      ? Date.now() + expirationDays * 24 * 60 * 60 * 1000 
      : Date.now() + 15 * 60 * 1000; // Default 15 minutes

    const [signedUrl] = await file.getSignedUrl({
      action: "read",
      expires: expires,
    });
    return { downloadUrl: signedUrl };
  }
});


export const deleteFiles = onCall({ cors: true }, async (request) => {
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

  logger.info("deleteFiles function called, siteId:", siteId, "email:", email);

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
    const filePath = firebaseFilesPath(appName, siteId, fileName);
    const file = bucket.file(filePath);
    deletePromises.push(
      file.delete().catch((err) => {
        // Ignore "file not found" errors (best effort delete)
        if (err.code === 404) {
          logger.info(`File not found for deletion: ${filePath}`);
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

export const listSiteFiles = onCall({ cors: true }, async (request) => {
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
  const prefix = firebaseFilesPath(appName, siteId, "");
  
  try {
    const [files] = await bucket.getFiles({ prefix });
    const fileList = files.map(file => ({
      name: file.name.split("/").pop(),
      size: parseInt(String(file.metadata.size || "0"), 10),
    }));

    return { files: fileList };
  } catch (error) {
    logger.error(`Failed to list files for site ${siteId}`, error);
    throw new HttpsError("internal", "Failed to list files");
  }
});

