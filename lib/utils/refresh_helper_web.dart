import 'dart:js_interop';

@JS('window.location.reload')
external void reload();

void reloadPage() {
  reload();
}
