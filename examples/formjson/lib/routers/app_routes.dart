// Copyright (c) 2025 bjorge

import 'package:flutter/material.dart';
import 'package:formjson/app_widgets/site_screen.dart';
import 'package:formjson/app_widgets/site_screen_form.dart';
import 'package:formjson/routers/landing.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';

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

/// A route for the site screen.
class SiteScreenFormRoute extends GoRoute {
  /// Creates a [SiteScreenFormRoute].
  SiteScreenFormRoute({required super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          final event = state.uri.queryParameters['event'] ?? '';

          return SiteScreenForm(
            key: Key('siteScreen:$siteId'),
            siteId: siteId,
            event: event,
          );
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'update';

  /// A builder for the full path to this route.
  static String fullPath(String siteId) =>
      '${SiteScreenRoute.fullPath(siteId)}/update';
}

final siteScreenFormRoute = SiteScreenFormRoute(routes: []);

final renameSiteRoute = RenameSiteRoute();
final exportSiteRoute = ExportSiteRoute();
final manageExportsRoute = ManageExportsRoute();
final siteMembersRoute = SiteMembersRoute();
final displaySiteRoute = SiteEventsDisplayRoute();
final siteEmailsDisplayRoute = SiteEmailsDisplayRoute();

final siteScreenRoute = SiteScreenRoute(
  routes: [
    siteScreenFormRoute,
    renameSiteRoute,
    exportSiteRoute,
    manageExportsRoute,
    siteMembersRoute,
    displaySiteRoute,
    siteEmailsDisplayRoute,
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
