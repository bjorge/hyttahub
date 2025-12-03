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


// Define the structure for the input files
interface ArchiveFile {
  relativePath: string;
  buffer: Buffer;
}

/**
 * Appends a batch of files to the incremental TAR archive for a site.
 * This is done by streaming the old archive to a temporary file (B), 
 * adding the new files, and then atomically moving the temporary file to 
 * the final path (A) to ensure memory efficiency and data safety.
 */
export async function batchAppendToArchive(
  appName: string,
  siteId: string,
  files: ArchiveFile[]
): Promise<void> {
  if (files.length === 0) {
    logger.warn('batchAppendToArchive called with an empty file list. Skipping.');
    return;
  }

  const bucket = admin.storage().bucket();
  const archivePath = firebaseArchivePath(appName, siteId);
  const archiveFile = bucket.file(archivePath);

  // Define the temporary file path (File B)
  const tempArchivePath = `${archivePath}.tmp.${Date.now()}`;
  const tempArchiveFile = bucket.file(tempArchivePath);

  const fileNamesList = files.map(f => f.relativePath).join(', ');

  try {
    // --- STEP 1: Check if archive exists ---
    const [exists] = await archiveFile.exists();

    if (!exists) {
      // --- CASE 1: CREATE NEW ARCHIVE (Direct write to final path A) ---
      logger.info(`Creating new archive at ${archivePath} with ${files.length} files.`);

      const pack = tar.pack();
      files.forEach(({ relativePath, buffer }) => {
        pack.entry({ name: `storage/${relativePath}` }, buffer);
      });
      pack.finalize();

      await pipeline(pack, archiveFile.createWriteStream({
        contentType: "application/x-tar",
      }));
      logger.info(`Created new archive successfully.`);
      return;
    }

    // --- CASE 2: APPEND TO EXISTING ARCHIVE (Stream A to B) ---
    logger.info(`Streaming and appending ${files.length} files to temporary archive: ${fileNamesList}`);

    // Set up streams for the Read-Modify-Write cycle
    const existingArchiveStream = archiveFile.createReadStream();
    const writeStreamB = tempArchiveFile.createWriteStream({
      contentType: "application/x-tar",
    });

    // Create new pack stream (this is the output stream, which writes to B)
    const pack = tar.pack();

    // Create the extractor stream (this is the stream that receives data from A)
    const extract = tar.extract();
    let isCorrupted = false;

    // Logic to re-add existing entries from the extractor to the packer
    extract.on("entry", (header: tar.Headers, stream: Readable, next: () => void) => {
      // Pipe existing entry data back into the new pack stream
      stream.pipe(pack.entry(header, (err) => {
        if (err) logger.error(`Error re-adding existing entry: ${err}`);
        next();
      }));
    });

    extract.on("error", (err: Error) => {
      // If the old file is corrupted, stop extraction and flag for recreation
      logger.warn(`Archive corrupted during stream, flag set for recreation: ${err.message}`);
      isCorrupted = true;
    });

    // Pipe the GCS download stream directly into the extractor
    // This starts the stream processing: GCS(A) -> extract -> pack
    existingArchiveStream.pipe(extract);

    // Pipe the output packer stream to the temporary GCS file B
    // Flow: pack -> GCS(B)
    pack.pipe(writeStreamB);

    // Wait for the entire existing stream to finish processing (i.e., A is fully read)
    await new Promise<void>((resolve, reject) => {
      // Reject on error from any part of the stream pipeline
      existingArchiveStream.on("error", reject);
      extract.on("error", reject);
      extract.on("finish", resolve);
    }).catch((err) => {
      // If streaming failed for any reason (GCS read error, TAR error), flag as corrupted
      logger.error(`Stream pipeline failed: ${err.message}`);
      isCorrupted = true;
    });

    if (isCorrupted) {
      // If stream failed or archive was corrupted, we abort the move and 
      // create a fresh archive (B) with only the new files (safe fallback)
      logger.warn(`Archive recreation triggered. Writing only new files to ${archivePath}.`);
      const newPack = tar.pack();
      files.forEach(({ relativePath, buffer }) => {
        newPack.entry({ name: `storage/${relativePath}` }, buffer);
      });
      newPack.finalize();

      // Overwrite the final archive path A directly (no need for move, since A is broken)
      await pipeline(newPack, archiveFile.createWriteStream({
        contentType: "application/x-tar",
      }));

      // Clean up the potentially half-written temporary file B
      await tempArchiveFile.delete({ ignoreNotFound: true });
      return;
    }

    // Add the new files to the active pack stream (B is still being written)
    files.forEach(({ relativePath, buffer }) => {
      pack.entry({ name: `storage/${relativePath}` }, buffer);
    });

    // Finalize the pack and wait for the temporary GCS write stream (B) to finish
    pack.finalize();
    await new Promise<void>((resolve, reject) => {
      writeStreamB.on('error', reject);
      writeStreamB.on('finish', resolve);
    });

    // --- STEP 3: Atomic Move (B to A) ---
    logger.info(`Moving complete temporary archive (B) to final path (A): ${archivePath}`);
    await tempArchiveFile.move(archiveFile);

    logger.info(`Successfully completed atomic batch append of ${files.length} files.`);

  } catch (error) {
    logger.error(`Fatal error in batchAppendToArchive: ${error}`);
    // Attempt to clean up the temporary file on error
    await tempArchiveFile.delete({ ignoreNotFound: true }).catch(e => logger.warn(`Failed to cleanup temp file: ${e.message}`));

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
  // Note: We wrap the single file into the array format [{ relativePath: string, buffer: Buffer }]
  batchAppendToArchive(appName, siteId, [{ relativePath: fileName, buffer: fileBuffer }]).catch((err) => {
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

