// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:formproto/routers/app_routes.dart';
import 'package:formproto/routers/app_router.dart';
import 'package:formproto/firebase_options.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/hyttahub.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:flutter/foundation.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb
            ? HydratedStorageDirectory.web
            : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  const firebaseRootCollection = 'formproto';
  final savedPlatform = HydratedBloc.storage.read('PlatformCubit:platform:$firebaseRootCollection');
  final storage = savedPlatform != null 
    ? StorageEnum.valueOf(savedPlatform['platform'] as int) ?? StorageEnum.inMemory 
    : StorageEnum.inMemory;

  await initializeHyttaHub(
    implementation: HyttaHubImplementation(
      appBuildNumber: appBuildNumber,
      firebaseRootCollection: firebaseRootCollection,
      appId: 'hyttahub.example.formproto',
      storage: storage,
    ),
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
    siteScreenRoute: (siteId) => SiteScreenRoute.fullPath(siteId),
  );

  setupGetIt();

  runApp(const AppRouter());
}

