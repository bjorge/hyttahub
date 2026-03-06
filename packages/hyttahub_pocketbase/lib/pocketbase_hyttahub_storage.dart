// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:typed_data';

import 'package:pocketbase/pocketbase.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';

/// Encodes a hyttahub path string into a valid PocketBase collection name.
///
/// PocketBase collection names must match `[a-zA-Z0-9_]+`. The hyttahub
/// framework uses slash-separated paths, so slashes are replaced with `__`.
///
/// Example:
///   `hyttahub/tictactoe/sites/abc/site_events`
///   → `hyttahub__tictactoe__sites__abc__site_events`
String encodePath(String path) => path.replaceAll('/', '__');

/// A [BaseHyttaHubStorage] implementation backed by PocketBase.
///
/// **ID mapping**: PocketBase requires record IDs to be exactly 15 alphanumeric
/// characters. HyttaHub uses arbitrary strings (emails, version numbers) as
/// document IDs. This class stores the application-level ID in a `doc_id` text
/// field and looks up records by filter rather than by PocketBase primary key.
///
/// **Path encoding**: The `path` argument (slash-separated) is encoded into a
/// valid collection name via [encodePath] (`/` → `__`).
///
/// **Real-time**: [listenCollection] and [listenEvents] use PocketBase SSE.
///
/// **Batching**: No native batch API — operations run sequentially.
///
/// **File operations** throw [UnimplementedError]. Extend this class to add them.
class PocketbaseHyttaHubStorage implements BaseHyttaHubStorage {
  PocketbaseHyttaHubStorage({required PocketBase client}) : _client = client;

  final PocketBase _client;

  // ── Internal helpers ─────────────────────────────────────────────────────

