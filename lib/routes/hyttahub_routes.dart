// Copyright (c) 2025 bjorge

import 'package:hyttahub/account_blocs/account_replay_bloc.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/account_widgets/account_events_display.dart';
import 'package:hyttahub/account_widgets/account_screen.dart';
import 'package:hyttahub/account_widgets/remove_account_screen.dart';
import 'package:hyttahub/account_widgets/add_site_screen.dart';
import 'package:hyttahub/account_widgets/import_site_screen.dart';
import 'package:hyttahub/account_widgets/select_admin_screen.dart';
import 'package:hyttahub/account_widgets/join_site_screen.dart';
import 'package:hyttahub/account_widgets/manage_sites_screen.dart';
import 'package:hyttahub/account_widgets/reorder_sites_screen.dart';
import 'package:hyttahub/account_widgets/leave_site_screen.dart';
import 'package:hyttahub/account_widgets/copy_site_screen.dart';
import 'package:hyttahub/account_widgets/copy_site_confirm_screen.dart';
import 'package:hyttahub/common_widgets/unimplemented_screen.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
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
import 'package:hyttahub/common_widgets/hyttahub_info_page.dart';

import 'package:hyttahub/service_blocs/service_replay_bloc.dart';
import 'package:hyttahub/service_widgets/login.dart';
import 'package:hyttahub/service_widgets/open_source_licenses_screen.dart';
import 'package:hyttahub/service_widgets/update_admin_screen.dart';

import 'package:hyttahub/proto/service_events.pb.dart';
import 'package:hyttahub/proto/bloom_filter.pb.dart';
import 'package:hyttahub/utilities/ids.dart';
import 'package:hyttahub/service_widgets/service_down_page.dart';
import 'package:hyttahub/service_widgets/service_new_version_page.dart';
import 'package:hyttahub/service_widgets/service_uninitialized_page.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/common_blocs/allowed_emails_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:hyttahub/site_widgets/add_member_screen.dart';
import 'package:hyttahub/site_widgets/remove_member_screen.dart';
import 'package:hyttahub/site_widgets/rename_site_screen.dart';
import 'package:hyttahub/site_widgets/restore_member_screen.dart';
import 'package:hyttahub/site_widgets/site_emails_display.dart';
import 'package:hyttahub/site_widgets/site_events_display.dart';
import 'package:hyttahub/site_widgets/update_member_screen.dart';
import 'package:hyttahub/site_widgets/site_members_screen.dart';
import 'package:hyttahub/site_widgets/export_site_screen.dart';
import 'package:hyttahub/site_widgets/manage_exports_screen.dart';
import 'package:hyttahub/site_widgets/export_details_screen.dart';
import 'package:hyttahub/site_widgets/site_info_screen.dart';
import 'package:hyttahub/utilities/common_error_handling.dart';

/// A route for the login screen.

class OpenSourceLicensesRoute extends GoRoute {
  /// Creates an [OpenSourceLicensesRoute].
  OpenSourceLicensesRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          return const OpenSourceLicensesScreen();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'licenses';

  /// The full path to this route.
  static const String fullPath = '/$pathSegment';

  void go(BuildContext context) => context.go(fullPath);
}

class LandingInfoPageRoute extends GoRoute {
  /// Creates a [LandingInfoPageRoute].
  LandingInfoPageRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          return const HyttaHubInfoPage();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'info';

  /// The full path to this route.
  static const String fullPath = '/$pathSegment';

  void go(BuildContext context) => context.go(fullPath);
}

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

class ImportSiteRoute extends GoRoute {
  /// Creates an [ImportSiteRoute].
  ImportSiteRoute({required super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          return ImportSiteScreen();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'importsite';

  /// The full path to this route.
  static final String fullPath = '${AccountScreenRoute.fullPath}/$pathSegment';
}

class SelectAdminRoute extends GoRoute {
  /// Creates a [SelectAdminRoute].
  SelectAdminRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          return SelectAdminScreen(siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'selectadmin/:siteId';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId}) =>
      '${ImportSiteRoute.fullPath}/selectadmin/$siteId';
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

/// A route for renaming a site.
class RenameSiteRoute extends GoRoute {
  /// Creates a [RenameSiteRoute].
  RenameSiteRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          final siteId = state.pathParameters['siteId'] ?? '';
          return RenameSiteScreen(event: event, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'rename';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId}) =>
      '${HyttaHubOptions.siteScreenRoute!(siteId)}/$pathSegment';
}

class SiteEventsDisplayRoute extends GoRoute {
  /// Creates an [SiteEventsDisplayRoute].
  SiteEventsDisplayRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          return SiteEventsDisplayScreen(siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'events_display';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId}) =>
      '${HyttaHubOptions.siteScreenRoute!(siteId)}/$pathSegment';
}

