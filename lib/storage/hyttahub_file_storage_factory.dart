// Copyright (c) 2025 bjorge

import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/storage/base_hyttahub_file_storage.dart';
import 'package:hyttahub/storage/firebase_hyttahub_file_storage.dart';
import 'package:hyttahub/storage/in_memory_hyttahub_file_storage.dart';

class HyttaHubFileStorageFactory {
  static final Map<StorageEnum, BaseHyttaHubFileStorage> _instances = {};

  static BaseHyttaHubFileStorage getFileStorage(StorageEnum type) {
    if (_instances.containsKey(type)) {
      return _instances[type]!;
    }

    BaseHyttaHubFileStorage storage;
    switch (type) {
      case StorageEnum.firestore:
        storage = FirebaseHyttaHubFileStorage();
        break;
      case StorageEnum.inMemory:
        storage = InMemoryHyttaHubFileStorage();
        break;
      default:
        storage = FirebaseHyttaHubFileStorage();
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
