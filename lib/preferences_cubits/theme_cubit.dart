// Copyright (c) 2025 bjorge

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hyttahub/hyttahub_options.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit(this.storageKey)
      : super(HyttaHubOptions.defaultTheme ?? ThemeMode.system);

  final String storageKey;

  void setTheme(ThemeMode mode) => emit(mode);

  void reset() => emit(HyttaHubOptions.defaultTheme ?? ThemeMode.system);

  // for hydrated storage
  @override
  String get id => ':$storageKey';

  @override
  ThemeMode fromJson(Map<String, dynamic> json) {
    final value = json['theme'] as String?;
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return HyttaHubOptions.defaultTheme ?? ThemeMode.system;
    }
  }

  @override
  Map<String, dynamic> toJson(ThemeMode state) {
    return {'theme': state.name};
  }
}
