import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { admin } from "../shared/firebase";
import * as logger from "firebase-functions/logger";
import * as tar from "tar-stream";
import { Readable } from "stream";
import { SiteEvent, SiteEvent_ImportEvent, SiteEventRecord } from "../ts/site_events";
import { AccountEvent } from "../ts/account_events";

import {
  fbPayload,
  fbTimeStamp,
  firebaseAccountEventsPath,
  firebaseExportsPath,
  firebaseSiteEventsPath,
  firebaseSiteUsersPath,
  firebaseSitesPath,
  isRunningInEmulator,
  fbUserId,
  fbVersion,
  firebaseFilesPath,
  firebaseArchivePath,
  fbAppId,
} from "../shared/constants";

import { onCall, HttpsError } from "firebase-functions/v2/https";
import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { batchAppendToArchive } from "../file_functions/file_functions";

// Helper to extract events.txt and photo buffers from an opened unzipper directory.
// Throws an HttpsError('invalid-argument', ...) if the archive contains any
// unexpected file that is neither `events.txt` at the root nor under `storage/`.
async function extractEventsAndFilesFromTar(buffer: Buffer): Promise<{
  eventsContent: string;
  photos: Array<{ relativePath: string; buffer: Buffer }>;
}> {
  const extract = tar.extract();
  let eventsContent = "";
  const photos: Array<{ relativePath: string; buffer: Buffer }> = [];
  const rejectedFiles: string[] = [];
  const storagePrefix = "storage/";

  return new Promise((resolve, reject) => {
    extract.on("entry", (header, stream, next) => {
      const chunks: Buffer[] = [];
      stream.on("data", (chunk) => chunks.push(chunk));
      stream.on("end", () => {
        const content = Buffer.concat(chunks);

        if (header.name === "events.txt") {
          eventsContent = content.toString();
        } else if (header.name.startsWith(storagePrefix)) {
          if (header.type === "file") {
            const relativePath = header.name.substring(storagePrefix.length);
            if (relativePath) {
              photos.push({ relativePath, buffer: content });
            }
          }
        } else {
          if (header.type === "file") {
            rejectedFiles.push(header.name);
          }
        }
        next();
      });
      stream.resume();
    });

    extract.on("finish", () => {
      if (rejectedFiles.length > 0) {
        logger.error(
          "Import rejected due to unexpected files in archive:",
          JSON.stringify(rejectedFiles, null, 2)
        );
        reject(
          new HttpsError(
            "invalid-argument",
            `Unexpected files in archive: ${rejectedFiles.join(", ")}`
          )
        );
        return;
      }

      if (!eventsContent) {
        logger.error("Import rejected: events.txt missing from archive");
        reject(
          new HttpsError("invalid-argument", "Archive is missing events.txt")
        );
        return;
      }

      resolve({ eventsContent, photos });
    });

    extract.on("error", (err) => reject(err));

    extract.end(buffer);
  });
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


export const backupSite = onDocumentWritten(
  {
    document: `hyttahub/{appPathSegment}/sites/{siteId}/site_exports/export_request`,
    memory: '4GiB',         // Sets the memory to 4 Gibibyte
    timeoutSeconds: 540,    // Sets the timeout to 540 seconds (9 minutes)
  },



  async (event) => {
    logger.info("exportSite trigger called for export_request document");

    const after = event.data?.after;
    if (!after) {
      logger.info("exportSite: No document data available (deleted?). Skipping.");
      return null;
    }

    const appName = event.params.appPathSegment;
    const siteId = event.params.siteId;


    const docData = after.data() || {};

    // If present, only perform export if at least 5 minutes have passed since fbTimeStamp on the request.
    let authorId = 0;
    let appId = '';
    try {
      const reqTsRaw = (docData as any)[fbTimeStamp];
      authorId = (docData as any)[fbUserId];
      appId = (docData as any)[fbAppId];
      logger.info("Author ID for export request:", authorId);

      // Read last export timestamp (if any) before deciding whether to run an export.
      const lastExportRef = admin
        .firestore()
        .doc(`hyttahub/${appName}/sites/${siteId}/site_exports/last_export`);
      let lastExport: admin.firestore.Timestamp | null = null;
      try {
        const lastExportSnap = await lastExportRef.get();
        if (lastExportSnap.exists) {
          const lastExportData = lastExportSnap.data();
          lastExport =
            (lastExportData &&
              lastExportData[fbTimeStamp]) ||
            null;
          logger.info(
            "exportSite: lastExport timestamp read:",
            lastExport && lastExport.toDate ? lastExport.toDate().toISOString() : String(lastExport)
          );
        } else {
          logger.info("exportSite: no last_export document found");
        }
      } catch (err) {
        logger.warn("exportSite: failed to read last_export document", err);
      }

      if (!lastExport) {
        await admin
          .firestore()
          .doc(`hyttahub/${appName}/sites/${siteId}/site_exports/last_export`)
          .set({ [fbTimeStamp]: FieldValue.serverTimestamp() }, { merge: true });
      } else {
        if (!reqTsRaw) {
          logger.info('exportSite: fbTimeStamp not present on request doc; skipping export.');
          return null;
        }

        const EXPORT_COOLDOWN_MS = 5 * 60 * 1000; // 5 minutes
        // lastExport exists; require request timestamp to be at least 5 minutes greater than last export
        const reqTs = reqTsRaw.toDate ? reqTsRaw.toDate() : new Date(reqTsRaw);
        const lastExportTs = lastExport.toDate();
        const elapsedMs = reqTs.getTime() - lastExportTs.getTime();
        if (elapsedMs < EXPORT_COOLDOWN_MS) {
          logger.info(`exportSite: request timestamp is only ${elapsedMs}ms old (<5min). Skipping export.`);
          return null;
        }

        // Update fbLastExportTime to now (merge) before starting export
        await admin
          .firestore()
          .doc(`hyttahub/${appName}/sites/${siteId}/site_exports/last_export`)
          .set({ [fbTimeStamp]: FieldValue.serverTimestamp() }, { merge: true });
      }
    } catch (err) {
      logger.warn('exportSite: failed to read or write fbLastExportTime; proceeding', err);
    }

    // Run the export and return a Promise so the function waits for completion.
    const exportPromise = (async () => {
      const bucket = admin.storage().bucket();
      const photoPrefix = firebaseFilesPath(appName, siteId, "");
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
        exportEvent: { previousSiteId: siteId, appName: appName, appId: appId },
      };

      const lastRecord: SiteEventRecord = {
        isoDate: new Date().toISOString(),
        version: lastEventVersion + 1,
        siteEvent: lastEvent,
      };

      const lastEncodedRecord = SiteEventRecord.encode(lastRecord).finish();
      const lastBase64Record = Buffer.from(lastEncodedRecord).toString("base64");
      events += "\n" + lastBase64Record;

      const pack = tar.pack();

      const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
      const tarFileName = `export-${siteId}-${timestamp}.tar`;
      const exportFilePath = firebaseExportsPath(appName, siteId, tarFileName);
      const exportFile = bucket.file(exportFilePath);
      const stream = exportFile.createWriteStream({
        contentType: "application/x-tar",
      });

      pack.pipe(stream);

      if (events.length > 0) {
        pack.entry({ name: "events.txt" }, events);
      }

      // Try to use the incremental TAR archive for faster backup
      const archivePath = firebaseArchivePath(appName, siteId);
      const archiveFile = bucket.file(archivePath);
      const [archiveExists] = await archiveFile.exists();

      // Get list of current files from storage (source of truth)
      const currentFileNames = new Set(
        files.map(f => f.name.split('/').pop()).filter((name): name is string => !!name)
      );

      logger.info(`Found ${currentFileNames.size} files in storage for site ${siteId}`);

      if (archiveExists && currentFileNames.size > 0) {
        logger.info(`Using incremental archive at ${archivePath}`);

        try {
          // Download and extract files from TAR archive
          const [archiveData] = await archiveFile.download();
          const extract = tar.extract();
          const filesFromArchive = new Set<string>();

          extract.on("entry", (header: tar.Headers, stream: Readable, next: () => void) => {
            const fileName = header.name.replace(/^storage\//, '');

            // Only include files that still exist in storage
            if (currentFileNames.has(fileName)) {
              filesFromArchive.add(fileName);
              // Pipe the entry from the existing archive to the new pack
              stream.pipe(pack.entry(header, (err) => {
                if (err) logger.error(`Error adding entry to pack: ${err}`);
                next();
              }));
            } else {
              logger.info(`Skipping deleted file from archive: ${fileName}`);
              stream.resume(); // Drain the stream
              next();
            }
          });

          await new Promise<void>((resolve, reject) => {
            extract.on("finish", resolve);
            extract.on("error", reject);
            extract.end(archiveData);
          });

          logger.info(`Extracted ${filesFromArchive.size} files from archive`);

          // Add any files that are in storage but not in archive (fallback)
          const missingFiles = Array.from(currentFileNames).filter(name => !filesFromArchive.has(name));
          if (missingFiles.length > 0) {
            logger.info(`Adding ${missingFiles.length} files from storage (not in archive)`);
            for (const fileName of missingFiles) {
              const file = files.find(f => f.name.endsWith(`/${fileName}`));
              if (file) {
                const metadata = file.metadata;
                const size = parseInt(String(metadata.size || 0), 10);
                await new Promise<void>((resolve, reject) => {
                  const entry = pack.entry({ name: `storage/${fileName}`, size }, (err) => {
                    if (err) reject(err);
                    else resolve();
                  });
                  file.createReadStream().pipe(entry);
                });
              }
            }
          }
        } catch (error) {
          logger.error(`Error reading archive, falling back to storage: ${error}`);
          // Fall back to reading all files from storage
          for (const file of files) {
            const fileName = file.name.split("/").pop();
            if (fileName) {
              const metadata = file.metadata;
              const size = parseInt(String(metadata.size || 0), 10);
              await new Promise<void>((resolve, reject) => {
                const entry = pack.entry({ name: `storage/${fileName}`, size }, (err) => {
                  if (err) reject(err);
                  else resolve();
                });
                file.createReadStream().pipe(entry);
              });
            }
          }
        }
      } else {
        // No archive exists, read all files from storage
        logger.info(`No archive found, reading ${files.length} files from storage`);
        for (const file of files) {
          const fileName = file.name.split("/").pop();
          if (fileName) {
            // Put photos inside a storage/ folder in the zip so imports map them
            // to storage paths and events.txt remains at the archive root.
            const metadata = file.metadata;
            const size = parseInt(String(metadata.size || 0), 10);
            await new Promise<void>((resolve, reject) => {
              const entry = pack.entry({ name: `storage/${fileName}`, size }, (err) => {
                if (err) reject(err);
                else resolve();
              });
              file.createReadStream().pipe(entry);
            });
          }
        }
      }

      logger.info(
        `Finalize site export for site ${siteId} at ${exportFilePath}`
      );

      pack.finalize();

      // Wait for the GCS write stream to finish before returning.
      await new Promise<void>((resolve, reject) => {
        stream.on('finish', () => resolve());
        stream.on('error', (err) => reject(err));
        pack.on('error', (err) => reject(err));
      });

      logger.info(
        `Successfully created site export for site ${siteId} at ${exportFilePath}`
      );
    })();

    return exportPromise;
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
    const extract = tar.extract();
    let eventsContent = "";

    extract.on("entry", (header, stream, next) => {
      if (header.name === "events.txt") {
        const chunks: Buffer[] = [];
        stream.on("data", (chunk) => chunks.push(chunk));
        stream.on("end", () => {
          eventsContent = Buffer.concat(chunks).toString();
          next();
        });
      } else {
        stream.resume();
        next();
      }
    });

    extract.on("finish", () => {
      if (eventsContent) {
        resolve({ events: eventsContent });
      } else {
        reject(new HttpsError("not-found", "events.txt not found in export"));
      }
    });

    extract.on("error", reject);

    file.createReadStream().pipe(extract);
  });
});

