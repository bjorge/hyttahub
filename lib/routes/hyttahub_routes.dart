// Copyright (c) 2025 bjorge

import 'package:hyttahub/account_widgets/account_events_display.dart';
import 'package:hyttahub/account_widgets/account_screen.dart';
import 'package:hyttahub/account_widgets/remove_account_screen.dart';
import 'package:hyttahub/account_widgets/add_site_screen.dart';
import 'package:hyttahub/account_widgets/join_site_screen.dart';
import 'package:hyttahub/account_widgets/manage_sites_screen.dart';
import 'package:hyttahub/account_widgets/leave_site_screen.dart';
import 'package:hyttahub/common_widgets/unimplemented_screen.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/auth_bloc.pb.dart';
import 'package:hyttahub/service_widgets/service_events_display.dart';
import 'package:hyttahub/service_widgets/service_privacy_display.dart';
import 'package:hyttahub/service_widgets/service_settings_form.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/service_widgets/add_admin_screen.dart';
import 'package:hyttahub/service_widgets/remove_admin_screen.dart';
import 'package:hyttahub/service_widgets/restore_admin_screen.dart';
import 'package:hyttahub/service_widgets/service_admin_screen.dart';
import 'package:hyttahub/service_widgets/service_admins_screen.dart';
import 'package:hyttahub/service_widgets/service_terms_display.dart';

import 'package:hyttahub/service_widgets/login.dart';
import 'package:hyttahub/service_widgets/update_admin_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/site_widgets/add_member_screen.dart';
import 'package:hyttahub/site_widgets/remove_member_screen.dart';
import 'package:hyttahub/site_widgets/restore_member_screen.dart';
import 'package:hyttahub/site_widgets/update_member_screen.dart';
import 'package:hyttahub/site_widgets/site_members_screen.dart';
import 'package:hyttahub/site_widgets/export_site_screen.dart';
import 'package:hyttahub/site_widgets/manage_exports_screen.dart';
import 'package:hyttahub/site_widgets/export_details_screen.dart';

/// A route for the login screen.
class LoginScreenRoute extends GoRoute {
  /// Creates a [LoginScreenRoute].
  LoginScreenRoute({required super.routes})
    : super(
        path: pathSegment,
        name: routeName,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(
            key: ValueKey('userLoginScreen'),
            child: LoginScreen(serviceLogin: false),
          );
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'userlogin';

  /// The full path to this route.
  static const String fullPath = '/$pathSegment';

  /// The name for this route.
  static const String routeName = 'userLogin';
}

/// A route for the login screen.
class ServiceLoginScreenRoute extends GoRoute {
  /// Creates a [LoginScreenRoute].
  ServiceLoginScreenRoute({required super.routes})
    : super(
        path: pathSegment,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(
            key: ValueKey('serviceLoginScreen'),
            child: LoginScreen(serviceLogin: true),
          );
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'servicelogin';

  /// The full path to this route.
  static const String fullPath = '/$pathSegment';
}

/// A route for the account screen.
class AccountScreenRoute extends GoRoute {
  /// Creates an [AccountScreenRoute].
  AccountScreenRoute({required super.routes})
    : super(
        path: pathSegment,
        name: routeName,

        builder: (BuildContext context, GoRouterState state) {
          return const AccountScreen();
        },

        // onExit: (context, state) {
        //   // logout when exiting account screen
        //   if (kDebugMode) {
        //     print("AccountScreenRoute: onExit called");
        //   }

        //   // context.read<AuthBloc>().add(
        //   //   AuthBlocEvent(logout: AuthBlocEvent_Logout()),
        //   // );
        //   return true;
        // },
      );

  /// The path segment for this route.
  static const String pathSegment = 'account';

  /// The full path to this route, constructed from its parent's path.
  static final String fullPath = '${LoginScreenRoute.fullPath}/$pathSegment';

