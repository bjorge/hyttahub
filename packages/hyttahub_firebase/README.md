# hyttahub_firebase

Firebase core persistence implementations for the `hyttahub` package.

## Features

Provides Firebase-specific implementations for:
*   Authentication (`FirebaseHyttaHubAuth`)
*   Cloud Functions (`FirebaseHyttaHubFunctions`)
*   Cloud Storage (`FirebaseHyttaHubInternalStorage`)
*   Firestore (`FirestoreHyttaHubStorage`)

## Usage

Use alongside the `hyttahub` base package to back your applications with Google Firebase.

```dart
import 'package:hyttahub_firebase/firebase_hyttahub_auth.dart';
import 'package:hyttahub_firebase/firestore_hyttahub_storage.dart';
// ... etc
```
