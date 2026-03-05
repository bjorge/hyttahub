// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:typed_data';

import 'package:pocketbase/pocketbase.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';

/// Encodes a hyttahub path string into a valid PocketBase collection name.
///
/// PocketBase collection names must match `[a-zA-Z0-9_]+` and cannot start
/// with a digit. The hyttahub framework uses slash-separated paths like
/// `hyttahub/tictactoe/sites/<siteId>/site_events`, so slashes are replaced
/// with double-underscores (`__`).
///
/// Example:
///   `hyttahub/tictactoe/sites/abc/site_events`
///   → `hyttahub__tictactoe__sites__abc__site_events`
String encodePath(String path) => path.replaceAll('/', '__');

/// A [BaseHyttaHubStorage] implementation backed by PocketBase.
///
/// PocketBase collections are used as the document store. The hyttahub `path`
/// argument (a slash-separated string) is automatically encoded into a valid
/// PocketBase collection name using [encodePath] (`/` → `__`).
///
/// **Real-time**: [listenCollection] and [listenEvents] use PocketBase's
/// Server-Sent Events (SSE) subscription API.
///
/// **Batching**: PocketBase has no native batch/transaction API. [runBatch]
/// executes operations sequentially.
///
/// **Server timestamp**: [serverTimestamp] returns `'@now'`, which PocketBase
/// accepts as a placeholder on write.
///
/// **File operations** (uploadFile, getFileBytes, deleteFiles, getFileUrl,
/// listFiles) throw [UnimplementedError]. Extend this class to implement them.
class PocketbaseHyttaHubStorage implements BaseHyttaHubStorage {
  PocketbaseHyttaHubStorage({required PocketBase client}) : _client = client;

  final PocketBase _client;

  // ── Document access ──────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>?> getDocument(String path, String docId) async {
    try {
      final record = await _client.collection(encodePath(path)).getOne(docId);
      return record.toJson();
    } on ClientException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCollection(
    String path, {
    String? orderBy,
    bool descending = false,
  }) async {
    final sort =
        orderBy != null ? '${descending ? '-' : '+'}$orderBy' : null;
    final records = await _client.collection(encodePath(path)).getFullList(
          sort: sort,
        );
    return records.map((r) => r.toJson()).toList();
  }

