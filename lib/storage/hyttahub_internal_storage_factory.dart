import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/storage/base_hyttahub_internal_storage.dart';
import 'package:hyttahub/storage/in_memory_hyttahub_internal_storage.dart';
import 'package:hyttahub/storage/hydrated_hyttahub_internal_storage.dart';

class HyttaHubInternalStorageFactory {
  static final Map<String, BaseHyttaHubInternalStorage> _instances = {};

  static BaseHyttaHubInternalStorage getInternalStorage(StorageEnum type, {String? implementationId}) {
    final implementationIdFromOptions =
        HyttaHubOptions.implementation?.storage == type
            ? HyttaHubOptions.implementation?.implementationId
            : null;

    final id = implementationId ??
        ((implementationIdFromOptions?.isNotEmpty ?? false)
            ? implementationIdFromOptions
            : null) ??
        type.name;

    if (_instances.containsKey(id)) {
      return _instances[id]!;
    }

    BaseHyttaHubInternalStorage? storage;

    switch (type) {
      case StorageEnum.memory:
        storage = InMemoryHyttaHubInternalStorage();
        break;
      case StorageEnum.local:
        storage = HydratedHyttaHubInternalStorage(
            storageKey: 'hyttahub:internal_local_storage');
        break;
      default:
        storage = InMemoryHyttaHubInternalStorage();
        break;
    }

    _instances[id] = storage;
    return storage;
  }

  static Future<void> clear() async {
    for (final storage in _instances.values) {
      await storage.dispose();
    }
    _instances.clear();
  }
}
