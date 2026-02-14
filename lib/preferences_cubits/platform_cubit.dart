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

class PlatformCubit extends HydratedCubit<StorageEnum> {
  PlatformCubit(this.storageKey)
    : super(HyttaHubOptions.implementation?.storage ?? StorageEnum.inMemory);

  final String storageKey;

  Future<void> setPlatform(StorageEnum storage) async {
    await PersistenceRegistry.initializePlatform(storage);

    if (HyttaHubOptions.implementation != null) {
      HyttaHubOptions.implementation!.storage = storage;
    }
    HyttaHubAuthFactory.clear();
    HyttaHubStorageFactory.clear();
    HyttaHubInternalStorageFactory.clear();
    HyttaHubFunctionsFactory.clear();

    // Refresh AuthBloc in GetIt to ensure it connects to the new platform.
    if (GetIt.instance.isRegistered<AuthBloc>()) {
      GetIt.instance<AuthBloc>().add(AuthBlocEvent(startup: AuthBlocEvent_AppStartup()));
    }

    emit(storage);
  }

  @override
  String get id => ':platform:$storageKey';

  @override
  StorageEnum fromJson(Map<String, dynamic> json) {
    final value = json['platform'] as int?;
    return StorageEnum.valueOf(value ?? StorageEnum.inMemory.value) ??
        StorageEnum.inMemory;
  }

  @override
  Map<String, dynamic> toJson(StorageEnum state) {
    return {'platform': state.value};
  }
}