class SiteEmailsDisplayRoute extends GoRoute {
  /// Creates an [SiteEmailsDisplayRoute].
  SiteEmailsDisplayRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          return SiteEmailsDisplayScreen(siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'emails_display';

  static String fullPath({required String siteId}) =>
      '${HyttaHubOptions.siteScreenRoute!(siteId)}/$pathSegment';
}

class SiteInfoRoute extends GoRoute {
  /// Creates an [SiteInfoRoute].
  SiteInfoRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          return SiteInfoScreen(siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'info';

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
          return ExportDetailsScreen(siteId: siteId, fileName: fileName);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'details/:fileName';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId, required String fileName}) =>
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

/// A route for copying sites.
class CopySiteRoute extends GoRoute {
  /// Creates an [CopySiteRoute].
  CopySiteRoute({required super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          return const CopySiteScreen();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'copysite';

  /// The full path to this route.
  static final String fullPath = '${AccountScreenRoute.fullPath}/$pathSegment';
}

class CopySiteConfirmRoute extends GoRoute {
  /// Creates an [CopySiteConfirmRoute].
  CopySiteConfirmRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          return CopySiteConfirmScreen(siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'copysiteconfirm/:siteId';

  /// The full path to this route.
  static String fullPath({required String siteId}) => '${CopySiteRoute.fullPath}/copysiteconfirm/$siteId';
}

class ReorderSitesRoute extends GoRoute {
  /// Creates an [ReorderSitesRoute].
  ReorderSitesRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          return ReorderSitesScreen(event: event);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'reordersites';

  /// The full path to this route.
  static final String fullPath = '${AccountScreenRoute.fullPath}/$pathSegment';
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
  final loc = HyttaHubLocalizations.of(context)!;

  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(loc.logoutDialogTitle),
          content: Text(loc.logoutDialogMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Stay on page
              child: Text(loc.cancelButton),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                  AuthBlocEvent(logout: AuthBlocEvent_Logout()),
                );

                // FirebaseAuth.instance.signOut(); // Sign out user
                Navigator.pop(context, true); // Allow navigation away
              },
              child: Text(loc.logout),
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
  static String fullPath = '${ServiceAdminScreenRoute.fullPath}/$pathSegment';
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
final manageExportsRoute = ManageExportsRoute(routes: [exportDetailsRoute]);

final addSiteRoute = AddSiteRoute();
final joinSiteRoute = JoinSiteRoute();
final removeSiteRoute = RemoveSiteRoute();
final selectAdminRoute = SelectAdminRoute();
final importSiteRoute = ImportSiteRoute(routes: [selectAdminRoute]);

final manageSitesRoute = ManageSitesRoute(routes: [removeSiteRoute]);
final copySiteConfirmRoute = CopySiteConfirmRoute();
final copySiteRoute = CopySiteRoute(routes: [copySiteConfirmRoute]);
final reorderSitesRoute = ReorderSitesRoute();
final accountOptionUnimplementedRoute = AccountOptionUnimplementedRoute();
final removeAccountRoute = RemoveAccountRoute();
final serviceEventsDisplayRoute = ServiceEventsDisplayRoute();
final superUserOptionsRoute = ServiceOptionsRoute();
final termsDisplayRoute = TermsDisplayRoute();
final privacyDisplayRoute = PrivacyDisplayRoute();

final renameSiteRoute = RenameSiteRoute();
final displaySiteRoute = SiteEventsDisplayRoute();
final siteEmailsDisplayRoute = SiteEmailsDisplayRoute();
final siteInfoRoute = SiteInfoRoute();
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
    importSiteRoute,
    joinSiteRoute,
    manageSitesRoute,
    copySiteRoute,
    reorderSitesRoute,
    termsDisplayRoute,
    privacyDisplayRoute,
    accountOptionUnimplementedRoute,
    removeAccountRoute,
    accountEventsDisplayRoute,
  ],
);

final accountShellRoute = ShellRoute(
  builder: (context, state, child) {
    return BlocProvider<AccountReplayBloc>(
      key: const Key('AccountShellBlocProvider'),
      create:
          (context) => AccountReplayBloc(
            context.read<AuthBloc>().state.email,
          )..add(CommonReplayBlocEvent(listen: true)),
      child: BlocBuilder<AccountReplayBloc, AccountReplayBlocState>(
        builder: (context, accountState) {
          final errorWidget = handleAccountReplayState(context, accountState);
          if (errorWidget != null) {
            return errorWidget;
          }
          return child;
        },
      ),
    );
  },
  routes: [accountScreenRoute],
);

final loginTermsDisplayRoute = CreateAccountTermsDisplayRoute();
final loginPrivacyDisplayRoute = CreateAccountPrivacyDisplayRoute();

final serviceShellRoute = ShellRoute(
  builder: (context, state, child) {
    return BlocProvider<ServiceReplayBloc>(
      key: const Key('ServiceShellServiceReplayBlocProvider'),
      create:
          (context) =>
              ServiceReplayBloc()..add(CommonReplayBlocEvent(listen: true)),
      child: BlocBuilder<ServiceReplayBloc, ServiceReplayBlocState>(
        builder: (context, serviceState) {
          final errorWidget = handleServiceReplayState(context, serviceState);
          if (errorWidget != null) {
            return errorWidget;
          }

          if (serviceState.state ==
              CommonReplayStateEnum.uninitializedListening) {
            final submitServiceEvent = SubmitServiceEvent(
              email: '',
              event: ServiceEvent(
                version: 1,
                author: 1,
                initialEvent: ServiceEvent_InitialEvent(
                  instance: generateId(),
                  alias: 'Admin',
                  filter: BloomFilter(),
                  appName:
                      HyttaHubOptions.implementation?.firebaseRootCollection ??
                      '',
                  appId: HyttaHubOptions.implementation?.appId ?? '',
                ),
              ),
            );

            final encodedEvent = base64Encode(submitServiceEvent.writeToBuffer());
            return ServiceUninitializedPage(event: encodedEvent);
          }

          final fullPath = state.fullPath ?? '';
          final isExempt =
              fullPath == '/' ||
              fullPath.startsWith(ServiceLoginScreenRoute.fullPath) ||
              fullPath.startsWith(LandingInfoPageRoute.fullPath) ||
              fullPath.startsWith(OpenSourceLicensesRoute.fullPath);

          if (!isExempt &&
              serviceState.state == CommonReplayStateEnum.listening &&
              serviceState.serviceUnavailable == true) {
            return ServiceDownPage();
          }

          if (!isExempt &&
              serviceState.state == CommonReplayStateEnum.listening &&
              serviceState.minVersion >
                  (HyttaHubOptions.implementation?.appBuildNumber ?? 0)) {
            return ServiceNewVersionPage();
          }

          return child;
        },
      ),
    );
  },
  routes: [
    loginScreenRoute,
    serviceLoginScreenRoute,
    landingInfoPageRoute,
    landingUnimplementedRoute,
  ],
);

final loginScreenRoute = LoginScreenRoute(
  routes: [
    accountShellRoute,
    loginTermsDisplayRoute,
    loginPrivacyDisplayRoute,
  ],
);

final serviceAdminShellRoute = ShellRoute(
  builder: (context, state, child) {
    return BlocProvider<ServiceAllowedEmailsBloc>(
      key: const Key('ServiceAllowedEmailsBlocProvider'),
      create:
          (context) =>
              ServiceAllowedEmailsBloc(
                firebaseServiceServiceAdminsPath(firebaseServiceCollectionName),
              )..add(
                AllowedEmailsBlocEvent(
                  fetchNow: AllowedEmailsBlocEvent_FetchedAllowedEmails(),
                ),
              ),
      child: BlocBuilder<ServiceAllowedEmailsBloc, AllowedEmailsBlocState>(
        builder: (context, allowedEmailsState) {
          final allowedEmailsErrorWidget = handleAllowedEmailsState(
            context,
            allowedEmailsState,
          );
          if (allowedEmailsErrorWidget != null) {
            return allowedEmailsErrorWidget;
          }

          return child;
        },
      ),
    );
  },
  routes: [serviceAdminScreenRoute],
);

final serviceLoginScreenRoute = ServiceLoginScreenRoute(
  routes: [serviceAdminShellRoute],
);

final standardSiteScreenRoutes = [
  renameSiteRoute,
  exportSiteRoute,
  manageExportsRoute,
  siteMembersRoute,
  displaySiteRoute,
  siteEmailsDisplayRoute,
  siteInfoRoute,
];

class HyttaHubRoutes {
  static final openSourceLicensesRoute = OpenSourceLicensesRoute();
  static final landingInfoPageRoute = LandingInfoPageRoute();
}

final landingInfoPageRoute = HyttaHubRoutes.landingInfoPageRoute;
