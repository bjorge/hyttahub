// Copyright (c) 2025 bjorge

import 'package:flutter/foundation.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/storage/base_hyttahub_internal_storage.dart';
import 'package:hyttahub/storage/firebase_hyttahub_internal_storage.dart';
import 'package:hyttahub/storage/in_memory_hyttahub_internal_storage.dart';
import 'package:hyttahub/storage/local_storage_hyttahub_internal_storage.dart';
import 'package:hyttahub/storage/sembast_hyttahub_internal_storage.dart';

class HyttaHubInternalStorageFactory {
  static final Map<StorageEnum, BaseHyttaHubInternalStorage> _instances = {};

  static BaseHyttaHubInternalStorage getInternalStorage(StorageEnum type) {
    if (_instances.containsKey(type)) {
      return _instances[type]!;
    }

    BaseHyttaHubInternalStorage storage;
    switch (type) {
      case StorageEnum.firestore:
        storage = FirebaseHyttaHubInternalStorage();
        break;
      case StorageEnum.inMemory:
        storage = InMemoryHyttaHubInternalStorage();
        break;
      case StorageEnum.localStorage:
        if (kIsWeb) {
          storage = SembastHyttaHubInternalStorage();
        } else {
          storage = LocalStorageHyttaHubInternalStorage();
        }
        break;
      default:
        storage = FirebaseHyttaHubInternalStorage();
    }

    _instances[type] = storage;
    return storage;
  }

  static Future<void> clear() async {
    for (final storage in _instances.values) {
      await storage.dispose();
    }
    _instances.clear();
  }
}
