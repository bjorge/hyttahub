// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:io';

import 'package:albums/app_blocs/app_replay.dart';
import 'package:albums/routers/app_routes.dart';
import 'package:albums/routers/app_router.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:albums/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:path_provider/path_provider.dart';

String appVersion = "2.0.4";
int appBuildNumber = 78;

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<AuthBloc>(() => AuthBloc());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HyttaHubOptions.siteScreenRoute = (siteId) {
    return SiteScreenRoute.fullPath(siteId);
  };

  HyttaHubOptions.appBuildNumber = appBuildNumber;

  HyttaHubOptions.appReplay = (siteReplay, event) {
    return appReplay(siteReplay, event);
  };

  HyttaHubOptions.firebaseRootCollection =
      'albums'; // the appName, do not change
  HyttaHubOptions.appId = 'hyttahub.example.album'; // do not change

  setupGetIt();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kDebugMode) {
    final host = getEmulatorHost();
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    await FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseStorage.instance.useStorageEmulator(host, 9199);
    FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
  }

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb
            ? HydratedStorageDirectory.web
            : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  runApp(const AppRouter());
}

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
