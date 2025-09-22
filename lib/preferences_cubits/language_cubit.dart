// Copyright (c) 2025 bjorge

import 'package:hydrated_bloc/hydrated_bloc.dart';

enum AppLanguage { en, it, es }

class LanguageCubit extends HydratedCubit<AppLanguage> {
  LanguageCubit() : super(AppLanguage.en);

  void setLanguage(AppLanguage mode) => emit(mode);

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