  /// Finds the PocketBase record for a given application [docId].
  /// Returns `null` if no record with `doc_id = docId` exists.
  Future<RecordModel?> _findRecord(String col, String docId) async {
    try {
      final results = await _client.collection(col).getFullList(
        filter: 'doc_id = "${_esc(docId)}"',
      );
      return results.isEmpty ? null : results.first;
    } on ClientException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  /// Minimal escaping for PocketBase filter string values.
  /// Escapes backslashes and double-quotes to prevent injection.
  String _esc(String value) => value.replaceAll(r'\', r'\\').replaceAll('"', r'\"');

  // ── Document access ──────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>?> getDocument(String path, String docId) async {
    final record = await _findRecord(encodePath(path), docId);
    return record?.toJson();
  }

  @override
  Future<List<Map<String, dynamic>>> getCollection(
    String path, {
    String? orderBy,
    bool descending = false,
  }) async {
    final sort = orderBy != null ? '${descending ? '-' : '+'}$orderBy' : null;
    try {
      final records = await _client.collection(encodePath(path)).getFullList(
        sort: sort,
      );
      return records.map((r) => r.toJson()).toList();
    } on ClientException catch (e) {
      if (e.statusCode == 404) return [];
      rethrow;
    }
  }

  @override
  Future<void> setDocument(
    String path,
    String docId,
    Map<String, dynamic> data,
  ) async {
    final col = encodePath(path);
    final existing = await _findRecord(col, docId);
    if (existing != null) {
      await _client.collection(col).update(existing.id, body: data);
    } else {
      await _client.collection(col).create(body: {'doc_id': docId, ...data});
    }
  }

  @override
  Future<void> updateDocument(
    String path,
    String docId,
    Map<String, dynamic> data,
  ) async {
    final col = encodePath(path);
    final existing = await _findRecord(col, docId);
    if (existing == null) {
      throw Exception('Document not found: $path/$docId');
    }
    await _client.collection(col).update(existing.id, body: data);
  }

  @override
  Future<void> deleteCollection(String path) async {
    final col = encodePath(path);
    try {
      final records = await _client.collection(col).getFullList();
      for (final record in records) {
        await _client.collection(col).delete(record.id);
      }
    } on ClientException catch (e) {
      if (e.statusCode == 404) return; // collection doesn't exist — nothing to delete
      rethrow;
    }
  }

  // ── Real-time ────────────────────────────────────────────────────────────

  @override
  Stream<Map<String, Map<String, dynamic>>> listenCollection(String path) {
    final col = encodePath(path);
    final controller = StreamController<Map<String, Map<String, dynamic>>>();

    Future<void> setup() async {
      final initial = await getCollection(path);
      final map = _toDocIdMap(initial);
      if (!controller.isClosed) controller.add(map);

      await _client.collection(col).subscribe('*', (event) async {
        if (controller.isClosed) return;
        final updated = await getCollection(path);
        controller.add(_toDocIdMap(updated));
      });
    }

    setup().catchError(controller.addError);
    controller.onCancel = () async {
      await _client.collection(col).unsubscribe('*');
    };
    return controller.stream;
  }

  /// Converts a list of records into a map keyed by `doc_id`
  /// (falling back to the PocketBase `id` if `doc_id` is absent).
  Map<String, Map<String, dynamic>> _toDocIdMap(List<Map<String, dynamic>> docs) {
    return {
      for (final doc in docs)
        if ((doc['doc_id'] ?? doc['id']) != null)
          (doc['doc_id'] ?? doc['id']) as String: doc,
    };
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
        final version = (doc[versionField] as num).toInt();
        final payload = doc[payloadField] as String;
        if (version > lastVersion) events[version] = payload;
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
  bool isPermissionDenied(Object error) =>
      error is ClientException && error.statusCode == 403;

  @override
  Future<void> runBatch(Future<void> Function(HyttaHubBatch batch) action) async {
    final batch = PocketbaseHyttaHubBatch(_client);
    await action(batch);
    await batch.executeAll();
  }

  // ── File operations (not implemented) ────────────────────────────────────

  @override
  Future<void> uploadFile({
    required String appName,
    required String siteId,
    required String fileName,
    required String base64Data,
  }) =>
      throw UnimplementedError(
        'uploadFile: extend PocketbaseHyttaHubStorage and implement '
        'file uploads using your PocketBase file collection schema.',
      );

  @override
  Future<Uint8List> getFileBytes({
    required String appName,
    required String siteId,
    required String fileName,
  }) =>
      throw UnimplementedError(
        'getFileBytes: extend PocketbaseHyttaHubStorage and implement '
        'file downloads using your PocketBase file collection schema.',
      );

  @override
  Future<void> deleteFiles({
    required String appName,
    required String siteId,
    required List<String> fileNames,
  }) =>
      throw UnimplementedError(
        'deleteFiles: extend PocketbaseHyttaHubStorage and implement '
        'file deletion using your PocketBase file collection schema.',
      );

  @override
  Future<String> getFileUrl({
    required String appName,
    required String siteId,
    required String fileName,
    int? expirationDays,
  }) =>
      throw UnimplementedError(
        'getFileUrl: extend PocketbaseHyttaHubStorage and implement '
        'URL generation using your PocketBase file collection schema.',
      );

  @override
  Future<List<String>> listFiles(String prefix) =>
      throw UnimplementedError(
        'listFiles: extend PocketbaseHyttaHubStorage and implement '
        'file listing using your PocketBase file collection schema.',
      );
}

/// A [HyttaHubBatch] implementation for PocketBase.
///
/// Operations are accumulated and executed sequentially by [executeAll].
class PocketbaseHyttaHubBatch implements HyttaHubBatch {
  PocketbaseHyttaHubBatch(this._client);

  final PocketBase _client;
  final List<Future<void> Function()> _operations = [];

  String _esc(String value) => value.replaceAll(r'\', r'\\').replaceAll('"', r'\"');

  @override
  void setDocument(String path, String docId, Map<String, dynamic> data) {
    final col = encodePath(path);
    _operations.add(() async {
      final existing = await _client.collection(col).getFullList(
        filter: 'doc_id = "${_esc(docId)}"',
      );
      if (existing.isNotEmpty) {
        await _client.collection(col).update(existing.first.id, body: data);
      } else {
        await _client.collection(col).create(body: {'doc_id': docId, ...data});
      }
    });
  }

  @override
  void updateDocument(String path, String docId, Map<String, dynamic> data) {
    final col = encodePath(path);
    _operations.add(() async {
      final existing = await _client.collection(col).getFullList(
        filter: 'doc_id = "${_esc(docId)}"',
      );
      if (existing.isEmpty) {
        throw Exception('Document not found for updateDocument: $path/$docId');
      }
      await _client.collection(col).update(existing.first.id, body: data);
    });
  }

  @override
  void commit() {
    // No-op: synchronous interface contract. Callers use [executeAll].
  }

  /// Executes all queued operations sequentially.
  Future<void> executeAll() async {
    for (final op in _operations) {
      await op();
    }
    _operations.clear();
  }
}
