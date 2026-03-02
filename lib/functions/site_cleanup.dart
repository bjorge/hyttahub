// Copyright (c) 2025 bjorge

import 'package:flutter/foundation.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/storage/hyttahub_internal_storage_factory.dart';
import 'package:hyttahub/storage/in_memory_hyttahub_storage.dart';

/// Cleans up an orphaned site (one with no remaining members).
/// This is used by the in-memory and local storage modes to perform
/// the equivalent of the Firebase cleanup cron job immediately.
///
/// This is NOT part of the public storage interface.
Future<void> cleanUpOrphanedSite({
  required InMemoryHyttaHubStorage storage,
  required String siteId,
}) async {
  if (kDebugMode) {
    print('cleanUpOrphanedSite: Cleaning up site $siteId');
  }

  // 1. Delete site_events collection
  await storage.deleteCollection(firebaseSiteEventsPath(siteId));

  // 2. Delete site_users collection (should already be empty, but be thorough)
  await storage.deleteCollection(firebaseSiteUsersPath(siteId));

  // 3. Delete active files for this site
  final filesPrefix = firebaseFilesPath(siteId, '');
  final files = await storage.listFiles(filesPrefix);
  if (files.isNotEmpty) {
    final internalStorage =
        HyttaHubInternalStorageFactory.getInternalStorage(storage.storageType);
    for (final filePath in files) {
      await internalStorage.deleteFile(filePath);
    }
  }

  // 4. Delete archive files for this site
  final archivePrefix = firebaseArchiveFilePath(siteId, '');
  final archiveFiles = await storage.listFiles(archivePrefix);
  if (archiveFiles.isNotEmpty) {
    final internalStorage =
        HyttaHubInternalStorageFactory.getInternalStorage(storage.storageType);
    for (final filePath in archiveFiles) {
      await internalStorage.deleteFile(filePath);
    }
  }

  if (kDebugMode) {
    print('cleanUpOrphanedSite: Site $siteId fully cleaned up');
  }
}