export const importSite = onCall({
  cors: true,
  memory: '4GiB',         // Sets the memory to 4 Gibibyte
  timeoutSeconds: 540,    // Sets the timeout to 540 seconds (9 minutes)
}, async (request) => {
  logger.info("importSite function called");

  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "User must be signed in");
  }

  const appName = request.data.appName;
  const base64Data = request.data.base64Data;
  const storagePath = request.data.storagePath;
  const newSiteId = generateId();
  const bucket = admin.storage().bucket();

  let tarBuffer: Buffer;
  let fileToDelete: any = null;

  try {
    if (storagePath) {
      logger.info(`Reading tar from storage path: ${storagePath}`);
      const file = bucket.file(storagePath);
      const [buffer] = await file.download();
      tarBuffer = buffer;
      fileToDelete = file;
    } else if (base64Data) {
      logger.info("Reading tar from base64 data");
      tarBuffer = Buffer.from(base64Data, "base64");
    } else {
      throw new HttpsError("invalid-argument", "Either base64Data or storagePath must be provided");
    }

    // Extract events and photos from the tar. This will throw an HttpsError
    // with code 'invalid-argument' if the archive contains unexpected files.
    const { eventsContent, photos } = await extractEventsAndFilesFromTar(tarBuffer);

    // Make sure the last event is an export event for the expected app.
    const eventLines = eventsContent.split("\n").filter((line) => line);
    const lastEventRecordLine = eventLines[eventLines.length - 1];
    const lastEventRecord = SiteEventRecord.decode(Buffer.from(lastEventRecordLine, "base64"));
    logger.info("Last event record in import data:", SiteEventRecord.toJSON(lastEventRecord));

    if (!lastEventRecord.siteEvent) {
      throw new HttpsError("invalid-argument", "Site record is missing siteEvent.");
    }

    if (!lastEventRecord.siteEvent.exportEvent) {
      throw new HttpsError("invalid-argument", "Last event is not an export event.");
    }

    if (lastEventRecord.siteEvent.exportEvent.appName !== request.data.appName) {
      throw new HttpsError("invalid-argument", `Exported data is for the wrong app: expected ${request.data.appName} but got ${lastEventRecord.siteEvent.exportEvent.appName}`);
    }

    logger.info("TODO: in the future, make sure the appId matches in addition to appName.");

    // Upload all photos returned by the extractor
    const photoUploadPromises: Promise<void>[] = photos.map(({ relativePath, buffer }) => {
      const photoPath = firebaseFilesPath(appName, newSiteId, relativePath);
      const gcsFile = bucket.file(photoPath);
      return gcsFile.save(buffer);
    });

    await Promise.all(photoUploadPromises);
    logger.info("All photos uploaded successfully");

    await batchAppendToArchive(appName, newSiteId, photos);
    logger.info("All photos appended to archive successfully");

    // Import all events
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


      // logger.info("Event record to import:", SiteEventRecord.toJSON(eventRecord));

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
  } finally {
    if (fileToDelete) {
      try {
        await fileToDelete.delete();
        logger.info(`Deleted temporary import file: ${fileToDelete.name}`);
      } catch (cleanupError) {
        logger.warn(`Failed to delete temporary import file: ${fileToDelete.name}`, cleanupError);
      }
    }
  }
});

