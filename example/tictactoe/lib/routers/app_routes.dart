// Copyright (c) 2025 bjorge

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:hyttahub/common_blocs/allowed_emails_bloc.dart';
import 'package:hyttahub/site_widgets/site_edit_mode_cubit.dart';
import 'package:hyttahub/utilities/common_error_handling.dart';
import 'package:tictactoe/app_blocs/app_replay_bloc.dart';
import 'package:tictactoe/app_widgets/app_events_display.dart';
import 'package:tictactoe/app_widgets/site_screen.dart';
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
final openSourceLicensesRoute = OpenSourceLicensesRoute();


final siteScreenRoute = SiteScreenRoute(
  routes: [...standardSiteScreenRoutes, appEventsDisplayRoute],
);

final siteShellRoute = ShellRoute(
  builder: (context, state, child) {
    final siteId = state.pathParameters['siteId'] ?? '';
    return MultiBlocProvider(
      providers: [
        BlocProvider<SiteReplayBloc>(
          key: Key('SiteReplayBloc-tictactoe-$siteId'),
          create: (_) => SiteReplayBloc(siteId)..add(CommonReplayBlocEvent(listen: true)),
        ),
        BlocProvider<AppReplayBloc>(
          key: Key('AppReplayBloc-tictactoe-$siteId'),
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
        BlocProvider<SiteEditModeCubit>(create: (_) => SiteEditModeCubit()),
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
              final errorWidget = handleSiteReplayState(context, siteState, siteId);
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
    serviceUserProviderShellRoute,
    openSourceLicensesRoute,
    landingInfoPageRoute,
  ],
);
