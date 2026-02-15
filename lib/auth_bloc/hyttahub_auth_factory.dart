// Copyright (c) 2025 bjorge

import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/auth_bloc/base_hyttahub_auth.dart';
import 'package:hyttahub/auth_bloc/in_memory_hyttahub_auth.dart';
import 'package:hyttahub/auth_bloc/hydrated_hyttahub_auth.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/utilities/persistence_registries.dart';

class HyttaHubAuthFactory {
  static final Map<String, BaseHyttaHubAuth> _instances = {};

  static BaseHyttaHubAuth getAuth(
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

    BaseHyttaHubAuth? auth;
    if (implementationId != null ||
        PersistenceRegistry.isImplementationRegistered(id)) {
      auth = PersistenceRegistry.createAuth(id);
    }

    if (auth == null) {
      switch (type) {
        case StorageEnum.memory:
          auth = InMemoryHyttaHubAuth();
          break;
        case StorageEnum.local:
          auth = HydratedHyttaHubAuth();
          break;
        default:
          break;
      }
    }

    auth ??= InMemoryHyttaHubAuth();

    _instances[id] = auth;
    return auth;
  }

  // For testing purposes
  static void setAuth(StorageEnum type, BaseHyttaHubAuth auth) {
    _instances[type.name] = auth;
  }

  static void clear() {
    _instances.clear();
  }
}
