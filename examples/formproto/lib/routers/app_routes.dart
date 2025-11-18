// Copyright (c) 2025 bjorge

import 'package:formproto/app_widgets/site_screen.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:formproto/routers/landing.dart';

/// A route for the site screen.
class SiteScreenRoute extends GoRoute {
  /// Creates a [SiteScreenRoute].
  SiteScreenRoute({required super.routes})
      : super(
          path: pathSegment,
          builder: (BuildContext context, GoRouterState state) {
            final siteId = state.pathParameters['siteId'] ?? '';

            return SiteScreen(key: Key('siteScreen:$siteId'), siteId: siteId);
          },
        );

  /// The path segment for this route.
  static const String pathSegment = 'site/:siteId';

  /// A builder for the full path to this route.
  static String fullPath(String siteId) =>
      '${AccountScreenRoute.fullPath}/site/$siteId';
}

final siteScreenRoute = SiteScreenRoute(
  routes: [],
);

/// A route for the landing page.
class LandingScreenRoute extends GoRoute {
  /// Creates a [LandingScreenRoute].
  LandingScreenRoute({required super.routes})
      : super(
          path: pathSegment,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return const MaterialPage(
              key: ValueKey('landingPage'),
              child: LandingPage(),
            );
          },
        );

  /// The path segment for this route.
  static const String pathSegment = '/';

  /// The full path to this route.
  static const String fullPath = pathSegment;
}

final landingScreenRoute = LandingScreenRoute(
  routes: [
    loginScreenRoute,
    serviceLoginScreenRoute,
    landingUnimplementedRoute,
  ],
);
