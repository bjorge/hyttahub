// Copyright (c) 2025 bjorge

import 'package:hyttahub/hyttahub_options.dart';
import 'package:get_it/get_it.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/utilities/persistence_registries.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hyttahub/auth_bloc/hyttahub_auth_factory.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';
import 'package:hyttahub/storage/hyttahub_internal_storage_factory.dart';
import 'package:hyttahub/functions/hyttahub_functions_factory.dart';
import 'package:hyttahub/proto/auth_bloc.pb.dart';

class PlatformCubit extends HydratedCubit<String> {
  PlatformCubit(this.storageKey)
      : super(HyttaHubOptions.implementation?.implementationId ?? 'memory');

  final String storageKey;

  Future<void> setImplementation(String implementationId) async {
    final descriptor = PersistenceRegistry.getImplementation(implementationId);
    if (descriptor == null) return;

    await PersistenceRegistry.initializePlatform(descriptor.type);

    if (HyttaHubOptions.implementation != null) {
      HyttaHubOptions.implementation!.storage = descriptor.type;
      HyttaHubOptions.implementation!.implementationId = implementationId;
    }

    HyttaHubAuthFactory.clear();
    HyttaHubStorageFactory.clear();
    HyttaHubInternalStorageFactory.clear();
    HyttaHubFunctionsFactory.clear();

    // Refresh AuthBloc in GetIt to ensure it connects to the new platform.
    if (GetIt.instance.isRegistered<AuthBloc>()) {
      GetIt.instance<AuthBloc>().add(AuthBlocEvent(startup: AuthBlocEvent_AppStartup()));
    }

    emit(implementationId);
  }

  // Backward compatibility method
  Future<void> setPlatform(StorageEnum storage) async {
    // Find the first implementation of this type
    final impls = PersistenceRegistry.registeredImplementations
        .where((i) => i.type == storage);
    if (impls.isNotEmpty) {
      await setImplementation(impls.first.id);
    } else {
      // Fallback for memory/local if not explicitly registered
      if (HyttaHubOptions.implementation != null) {
        HyttaHubOptions.implementation!.storage = storage;
        HyttaHubOptions.implementation!.implementationId = storage.name;
      }
      emit(storage.name);
    }
  }

  @override
  String get id => ':persistence:$storageKey';

  @override
  String fromJson(Map<String, dynamic> json) {
    return json['implementationId'] as String? ?? 'memory';
  }

  @override
  Map<String, dynamic> toJson(String state) {
    return {'implementationId': state};
  }
}
