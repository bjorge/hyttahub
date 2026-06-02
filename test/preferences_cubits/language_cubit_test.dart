// Copyright (c) 2025 bjorge

import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/preferences_cubits/language_cubit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

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
  group('LanguageCubit', () {
    setUp(() {
      HydratedBloc.storage = MockStorage();
      HyttaHubOptions.defaultLanguage = null;
    });

    test('initial state defaults to English when options default is null', () {
      final cubit = LanguageCubit('test_key');
      expect(cubit.state, AppLanguage.en);
      cubit.close();
    });

    test('initial state respects HyttaHubOptions.defaultLanguage', () {
      HyttaHubOptions.defaultLanguage = AppLanguage.nb;
      final cubit = LanguageCubit('test_key');
      expect(cubit.state, AppLanguage.nb);
      cubit.close();
    });

    test('reset resets to HyttaHubOptions.defaultLanguage if set', () {
      HyttaHubOptions.defaultLanguage = AppLanguage.es;
      final cubit = LanguageCubit('test_key');
      cubit.setLanguage(AppLanguage.nl);
      expect(cubit.state, AppLanguage.nl);
      cubit.reset();
      expect(cubit.state, AppLanguage.es);
      cubit.close();
    });

    test('reset resets to English if HyttaHubOptions.defaultLanguage is null', () {
      final cubit = LanguageCubit('test_key');
      cubit.setLanguage(AppLanguage.nl);
      expect(cubit.state, AppLanguage.nl);
      cubit.reset();
      expect(cubit.state, AppLanguage.en);
      cubit.close();
    });

    test('fromJson falls back to HyttaHubOptions.defaultLanguage on unknown/invalid value', () {
      HyttaHubOptions.defaultLanguage = AppLanguage.it;
      final cubit = LanguageCubit('test_key');
      final restored = cubit.fromJson({'language': 'unknown'});
      expect(restored, AppLanguage.it);
      cubit.close();
    });

    test('fromJson falls back to English on unknown/invalid value if defaultLanguage is null', () {
      final cubit = LanguageCubit('test_key');
      final restored = cubit.fromJson({'language': 'invalid'});
      expect(restored, AppLanguage.en);
      cubit.close();
    });
  });
}
