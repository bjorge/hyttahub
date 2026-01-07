// Copyright (c) 2025 bjorge

import 'package:tictactoe/app_widgets/site_screen.dart';
import 'package:tictactoe/app_widgets/app_events_display.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe/routers/landing.dart';

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

/// A route for the app events display screen.
class AppEventsDisplayRoute extends GoRoute {
  /// Creates an [AppEventsDisplayRoute].
  AppEventsDisplayRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          return AppEventsDisplayScreen(siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'app_events_display';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId}) =>
      '${SiteScreenRoute.fullPath(siteId)}/$pathSegment';
}

final appEventsDisplayRoute = AppEventsDisplayRoute();


final siteScreenRoute = SiteScreenRoute(
  routes: [
    ...standardSiteScreenRoutes,
    appEventsDisplayRoute,
  ],
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
