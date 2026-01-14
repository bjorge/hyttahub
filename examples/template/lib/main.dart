// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:template/routers/app_routes.dart';
import 'package:template/routers/app_router.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/hyttahub.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:template/firebase_options.dart';
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

  await initializeHyttaHub(
    implementation: HyttaHubImplementation(
      appBuildNumber: appBuildNumber,
      firebaseRootCollection: 'template',
      appId: 'hyttahub.example.template',
      storage: StorageEnum.inMemory,
    ),
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
    siteScreenRoute: (siteId) => SiteScreenRoute.fullPath(siteId),
  );

  setupGetIt();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb
            ? HydratedStorageDirectory.web
            : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  runApp(const AppRouter());
}