  /// The name for this route.
  static const String routeName = 'account';
}

/// A route for the service admin screen.
class ServiceAdminScreenRoute extends GoRoute {
  /// Creates an [ServiceAdminScreenRoute].
  ServiceAdminScreenRoute({required super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          return const ServiceAdminScreen();
        },
        onExit: (context, state) async {
          return await showLogoutDialog(context);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'service';

  /// The full path to this route, constructed from its parent's path.
  static final String fullPath =
      '${ServiceLoginScreenRoute.fullPath}/$pathSegment';
}

/// A route for adding a new site.
class AddSiteRoute extends GoRoute {
  /// Creates an [AddSiteRoute].
  AddSiteRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          return AddSiteScreen(event: event);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'addsite';

  /// The full path to this route.
  static final String fullPath = '${AccountScreenRoute.fullPath}/$pathSegment';
}

class SiteMembersRoute extends GoRoute {
  /// Creates an [SiteMembersRoute].
  SiteMembersRoute({super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          return SiteMembersScreen(siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'members';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId}) =>
      '${HyttaHubOptions.siteScreenRoute!(siteId)}/$pathSegment';
}

class ExportSiteRoute extends GoRoute {
  /// Creates an [ExportSiteRoute].
  ExportSiteRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          return ExportSiteScreen(siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'export';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId}) =>
      '${HyttaHubOptions.siteScreenRoute!(siteId)}/$pathSegment';
}

class ManageExportsRoute extends GoRoute {
  /// Creates a [ManageExportsRoute].
  ManageExportsRoute({super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          return ManageExportsScreen(siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'manage_exports';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId}) =>
      '${HyttaHubOptions.siteScreenRoute!(siteId)}/$pathSegment';
}

class ExportDetailsRoute extends GoRoute {
  /// Creates an [ExportDetailsRoute].
  ExportDetailsRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          final fileName = state.pathParameters['fileName'] ?? '';
          return ExportDetailsScreen(
            siteId: siteId,
            fileName: fileName,
          );
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'details/:fileName';

  /// A builder for the full path to this route.
  static String fullPath({
    required String siteId,
    required String fileName,
  }) =>
      '${ManageExportsRoute.fullPath(siteId: siteId)}/details/$fileName';
}

class AddMemberRoute extends GoRoute {
  /// Creates an [AddMemberRoute].
  AddMemberRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          final event = state.uri.queryParameters['event'] ?? '';
          return AddMemberScreen(event: event, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'addmember';

  static String fullPath({required String siteId}) =>
      '${SiteMembersRoute.fullPath(siteId: siteId)}/$pathSegment';

  /// A builder for the full path to this route.
  // static String fullPath({required String siteId}) =>
  //     '${SiteScreenRoute.fullPath(siteId)}/$pathSegment';
}

/// A route for removing a member from a site.
class RemoveMemberRoute extends GoRoute {
  /// Creates a [RemoveMemberRoute].
  RemoveMemberRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          final siteId = state.pathParameters['siteId'] ?? '';
          return RemoveMemberScreen(event: event, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'removemember';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId}) =>
      '${SiteMembersRoute.fullPath(siteId: siteId)}/$pathSegment';
}

class UpdateMemberRoute extends GoRoute {
  /// Creates a [UpdateMemberRoute].
  UpdateMemberRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          final siteId = state.pathParameters['siteId'] ?? '';
          final originalEmail =
              state.uri.queryParameters['originalEmail'] ?? '';
          return UpdateMemberScreen(
            event: event,
            siteId: siteId,
            originalEmail: originalEmail,
          );
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'updatemember';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId}) =>
      '${SiteMembersRoute.fullPath(siteId: siteId)}/$pathSegment';
}

class RestoreMemberRoute extends GoRoute {
  /// Creates a [RestoreMemberRoute].
  RestoreMemberRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          final siteId = state.pathParameters['siteId'] ?? '';
          return RestoreMemberScreen(event: event, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'restoremember';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId}) =>
      '${SiteMembersRoute.fullPath(siteId: siteId)}/$pathSegment';
}

/// A route for managing sites.
class ManageSitesRoute extends GoRoute {
  /// Creates an [ManageSitesRoute].
  ManageSitesRoute({required super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          return ManageSitesScreen();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'managesites';

  /// The full path to this route.
  static final String fullPath = '${AccountScreenRoute.fullPath}/$pathSegment';
}

class RemoveSiteRoute extends GoRoute {
  /// Creates an [RemoveSiteRoute].
  RemoveSiteRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          return LeaveSiteScreen(event: event);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'removesite';

  /// The full path to this route.
  static final String fullPath = '${ManageSitesRoute.fullPath}/$pathSegment';
}

/// A route for adding a new site.
class JoinSiteRoute extends GoRoute {
  /// Creates an [JoinSiteRoute].
  JoinSiteRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          return JoinSiteScreen(event: event);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'joinsite';

  /// The full path to this route.
  static final String fullPath = '${AccountScreenRoute.fullPath}/$pathSegment';
}

class AccountOptionUnimplementedRoute extends GoRoute {
  /// Creates an [AccountOptionUnimplementedRoute].
  AccountOptionUnimplementedRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          return UnimplementedScreen();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'unimplemented';

  /// The full path to this route.
  static final String fullPath = '${AccountScreenRoute.fullPath}/$pathSegment';
}

/// A route for removing the user's account.
class RemoveAccountRoute extends GoRoute {
  /// Creates a [RemoveAccountRoute].
  RemoveAccountRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          return RemoveAccountScreen(event: event);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'removeaccount';

  /// The full path to this route.
  static final String fullPath = '${AccountScreenRoute.fullPath}/$pathSegment';
}

class ServiceUnimplementedRoute extends GoRoute {
  /// Creates an [ServiceUnimplementedRoute].
  ServiceUnimplementedRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          return UnimplementedScreen();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'unimplemented';

  /// The full path to this route.
  static final String fullPath =
      '${ServiceAdminScreenRoute.fullPath}/$pathSegment';
}

class LandingUnimplementedRoute extends GoRoute {
  /// Creates an [LandingUnimplementedRoute].
  LandingUnimplementedRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          return UnimplementedScreen();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'unimplemented';

  /// The full path to this route.
  // static final String fullPath = '${LandingScreenRoute.fullPath}/$pathSegment';
  static const String fullPath = '/$pathSegment';
}

class ServiceEventsDisplayRoute extends GoRoute {
  /// Creates an [ServiceEventsDisplayRoute].
  ServiceEventsDisplayRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          return ServiceEventsDisplayScreen();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'events_display';

  /// The full path to this route.
  static final String fullPath =
      '${ServiceAdminScreenRoute.fullPath}/$pathSegment';
}

class AccountEventsDisplayRoute extends GoRoute {
  /// Creates an [AccountEventsDisplayRoute].
  AccountEventsDisplayRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final email = context.read<AuthBloc>().state.email;
          return AccountEventsDisplayScreen(email: email);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'events_display';

  /// The full path to this route.
  static final String fullPath = '${AccountScreenRoute.fullPath}/$pathSegment';
}

/// A route for adding a new site.
class ServiceOptionsRoute extends GoRoute {
  /// Creates an [ServiceOptionsRoute].
  ServiceOptionsRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          return ServiceSettingsForm(event: event);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'settings';

  /// The full path to this route.
  static final String fullPath =
      '${ServiceAdminScreenRoute.fullPath}/$pathSegment';
}

/// A route for displaying the terms of service
class TermsDisplayRoute extends GoRoute {
  /// Creates an [TermsDisplayRoute].
  TermsDisplayRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          return ServiceTermsDisplay();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'terms';

  /// A builder for the full path to this route.
  static final String fullPath = '${AccountScreenRoute.fullPath}/$pathSegment';
}

/// A route for displaying the terms of service
class CreateAccountTermsDisplayRoute extends GoRoute {
  /// Creates an [CreateAccountTermsDisplayRoute].
  CreateAccountTermsDisplayRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          return ServiceTermsDisplay();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'terms';

  /// A builder for the full path to this route.
  static final String fullPath = '${LoginScreenRoute.fullPath}/$pathSegment';
}

/// A route for displaying the privacy policy
class PrivacyDisplayRoute extends GoRoute {
  /// Creates an [PrivacyDisplayRoute].
  PrivacyDisplayRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          return ServicePrivacyDisplay();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'privacy';

  /// A builder for the full path to this route.
  static final String fullPath = '${AccountScreenRoute.fullPath}/$pathSegment';
}

/// A route for displaying the privacy policy
class CreateAccountPrivacyDisplayRoute extends GoRoute {
  /// Creates an [CreateAccountPrivacyDisplayRoute].
  CreateAccountPrivacyDisplayRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          return ServicePrivacyDisplay();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'privacy';

  /// A builder for the full path to this route.
  static final String fullPath = '${LoginScreenRoute.fullPath}/$pathSegment';
}

Future<bool> showLogoutDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Logout?'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Stay on page
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                  AuthBlocEvent(logout: AuthBlocEvent_Logout()),
                );

