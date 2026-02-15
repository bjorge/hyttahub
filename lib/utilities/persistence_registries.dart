// Copyright (c) 2025 bjorge

import 'package:hyttahub/auth_bloc/base_hyttahub_auth.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';
import 'package:hyttahub/storage/base_hyttahub_internal_storage.dart';
import 'package:hyttahub/functions/base_hyttahub_functions.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';

/// A descriptor for a HyttaHub implementation.
class HyttaHubImplementationDescriptor {
  final String id;
  final String name;
  final StorageEnum type;
  final BaseHyttaHubStorage Function()? storageBuilder;
  final BaseHyttaHubAuth Function()? authBuilder;
  final BaseHyttaHubFunctions Function()? functionsBuilder;
  final BaseHyttaHubInternalStorage Function()? internalStorageBuilder;

  HyttaHubImplementationDescriptor({
    required this.id,
    required this.name,
    required this.type,
    this.storageBuilder,
    this.authBuilder,
    this.functionsBuilder,
    this.internalStorageBuilder,
  });
}

/// A registry that allows the application layer to provide persistence implementations.
class PersistenceRegistry {
  static final Map<String, HyttaHubImplementationDescriptor> _implementations = {};

  static void registerImplementation(HyttaHubImplementationDescriptor descriptor) {
    _implementations[descriptor.id] = descriptor;
  }

  static List<HyttaHubImplementationDescriptor> get registeredImplementations =>
      _implementations.values.toList();

  static HyttaHubImplementationDescriptor? getImplementation(String id) => _implementations[id];

  static Future<void> Function(StorageEnum)? onInitializePlatform;

  static BaseHyttaHubStorage? createStorage(String id) =>
      _implementations[id]?.storageBuilder?.call();
  static BaseHyttaHubAuth? createAuth(String id) =>
      _implementations[id]?.authBuilder?.call();
  static BaseHyttaHubFunctions? createFunctions(String id) =>
      _implementations[id]?.functionsBuilder?.call();
  static BaseHyttaHubInternalStorage? createInternalStorage(String id) =>
      _implementations[id]?.internalStorageBuilder?.call();

  static bool isImplementationRegistered(String id) => _implementations.containsKey(id);

  static Future<void> initializePlatform(StorageEnum type) async {
    await onInitializePlatform?.call(type);
  }

  // Deprecated shim for backward compatibility during refactor if needed
  @Deprecated('Use registerImplementation')
  static void registerStorage(StorageEnum type, BaseHyttaHubStorage Function() builder) {}
}
