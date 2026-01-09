// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;
import 'package:hyttahub/storage/base_hyttahub_storage.dart';

class FirestoreHyttaHubStorage implements BaseHyttaHubStorage {
  final FirebaseFirestore _firestore;

  FirestoreHyttaHubStorage({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Map<String, dynamic>?> getDocument(String path, String docId) async {
    final doc = await _firestore.collection(path).doc(docId).get();
    return doc.data();
  }

  @override
  Future<List<Map<String, dynamic>>> getCollection(
    String path, {
    String? orderBy,
    bool descending = false,
  }) async {
    Query query = _firestore.collection(path);
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Future<void> setDocument(
    String path,
    String docId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection(path).doc(docId).set(data);
  }

  @override
  Future<void> updateDocument(
    String path,
    String docId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection(path).doc(docId).update(data);
  }

  @override
  Stream<Map<int, String>> listenEvents(
    String path, {
    required int lastVersion,
    required String versionField,
    required String payloadField,
  }) {
    return _firestore
        .collection(path)
        .where(versionField, isGreaterThan: lastVersion)
        .orderBy(versionField, descending: false)
        .snapshots()
        .map((snapshot) {
          final events = <int, String>{};
          for (var doc in snapshot.docs) {
            try {
              final version = doc[versionField] as int;
              final payload = doc[payloadField] as String;
              events[version] = payload;
            } catch (e) {
              // Ignore malformed documents
            }
          }
          return events;
        });
  }

  @override
  Stream<Map<String, Map<String, dynamic>>> listenCollection(String path) {
    return _firestore.collection(path).snapshots().map((snapshot) {
      final collection = <String, Map<String, dynamic>>{};
      for (var doc in snapshot.docs) {
        collection[doc.id] = doc.data();
      }
      return collection;
    });
  }

  @override
  dynamic get serverTimestamp => FieldValue.serverTimestamp();

  @override
  bool isPermissionDenied(Object error) {
    return error is FirebaseException && error.code == 'permission-denied';
  }

  @override
  Future<void> runBatch(Future<void> Function(HyttaHubBatch batch) action) async {
    final firestoreBatch = _firestore.batch();
    final hyttaBatch = FirestoreHyttaHubBatch(firestoreBatch, _firestore);
    await action(hyttaBatch);
    await firestoreBatch.commit();
  }

  @override
  Future<void> uploadFile({
    required String appName,
    required String siteId,
    required String fileName,
    required String base64Data,
  }) async {
    final callable = FirebaseFunctions.instance.httpsCallable('uploadFile');
    await callable.call({
      'appName': appName,
      'siteId': siteId,
      'fileName': fileName,
      'base64Data': base64Data,
    });
  }

  @override
  Future<Uint8List> getFileBytes({
    required String appName,
    required String siteId,
    required String fileName,
  }) async {
    final callable = FirebaseFunctions.instance.httpsCallable('getFile');
    final result = await callable.call({
      'appName': appName,
      'siteId': siteId,
      'fileName': fileName,
    });
    final data = result.data as Map<String, dynamic>;
    final downloadUrl = data['downloadUrl'] as String;
    final response = await http.get(Uri.parse(downloadUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    throw Exception('Failed to download bytes: ${response.statusCode}');
  }

  @override
  Future<void> deleteFiles({
    required String appName,
    required String siteId,
    required List<String> fileNames,
  }) async {
    final callable = FirebaseFunctions.instance.httpsCallable('deleteFiles');
    await callable.call({
      'appName': appName,
      'siteId': siteId,
      'fileNames': fileNames,
    });
  }
}

class FirestoreHyttaHubBatch implements HyttaHubBatch {
  final WriteBatch _batch;
  final FirebaseFirestore _firestore;

  FirestoreHyttaHubBatch(this._batch, this._firestore);

  @override
  void setDocument(String path, String docId, Map<String, dynamic> data) {
    _batch.set(_firestore.collection(path).doc(docId), data);
  }

  @override
  void updateDocument(String path, String docId, Map<String, dynamic> data) {
    _batch.update(_firestore.collection(path).doc(docId), data);
  }

  @override
  void commit() {
    // commit is handled by runBatch
  }
}