                // FirebaseAuth.instance.signOut(); // Sign out user
                Navigator.pop(context, true); // Allow navigation away
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ) ??
      false; // Default to false if dialog is dismissed
}

class ServiceAdminsRoute extends GoRoute {
  /// Creates an [SiteMembersRoute].
  ServiceAdminsRoute({super.routes})
      : super(
          path: pathSegment,
          builder: (BuildContext context, GoRouterState state) {
            return const ServiceAdminsScreen();
          },
        );

  /// The path segment for this route.
  static const String pathSegment = 'admins';

  /// A builder for the full path to this route.
  static String fullPath =
      '${ServiceAdminScreenRoute.fullPath}/$pathSegment';
}

class AddServiceAdminRoute extends GoRoute {
  /// Creates an [AddMemberRoute].
  AddServiceAdminRoute()
      : super(
          path: pathSegment,
          builder: (BuildContext context, GoRouterState state) {
            final event = state.uri.queryParameters['event'] ?? '';
            return AddServiceAdminScreen(event: event);
          },
        );

  /// The path segment for this route.
  static const String pathSegment = 'add';

  static String fullPath = '${ServiceAdminsRoute.fullPath}/$pathSegment';
}

/// A route for removing a member from a site.
class RemoveServiceAdminRoute extends GoRoute {
  /// Creates a [RemoveMemberRoute].
  RemoveServiceAdminRoute()
      : super(
          path: pathSegment,
          builder: (BuildContext context, GoRouterState state) {
            final event = state.uri.queryParameters['event'] ?? '';
            return RemoveServiceAdminScreen(event: event);
          },
        );

