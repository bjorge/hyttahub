// Copyright (c) 2025 bjorge

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';

/// Initializes HyttaHub with the provided [implementation] and optional [firebaseOptions].
///
/// This function handles Firebase initialization if [StorageEnum.firestore] is used,
/// and sets up emulators in debug mode.
Future<void> initializeHyttaHub({
  required HyttaHubImplementation implementation,
  FirebaseOptions? firebaseOptions,
  BaseSiteRoutePath? siteScreenRoute,
}) async {
  HyttaHubOptions.implementation = implementation;
  if (siteScreenRoute != null) {
    HyttaHubOptions.siteScreenRoute = siteScreenRoute;
  }

  if (implementation.storage == StorageEnum.firestore && firebaseOptions == null) {
    throw ArgumentError('FirebaseOptions must be provided when using StorageEnum.firestore');
  }

  if (firebaseOptions != null) {
    if (implementation.storage == StorageEnum.firestore && implementation.disableFirestoreCache) {
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: false,
      );
    }

    await Firebase.initializeApp(options: firebaseOptions);

    if (kDebugMode) {
      final host = getEmulatorHost();
      FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
      await FirebaseAuth.instance.useAuthEmulator(host, 9099);
      FirebaseStorage.instance.useStorageEmulator(host, 9199);
      FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
    }
  }
}

/// Helper to get the emulator host based on the platform.
String getEmulatorHost() {
  if (kIsWeb) {
    return 'localhost';
  } else if (Platform.isAndroid) {
    return '10.0.2.2';
  } else {
    // iOS Simulator, macOS, etc.
    return '127.0.0.1';
  }
}
