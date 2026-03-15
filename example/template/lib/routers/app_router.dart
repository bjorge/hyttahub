// Copyright (c) 2025 bjorge

import 'package:template/l10n/app_localizations.dart';
import 'package:template/routers/app_routes.dart';
import 'package:hyttahub/hyttahub_app.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/common_widgets/common_form.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    // tell hyttahub how to route to the site screen for the app
    accountScreenRoute.routes.add(siteShellRoute);

    _router = GoRouter(
      initialLocation: LandingScreenRoute.fullPath,
      routes: <RouteBase>[landingScreenRoute],
      observers: [ClearSnackBarsObserver()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return HyttaHubApp(
      routerConfig: _router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
