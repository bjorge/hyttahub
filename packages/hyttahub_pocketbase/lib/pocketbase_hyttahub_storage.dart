// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;
import 'package:hyttahub/storage/base_hyttahub_storage.dart';
import 'package:hyttahub/collection_paths.dart';

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
      final results = await _client
          .collection(col)
          .getFullList(filter: 'doc_id = "${_esc(docId)}"');
      return results.isEmpty ? null : results.first;
    } on ClientException catch (e) {
      if (_isCollectionNotFound(e)) {
        if (kDebugMode) {
          print('[PB] _findRecord col=$col not found (${e.statusCode})');
        }
        return null;
      }
      rethrow;
    }
  }

  /// Minimal escaping for PocketBase filter string values.
  /// Escapes backslashes and double-quotes to prevent injection.
  String _esc(String value) =>
      value.replaceAll(r'\', r'\\').replaceAll('"', r'\"');

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
      final records = await _client
          .collection(encodePath(path))
          .getFullList(sort: sort);
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
    if (kDebugMode) {
      print('[PB] setDocument path=$path col=$col docId=$docId data=$data');
    }
    final existing = await _findRecord(col, docId);
    try {
      if (existing != null) {
        if (kDebugMode) print('[PB] setDocument → update id=${existing.id}');
        await _client.collection(col).update(existing.id, body: data);
      } else {
        if (kDebugMode) print('[PB] setDocument → create');
        await _client.collection(col).create(body: {'doc_id': docId, ...data});
      }
      if (kDebugMode) print('[PB] setDocument ✓ col=$col docId=$docId');
    } on ClientException catch (e) {
      if (kDebugMode) {
        print(
          '[PB] setDocument ✗ col=$col docId=$docId status=${e.statusCode} msg=${e.response}',
        );
      }
      rethrow;
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
      if (_isCollectionNotFound(e)) {
        return; // collection doesn't exist — nothing to delete
      }
      rethrow;
    }
  }

  // ── Real-time ────────────────────────────────────────────────────────────

  @override
  Stream<Map<String, Map<String, dynamic>>> listenCollection(String path) {
    final col = encodePath(path);
    final controller = StreamController<Map<String, Map<String, dynamic>>>();
    Map<String, Map<String, dynamic>> currentData = {};
    // Holds the per-subscription unsubscribe function returned by PocketBase.
    // Using this instead of unsubscribe('*') avoids cancelling other blocs'
    // subscriptions on the same collection.
    Future<void> Function()? unsubscribeFn;

    Future<void> setup() async {
      while (!controller.isClosed) {
        try {
          final initial = await getCollection(path);
          currentData = _toDocIdMap(initial);
          if (!controller.isClosed) controller.add(Map.from(currentData));

          if (kDebugMode) {
            print('[PB] listenCollection subscribe col=$col');
          }

          unsubscribeFn = await _client.collection(col).subscribe('*', (event) async {
            if (controller.isClosed) return;
            if (kDebugMode) {
              print(
                '[PB] listenCollection SSE event col=$col action=${event.action}',
              );
            }
            final record = event.record;
            if (record != null) {
              final doc = record.toJson();
              final docId = (doc['doc_id'] ?? doc['id']) as String?;
              if (docId != null) {
                if (event.action == 'create' || event.action == 'update') {
                  currentData[docId] = doc;
                } else if (event.action == 'delete') {
                  currentData.remove(docId);
                }
                controller.add(Map.from(currentData));
                return;
              }
            }

            // Fallback to full fetch if record data is missing or invalid
            final updated = await getCollection(path);
            currentData = _toDocIdMap(updated);
            controller.add(Map.from(currentData));
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
      if (kDebugMode) {
        print('[PB] listenCollection cancel col=$col — calling per-subscription unsubscribe');
      }
      try {
        // Use the per-subscription unsubscribe to avoid removing other
        // subscribers on the same collection (e.g. the main AppReplayBloc).
        await unsubscribeFn?.call();
      } catch (_) {
        // Ignore unsubscribe errors for collections that were never subscribed.
      }
    };
    return controller.stream;
  }

  /// Converts a list of records into a map keyed by `doc_id`
  /// (falling back to the PocketBase `id` if `doc_id` is absent).
  Map<String, Map<String, dynamic>> _toDocIdMap(
    List<Map<String, dynamic>> docs,
  ) {
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
    // Per-subscription unsubscribe handle — prevents cancelling other blocs'
    // subscriptions on the same collection when this stream is cancelled.
    Future<void> Function()? unsubscribeFn;

    Future<void> setup() async {
      while (!controller.isClosed) {
        try {
          final initial = await getCollection(path);
          final seed = _buildEventMap(
            initial,
            lastVersion,
            versionField,
            payloadField,
          );
          if (kDebugMode) {
            print(
              '[PB] listenEvents col=$col seed=${seed.keys.toList()} lastVersion=$lastVersion',
            );
          }
          if (seed.isNotEmpty && !controller.isClosed) controller.add(seed);

          if (kDebugMode) {
            print('[PB] listenEvents subscribe col=$col');
          }

          unsubscribeFn = await _client.collection(col).subscribe('*', (event) async {
            if (controller.isClosed) return;
            if (kDebugMode) {
              print('[PB] listenEvents SSE event col=$col action=${event.action}');
            }

            final record = event.record;
            if (record != null) {
              final doc = record.toJson();
              try {
                final version = (doc[versionField] as num).toInt();
                final payload = doc[payloadField] as String;
                if (version > lastVersion) {
                  if (kDebugMode) {
                    print(
                      '[PB] listenEvents incremental update col=$col version=$version',
                    );
                  }
                  controller.add({version: payload});
                  return;
                }
              } catch (_) {
                // Ignore malformed record data
              }
            }

            // Fallback to full fetch if incremental update is insufficient
            final all = await getCollection(path);
            // Use the original lastVersion (not an internal watermark) to ensure
            // that delayed events (gaps) are eventually caught if they appear
            // in a later fetch. BaseReplayBloc will handle the deduplication.
            final events = _buildEventMap(
              all,
              lastVersion,
              versionField,
              payloadField,
            );
            if (kDebugMode) {
              print(
                '[PB] listenEvents fallback update col=$col newEvents=${events.keys.toList()}',
              );
            }
            if (events.isNotEmpty) {
              controller.add(events);
            }
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
      if (kDebugMode) {
        print('[PB] listenEvents cancel col=$col — calling per-subscription unsubscribe');
      }
      try {
        // Use the per-subscription unsubscribe to avoid removing other
        // subscribers on the same collection (e.g. the summary AppNameReplayBloc).
        await unsubscribeFn?.call();
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
  Future<void> runBatch(
    Future<void> Function(HyttaHubBatch batch) action,
  ) async {
    final batch = PocketbaseHyttaHubBatch(this);
    await action(batch);
    await batch.executeAll();
  }

  // ── File operations ───────────────────────────────────────────────────────
  //
  // Files are stored in a dedicated `__site_files` PocketBase collection.
  // Each file is one record: doc_id = fileName,  file = binary attachment.
  // The collection is auto-created by the Go emulator middleware.
  //
  // PocketBase file URLs are public (no auth needed to view) — matching the
  // design decision to use public read / member-only write.

  /// Returns the encoded collection name for the site files collection.
  String _filesCol(String appName, String siteId) =>
      encodePath(collectionSiteFilesPath(siteId, cloudRoot: appName));

  /// Returns the PocketBase file field name used in the site_files collection.
  static const String _fileField = 'file';

  @override
  Future<void> uploadFile({
    required String appName,
    required String siteId,
    required String fileName,
    required String base64Data,
  }) async {
    final col = _filesCol(appName, siteId);

    // Decode base64 → raw bytes.
    final bytes = base64Decode(base64Data);

    // If a record already exists for this fileName, delete it first so we
    // can replace the file attachment (PocketBase file fields can't be
    // patched with a fresh file via update in a simple way).
    final existing = await _findRecord(col, fileName);
    if (existing != null) {
      await _client.collection(col).delete(existing.id);
    }

    // Upload via multipart form.
    await _client
        .collection(col)
        .create(
          body: {'doc_id': fileName},
          files: [
            http.MultipartFile.fromBytes(_fileField, bytes, filename: fileName),
          ],
        );
  }

  @override
  Future<Uint8List> getFileBytes({
    required String appName,
    required String siteId,
    required String fileName,
  }) async {
    final url = await getFileUrl(
      appName: appName,
      siteId: siteId,
      fileName: fileName,
    );
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) return response.bodyBytes;
    throw Exception(
      'Failed to download file "$fileName": HTTP ${response.statusCode}',
    );
  }

  @override
  Future<String> getFileUrl({
    required String appName,
    required String siteId,
    required String fileName,
    int? expirationDays, // Not supported by PocketBase — ignored for now.
  }) async {
    final col = _filesCol(appName, siteId);
    final record = await _findRecord(col, fileName);
    if (record == null) throw Exception('File not found: $fileName');

    // PocketBase file URL: {baseUrl}/api/files/{collectionId}/{recordId}/{filename}
    // The attachment filename stored by PocketBase may have a random suffix
    // appended for uniqueness — use the value from the file field.
    final storedFiles = record.getListValue<String>(_fileField);
    if (storedFiles.isEmpty) {
      throw Exception('File field empty for record: $fileName');
    }
    final storedName = storedFiles.first;

    return _client.files.getUrl(record, storedName).toString();
  }

  @override
  Future<void> deleteFiles({
    required String appName,
    required String siteId,
    required List<String> fileNames,
  }) async {
    final col = _filesCol(appName, siteId);
    for (final fileName in fileNames) {
      final record = await _findRecord(col, fileName);
      if (record != null) {
        await _client.collection(col).delete(record.id);
      }
    }
  }

  @override
  Future<List<String>> listFiles(String prefix) async {
    // prefix is expected to be "appName/siteId" — derive the collection name
    // using the same hyttahub/{appName}/sites/{siteId}/site_files pattern.
    final segments = prefix.split('/').where((s) => s.isNotEmpty).toList();
    final appName = segments.isNotEmpty ? segments.first : '';
    final siteId = segments.length > 1 ? segments[1] : '';
    
    final col = _filesCol(appName, siteId);
    try {
      final records = await _client.collection(col).getFullList();
      return records
          .map((r) => r.getStringValue('doc_id'))
          .where((id) => id.isNotEmpty)
          .toList();
    } on ClientException catch (e) {
      if (_isCollectionNotFound(e)) return [];
      rethrow;
    }
  }
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
        await _storage._client
            .collection(col)
            .create(body: {'doc_id': docId, ...data});
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
