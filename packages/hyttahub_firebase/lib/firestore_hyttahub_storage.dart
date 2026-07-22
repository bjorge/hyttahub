// Copyright (c) 2025 bjorge

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;
import 'package:hyttahub/storage/base_hyttahub_storage.dart';

class FirestoreHyttaHubStorage implements BaseHyttaHubStorage {
  final FirebaseFirestore? _firestoreOverride;

  FirebaseFirestore get _firestore {
    if (_firestoreOverride == null && Firebase.apps.isEmpty) {
      throw Exception('FirestoreHyttaHubStorage: Firebase not initialized!');
    }
    return _firestoreOverride ?? FirebaseFirestore.instance;
  }

  FirestoreHyttaHubStorage({FirebaseFirestore? firestore})
      : _firestoreOverride = firestore;

  @override
  Future<Map<String, dynamic>?> getDocument(String path, String docId) async {
    final doc = await _firestore
        .collection(path)
        .doc(docId)
        .get(const GetOptions(source: Source.server));
    return doc.data();
  }

  @override
  Future<List<Map<String, dynamic>>> getCollection(
    String path, {
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    Query query = _firestore.collection(path);
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    if (limit != null) {
      query = query.limit(limit);
    }
    final snapshot = await query.get(const GetOptions(source: Source.server));
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
        .snapshots(includeMetadataChanges: true)
        .where((snapshot) => !snapshot.metadata.isFromCache)
        .map((snapshot) {
          final events = <int, String>{};
          for (var doc in snapshot.docs) {
            if (doc.metadata.hasPendingWrites) {
              continue;
            }
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
    return _firestore
        .collection(path)
        .snapshots(includeMetadataChanges: true)
        .where((snapshot) => !snapshot.metadata.isFromCache)
        .map((snapshot) {
      final collection = <String, Map<String, dynamic>>{};
      for (var doc in snapshot.docs) {
        if (doc.metadata.hasPendingWrites) {
          continue;
        }
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

  @override
  Future<String> getFileUrl({
    required String appName,
    required String siteId,
    required String fileName,
    int? expirationDays,
  }) async {
    final callable = FirebaseFunctions.instance.httpsCallable('getFile');
    final result = await callable.call({
      'appName': appName,
      'siteId': siteId,
      'fileName': fileName,
      if (expirationDays != null) 'expirationDays': expirationDays,
    });
    final data = result.data as Map<String, dynamic>;
    return data['downloadUrl'] as String;
  }

  @override
  Future<List<String>> listFiles(String prefix) async {
    final segments = prefix.split('/').where((s) => s.isNotEmpty).toList();
    final appName = segments.isNotEmpty ? segments.first : '';
    final siteId = segments.length > 1 ? segments[1] : '';

    final callable = FirebaseFunctions.instance.httpsCallable('listSiteFiles');
    final result = await callable.call({
      'appName': appName,
      'siteId': siteId,
    });

    final data = result.data as Map<String, dynamic>;
    final filesList = data['files'] as List<dynamic>? ?? [];
    return filesList
        .map((f) => (f as Map<String, dynamic>)['name'] as String)
        .toList();
  }

  @override
  Future<void> deleteCollection(String path) async {
    final collectionRef = _firestore.collection(path);
    final snapshot = await collectionRef.get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
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
  }
}
