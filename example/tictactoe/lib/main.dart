// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:tictactoe/routers/app_routes.dart';
import 'package:tictactoe/routers/app_router.dart';
import 'package:tictactoe/firebase_options.dart';
import 'package:hyttahub/hyttahub.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/utilities/persistence_registries.dart';
import 'package:hyttahub_firebase/firebase_hyttahub_auth.dart';
import 'package:hyttahub_firebase/firebase_hyttahub_functions.dart';
import 'package:hyttahub_firebase/firestore_hyttahub_storage.dart';
import 'package:hyttahub_firebase/firebase_hyttahub_internal_storage.dart';
import 'package:tictactoe/proto/app_events.pb.dart';
import 'package:tictactoe/l10n/app_localizations.dart';
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

String appVersion = "2.0.5";
int appBuildNumber = 79;


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

  const firebaseRootCollection = 'tictactoe';
  final savedPlatform = HydratedBloc.storage.read('PlatformCubit:persistence:$firebaseRootCollection');
  final implementationId = savedPlatform != null 
    ? savedPlatform['implementationId'] as String? ?? 'memory'
    : 'memory';
  
  final descriptor = PersistenceRegistry.getImplementation(implementationId);
  final storage = descriptor?.type ?? StorageEnum.memory;

  HyttaHubOptions.appTitle = "Tic-Tac-Toe";
  HyttaHubOptions.appVersion = appVersion;
  HyttaHubOptions.appBuildNumber = appBuildNumber;

  HyttaHubOptions.appEventDescriptionBuilder = (context, siteEvent) {
    if (!siteEvent.hasAppEvent()) return "App specific event";
    
    final appEvent = AppEvent.fromBuffer(siteEvent.appEvent.payload);
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return "App specific event";

    if (appEvent.hasMove()) return localizations.app_eventMove(appEvent.move.player, appEvent.move.x, appEvent.move.y);
    if (appEvent.hasStartGame()) return localizations.app_eventStartGame(appEvent.startGame.vsBot.toString());
    if (appEvent.hasPlayAgain()) return localizations.app_eventPlayAgain;
    
    return "App specific event";
  };

  await PersistenceRegistry.initializePlatform(storage);

  await initializeHyttaHub(
    implementation: HyttaHubImplementation(
      storage: storage,
      implementationId: implementationId,
      appBuildNumber: appBuildNumber,
      appId: 'hyttahub.example.tictactoe',
      firebaseRootCollection: firebaseRootCollection,
    ),
    siteScreenRoute: (siteId) => SiteScreenRoute.fullPath(siteId),
  );



  runApp(const AppRouter());
}

