// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:typed_data';

abstract class BaseHyttaHubStorage {
  Future<Map<String, dynamic>?> getDocument(String path, String docId);
  Future<List<Map<String, dynamic>>> getCollection(
    String path, {
    String? orderBy,
    bool descending = false,
  });
  Future<void> setDocument(String path, String docId, Map<String, dynamic> data);
  Future<void> updateDocument(String path, String docId, Map<String, dynamic> data);

  Stream<Map<String, Map<String, dynamic>>> listenCollection(String path);

  Stream<Map<int, String>> listenEvents(
    String path, {
    required int lastVersion,
    required String versionField,
    required String payloadField,
  });

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
}

abstract class HyttaHubBatch {
  void setDocument(String path, String docId, Map<String, dynamic> data);
  void updateDocument(String path, String docId, Map<String, dynamic> data);
  void commit();
}
