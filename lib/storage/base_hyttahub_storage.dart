// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:typed_data';

/// Restricts a collection read to records whose [field] is greater than
/// [version].
///
/// Applied by the backend where it can be, so an event log that has grown to
/// thousands of records is not transferred in full just to find the handful
/// that are new.
class VersionFilter {
  const VersionFilter({required this.field, required this.version});

  final String field;
  final int version;
}

abstract class BaseHyttaHubStorage {
  Future<Map<String, dynamic>?> getDocument(String path, String docId);

  /// Reads a collection.
  ///
  /// [newerThan] restricts the read to records above a version. Backends
  /// apply it server-side where they can, and callers must still tolerate a
  /// backend that does not — filter the result as well rather than assuming
  /// it has been narrowed.
  ///
  /// Note for query-planner backends: combining [newerThan] with an [orderBy]
  /// on a *different* field may be rejected (Firestore requires the first
  /// ordering to match the inequality field).
  Future<List<Map<String, dynamic>>> getCollection(
    String path, {
    String? orderBy,
    bool descending = false,
    int? limit,
    List<String>? fields,
    VersionFilter? newerThan,
  });
  Future<void> setDocument(String path, String docId, Map<String, dynamic> data);
  Future<void> updateDocument(String path, String docId, Map<String, dynamic> data);

  Stream<Map<String, Map<String, dynamic>>> listenCollection(String path);

  /// Streams events newer than the caller's current version.
  ///
  /// [lastVersion] is read whenever the stream needs to seed or re-seed —
  /// on first listen and after every reconnect — so the caller stays the
  /// single source of truth for how far it has actually got. An
  /// implementation must not cache its own copy: a version the caller has
  /// not processed yet has to be re-delivered, not assumed delivered.
  Stream<Map<int, String>> listenEvents(
    String path, {
    required int Function() lastVersion,
    required String versionField,
    required String payloadField,
  });

  /// Re-establishes the realtime transport, re-seeding every active
  /// [listenCollection] and [listenEvents] stream on this backend.
  ///
  /// Callers invoke this when they have evidence the stream has gone stale —
  /// typically events that exist in storage but never arrived. Backends whose
  /// realtime layer heals itself implement this as a no-op.
  Future<void> reconnectRealtime();

  dynamic get serverTimestamp;
  bool isPermissionDenied(Object error);

  Future<void> runBatch(Future<void> Function(HyttaHubBatch batch) action);

  Future<void> uploadFile({
    required String appName,
    required String siteId,
    required String fileName,
    required String base64Data,
  });

  Future<Uint8List> getFileBytes({
    required String appName,
    required String siteId,
    required String fileName,
  });

  Future<void> deleteFiles({
    required String appName,
    required String siteId,
    required List<String> fileNames,
  });

  Future<String> getFileUrl({
    required String appName,
    required String siteId,
    required String fileName,
    int? expirationDays,
  });
  Future<List<String>> listFiles(String prefix);

  Future<void> deleteCollection(String path);
}

abstract class HyttaHubBatch {
  void setDocument(String path, String docId, Map<String, dynamic> data);
  void updateDocument(String path, String docId, Map<String, dynamic> data);
  void commit();
}
