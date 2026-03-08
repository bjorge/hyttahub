// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:pocketbase/pocketbase.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';

/// Returns true if [s] is already a valid PocketBase collection name segment
/// (only letters, digits, underscores — no encoding needed).
bool _isSafeSegment(String s) => RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(s);

/// Encodes a single path segment into a valid PocketBase identifier.
///
/// Safe segments (e.g. `hyttahub`, `site_events`) are returned unchanged.
/// Others (e.g. email addresses like `user@example.com`) are base64url-encoded
/// (RFC 4648 §5), with `=` padding stripped and `-` replaced by `_`. An `e`
/// prefix is added to mark encoded segments and guarantee a letter start.
String _encodeSegment(String segment) {
  if (_isSafeSegment(segment)) return segment;
  final b64 = base64Url
      .encode(utf8.encode(segment))
      .replaceAll('=', '')
      .replaceAll('-', '_');
  return 'e$b64';
}

/// Encodes a hyttahub path into a valid PocketBase collection name.
///
/// Splits on `/` and encodes each segment with [_encodeSegment]. Safe segments
/// pass through unchanged; segments with special chars (emails, etc.) are
/// base64url-encoded. Segments are joined with `__`.
///
/// Example:
///   `hyttahub/tictactoe/accounts/user@example.com/account_events`
///   → `hyttahub__tictactoe__accounts__edXNlckBleGFtcGxlLmNvbQ__account_events`
String encodePath(String path) =>
    path.split('/').map(_encodeSegment).join('__');


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

  /// Returns true when the PocketBase error indicates a collection does not
  /// exist. PocketBase returns 400 "Missing collection context" (not 404) when
  /// a collection name is valid but the table hasn't been created yet. We also
  /// treat a plain 404 as missing, which covers deleted/typo'd names.
  bool _isCollectionNotFound(ClientException e) {
    if (e.statusCode == 404) return true;
    if (e.statusCode == 400) {
      final msg = (e.response['message'] as String? ?? '').toLowerCase();
      return msg.contains('missing collection') || 
             msg.contains('collection context') ||
             msg.contains('missing or invalid collection context');
    }
    return false;
  }

  /// Finds the PocketBase record for a given application [docId].
  /// Returns `null` if no record with `doc_id = docId` exists, or if the
  /// collection itself does not exist yet.
  Future<RecordModel?> _findRecord(String col, String docId) async {
    try {
      final results = await _client.collection(col).getFullList(
        filter: 'doc_id = "${_esc(docId)}"',
      );
      return results.isEmpty ? null : results.first;
    } on ClientException catch (e) {
      if (_isCollectionNotFound(e)) return null;
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
      if (_isCollectionNotFound(e)) return [];
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
      if (_isCollectionNotFound(e)) return; // collection doesn't exist — nothing to delete
      rethrow;
    }
  }

  // ── Real-time ────────────────────────────────────────────────────────────

  @override
  Stream<Map<String, Map<String, dynamic>>> listenCollection(String path) {
    final col = encodePath(path);
    final controller = StreamController<Map<String, Map<String, dynamic>>>();

    Future<void> setup() async {
      while (!controller.isClosed) {
        try {
          final initial = await getCollection(path);
          final map = _toDocIdMap(initial);
          if (!controller.isClosed) controller.add(map);

          await _client.collection(col).subscribe('*', (event) async {
            if (controller.isClosed) return;
            final updated = await getCollection(path);
            controller.add(_toDocIdMap(updated));
          });
          
          // Successfully subscribed, break out of the retry loop
          break;
        } on ClientException catch (e) {
          if (_isCollectionNotFound(e)) {
            // Collection does not exist yet. Wait a bit and retry.
            // The collection will be created on the first write.
            await Future.delayed(const Duration(milliseconds: 500));
            continue;
          }
          rethrow;
        }
      }
    }

    setup().catchError(controller.addError);
    controller.onCancel = () async {
      try {
        await _client.collection(col).unsubscribe('*');
      } catch (_) {
        // Ignore unsubscribe errors for collections that were never subscribed.
      }
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
      while (!controller.isClosed) {
        try {
          final initial = await getCollection(path);
          final seed = _buildEventMap(initial, lastVersion, versionField, payloadField);
          if (seed.isNotEmpty && !controller.isClosed) controller.add(seed);

          await _client.collection(col).subscribe('*', (event) async {
            if (controller.isClosed) return;
            final all = await getCollection(path);
            final events = _buildEventMap(all, lastVersion, versionField, payloadField);
            if (events.isNotEmpty) controller.add(events);
          });
          
          // Successfully subscribed, break out of the retry loop
          break;
        } on ClientException catch (e) {
          if (_isCollectionNotFound(e)) {
            // Collection does not exist yet. Wait a bit and retry.
            // The collection is created on the first write.
            await Future.delayed(const Duration(milliseconds: 500));
            continue;
          }
          rethrow;
        }
      }
    }

    setup().catchError(controller.addError);
    controller.onCancel = () async {
      try {
        await _client.collection(col).unsubscribe('*');
      } catch (_) {
        // Ignore unsubscribe errors for collections that were never subscribed.
      }
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
    final batch = PocketbaseHyttaHubBatch(this);
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
  PocketbaseHyttaHubBatch(this._storage);

  final PocketbaseHyttaHubStorage _storage;
  final List<Future<void> Function()> _operations = [];


  @override
  void setDocument(String path, String docId, Map<String, dynamic> data) {
    final col = encodePath(path);
    _operations.add(() async {
      final existing = await _storage._findRecord(col, docId);
      if (existing != null) {
        await _storage._client.collection(col).update(existing.id, body: data);
      } else {
        await _storage._client.collection(col).create(body: {'doc_id': docId, ...data});
      }
    });
  }

  @override
  void updateDocument(String path, String docId, Map<String, dynamic> data) {
    final col = encodePath(path);
    _operations.add(() async {
      final existing = await _storage._findRecord(col, docId);
      if (existing == null) {
        throw Exception('Document not found for updateDocument: $path/$docId');
      }
      await _storage._client.collection(col).update(existing.id, body: data);
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
