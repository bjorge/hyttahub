// Copyright (c) 2025 bjorge

import 'package:hyttahub/auth_bloc/base_hyttahub_auth.dart';
import 'package:hyttahub/auth_bloc/in_memory_hyttahub_auth.dart';
import 'package:hyttahub/auth_bloc/hydrated_hyttahub_auth.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/utilities/persistence_registries.dart';

class HyttaHubAuthFactory {
  static final Map<StorageEnum, BaseHyttaHubAuth> _instances = {};

  static BaseHyttaHubAuth getAuth(
    StorageEnum type,
  ) {
    if (_instances.containsKey(type)) {
      return _instances[type]!;
    }

    BaseHyttaHubAuth? auth;
    switch (type) {
      case StorageEnum.inMemory:
        auth = InMemoryHyttaHubAuth();
        break;
      case StorageEnum.localStorage:
        auth = HydratedHyttaHubAuth();
        break;
      default:
        auth = PersistenceRegistry.createAuth(type);
    }

    auth ??= InMemoryHyttaHubAuth();

    _instances[type] = auth;
    return auth;
  }

  // For testing purposes
  static void setAuth(StorageEnum type, BaseHyttaHubAuth auth) {
    _instances[type] = auth;
  }

  static void clear() {
    _instances.clear();
  }
}
