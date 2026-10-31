// Copyright (c) 2025 bjorge

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/preferences_cubits/language_cubit.dart';

void main() {
  test('every AppLanguage has a supported locale and loads', () async {
    for (final lang in AppLanguage.values) {
      final locale = Locale(lang.name);
      expect(
        HyttaHubLocalizations.supportedLocales.contains(locale),
        isTrue,
        reason: 'AppLanguage.${lang.name} is not in supportedLocales',
      );
      expect(HyttaHubLocalizations.delegate.isSupported(locale), isTrue,
          reason: '${lang.name} not supported by delegate');
      final l10n = await HyttaHubLocalizations.delegate.load(locale);
      expect(l10n.loginEmailLabel, isNotEmpty);
    }
    expect(AppLanguage.values.map((l) => l.name).toList(),
        ['en', 'it', 'es', 'ca', 'pt', 'nb', 'nl']);
  });

  test('catalan strings are Catalan', () async {
    final ca = await HyttaHubLocalizations.delegate.load(const Locale('ca'));
    expect(ca.loginEmailLabel, 'Correu electrònic');
    expect(ca.catalan, 'Català');
    expect(ca.portuguese, 'Portuguès');
    expect(ca.cancelButton, 'Cancel·la');
  });

  test('portuguese strings are Portuguese', () async {
    final pt = await HyttaHubLocalizations.delegate.load(const Locale('pt'));
    expect(pt.loginEmailLabel, 'E-mail');
    expect(pt.catalan, 'Catalão');
    expect(pt.portuguese, 'Português');
    expect(pt.cancelButton, 'Cancelar');
  });

  test('pt-BR and pt-PT both resolve to pt', () {
    const supported = HyttaHubLocalizations.supportedLocales;
    for (final device in [const Locale('pt', 'BR'), const Locale('pt', 'PT')]) {
      final resolved = basicLocaleListResolution([device], supported);
      expect(resolved, const Locale('pt'),
          reason: '$device should fall back to pt');
    }
  });

  test('placeholder substitution works in the new locales', () async {
    final ca = await HyttaHubLocalizations.delegate.load(const Locale('ca'));
    final pt = await HyttaHubLocalizations.delegate.load(const Locale('pt'));
    expect(ca.eventSiteCreated('Cabana'), contains('Cabana'));
    expect(pt.eventSiteCreated('Cabana'), contains('Cabana'));
    expect(ca.userId(7), contains('7'));
    expect(pt.userId(7), contains('7'));
  });

  test('language cubit round-trips the new codes', () {
    HydratedBloc.storage = _MemStorage();
    final cubit = LanguageCubit('tmp');
    for (final lang in [AppLanguage.ca, AppLanguage.pt]) {
      expect(cubit.toJson(lang), {'language': lang.name});
      expect(cubit.fromJson({'language': lang.name}), lang);
    }
    cubit.close();
  });
}

class _MemStorage implements Storage {
  final _data = <String, dynamic>{};
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
