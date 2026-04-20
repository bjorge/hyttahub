import 'renderer_detection_stub.dart'
    if (dart.library.js_interop) 'renderer_detection_web.dart';

String? get getWebRenderer => webRenderer;
String? get getWebBrowser => webBrowser;
