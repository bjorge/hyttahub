// Copyright (c) 2025 bjorge

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';

class InMemoryHyttaHubStorage implements BaseHyttaHubStorage {
  // Map of path -> (Map of docId -> data)
  final Map<String, Map<String, Map<String, dynamic>>> _data = {};

  // Stream controller for simulated real-time updates
  final StreamController<Map<String, dynamic>> _updateController =
      StreamController<Map<String, dynamic>>.broadcast();

  @override
  Future<Map<String, dynamic>?> getDocument(String path, String docId) async {
    return _data[path]?[docId];
  }

  @override
  Future<List<Map<String, dynamic>>> getCollection(
    String path, {
    String? orderBy,
    bool descending = false,
  }) async {
    final docs = _data[path];
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
    Map<String, dynamic> data,
  ) async {
    _data.putIfAbsent(path, () => {})[docId] = Map<String, dynamic>.from(data);
    _updateController.add({'path': path, 'docId': docId});
  }

  @override
  Future<void> updateDocument(
    String path,
    String docId,
    Map<String, dynamic> data,
  ) async {
    final existing = _data[path]?[docId];
    if (existing == null) {
      throw Exception('Document not found: $path/$docId');
    }
    existing.addAll(data);
    _updateController.add({'path': path, 'docId': docId});
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
    return _updateController.stream
        .where((update) => update['path'] == path)
        .map((_) => _getEvents(path, lastVersion, versionField, payloadField))
        .startWith2(initialEvents);
  }

  @override
  Stream<Map<String, Map<String, dynamic>>> listenCollection(String path) {
    return _updateController.stream
        .where((update) => update['path'] == path)
        .map((_) => Map<String, Map<String, dynamic>>.from(_data[path] ?? {}))
        .startWith2(Map<String, Map<String, dynamic>>.from(_data[path] ?? {}));
  }

  Map<int, String> _getEvents(
    String path,
    int lastVersion,
    String versionField,
    String payloadField,
  ) {
    final events = <int, String>{};
    final docs = _data[path] ?? {};
    for (var doc in docs.values) {
      final version = doc[versionField] as int;
      if (version > lastVersion) {
        events[version] = doc[payloadField] as String;
      }
    }
    // Sort by version
    final sortedKeys = events.keys.toList()..sort();
    return Map.fromEntries(sortedKeys.map((k) => MapEntry(k, events[k]!)));
  }

  @override
  dynamic get serverTimestamp => Timestamp.now();

  @override
  bool isPermissionDenied(Object error) => false;

  @override
  Future<void> runBatch(Future<void> Function(HyttaHubBatch batch) action) async {
    final batch = InMemoryHyttaHubBatch(this);
    await action(batch);
    batch.commit();
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
