// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';
import 'package:hyttahub/storage/hyttahub_internal_storage_factory.dart';

class InMemoryHyttaHubStorage implements BaseHyttaHubStorage {
  final StorageEnum storageType;

  InMemoryHyttaHubStorage({this.storageType = StorageEnum.memory});

  // Map of path -> (Map of docId -> data)
  final Map<String, Map<String, Map<String, dynamic>>> data = {};

  // Stream controller for simulated real-time updates
  final StreamController<Map<String, dynamic>> updateController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get updates => updateController.stream;

  @override
  Future<Map<String, dynamic>?> getDocument(String path, String docId) async {
    return data[path]?[docId];
  }

  @override
  Future<List<Map<String, dynamic>>> getCollection(
    String path, {
    String? orderBy,
    bool descending = false,
  }) async {
    final docs = data[path];
    if (docs == null) return [];

    final list = docs.values.toList();
    if (orderBy != null) {
      list.sort((a, b) {
        final valA = a[orderBy];
        final valB = b[orderBy];
        if (valA == null || valB == null) return 0;
        final cmp = (valA as Comparable).compareTo(valB);
        return descending ? -cmp : cmp;
      });
    }
    return list;
  }

  @override
  Future<void> setDocument(
    String path,
    String docId,
    Map<String, dynamic> dataMap,
  ) async {
    data.putIfAbsent(path, () => {})[docId] = Map<String, dynamic>.from(dataMap);
    updateController.add({'path': path, 'docId': docId});
  }

  @override
  Future<void> updateDocument(
    String path,
    String docId,
    Map<String, dynamic> dataMap,
  ) async {
    final existing = data[path]?[docId];
    if (existing == null) {
      throw Exception('Document not found: $path/$docId');
    }
    existing.addAll(dataMap);
    updateController.add({'path': path, 'docId': docId});
  }

  @override
  Stream<Map<int, String>> listenEvents(
    String path, {
    required int lastVersion,
    required String versionField,
    required String payloadField,
  }) {
    // Initial events
    final initialEvents = _getEvents(path, lastVersion, versionField, payloadField);

    // Filtered stream for updates
    return updateController.stream
        .where((update) => update['path'] == path)
        .map((_) => _getEvents(path, lastVersion, versionField, payloadField))
        .startWith2(initialEvents);
  }

  @override
  Stream<Map<String, Map<String, dynamic>>> listenCollection(String path) {
    return updateController.stream
        .where((update) => update['path'] == path)
        .map((_) => Map<String, Map<String, dynamic>>.from(data[path] ?? {}))
        .startWith2(Map<String, Map<String, dynamic>>.from(data[path] ?? {}));
  }

  Map<int, String> _getEvents(
    String path,
    int lastVersion,
    String versionField,
    String payloadField,
  ) {
    final eventsMap = <int, String>{};
    final docs = data[path] ?? {};
    for (var doc in docs.values) {
      final version = doc[versionField] as int;
      if (version > lastVersion) {
        eventsMap[version] = doc[payloadField] as String;
      }
    }
    // Sort by version
    final sortedKeys = eventsMap.keys.toList()..sort();
    return Map.fromEntries(sortedKeys.map((k) => MapEntry(k, eventsMap[k]!)));
  }

  @override
  dynamic get serverTimestamp => DateTime.now().toIso8601String();

  @override
  bool isPermissionDenied(Object error) => false;

  @override
  Future<void> runBatch(Future<void> Function(HyttaHubBatch batch) action) async {
    final batch = InMemoryHyttaHubBatch(this);
    await action(batch);
    batch.commit();
  }

  @override
  Future<void> uploadFile({
    required String appName,
    required String siteId,
    required String fileName,
    required String base64Data,
  }) async {
    final internalStorage = HyttaHubInternalStorageFactory.getInternalStorage(storageType);
    final path = firebaseFilesPath(siteId, fileName);
    final bytes = base64Decode(base64Data);
    await internalStorage.uploadFile(path, bytes);
    // Also write to the archive (append-only, never deleted)
    final archivePath = firebaseArchiveFilePath(siteId, fileName);
    await internalStorage.uploadFile(archivePath, bytes);
    updateController.add({'path': '_files/$siteId', 'docId': fileName});
  }

  @override
  Future<Uint8List> getFileBytes({
    required String appName,
    required String siteId,
    required String fileName,
  }) async {
    final internalStorage = HyttaHubInternalStorageFactory.getInternalStorage(storageType);
    final path = firebaseFilesPath(siteId, fileName);
    return await internalStorage.downloadFile(path);
  }

  @override
  Future<void> deleteFiles({
    required String appName,
    required String siteId,
    required List<String> fileNames,
  }) async {
    final internalStorage = HyttaHubInternalStorageFactory.getInternalStorage(storageType);
    for (final fileName in fileNames) {
      final path = firebaseFilesPath(siteId, fileName);
      await internalStorage.deleteFile(path);
    }
    updateController.add({'path': '_files/$siteId'});
  }

  @override
  Future<String> getFileUrl({
    required String appName,
    required String siteId,
    required String fileName,
    int? expirationDays,
  }) async {
    final internalStorage = HyttaHubInternalStorageFactory.getInternalStorage(storageType);
    final path = firebaseFilesPath(siteId, fileName);
    return await internalStorage.getDownloadUrl(path);
  }

  @override
  Future<List<String>> listFiles(String prefix) async {
    final internalStorage = HyttaHubInternalStorageFactory.getInternalStorage(storageType);
    return await internalStorage.listFiles(prefix);
  }

  /// Deletes a single document from a collection.
  /// This is NOT part of BaseHyttaHubStorage — it's internal to in-memory/local storage.
  Future<void> deleteDocument(String path, String docId) async {
    data[path]?.remove(docId);
    updateController.add({'path': path, 'docId': docId});
  }

  /// Deletes an entire collection and all its documents.
  @override
  Future<void> deleteCollection(String path) async {
    data.remove(path);
    updateController.add({'path': path});
  }
}

class InMemoryHyttaHubBatch implements HyttaHubBatch {
  final InMemoryHyttaHubStorage _storage;
  final List<void Function()> _operations = [];

  InMemoryHyttaHubBatch(this._storage);

  @override
  void setDocument(String path, String docId, Map<String, dynamic> data) {
    _operations.add(() => _storage.setDocument(path, docId, data));
  }

  @override
  void updateDocument(String path, String docId, Map<String, dynamic> data) {
    _operations.add(() => _storage.updateDocument(path, docId, data));
  }

  @override
  void commit() {
    for (var op in _operations) {
      op();
    }
  }
}

extension StartWith2<T> on Stream<T> {
  Stream<T> startWith2(T value) async* {
    yield value;
    yield* this;
  }
}
