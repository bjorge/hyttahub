// Copyright (c) 2025 bjorge

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';
import 'package:hyttahub/storage/firestore_hyttahub_storage.dart';
import 'package:hyttahub/storage/in_memory_hyttahub_storage.dart';

class HyttaHubStorageFactory {
  static final Map<StorageEnum, BaseHyttaHubStorage> _instances = {};

  static BaseHyttaHubStorage getStorage(
    StorageEnum type, {
    FirebaseFirestore? firestore,
  }) {
    if (_instances.containsKey(type)) {
      return _instances[type]!;
    }

    BaseHyttaHubStorage storage;
    switch (type) {
      case StorageEnum.firestore:
        storage = FirestoreHyttaHubStorage(firestore: firestore);
        break;
      case StorageEnum.inMemory:
        storage = InMemoryHyttaHubStorage();
        break;
      default:
        storage = FirestoreHyttaHubStorage(firestore: firestore);
    }

    _instances[type] = storage;
    return storage;
  }

  // For testing purposes
  static void setStorage(StorageEnum type, BaseHyttaHubStorage storage) {
    _instances[type] = storage;
  }

  static void clear() {
    _instances.clear();
  }
}
