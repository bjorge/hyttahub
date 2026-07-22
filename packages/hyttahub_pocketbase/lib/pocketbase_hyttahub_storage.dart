// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;
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

/// Information extracted from a hierarchical HyttaHub collection path
/// to map it to a flat collection structure with app and parent IDs.
class PathInfo {
  final String collection;
  final String app;
  final String? siteId;
  final String? accountId;
  final String? serviceId;

  PathInfo({
    required this.collection,
    required this.app,
    this.siteId,
    this.accountId,
    this.serviceId,
  });

  /// Custom path parsers registered by consumers to handle application-specific flat collections.
  static final List<PathInfo? Function(String path)> customParsers = [];

  /// Introspects the hierarchical path and returns the mapped [PathInfo]
  /// with the appropriate flat collection name, app field, and parent IDs.
  static PathInfo parse(String path) {
    for (final parser in customParsers) {
      final info = parser(path);
      if (info != null) return info;
    }

    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    if (segments.length >= 3 && segments[0] == 'hyttahub') {
      final app = segments[1];
      if (segments.length == 3 && segments[2] == 'beta_users') {
        return PathInfo(
          collection: 'hyttahub_beta_users',
          app: app,
        );
      }
      if (segments.length == 4 && segments[2] == 'services') {
        final id = segments[3];
        return PathInfo(
          collection: 'hyttahub_beta_users',
          app: app,
          serviceId: id,
        );
      }
      if (segments.length >= 5) {
        final type = segments[2]; // 'sites', 'accounts', 'services'
        final id = segments[3];
        final sub = segments[4];

        if (type == 'sites') {
          if (sub == 'site_users') {
            return PathInfo(collection: 'hyttahub_site_users', app: app, siteId: id);
          } else if (sub == 'site_events') {
            return PathInfo(collection: 'hyttahub_site_events', app: app, siteId: id);
          } else if (sub == 'site_files') {
            return PathInfo(collection: 'hyttahub_site_files', app: app, siteId: id);
          }
        } else if (type == 'accounts' && sub == 'account_events') {
          return PathInfo(collection: 'hyttahub_account_events', app: app, accountId: id);
        } else if (type == 'services') {
          if (sub == 'service_users') {
            return PathInfo(collection: 'hyttahub_service_users', app: app, serviceId: id);
          } else if (sub == 'service_events') {
            return PathInfo(collection: 'hyttahub_service_events', app: app, serviceId: id);
          } else if (sub == 'beta_users') {
            return PathInfo(collection: 'hyttahub_beta_users', app: app, serviceId: id);
          }
        }
      }
    }
    // Fallback if the path format doesn't match standard HyttaHub schemas
    return PathInfo(
      collection: encodePath(path),
      app: segments.length > 1 ? segments[1] : 'unknown',
    );
  }

  /// Generates the PocketBase filter string restricting records to this path.
  String get filter {
    final parts = ['app = "$app"'];
    if (siteId != null) parts.add('siteId = "$siteId"');
    if (accountId != null) parts.add('accountId = "$accountId"');
    if (serviceId != null) parts.add('serviceId = "$serviceId"');
    return parts.join(' && ');
  }

  /// Returns the fields needed to be stored in the record to represent the path.
  Map<String, dynamic> get fields {
    return {
      'app': app,
      if (siteId != null) 'siteId': siteId,
      if (accountId != null) 'accountId': accountId,
      if (serviceId != null) 'serviceId': serviceId,
    };
  }
}

