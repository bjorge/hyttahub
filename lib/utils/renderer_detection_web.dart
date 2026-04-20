import 'dart:js_interop';

@JS()
external JSWindow get window;

@JS('Window')
extension type JSWindow(JSObject _) implements JSObject {
  external JSDocument get document;
  external JSNavigator get navigator;
}

@JS('Document')
extension type JSDocument(JSObject _) implements JSObject {
  external JSElement? get body;
}

@JS('Element')
extension type JSElement(JSObject _) implements JSObject {
  external String? getAttribute(String name);
}

@JS('Navigator')
extension type JSNavigator(JSObject _) implements JSObject {
  external String get userAgent;
}

String? get webRenderer {
  final renderer = window.document.body?.getAttribute('flt-renderer');
  if (renderer == 'html') return 'JS';
  return renderer;
}

String? get webBrowser {
  final ua = window.navigator.userAgent.toLowerCase();
  if (ua.contains('chrome') && !ua.contains('edg/') && !ua.contains('opr/')) {
    return 'chrome';
  }
  return 'non-chrome';
}