export const assignUserToImportedSite = onCall({ cors: true }, async (request) => {
  logger.info("assignUserToImportedSite function called");

  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "User must be signed in");
  }

  logger.info("uid is:", uid);

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

  const siteEventsCollectionRef = admin
    .firestore()
    .collection(firebaseSiteEventsPath(appName, siteId));

  const accountEventsCollectionRef = admin
    .firestore()
    .collection(firebaseAccountEventsPath(appName, email));

  // Get the latest account event version to increment it.
  const lastAccountEventSnapshot = await accountEventsCollectionRef
    .orderBy(fbVersion, "desc")
    .limit(1)
    .get();
  let newAccountEventVersion = 1;
  if (!lastAccountEventSnapshot.empty) {
    const lastEventData = lastAccountEventSnapshot.docs[0].data();
    if (
      lastEventData[fbVersion] &&
      typeof lastEventData[fbVersion] === "number"
    ) {
      newAccountEventVersion = lastEventData[fbVersion] + 1;
    }
  }

  // Get the latest site event version to increment it.
  const lastSiteEventSnapshot = await siteEventsCollectionRef
    .orderBy(fbVersion, "desc")
    .limit(1)
    .get();
  let newSiteEventVersion = 1;
  if (!lastSiteEventSnapshot.empty) {
    const lastEventData = lastSiteEventSnapshot.docs[0].data();
    if (
      lastEventData[fbVersion] &&
      typeof lastEventData[fbVersion] === "number"
    ) {
      newSiteEventVersion = lastEventData[fbVersion] + 1;
    }
  }


  const writeBatch = admin.firestore().batch();

  const userDocRef = siteUsersCollectionRef.doc(email);
  writeBatch.set(userDocRef, {
    [fbUserId]: Number(memberId),
    [fbTimeStamp]: FieldValue.serverTimestamp(),
  });

  const newAccountEventRef = accountEventsCollectionRef.doc(newAccountEventVersion.toString());
  const joinSiteEvent = AccountEvent.create({
    joinSite: siteId,
    version: newAccountEventVersion,
  });
  writeBatch.set(newAccountEventRef, {
    [fbPayload]: Buffer.from(
      AccountEvent.encode(joinSiteEvent).finish()
    ).toString("base64"),
    [fbTimeStamp]: FieldValue.serverTimestamp(),
    [fbVersion]: newAccountEventVersion,
  });

  const newSiteEventRef = siteEventsCollectionRef.doc(newSiteEventVersion.toString());
  const importSiteEvent = SiteEvent.create({
    importEvent: SiteEvent_ImportEvent.create({}),
    version: newSiteEventVersion,
    author: Number(memberId),
  });
  writeBatch.set(newSiteEventRef, {
    [fbPayload]: Buffer.from(
      SiteEvent.encode(importSiteEvent).finish()
    ).toString("base64"),
    [fbTimeStamp]: FieldValue.serverTimestamp(),
    [fbVersion]: newSiteEventVersion,
  });

  await writeBatch.commit();

  return { success: true };
});