/// A [BaseHyttaHubStorage] implementation backed by PocketBase.
///
/// **ID mapping**: PocketBase requires record IDs to be exactly 15 alphanumeric
/// characters. HyttaHub uses arbitrary strings (emails, version numbers) as
/// document IDs. This class stores the application-level ID in a `doc_id` text
/// field and looks up records by filter rather than by PocketBase primary key.
///
/// **Path encoding**: Paths are mapped to a set of flat, static collections
/// (e.g., `hyttahub_site_events`) using [PathInfo.parse] with the dynamic parts
/// of the path extracted as separate indexed fields (e.g. `app`, `siteId`).
///
/// **Real-time**: [listenCollection] and [listenEvents] use PocketBase SSE with
/// client-side filtering matching the requested [PathInfo].
///
/// **Batching**: No native batch API — operations run sequentially.
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

  /// Finds the PocketBase record for a given [PathInfo] and application [docId].
  /// Returns `null` if no record with `doc_id = docId` exists, or if the
  /// collection itself does not exist yet.
  Future<RecordModel?> _findRecord(PathInfo info, String docId) async {
    try {
      final filter = '${info.filter} && doc_id = "${_esc(docId)}"';
      final results = await _client
          .collection(info.collection)
          .getFullList(filter: filter);
      return results.isEmpty ? null : results.first;
    } on ClientException catch (e) {
      if (_isCollectionNotFound(e)) {
        if (kDebugMode) {
          print('[PB] _findRecord col=${info.collection} not found (${e.statusCode})');
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
    final info = PathInfo.parse(path);
    final record = await _findRecord(info, docId);
    return record?.toJson();
  }

  @override
  Future<List<Map<String, dynamic>>> getCollection(
    String path, {
    String? orderBy,
    bool descending = false,
    int? limit,
    List<String>? fields,
  }) async {
    final info = PathInfo.parse(path);
    final sort = orderBy != null ? '${descending ? '-' : '+'}$orderBy' : null;
    final fieldsStr = fields != null && fields.isNotEmpty ? fields.join(',') : null;
    try {
      if (limit != null) {
        final result = await _client
            .collection(info.collection)
            .getList(
              page: 1,
              perPage: limit,
              sort: sort,
              filter: info.filter,
              fields: fieldsStr,
            );
        return result.items.map((r) => r.toJson()).toList();
      }
      final records = await _client
          .collection(info.collection)
          .getFullList(
            sort: sort,
            filter: info.filter,
            fields: fieldsStr,
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
    final info = PathInfo.parse(path);
    if (kDebugMode) {
      print('[PB] setDocument path=$path col=${info.collection} docId=$docId data=$data');
    }
    try {
      if (kDebugMode) print('[PB] setDocument → create');
      await _client.collection(info.collection).create(body: {
        'doc_id': docId,
        ...info.fields,
        ...data,
      });
      if (kDebugMode) print('[PB] setDocument ✓ col=${info.collection} docId=$docId');
    } on ClientException catch (e) {
      if (kDebugMode) {
        print(
          '[PB] setDocument ✗ col=${info.collection} docId=$docId status=${e.statusCode} msg=${e.response}',
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
    final info = PathInfo.parse(path);
    final existing = await _findRecord(info, docId);
    if (existing == null) {
      throw Exception('Document not found: $path/$docId');
    }
    await _client.collection(info.collection).update(existing.id, body: data);
  }

  @override
  Future<void> deleteCollection(String path) async {
    final info = PathInfo.parse(path);
    try {
      final records = await _client.collection(info.collection).getFullList(filter: info.filter);
      for (final record in records) {
        await _client.collection(info.collection).delete(record.id);
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
    final info = PathInfo.parse(path);
    final controller = StreamController<Map<String, Map<String, dynamic>>>();
    Map<String, Map<String, dynamic>> currentData = {};
    // Holds the per-subscription unsubscribe function returned by PocketBase.
    Future<void> Function()? unsubscribeFn;
    bool isSettingUp = false;

    Future<void> setup() async {
      if (isSettingUp) return;
      isSettingUp = true;

      // Clean up previous subscription before recreating
      try {
        await unsubscribeFn?.call();
      } catch (_) {}
      unsubscribeFn = null;

      while (!controller.isClosed) {
        try {
          final initial = await getCollection(path);
          currentData = _toDocIdMap(initial);
          if (!controller.isClosed) controller.add(Map.from(currentData));

          if (kDebugMode) {
            print('[PB] listenCollection subscribe col=${info.collection}');
          }

          final unsub = await _client.collection(info.collection).subscribe('*', (event) async {
            if (controller.isClosed) return;
            final record = event.record;
            if (record != null) {
              // Client-side filtering matching the requested PathInfo
              final recApp = record.getStringValue('app');
              if (recApp != info.app) return;
              if (info.siteId != null && record.getStringValue('siteId') != info.siteId) return;
              if (info.accountId != null && record.getStringValue('accountId') != info.accountId) return;
              if (info.serviceId != null && record.getStringValue('serviceId') != info.serviceId) return;

              if (kDebugMode) {
                print(
                  '[PB] listenCollection SSE event col=${info.collection} action=${event.action}',
                );
              }
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
          }, filter: info.filter);

          if (controller.isClosed) {
            await unsub();
            break;
          }
          unsubscribeFn = unsub;
          break;
        } catch (e) {
          if (e is ClientException) {
            if (e.statusCode == 400 || e.statusCode == 401 || e.statusCode == 403) {
              rethrow;
            }
            if (_isCollectionNotFound(e)) {
              // Collection does not exist yet. Wait a bit and retry.
              await Future.delayed(const Duration(milliseconds: 500));
              continue;
            }
          }
          if (kDebugMode) {
            print('[PB] listenCollection transient error: $e. Retrying in 2s...');
          }
          await Future.delayed(const Duration(seconds: 2));
          continue;
        }
      }
      isSettingUp = false;
    }

    setup().catchError(controller.addError);

    _StorageLifecycleObserver? observer;
    try {
      final binding = WidgetsBinding.instance;
      observer = _StorageLifecycleObserver(() {
        if (kDebugMode) {
          print('[PB] App resumed, forcing listenCollection setup for ${info.collection}');
        }
        setup();
      });
      binding.addObserver(observer);
    } catch (_) {
      // Ignored if WidgetsBinding is not initialized (e.g. in unit tests)
    }

    controller.onCancel = () async {
      if (observer != null) {
        try {
          WidgetsBinding.instance.removeObserver(observer);
        } catch (_) {}
      }
      if (kDebugMode) {
        print('[PB] listenCollection cancel col=${info.collection} — calling unsubscribe');
      }
      try {
        await unsubscribeFn?.call();
      } catch (_) {}
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
    final info = PathInfo.parse(path);
    final controller = StreamController<Map<int, String>>();
    Future<void> Function()? unsubscribeFn;
    bool isSettingUp = false;

    Future<void> setup() async {
      if (isSettingUp) return;
      isSettingUp = true;

      // Clean up previous subscription before recreating
      try {
        await unsubscribeFn?.call();
      } catch (_) {}
      unsubscribeFn = null;

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
              '[PB] listenEvents col=${info.collection} seed=${seed.keys.toList()} lastVersion=$lastVersion',
            );
          }
          if (seed.isNotEmpty && !controller.isClosed) controller.add(seed);

          if (kDebugMode) {
            print('[PB] listenEvents subscribe col=${info.collection}');
          }

          final unsub = await _client.collection(info.collection).subscribe('*', (event) async {
            if (controller.isClosed) return;

            final record = event.record;
            if (record != null) {
              // Client-side filtering matching the requested PathInfo
              final recApp = record.getStringValue('app');
              if (recApp != info.app) return;
              if (info.siteId != null && record.getStringValue('siteId') != info.siteId) return;
              if (info.accountId != null && record.getStringValue('accountId') != info.accountId) return;
              if (info.serviceId != null && record.getStringValue('serviceId') != info.serviceId) return;

              if (kDebugMode) {
                print('[PB] listenEvents SSE event col=${info.collection} action=${event.action}');
              }
              final doc = record.toJson();
              try {
                final version = (doc[versionField] as num).toInt();
                final payload = doc[payloadField] as String;
                if (version > lastVersion) {
                  if (kDebugMode) {
                    print(
                      '[PB] listenEvents incremental update col=${info.collection} version=$version',
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
            final events = _buildEventMap(
              all,
              lastVersion,
              versionField,
              payloadField,
            );
            if (kDebugMode) {
              print(
                '[PB] listenEvents fallback update col=${info.collection} newEvents=${events.keys.toList()}',
              );
            }
            if (events.isNotEmpty) {
              controller.add(events);
            }
          }, filter: info.filter);

          if (controller.isClosed) {
            await unsub();
            break;
          }
          unsubscribeFn = unsub;
          break;
        } catch (e) {
          if (e is ClientException) {
            if (e.statusCode == 400 || e.statusCode == 401 || e.statusCode == 403) {
              rethrow;
            }
            if (_isCollectionNotFound(e)) {
              await Future.delayed(const Duration(milliseconds: 500));
              continue;
            }
          }
          if (kDebugMode) {
            print('[PB] listenEvents transient error: $e. Retrying in 2s...');
          }
          await Future.delayed(const Duration(seconds: 2));
          continue;
        }
      }
      isSettingUp = false;
    }

    setup().catchError(controller.addError);

    _StorageLifecycleObserver? observer;
    try {
      final binding = WidgetsBinding.instance;
      observer = _StorageLifecycleObserver(() {
        if (kDebugMode) {
          print('[PB] App resumed, forcing listenEvents setup for ${info.collection}');
        }
        setup();
      });
      binding.addObserver(observer);
    } catch (_) {
      // Ignored if WidgetsBinding is not initialized (e.g. in unit tests)
    }

    controller.onCancel = () async {
      if (observer != null) {
        try {
          WidgetsBinding.instance.removeObserver(observer);
        } catch (_) {}
      }
      if (kDebugMode) {
        print('[PB] listenEvents cancel col=${info.collection} — calling unsubscribe');
      }
      try {
        await unsubscribeFn?.call();
      } catch (_) {}
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

  /// Returns the PathInfo for the site files collection.
  PathInfo _filesPathInfo(String appName, String siteId) =>
      PathInfo.parse('hyttahub/$appName/sites/$siteId/site_files');

  static const String _fileField = 'file';

  @override
  Future<void> uploadFile({
    required String appName,
    required String siteId,
    required String fileName,
    required String base64Data,
  }) async {
    final info = _filesPathInfo(appName, siteId);
    final bytes = base64Decode(base64Data);

    final existing = await _findRecord(info, fileName);
    if (existing != null) {
      await _client.collection(info.collection).delete(existing.id);
    }

    await _client.collection(info.collection).create(
          body: {
            'doc_id': fileName,
            ...info.fields,
          },
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
    int? expirationDays,
  }) async {
    final info = _filesPathInfo(appName, siteId);
    final record = await _findRecord(info, fileName);
    if (record == null) throw Exception('File not found: $fileName');

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
    final info = _filesPathInfo(appName, siteId);
    for (final fileName in fileNames) {
      final record = await _findRecord(info, fileName);
      if (record != null) {
        await _client.collection(info.collection).delete(record.id);
      }
    }
  }

  @override
  Future<List<String>> listFiles(String prefix) async {
    final segments = prefix.split('/').where((s) => s.isNotEmpty).toList();
    final appName = segments.isNotEmpty ? segments.first : '';
    final siteId = segments.length > 1 ? segments[1] : '';
    
    final info = _filesPathInfo(appName, siteId);
    try {
      final records = await _client.collection(info.collection).getFullList(filter: info.filter);
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
class PocketbaseHyttaHubBatch implements HyttaHubBatch {
  PocketbaseHyttaHubBatch(this._storage);

  final PocketbaseHyttaHubStorage _storage;
  final List<Future<void> Function()> _operations = [];

  @override
  void setDocument(String path, String docId, Map<String, dynamic> data) {
    final info = PathInfo.parse(path);
    _operations.add(() async {
      await _storage._client.collection(info.collection).create(body: {
        'doc_id': docId,
        ...info.fields,
        ...data,
      });
    });
  }

  @override
  void updateDocument(String path, String docId, Map<String, dynamic> data) {
    final info = PathInfo.parse(path);
    _operations.add(() async {
      final existing = await _storage._findRecord(info, docId);
      if (existing == null) {
        throw Exception('Document not found for updateDocument: $path/$docId');
      }
      await _storage._client.collection(info.collection).update(existing.id, body: data);
    });
  }

  @override
  void commit() {
    // No-op: synchronous interface contract.
  }

  /// Executes all queued operations sequentially.
  Future<void> executeAll() async {
    for (final op in _operations) {
      await op();
    }
    _operations.clear();
  }
}

class _StorageLifecycleObserver extends WidgetsBindingObserver {
  _StorageLifecycleObserver(this.onResume);
  final VoidCallback onResume;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }
}
