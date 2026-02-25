// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:template/routers/app_routes.dart';
import 'package:template/routers/app_router.dart';
import 'package:hyttahub/hyttahub.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/utilities/persistence_registries.dart';
import 'package:hyttahub_firebase/firebase_hyttahub_auth.dart';
import 'package:hyttahub_firebase/firebase_hyttahub_functions.dart';
import 'package:hyttahub_firebase/firestore_hyttahub_storage.dart';
import 'package:hyttahub_firebase/firebase_hyttahub_internal_storage.dart';
import 'package:template/firebase_options.dart';
import 'package:template/proto/app_events.pb.dart';
import 'package:template/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

String appVersion = "2.0.4";
int appBuildNumber = 78;


void registerPersistence() {
  PersistenceRegistry.registerImplementation(HyttaHubImplementationDescriptor(
    id: 'firebase',
    name: 'Firebase Cloud',
    type: StorageEnum.cloud,
    storageBuilder: () => FirestoreHyttaHubStorage(),
    authBuilder: () => FirebaseHyttaHubAuth(),
    functionsBuilder: () => FirebaseHyttaHubFunctions(),
    internalStorageBuilder: () => FirebaseHyttaHubInternalStorage(),
  ));

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

  PersistenceRegistry.onInitializePlatform = (storage) async {
    if (storage == StorageEnum.cloud) {
      if (Firebase.apps.isEmpty) {
        if (kDebugMode) {
          print('PersistenceRegistry: Initializing Firebase for firestore');
        }
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
        if (kDebugMode) {
          print('PersistenceRegistry: Firebase initialized');
        }
        FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
        if (kDebugMode) {
          final host = kIsWeb ? 'localhost' : (Platform.isAndroid ? '10.0.2.2' : '127.0.0.1');
          FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
          await FirebaseAuth.instance.useAuthEmulator(host, 9099);
          FirebaseStorage.instance.useStorageEmulator(host, 9199);
          FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
        }
      }
    }
  };
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerPersistence();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb
            ? HydratedStorageDirectory.web
            : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  const firebaseRootCollection = 'template';
  final savedPlatform = HydratedBloc.storage.read('PlatformCubit:persistence:$firebaseRootCollection');
  final implementationId = savedPlatform != null 
    ? savedPlatform['implementationId'] as String? ?? 'memory'
    : 'memory';
  
  final descriptor = PersistenceRegistry.getImplementation(implementationId);
  final storage = descriptor?.type ?? StorageEnum.memory;

  HyttaHubOptions.appTitle = "HyttaHub Template";
  HyttaHubOptions.appVersion = appVersion;
  HyttaHubOptions.appBuildNumber = appBuildNumber;

  HyttaHubOptions.appEventDescriptionBuilder = (context, siteEvent) {
    final localizations = AppLocalizations.of(context);
    if (!siteEvent.hasAppEvent()) return localizations?.app_appSpecificEvent ?? "App specific event";
    
    final appEvent = AppEvent.fromBuffer(siteEvent.appEvent.payload);
    if (localizations == null) return "App specific event";

    if (appEvent.hasUpdateText()) return localizations.app_eventUpdateText(appEvent.updateText.value);
    if (appEvent.hasUpdateCode()) return localizations.app_eventUpdateCode;
    if (appEvent.hasUpdateCheckbox()) return localizations.app_eventUpdateCheckbox(appEvent.updateCheckbox.value.toString());
    if (appEvent.hasUpdateDropdown()) return localizations.app_eventUpdateDropdown(appEvent.updateDropdown.value);
    if (appEvent.hasUpdateList()) return localizations.app_eventUpdateList;
    if (appEvent.hasUpdatePhoto()) return localizations.app_eventUpdatePhoto(appEvent.updatePhoto.name);
    if (appEvent.hasRemovePhoto()) return localizations.app_eventRemovePhoto;
    
    return localizations.app_appSpecificEvent;
  };

  await PersistenceRegistry.initializePlatform(storage);

  await initializeHyttaHub(
    implementation: HyttaHubImplementation(
      appBuildNumber: appBuildNumber,
      firebaseRootCollection: firebaseRootCollection,
      appId: 'hyttahub.example.template',
      storage: storage,
      implementationId: implementationId,
    ),
    siteScreenRoute: (siteId) => SiteScreenRoute.fullPath(siteId),
  );



  runApp(const AppRouter());
}

