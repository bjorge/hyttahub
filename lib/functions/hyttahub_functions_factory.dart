// Copyright (c) 2025 bjorge

import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/functions/base_hyttahub_functions.dart';
import 'package:hyttahub/functions/in_memory_hyttahub_functions.dart';
import 'package:hyttahub/utilities/persistence_registries.dart';

class HyttaHubFunctionsFactory {
  static final Map<String, BaseHyttaHubFunctions> _instances = {};

  static BaseHyttaHubFunctions getFunctions(
    StorageEnum type, {
    String? implementationId,
  }) {
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

    BaseHyttaHubFunctions? functions;
    if (implementationId != null ||
        PersistenceRegistry.isImplementationRegistered(id)) {
      functions = PersistenceRegistry.createFunctions(id);
    }

    if (functions == null) {
      switch (type) {
        case StorageEnum.memory:
        case StorageEnum.local:
          functions = InMemoryHyttaHubFunctions(type);
          break;
        default:
          break;
      }
    }

    functions ??= InMemoryHyttaHubFunctions(type);

    _instances[id] = functions;
    return functions;
  }

  static Future<void> clear() async {
    for (final functions in _instances.values) {
      await functions.dispose();
    }
    _instances.clear();
  }

  // For testing purposes
  static void setFunctions(StorageEnum type, BaseHyttaHubFunctions functions) {
    _instances[type.name] = functions;
  }
}
