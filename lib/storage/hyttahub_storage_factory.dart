import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';
import 'package:hyttahub/storage/in_memory_hyttahub_storage.dart';
import 'package:hyttahub/storage/hydrated_hyttahub_storage.dart';
import 'package:hyttahub/utilities/persistence_registries.dart';

class HyttaHubStorageFactory {
  static final Map<String, BaseHyttaHubStorage> _instances = {};

  static BaseHyttaHubStorage getStorage(
    StorageEnum type, {
    String? implementationId,
  }) {
    final id = implementationId ??
        (HyttaHubOptions.implementation?.storage == type
            ? HyttaHubOptions.implementation?.implementationId
            : null) ??
        type.name;

    if (_instances.containsKey(id)) {
      return _instances[id]!;
    }

    BaseHyttaHubStorage? storage;
    if (implementationId != null ||
        PersistenceRegistry.isImplementationRegistered(id)) {
      storage = PersistenceRegistry.createStorage(id);
    }

    if (storage == null) {
      switch (type) {
        case StorageEnum.memory:
          storage = InMemoryHyttaHubStorage();
          break;
        case StorageEnum.local:
          storage = HydratedHyttaHubStorage(storageKey: 'hyttahub:local_storage');
          break;
        default:
          break;
      }
    }

    storage ??= InMemoryHyttaHubStorage();

    _instances[id] = storage;
    return storage;
  }

  // For testing purposes
  static void setStorage(StorageEnum type, BaseHyttaHubStorage storage) {
    _instances[type.name] = storage;
  }

  static void clear() {
    _instances.clear();
  }
}
