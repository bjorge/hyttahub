// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:template/routers/app_routes.dart';
import 'package:template/routers/app_router.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/hyttahub.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/utilities/persistence_registries.dart';
import 'package:template/persistence/firebase_hyttahub_auth.dart';
import 'package:template/persistence/firebase_hyttahub_functions.dart';
import 'package:template/persistence/firestore_hyttahub_storage.dart';
import 'package:template/persistence/local_storage_hyttahub_auth.dart';
import 'package:template/persistence/sembast_hyttahub_storage.dart';
import 'package:template/persistence/firebase_hyttahub_internal_storage.dart';
import 'package:template/persistence/sembast_hyttahub_internal_storage.dart';
import 'package:template/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

String appVersion = "2.0.4";
int appBuildNumber = 78;

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<AuthBloc>(() => AuthBloc());
}

void registerPersistence() {
  PersistenceRegistry.registerStorage(StorageEnum.firestore, () => FirestoreHyttaHubStorage());
  PersistenceRegistry.registerStorage(StorageEnum.localStorage, () => SembastHyttaHubStorage());
  
  PersistenceRegistry.registerAuth(StorageEnum.firestore, () => FirebaseHyttaHubAuth());
  PersistenceRegistry.registerAuth(StorageEnum.localStorage, () => LocalStorageHyttaHubAuth());
  
  PersistenceRegistry.registerFunctions(StorageEnum.firestore, () => FirebaseHyttaHubFunctions());

  PersistenceRegistry.registerInternalStorage(StorageEnum.firestore, () => FirebaseHyttaHubInternalStorage());
  PersistenceRegistry.registerInternalStorage(StorageEnum.localStorage, () => SembastHyttaHubInternalStorage());

  PersistenceRegistry.onInitializePlatform = (storage) async {
    if (storage == StorageEnum.firestore) {
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
  final savedPlatform = HydratedBloc.storage.read('PlatformCubit:platform:$firebaseRootCollection');
  final storage = savedPlatform != null 
    ? StorageEnum.valueOf(savedPlatform['platform'] as int) ?? StorageEnum.inMemory 
    : StorageEnum.inMemory;

  HyttaHubOptions.appTitle = "HyttaHub Template";
  HyttaHubOptions.appVersion = appVersion;
  HyttaHubOptions.appBuildNumber = appBuildNumber;

  await PersistenceRegistry.initializePlatform(storage);

  await initializeHyttaHub(
    implementation: HyttaHubImplementation(
      appBuildNumber: appBuildNumber,
      firebaseRootCollection: firebaseRootCollection,
      appId: 'hyttahub.example.template',
      storage: storage,
    ),
    siteScreenRoute: (siteId) => SiteScreenRoute.fullPath(siteId),
  );

  setupGetIt();

  runApp(const AppRouter());
}

