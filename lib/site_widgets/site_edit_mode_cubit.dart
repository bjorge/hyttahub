// Copyright (c) 2025 bjorge

import 'package:bloc/bloc.dart';

class SiteEditModeCubit extends Cubit<bool?> {
  SiteEditModeCubit() : super(null);

  bool isEditModeConfigured() {
    return state != null;
  }

  void editModeOn() {
    emit(true);
  }

  void editModeOff() {
    emit(false);
  }

  void editModeClear() {
    emit(null);
  }
}
