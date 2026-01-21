// Copyright (c) 2025 bjorge

import 'package:template/app_widgets/site_screen.dart';
import 'package:template/app_widgets/photo_upload_screen.dart';
import 'package:template/app_widgets/app_events_display.dart';
import 'package:template/app_widgets/update_text_screen.dart';
import 'package:template/app_widgets/update_code_screen.dart';
import 'package:template/app_widgets/update_checkbox_screen.dart';
import 'package:template/app_widgets/update_dropdown_screen.dart';
import 'package:template/app_widgets/update_list_screen.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:template/routers/landing.dart';

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

class UpdateTextRoute extends GoRoute {
  UpdateTextRoute({required super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          final event = state.uri.queryParameters['event'] ?? '';
          return UpdateTextScreen(
            key: Key('updateText:$siteId'),
            siteId: siteId,
            event: event,
          );
        },
      );
  static const String pathSegment = 'update-text';
  static String fullPath(String siteId) =>
      '${SiteScreenRoute.fullPath(siteId)}/$pathSegment';
}

class UpdateCodeRoute extends GoRoute {
  UpdateCodeRoute({required super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          final event = state.uri.queryParameters['event'] ?? '';
          return UpdateCodeScreen(
            key: Key('updateCode:$siteId'),
            siteId: siteId,
            event: event,
          );
        },
      );
  static const String pathSegment = 'update-code';
  static String fullPath(String siteId) =>
      '${SiteScreenRoute.fullPath(siteId)}/$pathSegment';
}

class UpdateCheckboxRoute extends GoRoute {
  UpdateCheckboxRoute({required super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          final event = state.uri.queryParameters['event'] ?? '';
          return UpdateCheckboxScreen(
            key: Key('updateCheckbox:$siteId'),
            siteId: siteId,
            event: event,
          );
        },
      );
  static const String pathSegment = 'update-checkbox';
  static String fullPath(String siteId) =>
      '${SiteScreenRoute.fullPath(siteId)}/$pathSegment';
}

class UpdateDropdownRoute extends GoRoute {
  UpdateDropdownRoute({required super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          final event = state.uri.queryParameters['event'] ?? '';
          return UpdateDropdownScreen(
            key: Key('updateDropdown:$siteId'),
            siteId: siteId,
            event: event,
          );
        },
      );
  static const String pathSegment = 'update-dropdown';
  static String fullPath(String siteId) =>
      '${SiteScreenRoute.fullPath(siteId)}/$pathSegment';
}

class UpdateListRoute extends GoRoute {
  UpdateListRoute({required super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          final event = state.uri.queryParameters['event'] ?? '';
          return UpdateListScreen(
            key: Key('updateList:$siteId'),
            siteId: siteId,
            event: event,
          );
        },
      );
  static const String pathSegment = 'update-list';
  static String fullPath(String siteId) =>
      '${SiteScreenRoute.fullPath(siteId)}/$pathSegment';
}

/// A route for the add photo screen.
class AddPhotoRoute extends GoRoute {
  /// Creates a [AddPhotoRoute].
  AddPhotoRoute({required super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          final event = state.uri.queryParameters['event'] ?? '';

          return PhotoUploadScreen(
            key: Key('photoUpload:$siteId'),
            siteId: siteId,
            event: event,
          );
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'add-photo';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId}) =>
      '${SiteScreenRoute.fullPath(siteId)}/$pathSegment';
}

final addPhotoRoute = AddPhotoRoute(routes: []);
final updateTextRoute = UpdateTextRoute(routes: []);
final updateCodeRoute = UpdateCodeRoute(routes: []);
final updateCheckboxRoute = UpdateCheckboxRoute(routes: []);
final updateDropdownRoute = UpdateDropdownRoute(routes: []);
final updateListRoute = UpdateListRoute(routes: []);
final appEventsDisplayRoute = AppEventsDisplayRoute();


final siteScreenRoute = SiteScreenRoute(
  routes: [
    addPhotoRoute,
    updateTextRoute,
    updateCodeRoute,
    updateCheckboxRoute,
    updateDropdownRoute,
    updateListRoute,
    appEventsDisplayRoute,
    ...standardSiteScreenRoutes,
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
    ServiceNewVersionRoute(),
    ServiceDownRoute(),
    landingUnimplementedRoute,
  ],
);