  /// The path segment for this route.
  static const String pathSegment = 'remove';

  /// A builder for the full path to this route.
  static String fullPath = '${ServiceAdminsRoute.fullPath}/$pathSegment';
}

class UpdateServiceAdminRoute extends GoRoute {
  /// Creates a [UpdateMemberRoute].
  UpdateServiceAdminRoute()
      : super(
          path: pathSegment,
          builder: (BuildContext context, GoRouterState state) {
            final event = state.uri.queryParameters['event'] ?? '';
            final originalEmail =
                state.uri.queryParameters['originalEmail'] ?? '';
            return UpdateServiceAdminScreen(
              event: event,
              originalEmail: originalEmail,
            );
          },
        );

  /// The path segment for this route.
  static const String pathSegment = 'update';

  /// A builder for the full path to this route.
  static String fullPath = '${ServiceAdminsRoute.fullPath}/$pathSegment';
}

class RestoreServiceAdminRoute extends GoRoute {
  /// Creates a [RestoreMemberRoute].
  RestoreServiceAdminRoute()
      : super(
          path: pathSegment,
          builder: (BuildContext context, GoRouterState state) {
            final event = state.uri.queryParameters['event'] ?? '';
            return RestoreServiceAdminScreen(event: event);
          },
        );

  /// The path segment for this route.
  static const String pathSegment = 'restore';

  /// A builder for the full path to this route.
  static String fullPath = '${ServiceAdminsRoute.fullPath}/$pathSegment';
}

final serviceUnimplementedRoute = ServiceUnimplementedRoute();
final landingUnimplementedRoute = ServiceUnimplementedRoute();

final exportDetailsRoute = ExportDetailsRoute();
final exportSiteRoute = ExportSiteRoute();
final manageExportsRoute = ManageExportsRoute(
  routes: [exportDetailsRoute],
);

final addSiteRoute = AddSiteRoute();
final joinSiteRoute = JoinSiteRoute();
final removeSiteRoute = RemoveSiteRoute();

final manageSitesRoute = ManageSitesRoute(routes: [removeSiteRoute]);
final accountOptionUnimplementedRoute = AccountOptionUnimplementedRoute();
final removeAccountRoute = RemoveAccountRoute();
final serviceEventsDisplayRoute = ServiceEventsDisplayRoute();
final superUserOptionsRoute = ServiceOptionsRoute();
final termsDisplayRoute = TermsDisplayRoute();
final privacyDisplayRoute = PrivacyDisplayRoute();

final addMemberRoute = AddMemberRoute();
final removeMemberRoute = RemoveMemberRoute();
final updateMemberRoute = UpdateMemberRoute();
final restoreMemberRoute = RestoreMemberRoute();
final siteMembersRoute = SiteMembersRoute(
  routes: [
    addMemberRoute,
    removeMemberRoute,
    updateMemberRoute,
    restoreMemberRoute,
  ],
);

final addServiceAdminRoute = AddServiceAdminRoute();
final removeServiceAdminRoute = RemoveServiceAdminRoute();
final updateServiceAdminRoute = UpdateServiceAdminRoute();
final restoreServiceAdminRoute = RestoreServiceAdminRoute();
final serviceAdminsRoute = ServiceAdminsRoute(
  routes: [
    addServiceAdminRoute,
    removeServiceAdminRoute,
    updateServiceAdminRoute,
    restoreServiceAdminRoute,
  ],
);

final serviceAdminScreenRoute = ServiceAdminScreenRoute(
  routes: [
    superUserOptionsRoute,
    serviceUnimplementedRoute,
    serviceEventsDisplayRoute,
    serviceAdminsRoute,
  ],
);

final accountEventsDisplayRoute = AccountEventsDisplayRoute();
final accountScreenRoute = AccountScreenRoute(
  routes: [
    addSiteRoute,
    joinSiteRoute,
    manageSitesRoute,
    termsDisplayRoute,
    privacyDisplayRoute,
    accountOptionUnimplementedRoute,
    removeAccountRoute,
    accountEventsDisplayRoute,
  ],
);

final loginTermsDisplayRoute = CreateAccountTermsDisplayRoute();
final loginPrivacyDisplayRoute = CreateAccountPrivacyDisplayRoute();

final loginScreenRoute = LoginScreenRoute(
  routes: [
    accountScreenRoute,
    loginTermsDisplayRoute,
    loginPrivacyDisplayRoute,
  ],
);

final serviceLoginScreenRoute = ServiceLoginScreenRoute(
  routes: [serviceAdminScreenRoute],
);
