import 'package:flutter/foundation.dart';
import 'refresh_helper_stub.dart'
    if (dart.library.js_interop) 'refresh_helper_web.dart';

class RefreshHelper {
  static Future<void> refresh() async {
    if (kIsWeb) {
      await reloadPage();
    }
  }
}
