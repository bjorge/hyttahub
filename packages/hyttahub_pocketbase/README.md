# hyttahub_pocketbase

PocketBase persistence implementations for the `hyttahub` package.

## Features

Provides PocketBase-specific implementations for:
*   Authentication (`PocketbaseHyttaHubAuth`)
*   Cloud Functions stub (`PocketbaseHyttaHubFunctions`)
*   Internal Storage stub (`PocketbaseHyttaHubInternalStorage`)
*   Document Storage (`PocketbaseHyttaHubStorage`)

## Usage

To use this package, create a `PocketBase` client and register the PocketBase
persistence implementation with the `hyttahub` `PersistenceRegistry` before
calling `initializeHyttaHub()`.

```dart
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hyttahub/hyttahub.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/utilities/persistence_registries.dart';

import 'package:hyttahub_pocketbase/pocketbase_hyttahub_auth.dart';
import 'package:hyttahub_pocketbase/pocketbase_hyttahub_functions.dart';
import 'package:hyttahub_pocketbase/pocketbase_hyttahub_internal_storage.dart';
import 'package:hyttahub_pocketbase/pocketbase_hyttahub_storage.dart';

void registerPersistence() {
  final pb = PocketBase('https://your-pocketbase-host.example.com');

  PersistenceRegistry.registerImplementation(
    HyttaHubImplementationDescriptor(
      id: 'pocketbase',
      name: 'PocketBase',
      type: StorageEnum.cloud,
      storageBuilder: () => PocketbaseHyttaHubStorage(client: pb),
      authBuilder: () => PocketbaseHyttaHubAuth(client: pb),
      functionsBuilder: () => PocketbaseHyttaHubFunctions(),
      internalStorageBuilder: () => PocketbaseHyttaHubInternalStorage(),
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Register the PocketBase implementation
  registerPersistence();

  // 2. Initialize the core Hyttahub framework
  await initializeHyttaHub(
    implementation: HyttaHubImplementation(
      appBuildNumber: 1,
      firebaseRootCollection: 'my_app',
      appId: 'com.example.myapp',
      storage: StorageEnum.cloud,
      implementationId: 'pocketbase',
    ),
    siteScreenRoute: (siteId) => SiteScreenRoute.fullPath(siteId),
  );

  runApp(const MyApp());
}
```

## File Storage

PocketBase stores files as fields on records, not in a separate blob store.
The default `PocketbaseHyttaHubStorage` and `PocketbaseHyttaHubInternalStorage`
throw `UnimplementedError` for all file-related methods.

To enable file support, extend the relevant class and implement the methods
against your own PocketBase file collection schema:

```dart
class MyPocketbaseStorage extends PocketbaseHyttaHubStorage {
  MyPocketbaseStorage({required super.client});

  @override
  Future<void> uploadFile({
    required String appName,
    required String siteId,
    required String fileName,
    required String base64Data,
  }) async {
    // Implement using your PocketBase file collection.
  }
}
```

## Server-side Functions

PocketBase has no built-in equivalent of Firebase Cloud Functions.
`PocketbaseHyttaHubFunctions` throws `UnimplementedError` for `copySite` and
`listSiteFiles`. Extend the class and call your PocketBase hooks or a custom
backend instead:

```dart
class MyPocketbaseFunctions extends PocketbaseHyttaHubFunctions {
  MyPocketbaseFunctions(this._pb);
  final PocketBase _pb;

  @override
  Future<Map<String, dynamic>> copySite({
    required String siteId,
    required String appName,
    int? upToVersion,
    String? mockUserEmail,
  }) async {
    final result = await _pb.send(
      '/api/my-hooks/copy-site',
      method: 'POST',
      body: {'siteId': siteId, 'appName': appName},
    );
    return Map<String, dynamic>.from(result as Map);
  }
}
```

## Real-time Updates

`listenCollection` and `listenEvents` use PocketBase's Server-Sent Events
(SSE) subscription API. Each stream seeds an initial value from a full
collection fetch, then re-fetches on every SSE event for consistency.

## Batching

PocketBase has no native batch/transaction API. `runBatch` accumulates
operations and executes them sequentially.
