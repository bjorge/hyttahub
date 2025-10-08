import * as admin from "firebase-admin";
import archiver from "archiver";
import * as logger from "firebase-functions/logger";

import {
  firebaseExportsPath,
  firebasePhotosPath,
  firebaseSiteUsersPath,
  isRunningInEmulator,
} from "../shared/constants";

import { onCall, HttpsError } from "firebase-functions/v2/https";

export const uploadPhoto = onCall(async (request) => {
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

export const getPhoto = onCall(async (request) => {
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

export const deletePhoto = onCall(async (request) => {
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

export const deleteAlbumPhotos = onCall(async (request) => {
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

export const exportPhotos = onCall(async (request) => {
  logger.info("exportPhotos function called");

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

  // Return immediately and perform the export in the background
  // eslint-disable-next-line @typescript-eslint/no-floating-promises
  (async () => {
    const bucket = admin.storage().bucket();
    const photoPrefix = firebasePhotosPath(appName, siteId, "");
    const [files] = await bucket.getFiles({ prefix: photoPrefix });

    if (files.length === 0) {
      logger.info(`No photos found for site ${siteId} to export.`);
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

    for (const file of files) {
      const fileName = file.name.split("/").pop();
      if (fileName) {
        archive.append(file.createReadStream(), { name: fileName });
      }
    }

    await archive.finalize();

    logger.info(
      `Successfully created photo export for site ${siteId} at ${exportFilePath}`
    );
  })();

  return { status: "Export started" };
});

export const listExports = onCall(async (request) => {
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

export const deleteExport = onCall(async (request) => {

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