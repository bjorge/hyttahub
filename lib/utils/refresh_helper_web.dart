import 'dart:js_interop';

@JS()
external JSWindow get window;

@JS()
external JSNavigator get navigator;

@JS('Window')
extension type JSWindow(JSObject _) implements JSObject {
  external JSLocation get location;
  external JSCacheStorage? get caches;
}

@JS('Location')
extension type JSLocation(JSObject _) implements JSObject {
  external String get href;
  external set href(String value);
}

@JS('Navigator')
extension type JSNavigator(JSObject _) implements JSObject {
  external JSServiceWorkerContainer? get serviceWorker;
}

@JS('ServiceWorkerContainer')
extension type JSServiceWorkerContainer(JSObject _) implements JSObject {
  external JSPromise<JSArray<JSServiceWorkerRegistration>> getRegistrations();
}

@JS('ServiceWorkerRegistration')
extension type JSServiceWorkerRegistration(JSObject _) implements JSObject {
  external JSPromise<JSBoolean> unregister();
}

@JS('CacheStorage')
extension type JSCacheStorage(JSObject _) implements JSObject {
  external JSPromise<JSArray<JSString>> keys();
  @JS('delete')
  external JSPromise<JSBoolean> deleteCache(JSString cacheName);
}

Future<void> reloadPage() async {
  // 1. Unregister all service workers to ensure the next load doesn't use an old SW
  final sw = navigator.serviceWorker;
  if (sw != null) {
    try {
      final regs = await sw.getRegistrations().toDart;
      final registrations = regs.toDart;
      for (final registration in registrations) {
        await registration.unregister().toDart;
      }
    } catch (_) {
      // Ignore errors during SW unregistration
    }
  }

  // 2. Clear all named caches in the Cache API storage
  final caches = window.caches;
  if (caches != null) {
    try {
      final ks = await caches.keys().toDart;
      final keys = ks.toDart;
      for (final key in keys) {
        await caches.deleteCache(key).toDart;
      }
    } catch (_) {
      // Ignore errors during cache clearing
    }
  }

  // 3. Reload with a unique query string parameter to bypass browser/CDN caches
  final location = window.location;
  final uri = Uri.parse(location.href);
  final newParams = Map<String, String>.from(uri.queryParameters);
  newParams['v'] = DateTime.now().millisecondsSinceEpoch.toString();

  location.href = uri.replace(queryParameters: newParams).toString();
}
