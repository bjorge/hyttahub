// Copyright (c) 2025 bjorge

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
