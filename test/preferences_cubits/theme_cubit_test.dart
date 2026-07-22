// Copyright (c) 2025 bjorge

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/preferences_cubits/theme_cubit.dart';

class MockStorage implements Storage {
  final Map<String, dynamic> _data = <String, dynamic>{};

  @override
  dynamic read(String key) => _data[key];

  @override
  Future<void> write(String key, dynamic value) async => _data[key] = value;

  @override
  Future<void> delete(String key) async => _data.remove(key);

  @override
  Future<void> clear() async => _data.clear();

  @override
  Future<void> close() => Future.value();
}

void main() {
  group('ThemeCubit', () {
    setUp(() {
      HydratedBloc.storage = MockStorage();
      HyttaHubOptions.defaultTheme = null;
    });

    test('initial state defaults to ThemeMode.system when options default is null', () {
      final cubit = ThemeCubit('test_key');
      expect(cubit.state, ThemeMode.system);
      cubit.close();
    });

    test('initial state respects HyttaHubOptions.defaultTheme', () {
      HyttaHubOptions.defaultTheme = ThemeMode.dark;
      final cubit = ThemeCubit('test_key');
      expect(cubit.state, ThemeMode.dark);
      cubit.close();
    });

    test('reset resets to HyttaHubOptions.defaultTheme if set', () {
      HyttaHubOptions.defaultTheme = ThemeMode.dark;
      final cubit = ThemeCubit('test_key');
      cubit.setTheme(ThemeMode.light);
      expect(cubit.state, ThemeMode.light);
      cubit.reset();
      expect(cubit.state, ThemeMode.dark);
      cubit.close();
    });

    test('reset resets to ThemeMode.system if HyttaHubOptions.defaultTheme is null', () {
      final cubit = ThemeCubit('test_key');
      cubit.setTheme(ThemeMode.dark);
      expect(cubit.state, ThemeMode.dark);
      cubit.reset();
      expect(cubit.state, ThemeMode.system);
      cubit.close();
    });

    test('fromJson falls back to HyttaHubOptions.defaultTheme on unknown/invalid value', () {
      HyttaHubOptions.defaultTheme = ThemeMode.light;
      final cubit = ThemeCubit('test_key');
      final restored = cubit.fromJson({'theme': 'unknown'});
      expect(restored, ThemeMode.light);
      cubit.close();
    });

    test('fromJson falls back to ThemeMode.system on unknown/invalid value if defaultTheme is null', () {
      final cubit = ThemeCubit('test_key');
      final restored = cubit.fromJson({'theme': 'invalid'});
      expect(restored, ThemeMode.system);
      cubit.close();
    });
  });
}
