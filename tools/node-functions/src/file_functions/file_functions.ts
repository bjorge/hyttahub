import { admin } from "../shared/firebase";
import * as logger from "firebase-functions/logger";
import * as tar from "tar-stream";
import { pipeline } from "stream/promises";
import { Readable } from "stream";

import {
  firebaseFilesPath,
  firebaseSiteUsersPath,
  firebaseArchivePath,
  isRunningInEmulator,
} from "../shared/constants";

import { onCall, HttpsError } from "firebase-functions/v2/https";

/**
 * Appends a file to the incremental TAR archive for a site.
 * If the archive doesn't exist, creates a new one.
 * If the archive is corrupted, recreates it with just the new file.
 */
async function appendToArchive(
  appName: string,
  siteId: string,
  fileName: string,
  fileBuffer: Buffer
): Promise<void> {
  const bucket = admin.storage().bucket();
  const archivePath = firebaseArchivePath(appName, siteId);
  const archiveFile = bucket.file(archivePath);

  try {
    // Check if archive exists
    const [exists] = await archiveFile.exists();

    if (!exists) {
      // Create new archive with just this file
      logger.info(`Creating new archive at ${archivePath}`);
      const pack = tar.pack();
      pack.entry({ name: `storage/${fileName}` }, fileBuffer);
      pack.finalize();

      await pipeline(pack, archiveFile.createWriteStream({
        contentType: "application/x-tar",
      }));
      logger.info(`Created new archive with file ${fileName}`);
      return;
    }

    // Archive exists - append to it
    logger.info(`Appending ${fileName} to existing archive at ${archivePath}`);

    // Download existing archive
    const [existingData] = await archiveFile.download();

    // Create new pack with existing data + new file
    const pack = tar.pack();

    // First, extract and re-add all existing entries
    const extract = tar.extract();
    let hasError = false;

    extract.on("entry", (header: tar.Headers, stream: Readable, next: () => void) => {
      stream.pipe(pack.entry(header, (err) => {
        if (err) logger.error(`Error adding entry to pack: ${err}`);
        next();
      }));
    });

    extract.on("error", (err: Error) => {
      logger.warn(`Archive corrupted, recreating: ${err.message}`);
      hasError = true;
    });

    // Write existing data to extractor
    await new Promise<void>((resolve, reject) => {
      extract.on("finish", resolve);
      extract.on("error", reject);
      extract.end(existingData);
    }).catch(() => {
      hasError = true;
    });

    if (hasError) {
      // Archive was corrupted, create fresh one with just new file
      logger.info(`Recreating corrupted archive with just ${fileName}`);
      const newPack = tar.pack();
      newPack.entry({ name: `storage/${fileName}` }, fileBuffer);
      newPack.finalize();

      await pipeline(newPack, archiveFile.createWriteStream({
        contentType: "application/x-tar",
      }));
      return;
    }

    // Add new file
    pack.entry({ name: `storage/${fileName}` }, fileBuffer);
    pack.finalize();

    // Upload updated archive
    await pipeline(pack, archiveFile.createWriteStream({
      contentType: "application/x-tar",
    }));

    logger.info(`Successfully appended ${fileName} to archive`);
  } catch (error) {
    logger.error(`Error appending to archive: ${error}`);
    // Don't throw - file is already saved to storage, archive is just an optimization
    logger.warn("Continuing without updating archive - will rebuild during backup");
  }
}


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

  // Append to incremental archive (don't await - run in background)
  appendToArchive(appName, siteId, fileName, fileBuffer).catch((err) => {
    logger.error(`Failed to append to archive (non-fatal): ${err}`);
  });

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

  const filePath = firebaseFilesPath(appName, siteId, fileName);
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

