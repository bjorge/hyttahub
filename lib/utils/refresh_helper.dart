import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'refresh_helper_stub.dart'
    if (dart.library.js_interop) 'refresh_helper_web.dart';

class RefreshHelper {
  static Future<void> refresh() async {
    await HydratedBloc.storage.clear();
    if (kIsWeb) {
      reloadPage();
    }
  }
}