  @override
  Future<void> setDocument(
    String path,
    String docId,
    Map<String, dynamic> data,
  ) async {
    final col = encodePath(path);
    try {
      // Attempt to update; fall back to create with explicit id if not found.
      await _client.collection(col).update(docId, body: data);
    } on ClientException catch (e) {
      if (e.statusCode == 404) {
        await _client.collection(col).create(body: {'id': docId, ...data});
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> updateDocument(
    String path,
    String docId,
    Map<String, dynamic> data,
  ) async {
    await _client.collection(encodePath(path)).update(docId, body: data);
  }

  @override
  Future<void> deleteCollection(String path) async {
    final col = encodePath(path);
    final records = await _client.collection(col).getFullList();
    for (final record in records) {
      await _client.collection(col).delete(record.id);
    }
  }

  // ── Real-time ────────────────────────────────────────────────────────────

  @override
  Stream<Map<String, Map<String, dynamic>>> listenCollection(String path) {
    final col = encodePath(path);
    final controller = StreamController<Map<String, Map<String, dynamic>>>();

    Future<void> setup() async {
      // Seed with the current state so the stream always emits an initial value.
      final initial = await getCollection(path);
      final map = <String, Map<String, dynamic>>{
        for (final doc in initial)
          if (doc['id'] != null) doc['id'] as String: doc,
      };
      if (!controller.isClosed) controller.add(map);

      await _client.collection(col).subscribe('*', (event) async {
        if (controller.isClosed) return;
        final updated = await getCollection(path);
        final updatedMap = <String, Map<String, dynamic>>{
          for (final doc in updated)
            if (doc['id'] != null) doc['id'] as String: doc,
        };
        controller.add(updatedMap);
      });
    }

    setup().catchError(controller.addError);
    controller.onCancel = () async {
      await _client.collection(col).unsubscribe('*');
    };
    return controller.stream;
  }

  @override
  Stream<Map<int, String>> listenEvents(
    String path, {
    required int lastVersion,
    required String versionField,
    required String payloadField,
  }) {
    final col = encodePath(path);
    final controller = StreamController<Map<int, String>>();

    Future<void> setup() async {
      final initial = await getCollection(path);
      final seed = _buildEventMap(initial, lastVersion, versionField, payloadField);
      if (seed.isNotEmpty && !controller.isClosed) controller.add(seed);

      await _client.collection(col).subscribe('*', (event) async {
        if (controller.isClosed) return;
        final all = await getCollection(path);
        final events = _buildEventMap(all, lastVersion, versionField, payloadField);
        if (events.isNotEmpty) controller.add(events);
      });
    }

    setup().catchError(controller.addError);
    controller.onCancel = () async {
      await _client.collection(col).unsubscribe('*');
    };
    return controller.stream;
  }

  Map<int, String> _buildEventMap(
    List<Map<String, dynamic>> docs,
    int lastVersion,
    String versionField,
    String payloadField,
  ) {
    final events = <int, String>{};
    for (final doc in docs) {
      try {
        final version = doc[versionField] as int;
        final payload = doc[payloadField] as String;
        if (version > lastVersion) {
          events[version] = payload;
        }
      } catch (_) {
        // Skip malformed documents.
      }
    }
    return events;
  }

  // ── Misc ─────────────────────────────────────────────────────────────────

  @override
  dynamic get serverTimestamp => '@now';

  @override
  bool isPermissionDenied(Object error) {
    return error is ClientException && error.statusCode == 403;
  }

  @override
  Future<void> runBatch(Future<void> Function(HyttaHubBatch batch) action) async {
    final batch = PocketbaseHyttaHubBatch(_client);
    await action(batch);
    await batch.executeAll();
  }

  // ── File operations (not implemented) ────────────────────────────────────
  // PocketBase file handling requires a consumer-specific collection/record
  // layout. Extend this class and override these methods as needed.

  @override
  Future<void> uploadFile({
    required String appName,
    required String siteId,
    required String fileName,
    required String base64Data,
  }) async {
    throw UnimplementedError(
      'uploadFile is not implemented for PocketbaseHyttaHubStorage. '
      'Extend this class and implement file uploads using your PocketBase '
      'file collection schema.',
    );
  }

  @override
  Future<Uint8List> getFileBytes({
    required String appName,
    required String siteId,
    required String fileName,
  }) async {
    throw UnimplementedError(
      'getFileBytes is not implemented for PocketbaseHyttaHubStorage. '
      'Extend this class and implement file downloads using your PocketBase '
      'file collection schema.',
    );
  }

  @override
  Future<void> deleteFiles({
    required String appName,
    required String siteId,
    required List<String> fileNames,
  }) async {
    throw UnimplementedError(
      'deleteFiles is not implemented for PocketbaseHyttaHubStorage. '
      'Extend this class and implement file deletion using your PocketBase '
      'file collection schema.',
    );
  }

  @override
  Future<String> getFileUrl({
    required String appName,
    required String siteId,
    required String fileName,
    int? expirationDays,
  }) async {
    throw UnimplementedError(
      'getFileUrl is not implemented for PocketbaseHyttaHubStorage. '
      'Extend this class and implement URL generation using your PocketBase '
      'file collection schema.',
    );
  }

  @override
  Future<List<String>> listFiles(String prefix) async {
    throw UnimplementedError(
      'listFiles is not implemented for PocketbaseHyttaHubStorage. '
      'Extend this class and implement file listing using your PocketBase '
      'file collection schema.',
    );
  }
}

/// A [HyttaHubBatch] implementation for PocketBase.
///
/// PocketBase has no native batch/transaction API, so operations are
/// accumulated and committed sequentially on [executeAll].
class PocketbaseHyttaHubBatch implements HyttaHubBatch {
  PocketbaseHyttaHubBatch(this._client);

  final PocketBase _client;
  final List<Future<void> Function()> _operations = [];

  @override
  void setDocument(String path, String docId, Map<String, dynamic> data) {
    final col = encodePath(path);
    _operations.add(() async {
      try {
        await _client.collection(col).update(docId, body: data);
      } on ClientException catch (e) {
        if (e.statusCode == 404) {
          await _client.collection(col).create(body: {'id': docId, ...data});
        } else {
          rethrow;
        }
      }
    });
  }

  @override
  void updateDocument(String path, String docId, Map<String, dynamic> data) {
    final col = encodePath(path);
    _operations.add(() async {
      await _client.collection(col).update(docId, body: data);
    });
  }

  @override
  void commit() {
    // No-op: the synchronous interface contract is satisfied here.
    // Callers should use [executeAll] to actually run the queued operations.
  }

  /// Executes all queued operations sequentially.
  ///
  /// Called internally by [PocketbaseHyttaHubStorage.runBatch] after the
  /// batch action completes.
  Future<void> executeAll() async {
    for (final op in _operations) {
      await op();
    }
    _operations.clear();
  }
}
