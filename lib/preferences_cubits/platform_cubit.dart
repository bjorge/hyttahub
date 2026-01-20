// Copyright (c) 2025 bjorge

import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class PlatformCubit extends HydratedCubit<StorageEnum> {
  PlatformCubit(this.storageKey)
    : super(HyttaHubOptions.implementation?.storage ?? StorageEnum.inMemory);

  final String storageKey;

  void setPlatform(StorageEnum storage) {
    if (HyttaHubOptions.implementation != null) {
      HyttaHubOptions.implementation!.storage = storage;
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
