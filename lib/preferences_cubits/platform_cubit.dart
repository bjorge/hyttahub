// Copyright (c) 2025 bjorge

import 'package:hyttahub/hyttahub_options.dart';
import 'package:get_it/get_it.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hyttahub/auth_bloc/hyttahub_auth_factory.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';
import 'package:hyttahub/storage/hyttahub_internal_storage_factory.dart';
import 'package:hyttahub/functions/hyttahub_functions_factory.dart';

class PlatformCubit extends HydratedCubit<StorageEnum> {
  PlatformCubit(this.storageKey)
    : super(HyttaHubOptions.implementation?.storage ?? StorageEnum.inMemory);

  final String storageKey;

  void setPlatform(StorageEnum storage) {
    if (HyttaHubOptions.implementation != null) {
      HyttaHubOptions.implementation!.storage = storage;
    }
    HyttaHubAuthFactory.clear();
    HyttaHubStorageFactory.clear();
    HyttaHubInternalStorageFactory.clear();
    HyttaHubFunctionsFactory.clear();

    // Reset AuthBloc in GetIt to ensure a fresh instance for the new platform.
    if (GetIt.instance.isRegistered<AuthBloc>()) {
      GetIt.instance<AuthBloc>().close();
      GetIt.instance.resetLazySingleton<AuthBloc>();
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
