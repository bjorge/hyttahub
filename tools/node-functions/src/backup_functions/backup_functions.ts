import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { admin } from "../shared/firebase";
import * as logger from "firebase-functions/logger";
import * as tar from "tar-stream";
import { Readable } from "stream";
import { SiteEvent, SiteEvent_ImportEvent, SiteEventRecord } from "../ts/site_events";
import { AccountEvent } from "../ts/account_events";


import { firebaseAccountEventsPath, firebaseExportsPath, firebaseSiteEventsPath, firebaseSiteUsersPath, isRunningInEmulator, fbUserId, fbVersion, firebaseFilesPath, firebaseArchivePath, fbAppId, fbPayload, fbTimeStamp } from "../shared/constants";

import { onCall, HttpsError } from "firebase-functions/v2/https";
import { onDocumentWritten } from "firebase-functions/v2/firestore";

// Helper to stream and process tar entries without loading the entire archive into memory.
// Throws an HttpsError('invalid-argument', ...) if the archive contains any
// unexpected file that is neither `events.txt` at the root nor under `storage/`.
// 
// This function processes files as they are streamed and uploads them immediately,
// which is essential for handling large (>1GB) tar files.
//
// Memory optimization: Instead of loading the entire tar into memory first, we:
// 1. Stream the tar file entry-by-entry
// 2. Upload each file to storage immediately as it's extracted
// 3. Do NOT keep file buffers in memory (to minimize memory usage)
// 4. Process uploads in batches to prevent too many concurrent uploads
// 
// This approach uses significantly less memory than loading the entire tar file,
// especially when the tar contains many large files.
//
// Note: Archive append is skipped because it would require keeping all file buffers
// in memory, which defeats the purpose of streaming for large imports.
async function streamAndProcessTar(
  inputStream: Readable,
  appName: string,
  siteId: string,
  bucket: any
): Promise<{
  eventsContent: string;
  photoCount: number;
}> {
  const extract = tar.extract();
  let eventsContent = "";
  const rejectedFiles: string[] = [];
  const storagePrefix = "storage/";
  let photoCount = 0;

  // Batch upload processing to prevent memory buildup
  const UPLOAD_BATCH_SIZE = 10;
  let currentBatch: Promise<void>[] = [];
  const batchPromises: Promise<void[]>[] = [];

  return new Promise((resolve, reject) => {
    extract.on("entry", (header, stream, next) => {
      const chunks: Buffer[] = [];

      stream.on("data", (chunk) => chunks.push(chunk));
      stream.on("end", async () => {
        const content = Buffer.concat(chunks);

        if (header.name === "events.txt") {
          eventsContent = content.toString();
          next();
        } else if (header.name.startsWith(storagePrefix)) {
          if (header.type === "file") {
            const relativePath = header.name.substring(storagePrefix.length);
            if (relativePath) {
              photoCount++;
              // Upload photo immediately without storing in memory
              const photoPath = firebaseFilesPath(appName, siteId, relativePath);
              const gcsFile = bucket.file(photoPath);
              logger.info(`Uploading photo ${relativePath}`);
              const uploadPromise = gcsFile.save(content).catch((err: Error) => {
                logger.error(`Failed to upload file ${relativePath}:`, err);
                throw err;
              });

              currentBatch.push(uploadPromise);

              // When batch is full, wait for it to complete before continuing
              if (currentBatch.length >= UPLOAD_BATCH_SIZE) {
                const batchToWait = Promise.all(currentBatch);
                batchPromises.push(batchToWait);
                currentBatch = [];

                // Wait for this batch to complete before processing next entry
                try {
                  await batchToWait;
                } catch (err) {
                  reject(err);
                  return;
                }
              }
            }
          }
          next();
        } else {
          if (header.type === "file") {
            rejectedFiles.push(header.name);
          }
          next();
        }
      });

      stream.on("error", (err) => {
        logger.error("Error reading stream entry:", err);
        reject(err);
      });

      stream.resume();
    });

    extract.on("finish", async () => {
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

      // Wait for any remaining uploads in the current batch
      try {
        if (currentBatch.length > 0) {
          await Promise.all(currentBatch);
        }
        // Also wait for all batch promises (should already be complete, but just to be safe)
        await Promise.all(batchPromises);
        logger.info(`All ${photoCount} photos uploaded successfully`);
        resolve({ eventsContent, photoCount });
      } catch (err) {
        logger.error("Error uploading photos:", err);
        reject(err);
      }
    });

    extract.on("error", (err) => {
      logger.error("Error extracting tar:", err);
      reject(err);
    });

    inputStream.on("error", (err) => {
      logger.error("Error reading input stream:", err);
      reject(err);
    });

    inputStream.pipe(extract);
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

          // logger.info("Event record to export:", SiteEventRecord.toJSON(record));

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
            logger.info(`Adding file to archive: ${fileName}`);
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

      // Copy the export to the archive path to keep it as the latest backup
      try {
        const archivePath = firebaseArchivePath(appName, siteId);
        const archiveFile = bucket.file(archivePath);

        logger.info(`Copying export to archive path: ${archivePath}`);
        await exportFile.copy(archiveFile);
        logger.info(`Successfully saved backup as latest archive at ${archivePath}`);
      } catch (archiveError) {
        logger.error(`Failed to copy export to archive path:`, archiveError);
        // Don't fail the export if archive copy fails
      }
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
    throw new HttpsError("unauthenticated", "User email is required");
  }

  logger.info("exportDetails", { siteId, email, appName, fileName });

  // --- Permissions ---
  const emailRef = admin
    .firestore()
    .collection(firebaseSiteUsersPath(appName, siteId))
    .doc(email);

  const emailDoc = await emailRef.get();
  if (!emailDoc.exists) {
    throw new HttpsError("permission-denied", "User is not a member of this site");
  }

  // --- Storage ---
  const bucket = admin.storage().bucket();
  const filePath = firebaseExportsPath(appName, siteId, fileName);
  const file = bucket.file(filePath);

  // --- Extract only events.txt with early stop ---
  return new Promise<{ events: string }>((resolve, reject) => {
    const extract = tar.extract();
    const readStream = file.createReadStream();

    let eventsContent = "";
    let extractionFinished = false;

    extract.on("entry", (header, stream, next) => {
      try {
        const entryName = header.name;

        if (entryName === "events.txt") {
          const chunks: Buffer[] = [];

          stream.on("data", (chunk) => chunks.push(chunk));
          stream.on("end", () => {
            eventsContent = Buffer.concat(chunks).toString();

            // --- EARLY STOP ---
            extractionFinished = true;
            extract.destroy();     // Stop tar parsing
            readStream.destroy();  // Stop downloading rest of file

            resolve({ events: eventsContent });
          });

        } else {
          // Skip all other files
          stream.resume();
          next();
        }

      } catch (err) {
        reject(err);
      }
    });

    extract.on("finish", () => {
      if (!extractionFinished) {
        reject(new HttpsError("not-found", "events.txt not found in archive"));
      }
    });

    extract.on("error", (err) => {
      if (!extractionFinished) reject(err);
    });

    readStream.on("error", (err) => {
      if (!extractionFinished) reject(err);
    });

    readStream.pipe(extract);
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

  let inputStream: Readable;
  let fileToDelete: any = null;

  try {
    // Create a readable stream from either storage or base64 data
    if (storagePath) {
      logger.info(`Streaming tar from storage path: ${storagePath}`);
      const file = bucket.file(storagePath);
      inputStream = file.createReadStream();
      fileToDelete = file;
    } else if (base64Data) {
      logger.info("Creating stream from base64 data");
      // Convert base64 to a readable stream without loading entire buffer into memory
      const buffer = Buffer.from(base64Data, "base64");
      inputStream = Readable.from(buffer);
    } else {
      throw new HttpsError("invalid-argument", "Either base64Data or storagePath must be provided");
    }

    // Stream and process the tar file, uploading photos as we go
    // This will throw an HttpsError with code 'invalid-argument' if the archive contains unexpected files.
    const { eventsContent, photoCount } = await streamAndProcessTar(inputStream, appName, newSiteId, bucket);

    logger.info(`Streamed and processed tar file: ${photoCount} photos uploaded`);

    // Make sure the last event is an export event for the expected app.
    const eventLines = eventsContent.split("\n").filter((line: string) => line);
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

    // Note: Archive append is skipped for streaming imports to avoid keeping all file buffers in memory.
    // The archive will be rebuilt during the next scheduled cleanupArchives run if needed.
    logger.info("Skipping archive append for streaming import (will be rebuilt by cleanupArchives if needed)");

    // Import all events
    const writeBatch = admin.firestore().batch();
    const siteEventsCollection = admin
      .firestore()
      .collection(firebaseSiteEventsPath(appName, newSiteId));

    const membersMap = new Map<string, { memberId: string, name: string, admin: boolean }>();
    for (const line of eventLines) {
      const eventRecord = SiteEventRecord.decode(Buffer.from(line, "base64"));
      const docRef = siteEventsCollection.doc(eventRecord.version.toString());
      if (!eventRecord.siteEvent) {
        throw new HttpsError("invalid-argument", "Site event is missing in import data.");
      }

      writeBatch.set(docRef, {
        [fbPayload]: Buffer.from(
          SiteEvent.encode(eventRecord.siteEvent).finish()
        ).toString("base64"),
        [fbTimeStamp]: Timestamp.fromDate(new Date(eventRecord.isoDate)),
        [fbVersion]: eventRecord.version,
      });

      // Identify active members by replaying site events
      if (eventRecord.siteEvent.newSite) {
        membersMap.set(String(eventRecord.version), {
          memberId: String(eventRecord.version),
          name: eventRecord.siteEvent.newSite.memberName,
          admin: true,
        });
      } else if (eventRecord.siteEvent.addMember) {
        membersMap.set(String(eventRecord.version), {
          memberId: String(eventRecord.version),
          name: eventRecord.siteEvent.addMember.memberName,
          admin: eventRecord.siteEvent.addMember.admin,
        });
      } else if (eventRecord.siteEvent.updateMember) {
        const id = String(eventRecord.siteEvent.updateMember.memberId);
        const member = membersMap.get(id);
        if (member) {
          member.name = eventRecord.siteEvent.updateMember.memberName;
          member.admin = eventRecord.siteEvent.updateMember.admin;
        }
      } else if (eventRecord.siteEvent.removeMember) {
        membersMap.delete(String(eventRecord.siteEvent.removeMember.memberId));
      } else if (eventRecord.siteEvent.leaveSite) {
        membersMap.delete(String(eventRecord.siteEvent.leaveSite.memberId));
      } else if (eventRecord.siteEvent.restoreMember) {
        membersMap.set(String(eventRecord.siteEvent.restoreMember.memberId), {
          memberId: String(eventRecord.siteEvent.restoreMember.memberId),
          name: eventRecord.siteEvent.restoreMember.memberName,
          admin: eventRecord.siteEvent.restoreMember.admin,
        });
      } else if (eventRecord.siteEvent.importEvent) {
        const authorId = String(eventRecord.siteEvent.author);
        for (const [id] of membersMap) {
          if (id !== authorId) {
            membersMap.delete(id);
          }
        }
      }
    }

    const adminMembers = Array.from(membersMap.values())
      .filter((m) => m.admin)
      .map((m) => ({ memberId: m.memberId, name: m.name }));

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

  // 6. Copy storage items
  const oldStoragePrefix = firebaseFilesPath(appName, oldSiteId, "");

  const query: any = { prefix: oldStoragePrefix, autoPaginate: false };
  let pageToken: string | undefined;

  do {
    if (pageToken) {
      query.pageToken = pageToken;
    }

    const [files, nextQuery] = await bucket.getFiles(query);
    const copyPromises = [];

    for (const file of files) {
      const relativePath = file.name.substring(oldStoragePrefix.length);
      const newPath = firebaseFilesPath(appName, newSiteId, relativePath);
      copyPromises.push(file.copy(bucket.file(newPath)));
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
