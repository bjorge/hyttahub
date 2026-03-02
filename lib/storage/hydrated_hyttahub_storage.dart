// Copyright (c) 2025 bjorge

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/storage/in_memory_hyttahub_storage.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';

class HydratedHyttaHubStorage extends InMemoryHyttaHubStorage {
  final String storageKey;

  HydratedHyttaHubStorage({required this.storageKey})
      : super(storageType: StorageEnum.local) {
    _loadFromStorage();
  }

  void _loadFromStorage() {
    try {
      final storedData = HydratedBloc.storage.read(storageKey);
      if (kDebugMode) {
        print('HydratedHyttaHubStorage: loading from $storageKey, found: ${storedData != null}');
      }
      if (storedData != null && storedData is Map) {
        // Correctly cast the stored data back to the nested map structure
        storedData.forEach((path, docs) {
          if (docs is Map) {
            final pathMap = data.putIfAbsent(path.toString(), () => {});
            docs.forEach((docId, docData) {
              if (docData is Map) {
                pathMap[docId.toString()] = Map<String, dynamic>.from(docData);
              }
            });
          }
        });
        if (kDebugMode) {
          print('HydratedHyttaHubStorage: loaded ${data.length} collections');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('HydratedHyttaHubStorage: error loading: $e');
      }
    }
  }

  Future<void> _persist() async {
    try {
      if (kDebugMode) {
        print('HydratedHyttaHubStorage: persisting data to $storageKey');
      }
      await HydratedBloc.storage.write(storageKey, data);
    } catch (e) {
      if (kDebugMode) {
        print('HydratedHyttaHubStorage: error persisting: $e');
      }
    }
  }

  @override
  Future<void> setDocument(String path, String docId, Map<String, dynamic> dataMap) async {
    await super.setDocument(path, docId, dataMap);
    await _persist();
  }

  @override
  Future<void> updateDocument(String path, String docId, Map<String, dynamic> dataMap) async {
    await super.updateDocument(path, docId, dataMap);
    await _persist();
  }

  @override
  Future<void> runBatch(Future<void> Function(HyttaHubBatch batch) action) async {
    await super.runBatch(action);
    await _persist();
  }

  @override
  Future<void> deleteDocument(String path, String docId) async {
    await super.deleteDocument(path, docId);
    await _persist();
  }

  @override
  Future<void> deleteCollection(String path) async {
    await super.deleteCollection(path);
    await _persist();
  }
}
