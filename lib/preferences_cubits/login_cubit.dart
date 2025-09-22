// Copyright (c) 2025 bjorge

import 'package:hydrated_bloc/hydrated_bloc.dart';

class CreateAccountCubit extends HydratedCubit<bool> {
  CreateAccountCubit() : super(true);

  void setCreateAccount(bool mode) => emit(mode);

  @override
  bool fromJson(Map<String, dynamic> json) {
    final value = json['create_account'] as bool?;
    return value ?? true; // Default to true if not set
  }

  @override
  Map<String, dynamic> toJson(bool state) {
    return {'create_account': state};
  }
}
