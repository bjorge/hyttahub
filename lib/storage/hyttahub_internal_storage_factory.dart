// Copyright (c) 2025 bjorge

import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/storage/base_hyttahub_internal_storage.dart';
import 'package:hyttahub/storage/in_memory_hyttahub_internal_storage.dart';
import 'package:hyttahub/storage/hydrated_hyttahub_internal_storage.dart';
import 'package:hyttahub/utilities/persistence_registries.dart';

class HyttaHubInternalStorageFactory {
  static final Map<StorageEnum, BaseHyttaHubInternalStorage> _instances = {};

  static BaseHyttaHubInternalStorage getInternalStorage(StorageEnum type) {
    if (_instances.containsKey(type)) {
      return _instances[type]!;
    }

    BaseHyttaHubInternalStorage? storage;
    switch (type) {
      case StorageEnum.memory:
        storage = InMemoryHyttaHubInternalStorage();
        break;
      case StorageEnum.local:
        storage = HydratedHyttaHubInternalStorage(storageKey: 'hyttahub:internal_local_storage');
        break;
      default:
        storage = PersistenceRegistry.createInternalStorage(type);
    }

    storage ??= InMemoryHyttaHubInternalStorage();
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