/**
 * Scheduled function that runs daily to rebuild TAR archives,
 * removing files that have been deleted from storage.
 * This keeps the archives lean and accurate by streaming the process.
 */
export const cleanupArchives = onSchedule({
  schedule: "0 2 * * *", // Run at 2 AM every day
  timeZone: "UTC",
  memory: "2GiB",
  timeoutSeconds: 540,
}, async (event) => {
  logger.info("cleanupArchives: Starting daily archive cleanup");

  const bucket = admin.storage().bucket();
  const db = admin.firestore();

  // Dynamically discover all app path segments under the top-level `hyttahub` collection
  const hyttahubRoot = db.collection('hyttahub');
  const appDocs = await hyttahubRoot.listDocuments();

  if (appDocs.length === 0) {
    logger.info('cleanupArchives: No app documents found under hyttahub.');
    return;
  }

  for (const appDoc of appDocs) {
    const appName = appDoc.id;
    logger.info(`cleanupArchives: Processing app: ${appName}`);
    try {
      // Get all sites for this app
      const sitesCollection = db.collection(firebaseSitesPath(appName));
      const sitesSnapshot = await sitesCollection.listDocuments();

      logger.info(`cleanupArchives: Found ${sitesSnapshot.length} sites for app ${appName}`);

      for (const siteDoc of sitesSnapshot) {
        const siteId = siteDoc.id;

        // Define the paths for the final archive (A) and temporary archive (B)
        const archivePath = firebaseArchivePath(appName, siteId);
        const archiveFile = bucket.file(archivePath);
        const tempArchivePath = `${archivePath}.tmp.cleanup.${Date.now()}`;
        const tempArchiveFile = bucket.file(tempArchivePath);

        try {
          // Check for archive existence
          const [archiveExists] = await archiveFile.exists();

          if (!archiveExists) {
            logger.info(`cleanupArchives: No archive for site ${siteId}, skipping`);
            continue;
          }

          // Get current files from storage (source of truth) and their metadata
          const photoPrefix = firebaseFilesPath(appName, siteId, "");
          // getFiles returns File objects which contain the size property in metadata
          const [files] = await bucket.getFiles({ prefix: photoPrefix });

          if (files.length === 0) {
            logger.info(`cleanupArchives: No files in storage for site ${siteId}, deleting archive`);
            await archiveFile.delete();
            continue;
          }

          // --- COST OPTIMIZATION CHECK START ---

          // 1. Calculate the expected size of the rebuilt archive (sum of all valid file sizes)
          const totalValidFileSize = files.reduce((sum, file) => {
            // FIX: Template literal ensures the argument to parseInt is always a string.
            const fileSize = parseInt(`${file.metadata?.size ?? 0}`, 10);
            // We add a conservative overhead of 1024 bytes (1KB) per file for TAR headers
            return sum + fileSize + 1024;
          }, 0);

          // 2. Get the existing archive size (Class B operation)
          const [metadata] = await archiveFile.getMetadata();
          const existingArchiveSize = parseInt(`${metadata?.size ?? 0}`, 10);

          // Define the allowed tolerance (e.g., 20% difference)
          const rebuildToleranceFactor = 1.20; // Rebuild only if current size is > 120% of expected size

          if (existingArchiveSize < totalValidFileSize * rebuildToleranceFactor) {
            logger.info(`cleanupArchives: Archive for site ${siteId} is efficient enough (Current: ${existingArchiveSize} bytes, Expected: ${totalValidFileSize} bytes). Skipping rebuild.`);
            continue;
          }

          logger.warn(`cleanupArchives: Archive for site ${siteId} is inefficient (Current: ${existingArchiveSize} bytes, Expected: ${totalValidFileSize} bytes). STARTING REBUILD.`);

          // --- COST OPTIMIZATION CHECK END ---

          // Create a Set of valid file names (source of truth)
          const currentFileNames = new Set(
            files.map(f => f.name.split('/').pop()).filter((name): name is string => !!name)
          );

          // --- START STREAMING REBUILD PROCESS (A to B) ---

          const existingArchiveStream = archiveFile.createReadStream();
          const writeStreamB = tempArchiveFile.createWriteStream({
            contentType: "application/x-tar",
          });

          const extract = tar.extract();
          const pack = tar.pack();

          let filesInArchive = 0;
          let filesRemoved = 0;
          let streamFailed = false;

          // Logic to keep valid entries and discard deleted ones
          extract.on("entry", (header: tar.Headers, stream: Readable, next: () => void) => {
            const fileName = header.name.replace(/^storage\//, '');

            if (currentFileNames.has(fileName)) {
              // Keep: Pipe the entry data to the new packer stream
              filesInArchive++;

              // FIX for TS2345: Explicitly clone and map problematic numeric fields (uid/gid) 
              // to strings to ensure compatibility with strict TypeScript definition of pack.entry().
              const packHeader = {
                ...header,
                uid: header.uid ? String(header.uid) : undefined,
                gid: header.gid ? String(header.gid) : undefined,
              } as tar.Headers; // Cast back to Headers, accepting the minor type coercion.

              stream.pipe(pack.entry(packHeader, (err) => {
                if (err) logger.error(`Error adding entry to pack: ${err}`);
                next();
              }));
            } else {
              // Discard: Drain the stream to move to the next entry
              filesRemoved++;
              logger.info(`cleanupArchives: Removing deleted file from archive: ${fileName}`);
              stream.resume(); // Drain the stream to consume data
              stream.on('end', () => next());
            }
          });

          extract.on("error", (err: Error) => {
            // If archive corrupted during extraction, flag failure
            logger.error(`cleanupArchives: Archive extraction failed: ${err.message}`);
            streamFailed = true;
          });

          // Pipeline connection
          existingArchiveStream.pipe(extract); // GCS (A) -> Extractor
          pack.pipe(writeStreamB);            // Packer -> GCS (B)

          // Wait for the entire stream to finish processing
          await new Promise<void>((resolve, reject) => {
            existingArchiveStream.on("error", reject); // Catch GCS read errors
            writeStreamB.on("error", reject);          // Catch GCS write errors
            extract.on("error", reject);

            // Once extraction is complete, finalize the pack (no more entries will be added)
            extract.on("finish", () => {
              pack.finalize();
            });
            writeStreamB.on("finish", resolve); // Resolve when the final write to B is done
          });

          if (streamFailed) {
            // If extraction failed, we cannot trust the new file, so we skip the move.
            throw new Error("Archive rebuild failed due to stream corruption or error.");
          }

          // --- END STREAMING REBUILD PROCESS ---

          // --- ATOMIC REPLACEMENT (B to A) ---
          logger.info(`cleanupArchives: Moving rebuilt archive (B) to final path (A): ${archivePath}`);
          await tempArchiveFile.move(archiveFile);

          logger.info(`cleanupArchives: Rebuilt archive for site ${siteId}: kept ${filesInArchive} files, removed ${filesRemoved} files`);

        } catch (siteError) {
          logger.error(`cleanupArchives: Error processing site ${siteId}. Deleting temporary file if exists:`, siteError);
          // Clean up temporary file on failure
          await tempArchiveFile.delete({ ignoreNotFound: true }).catch(e => logger.warn(`Failed to cleanup temp file: ${e.message}`));
          // Continue with next site
        }
      }
    } catch (appError) {
      logger.error(`cleanupArchives: Error processing app ${appName}:`, appError);
      // Continue with next app
    }
  }

  logger.info("cleanupArchives: Daily archive cleanup completed");
});