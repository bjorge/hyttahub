// Copyright (c) 2025 bjorge

import 'package:hydrated_bloc/hydrated_bloc.dart';

enum AppLanguage { en, it, es }

class LanguageCubit extends HydratedCubit<AppLanguage> {
  LanguageCubit(this.storageKey) : super(AppLanguage.en);

  final String storageKey;

  void setLanguage(AppLanguage mode) => emit(mode);

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
      default:
        return AppLanguage.en;
    }
  }

  @override
  Map<String, dynamic> toJson(AppLanguage state) {
    return {'language': state.name};
  }
}
