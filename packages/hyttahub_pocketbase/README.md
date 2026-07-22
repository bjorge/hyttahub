# hyttahub_pocketbase

PocketBase persistence implementations for the `hyttahub` package.

## Features

Provides PocketBase-specific implementations for:
*   Authentication (`PocketbaseHyttaHubAuth`)
*   Storage (`PocketbaseHyttaHubStorage`)

## Usage

To use this package, create a `PocketBase` client and register the PocketBase persistence implementation with the `hyttahub` `PersistenceRegistry` before calling `initializeHyttaHub()`.

```dart
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hyttahub/hyttahub.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/utilities/persistence_registries.dart';

import 'package:hyttahub_pocketbase/pocketbase_hyttahub_auth.dart';
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
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Register the PocketBase implementation
  registerPersistence();

  // 2. Initialize the platform
  const storage = StorageEnum.cloud;
  await PersistenceRegistry.initializePlatform(storage);

  // 3. Initialize the core Hyttahub framework
  await initializeHyttaHub(
    implementation: HyttaHubImplementation(
      appBuildNumber: 1,
      cloudRootCollection: 'my_app',
      appId: 'com.example.myapp',
      storage: storage,
      implementationId: 'pocketbase',
    ),
    siteScreenRoute: (siteId) => SiteScreenRoute.fullPath(siteId),
  );

  runApp(const MyApp());
}
```

## Storage Implementation

`PocketbaseHyttaHubStorage` implements the core `BaseHyttaHubStorage` API, providing:

*   **Real-time Updates**: Uses PocketBase's Server-Sent Events (SSE) subscription API. 
*   **Batching**: Uses PocketBase's batch service (`createBatch()`) to process operations transactionally in a single HTTP batch request.
*   **File Storage**: Automatically handles site-specific shared assets. Each file is stored as a PocketBase record in a collection named `hyttahub__{appName}__sites__{siteId}__site_files`.
