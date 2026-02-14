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
import 'package:hyttahub/utilities/common_error_handling.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:template/routers/landing.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:template/app_blocs/app_replay_bloc.dart';
import 'package:hyttahub/common_blocs/allowed_emails_bloc.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

final siteShellRoute = ShellRoute(
  builder: (context, state, child) {
    final siteId = state.pathParameters['siteId'] ?? '';
    return MultiBlocProvider(
      providers: [
        BlocProvider<SiteReplayBloc>(
          key: Key('SiteReplayBloc-albums-$siteId'),
          create: (_) => SiteReplayBloc(siteId)..add(CommonReplayBlocEvent(listen: true)),
        ),
        BlocProvider<AppReplayBloc>(
          key: Key('AppReplayBloc-albums-$siteId'),
          create: (_) => AppReplayBloc(siteId)..add(CommonReplayBlocEvent(listen: true)),
        ),
        BlocProvider<SiteAllowedEmailsBloc>(
          key: Key('SiteAllowedEmailsBloc-site-shell-$siteId'),
          create: (_) => SiteAllowedEmailsBloc(firebaseSiteUsersPath(siteId))..add(
            AllowedEmailsBlocEvent(
              fetchNow: AllowedEmailsBlocEvent_FetchedAllowedEmails(),
            ),
          ),
        ),
      ],
      child: BlocBuilder<SiteAllowedEmailsBloc, AllowedEmailsBlocState>(
        builder: (context, allowedEmailsState) {
          final allowedEmailsErrorWidget =
              handleAllowedEmailsState(context, allowedEmailsState);
          if (allowedEmailsErrorWidget != null) {
            return allowedEmailsErrorWidget;
          }

          return BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
            builder: (context, siteState) {
              final errorWidget = handleSiteReplayState(context, siteState);
              if (errorWidget != null) {
                return errorWidget;
              }
              return child;
            },
          );
        },
      ),
    );
  },
  routes: [siteScreenRoute],
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
    serviceShellRoute,
    HyttaHubRoutes.openSourceLicensesRoute,
  ],
);
