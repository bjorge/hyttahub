// Copyright (c) 2025 bjorge

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hyttahub/auth_bloc/base_hyttahub_auth.dart';
import 'package:hyttahub/auth_bloc/firebase_hyttahub_auth.dart';
import 'package:hyttahub/auth_bloc/in_memory_hyttahub_auth.dart';
import 'package:hyttahub/auth_bloc/local_storage_hyttahub_auth.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';

class HyttaHubAuthFactory {
  static final Map<StorageEnum, BaseHyttaHubAuth> _instances = {};

  static BaseHyttaHubAuth getAuth(
    StorageEnum type, {
    FirebaseAuth? firebaseAuth,
  }) {
    if (_instances.containsKey(type)) {
      return _instances[type]!;
    }

    BaseHyttaHubAuth auth;
    switch (type) {
      case StorageEnum.firestore:
        auth = FirebaseHyttaHubAuth(auth: firebaseAuth);
        break;
      case StorageEnum.inMemory:
        auth = InMemoryHyttaHubAuth();
        break;
      case StorageEnum.localStorage:
        auth = LocalStorageHyttaHubAuth();
        break;
      default:
        auth = FirebaseHyttaHubAuth(auth: firebaseAuth);
    }

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
