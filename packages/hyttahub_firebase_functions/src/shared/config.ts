/**
 * Optional configuration for the archive storage bucket.
 * Consuming apps call setArchiveBucketName() in their index.ts
 * to enable file archiving to a separate GCS bucket.
 */

let archiveBucketName: string | undefined;

export const setArchiveBucketName = (name: string) => {
  archiveBucketName = name;
};

export const getArchiveBucketName = (): string | undefined => archiveBucketName;
