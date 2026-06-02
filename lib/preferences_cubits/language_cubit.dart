// Copyright (c) 2025 bjorge

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hyttahub/hyttahub_options.dart';

enum AppLanguage { en, it, es, nb, nl }

class LanguageCubit extends HydratedCubit<AppLanguage> {
  LanguageCubit(this.storageKey) : super(HyttaHubOptions.defaultLanguage ?? AppLanguage.en);

  final String storageKey;

  void setLanguage(AppLanguage mode) => emit(mode);

  void reset() => emit(HyttaHubOptions.defaultLanguage ?? AppLanguage.en);

  // for hydrated storage
  @override
  String get id => ':$storageKey';

  @override
  AppLanguage fromJson(Map<String, dynamic> json) {
    final value = json['language'] as String?;
    switch (value) {
      case 'en':
        return AppLanguage.en;
      case 'it':
        return AppLanguage.it;
      case 'es':
        return AppLanguage.es;
      case 'nb':
        return AppLanguage.nb;
      case 'nl':
        return AppLanguage.nl;
      default:
        return HyttaHubOptions.defaultLanguage ?? AppLanguage.en;
    }
  }

  @override
  Map<String, dynamic> toJson(AppLanguage state) {
    return {'language': state.name};
  }
}
