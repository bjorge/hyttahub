import * as logger from "firebase-functions/logger";


import { HttpsError } from "firebase-functions/v2/https";

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



