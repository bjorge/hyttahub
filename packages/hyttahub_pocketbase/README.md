# hyttahub_pocketbase

PocketBase persistence implementations for the `hyttahub` package.

## Features

Provides PocketBase-specific implementations for:
*   Authentication (`PocketbaseHyttaHubAuth`)
*   Document Storage (`PocketbaseHyttaHubStorage`)
*   File Storage (implemented in `PocketbaseHyttaHubStorage`)
*   Server-side Functions (partially implemented in `PocketbaseHyttaHubFunctions`)
*   Internal Storage stub (`PocketbaseHyttaHubInternalStorage`)

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
      functionsBuilder: () => PocketbaseHyttaHubFunctions(client: pb),
      internalStorageBuilder: () => PocketbaseHyttaHubInternalStorage(),
    ),
  );
}

Future<void> main() async {
  // ... standard Flutter/HyttaHub initialization
}
```

## File Storage (Site Files)

`PocketbaseHyttaHubStorage` implements the core "Site Files" API. This is used for
assets that belong to a site (like photos) and are shared among members.

*   **Implementation**: Uses a naming convention: `hyttahub__{appName}__sites__{siteId}__site_files`.
*   **Storage**: Each file is one PocketBase record; `doc_id` is the filename, and `file` is the binary field.

## Internal Storage (Generic Blobs)

`PocketbaseHyttaHubInternalStorage` is a separate, low-level interface for
generic blob storage (similar to S3/Firebase Storage).

*   **When to implement**: Only if your app needs to store arbitrary data blobs
    that don't belong to a specific HyttaHub site.
*   **Why it's a stub**: PocketBase requires every file to be a field on a record.
    Since we can't guess your schema for generic paths, this is left for you to
    override if needed.
*   **Is it needed?**: For standard HyttaHub site features (sharing photos/events),
    **no**. You only need `PocketbaseHyttaHubStorage`.

## Server-side Functions

`PocketbaseHyttaHubFunctions` provides a client-side implementation for:
*   `listSiteFiles`: Fetches file metadata from the `site_files` collection.

`copySite` throws `UnimplementedError` by default as it typically requires
a custom backend or PocketBase hook to handle recursive collection cloning.

To implement custom function logic:

```dart
class MyPocketbaseFunctions extends PocketbaseHyttaHubFunctions {
  MyPocketbaseFunctions({required super.client});

  @override
  Future<Map<String, dynamic>> copySite({
    required String siteId,
    required String appName,
    int? upToVersion,
    String? mockUserEmail,
  }) async {
    final result = await client.send(
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
