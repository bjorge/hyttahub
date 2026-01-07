// Copyright (c) 2025 bjorge

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hyttahub/auth_bloc/base_hyttahub_auth.dart';
import 'package:hyttahub/auth_bloc/firebase_hyttahub_auth.dart';
import 'package:hyttahub/auth_bloc/in_memory_hyttahub_auth.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';

class HyttaHubAuthFactory {
  static BaseHyttaHubAuth? _instance;

  static BaseHyttaHubAuth getAuth(
    StorageEnum type, {
    FirebaseAuth? firebaseAuth,
  }) {
    if (_instance != null) {
      return _instance!;
    }

    switch (type) {
      case StorageEnum.firestore:
        _instance = FirebaseHyttaHubAuth(auth: firebaseAuth);
        break;
      case StorageEnum.inMemory:
        _instance = InMemoryHyttaHubAuth();
        break;
      default:
        _instance = FirebaseHyttaHubAuth(auth: firebaseAuth);
    }

    return _instance!;
  }

  // For testing purposes
  static void setAuth(BaseHyttaHubAuth auth) {
    _instance = auth;
  }

  static void clear() {
    _instance = null;
  }
}
