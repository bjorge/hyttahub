// Copyright (c) 2025 bjorge

import 'package:hyttahub/auth_bloc/base_hyttahub_auth.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';
import 'package:hyttahub/storage/base_hyttahub_internal_storage.dart';
import 'package:hyttahub/functions/base_hyttahub_functions.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';

/// A registry that allows the application layer to provide persistence implementations.
class PersistenceRegistry {
  static final Map<StorageEnum, BaseHyttaHubStorage Function()> _storageBuilders = {};
  static final Map<StorageEnum, BaseHyttaHubAuth Function()> _authBuilders = {};
  static final Map<StorageEnum, BaseHyttaHubFunctions Function()> _functionsBuilders = {};

  static void registerStorage(StorageEnum type, BaseHyttaHubStorage Function() builder) {
    _storageBuilders[type] = builder;
  }

  static void registerAuth(StorageEnum type, BaseHyttaHubAuth Function() builder) {
    _authBuilders[type] = builder;
  }

  static void registerFunctions(StorageEnum type, BaseHyttaHubFunctions Function() builder) {
    _functionsBuilders[type] = builder;
  }

  static BaseHyttaHubStorage? createStorage(StorageEnum type) => _storageBuilders[type]?.call();
  static BaseHyttaHubAuth? createAuth(StorageEnum type) => _authBuilders[type]?.call();
  static BaseHyttaHubFunctions? createFunctions(StorageEnum type) => _functionsBuilders[type]?.call();

  static final Map<StorageEnum, BaseHyttaHubInternalStorage Function()> _internalStorageBuilders = {};

  static Future<void> Function(StorageEnum)? onInitializePlatform;

  static void registerInternalStorage(StorageEnum type, BaseHyttaHubInternalStorage Function() builder) {
    _internalStorageBuilders[type] = builder;
  }
  static BaseHyttaHubInternalStorage? createInternalStorage(StorageEnum type) => _internalStorageBuilders[type]?.call();

  static bool isStorageRegistered(StorageEnum type) => _storageBuilders.containsKey(type);
  static bool isAuthRegistered(StorageEnum type) => _authBuilders.containsKey(type);
  static bool isFunctionsRegistered(StorageEnum type) => _functionsBuilders.containsKey(type);
  static bool isInternalStorageRegistered(StorageEnum type) => _internalStorageBuilders.containsKey(type);

  static Future<void> initializePlatform(StorageEnum type) async {
    await onInitializePlatform?.call(type);
  }
}
