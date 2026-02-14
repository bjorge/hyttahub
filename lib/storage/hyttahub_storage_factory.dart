// Copyright (c) 2025 bjorge

import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';
import 'package:hyttahub/storage/in_memory_hyttahub_storage.dart';
import 'package:hyttahub/utilities/persistence_registries.dart';

class HyttaHubStorageFactory {
  static final Map<StorageEnum, BaseHyttaHubStorage> _instances = {};

  static BaseHyttaHubStorage getStorage(
    StorageEnum type,
  ) {
    if (_instances.containsKey(type)) {
      return _instances[type]!;
    }

    BaseHyttaHubStorage? storage;
    switch (type) {
      case StorageEnum.inMemory:
        storage = InMemoryHyttaHubStorage();
        break;
      default:
        storage = PersistenceRegistry.createStorage(type);
    }

    storage ??= InMemoryHyttaHubStorage();

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
