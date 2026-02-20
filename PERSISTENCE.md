## Persistence Registration

HyttaHub is persistence-agnostic and uses a dynamic registration system. This allows you to support multiple providers for the same storage type (e.g., both Firebase and Supabase for cloud storage) and switch between them at runtime.

In your application's `main.dart`, register your implementations using `PersistenceRegistry` before calling `initializeHyttaHub`:

```dart
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/utilities/persistence_registries.dart';

void registerPersistence() {
  // Register a cloud implementation
  PersistenceRegistry.registerImplementation(HyttaHubImplementationDescriptor(
    id: 'firebase',
    name: 'Firebase Cloud',
    type: StorageEnum.cloud,
    storageBuilder: () => FirestoreHyttaHubStorage(),
    authBuilder: () => FirebaseHyttaHubAuth(),
    functionsBuilder: () => FirebaseHyttaHubFunctions(),
    internalStorageBuilder: () => FirebaseHyttaHubInternalStorage(),
  ));

  // Register built-in providers (Memory/Local) to make them selectable in the UI
  PersistenceRegistry.registerImplementation(HyttaHubImplementationDescriptor(
    id: 'memory',
    name: 'In-Memory',
    type: StorageEnum.memory,
  ));

  PersistenceRegistry.registerImplementation(HyttaHubImplementationDescriptor(
    id: 'local',
    name: 'Local Storage',
    type: StorageEnum.local,
  ));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerPersistence();
  
  // Load saved implementation ID from storage or default to 'memory'
  final implementationId = 'memory'; 
  final descriptor = PersistenceRegistry.getImplementation(implementationId);

  await initializeHyttaHub(
    implementation: HyttaHubImplementation(
      storage: descriptor?.type ?? StorageEnum.memory,
      implementationId: implementationId,
      // ... other options
    ),
    // ...
  );
}
```

### How it Works:
- **Custom Builders**: If you provide `storageBuilder`, `authBuilder`, etc., the library will use your custom classes.
- **Built-in Fallbacks**: If you omit the builders (as shown in the 'memory' and 'local' examples above), the library falls back to its internal `InMemoryHyttaHubStorage` and `HydratedHyttaHubStorage` defaults based on the `StorageEnum` type.
- **Runtime Switching**: The `PlatformCubit` manages the active `implementationId`, allowing the user to switch providers through the `HyttaHubAppBarActions` picker.
