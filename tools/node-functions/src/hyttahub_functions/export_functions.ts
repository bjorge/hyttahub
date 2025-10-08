// // Copyright (c) 2025 bjorge

// import * as functions from 'firebase-functions';
// import * as admin from 'firebase-admin';
// import * as archiver from 'archiver';
// import { getStorage } from 'firebase-admin/storage';
// import { AppReplayBlocState, Photo } from '../ts/app_replay_bloc';
// import { unpackAny } from './util';

// const db = admin.firestore();

// exports.exportPhotos = functions.https.onCall(async (data, context) => {
//   const siteId = data.siteId;
//   const uid = context.auth?.uid;

//   if (!uid) {
//     throw new functions.https.HttpsError(
//       'unauthenticated',
//       'The function must be called while authenticated.'
//     );
//   }

//   const siteRef = db.doc(`sites/${siteId}`);
//   const siteDoc = await siteRef.get();

//   if (!siteDoc.exists) {
//     throw new functions.https.HttpsError('not-found', 'Site not found.');
//   }

//   const siteData = siteDoc.data();
//   if (!siteData) {
//     throw new functions.https.HttpsError('not-found', 'Site data not found.');
//   }

//   const appReplayBlocState = unpackAny(
//     siteData.appBlocState,
//     new AppReplayBlocState()
//   );

//   const photos: Photo[] = [];
//   appReplayBlocState.albums.forEach((album) => {
//     photos.push(...album.photos);
//   });

//   if (photos.length === 0) {
//     return { message: 'No photos to export.' };
//   }

//   const bucket = getStorage().bucket();
//   const exportFileName = `exports/${siteId}/${new Date().toISOString()}.zip`;
//   const file = bucket.file(exportFileName);

//   const archive = archiver('zip', {
//     zlib: { level: 9 },
//   });

//   const stream = file.createWriteStream({
//     metadata: {
//       contentType: 'application/zip',
//     },
//   });

//   archive.pipe(stream);

//   for (const photo of photos) {
//     const photoFile = bucket.file(`sites/${siteId}/photos/${photo.id}`);
//     const photoStream = photoFile.createReadStream();
//     archive.append(photoStream, { name: `${photo.id}.jpg` });
//   }

//   await archive.finalize();

//   return { message: 'Export started. Check back later.' };
// });

// exports.listExports = functions.https.onCall(async (data, context) => {
//   const siteId = data.siteId;
//   const uid = context.auth?.uid;

//   if (!uid) {
//     throw new functions.https.HttpsError(
//       'unauthenticated',
//       'The function must be called while authenticated.'
//     );
//   }

//   const bucket = getStorage().bucket();
//   const [files] = await bucket.getFiles({
//     prefix: `exports/${siteId}/`,
//   });

//   const signedUrlConfig = {
//     action: 'read' as const,
//     expires: Date.now() + 15 * 60 * 1000, // 15 minutes
//   };

//   const exportFiles = await Promise.all(
//     files.map(async (file) => {
//       const [url] = await file.getSignedUrl(signedUrlConfig);
//       return {
//         name: file.name.split('/').pop(),
//         url: url,
//       };
//     })
//   );

//   return { files: exportFiles };
// });

// exports.deleteExport = functions.https.onCall(async (data, context) => {
//   const siteId = data.siteId;
//   const fileName = data.fileName;
//   const uid = context.auth?.uid;

//   if (!uid) {
//     throw new functions.https.HttpsError(
//       'unauthenticated',
//       'The function must be called while authenticated.'
//     );
//   }

//   const bucket = getStorage().bucket();
//   const file = bucket.file(`exports/${siteId}/${fileName}`);
//   await file.delete();

//   return { message: 'Export deleted successfully.' };
// });