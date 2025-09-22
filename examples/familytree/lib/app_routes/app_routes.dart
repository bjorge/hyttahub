// Copyright (c) 2025 bjorge

import 'package:familytree/app_routes/landing.dart';
import 'package:familytree/app_widgets/add_connection_screen.dart';
import 'package:familytree/app_widgets/add_photo_screen.dart';
import 'package:familytree/app_widgets/add_tree_member_screen.dart';
import 'package:familytree/app_widgets/add_tree_screen.dart';
import 'package:familytree/app_widgets/app_events_display.dart';
import 'package:familytree/app_widgets/delete_photo_screen.dart';
import 'package:familytree/app_widgets/delete_tree_screen.dart';
import 'package:familytree/app_widgets/photo_info_screen.dart';
import 'package:familytree/app_widgets/remove_connection_screen.dart';
import 'package:familytree/app_widgets/remove_tree_member_screen.dart';
import 'package:familytree/app_widgets/reorder_trees_screen.dart';
import 'package:familytree/app_widgets/tree_person_screen.dart';
import 'package:familytree/app_widgets/tree_screen.dart';
import 'package:familytree/app_widgets/update_photo_caption_screen.dart';
import 'package:familytree/app_widgets/update_tree_member_screen.dart';
import 'package:hyttahub/common_widgets/unimplemented_screen.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/site_widgets/rename_site_screen.dart';
import 'package:hyttahub/site_widgets/site_emails_display.dart';
import 'package:hyttahub/site_widgets/site_events_display.dart';
import 'package:familytree/app_widgets/site_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

/// A route for adding a new tree.
class AddTreeRoute extends GoRoute {
  /// Creates an [AddTreeRoute].
  AddTreeRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          final event = state.uri.queryParameters['event'] ?? '';
          return AddTreeScreen(event: event, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'addtree';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId}) =>
      '${SiteScreenRoute.fullPath(siteId)}/$pathSegment';
}

/// A route for the tree screen.
class TreeRoute extends GoRoute {
  /// Creates an [TreeRoute].
  TreeRoute({required super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final treeId =
              int.tryParse(state.pathParameters['treeId'] ?? '') ?? 0;
          final siteId = state.pathParameters['siteId'] ?? '';
          return TreeScreen(treeId: treeId, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'tree/:treeId';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId, required int treeId}) =>
      '${SiteScreenRoute.fullPath(siteId)}/tree/$treeId';
}

/// A route for the tree person.
class TreePersonRoute extends GoRoute {
  /// Creates an [TreePersonRoute].
  TreePersonRoute({required super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final treeId =
              int.tryParse(state.pathParameters['treeId'] ?? '') ?? 0;
          final siteId = state.pathParameters['siteId'] ?? '';
          final treePersonId =
              int.tryParse(state.pathParameters['treePersonId'] ?? '') ?? 0;
          return TreePersonScreen(
            treeId: treeId,
            siteId: siteId,
            treePersonId: treePersonId,
          );
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'treeperson/:treePersonId';

  static String fullPath({
    required String siteId,
    required int treeId,
    required int treePersonId,
  }) =>
      '${TreeRoute.fullPath(siteId: siteId, treeId: treeId)}/treeperson/$treePersonId';
}

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
      '${SiteScreenRoute.fullPath(siteId)}/$pathSegment';
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

  /// A builder for the full path to this route.
  static String fullPath({required String siteId}) =>
      '${SiteScreenRoute.fullPath(siteId)}/$pathSegment';
}

// class AddMemberRoute extends GoRoute {
//   /// Creates an [AddMemberRoute].
//   AddMemberRoute()
//     : super(
//         path: pathSegment,
//         builder: (BuildContext context, GoRouterState state) {
//           final siteId = state.pathParameters['siteId'] ?? '';
//           final event = state.uri.queryParameters['event'] ?? '';
//           return AddMemberScreen(event: event, siteId: siteId);
//         },
//       );

//   /// The path segment for this route.
//   static const String pathSegment = 'addmember';

//   /// A builder for the full path to this route.
//   static String fullPath({required String siteId}) =>
//       '${SiteScreenRoute.fullPath(siteId)}/$pathSegment';
// }

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
      '${SiteScreenRoute.fullPath(siteId)}/$pathSegment';
}

class SiteUnimplementedRoute extends GoRoute {
  /// Creates an [SiteUnimplementedRoute].
  SiteUnimplementedRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          return UnimplementedScreen();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'unimplemented';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId}) =>
      '${SiteScreenRoute.fullPath(siteId)}/$pathSegment';
}

final addTreeRoute = AddTreeRoute();

/// A route for adding a new tree member.
class AddTreeMemberRoute extends GoRoute {
  /// Creates an [AddTreeMemberRoute].
  AddTreeMemberRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          final siteId = state.pathParameters['siteId'] ?? '';
          return AddTreeMemberScreen(event: event, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'addmember';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId, required int treeId}) =>
      '${TreeRoute.fullPath(siteId: siteId, treeId: treeId)}/$pathSegment';
}

/// A route for renaming a tree.
class RenameTreeRoute extends GoRoute {
  /// Creates a [RenameTreeRoute].
  RenameTreeRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          final siteId = state.pathParameters['siteId'] ?? '';
          return DeleteTreeScreen(event: event, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'rename';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId, required int treeId}) =>
      '${TreeRoute.fullPath(siteId: siteId, treeId: treeId)}/$pathSegment';
}

/// A route for deleting a tree.
class DeleteTreeRoute extends GoRoute {
  /// Creates a [DeleteTreeRoute].
  DeleteTreeRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          return UnimplementedScreen();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'deletetree';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId, required int treeId}) =>
      '${TreeRoute.fullPath(siteId: siteId, treeId: treeId)}/$pathSegment';
}

/// A route for updating a tree member.
class UpdateTreeMemberRoute extends GoRoute {
  /// Creates an [UpdateTreeMemberRoute].
  UpdateTreeMemberRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          final siteId = state.pathParameters['siteId'] ?? '';
          return UpdateTreeMemberScreen(event: event, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'updatemember/:memberId';

  /// A builder for the full path to this route.
  static String fullPath({
    required String siteId,
    required int treeId,
    required int memberId,
  }) =>
      '${TreeRoute.fullPath(siteId: siteId, treeId: treeId)}/updatemember/$memberId';
}

/// A route for removing a tree member.
class RemoveTreeMemberRoute extends GoRoute {
  /// Creates a [RemoveTreeMemberRoute].
  RemoveTreeMemberRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          final siteId = state.pathParameters['siteId'] ?? '';
          return RemoveTreeMemberScreen(event: event, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'removemember/:memberId';

  /// A builder for the full path to this route.
  static String fullPath({
    required String siteId,
    required int treeId,
    required int memberId,
  }) =>
      '${TreeRoute.fullPath(siteId: siteId, treeId: treeId)}/removemember/$memberId';
}

/// A route for adding a connection between tree members.
class AddConnectionRoute extends GoRoute {
  /// Creates an [AddConnectionRoute].
  AddConnectionRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          final siteId = state.pathParameters['siteId'] ?? '';
          final treeId =
              int.tryParse(state.pathParameters['treeId'] ?? '') ?? 0;
          final fromTreeMemberId =
              int.tryParse(state.pathParameters['fromTreeMemberId'] ?? '') ?? 0;
          return AddConnectionScreen(
            event: event,
            siteId: siteId,
            treeId: treeId,
            fromTreeMemberId: fromTreeMemberId,
          );
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'addconnection/:fromTreeMemberId';

  /// A builder for the full path to this route.
  static String fullPath({
    required String siteId,
    required int treeId,
    required int fromTreeMemberId,
  }) =>
      '${TreeRoute.fullPath(siteId: siteId, treeId: treeId)}/addconnection/$fromTreeMemberId';
}

/// A route for removing a connection between tree members.
class RemoveConnectionRoute extends GoRoute {
  /// Creates a [RemoveConnectionRoute].
  RemoveConnectionRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          final siteId = state.pathParameters['siteId'] ?? '';
          return RemoveConnectionScreen(event: event, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'removeconnection/:connectionId';

  /// A builder for the full path to this route.
  static String fullPath({
    required String siteId,
    required int treeId,
    required int connectionId,
  }) =>
      '${TreeRoute.fullPath(siteId: siteId, treeId: treeId)}/removeconnection/$connectionId';
}

/// A route for adding a new photo.
class AddPhotoRoute extends GoRoute {
  /// Creates an [AddPhotoRoute].
  AddPhotoRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          final siteId = state.pathParameters['siteId'] ?? '';

          return AddPhotoScreen(event: event, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'addphoto/:treeMemberId';

  /// A builder for the full path to this route.
  static String fullPath({
    required String siteId,
    required int treeId,
    required int treeMemberId,
  }) =>
      '${TreeRoute.fullPath(siteId: siteId, treeId: treeId)}/addphoto/$treeMemberId';
}

/// A route for deleting a photo.
class DeletePhotoRoute extends GoRoute {
  /// Creates a [DeletePhotoRoute].
  DeletePhotoRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          final siteId = state.pathParameters['siteId'] ?? '';
          return DeletePhotoScreen(event: event, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'delete';

  /// A builder for the full path to this route.
  static String fullPath({
    required String siteId,
    required int treeId,
    required int photoId,
  }) =>
      '${PhotoInfoRoute.fullPath(siteId: siteId, treeId: treeId, photoId: photoId)}/$pathSegment';
}

/// A route for updating a photo's caption.
class UpdatePhotoCaptionRoute extends GoRoute {
  /// Creates an [UpdatePhotoCaptionRoute].
  UpdatePhotoCaptionRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          final siteId = state.pathParameters['siteId'] ?? '';
          return UpdatePhotoCaptionScreen(event: event, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'updatecaption';

  /// A builder for the full path to this route.
  static String fullPath({
    required String siteId,
    required int treeId,
    required int photoId,
  }) =>
      '${PhotoInfoRoute.fullPath(siteId: siteId, treeId: treeId, photoId: photoId)}/$pathSegment';
}

/// A route for viewing photo information.
class PhotoInfoRoute extends GoRoute {
  /// Creates a [PhotoInfoRoute].
  PhotoInfoRoute({required super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final photoId =
              int.tryParse(state.pathParameters['photoId'] ?? '') ?? 0;
          final siteId = state.pathParameters['siteId'] ?? '';
          final treeId =
              int.tryParse(state.pathParameters['treeId'] ?? '') ?? 0;
          return PhotoInfoScreen(
            photoId: photoId,
            siteId: siteId,
            treeId: treeId,
          );
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'photo/:photoId';

  /// A builder for the full path to this route.
  static String fullPath({
    required String siteId,
    required int treeId,
    required int photoId,
  }) => '${TreeRoute.fullPath(siteId: siteId, treeId: treeId)}/photo/$photoId';
}

/// A route for reordering trees in a site.
class ReorderTreesRoute extends GoRoute {
  /// Creates a [ReorderTreesRoute].
  ReorderTreesRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          final event = state.uri.queryParameters['event'] ?? '';
          return ReorderTreesScreen(siteId: siteId, event: event);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'reordertrees';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId}) =>
      '${SiteScreenRoute.fullPath(siteId)}/$pathSegment';
}

final addTreeMemberRoute = AddTreeMemberRoute();
final renameTreeRoute = RenameTreeRoute();
final deleteTreeRoute = DeleteTreeRoute();
final updateTreeMemberRoute = UpdateTreeMemberRoute();
final removeTreeMemberRoute = RemoveTreeMemberRoute();
final addConnectionRoute = AddConnectionRoute();
final removeConnectionRoute = RemoveConnectionRoute();
final addPhotoRoute = AddPhotoRoute();
final deletePhotoRoute = DeletePhotoRoute();
final updatePhotoCaptionRoute = UpdatePhotoCaptionRoute();

final photoInfoRoute = PhotoInfoRoute(
  routes: [deletePhotoRoute, updatePhotoCaptionRoute],
);
final treePersonRoute = TreePersonRoute(routes: [photoInfoRoute]);

final treeRoute = TreeRoute(
  routes: [
    addTreeMemberRoute,
    renameTreeRoute,
    deleteTreeRoute,
    updateTreeMemberRoute,
    removeTreeMemberRoute,
    addConnectionRoute,
    removeConnectionRoute,
    addPhotoRoute,
    photoInfoRoute,
    treePersonRoute,
  ],
);

final siteEventsDisplayRoute = SiteEventsDisplayRoute();
final appEventsDisplayRoute = AppEventsDisplayRoute();
final siteEmailsDisplayRoute = SiteEmailsDisplayRoute();
final siteUnimplementedRoute = SiteUnimplementedRoute();

final renameSiteRoute = RenameSiteRoute();

final reorderTreesRoute = ReorderTreesRoute();

final siteScreenRoute = SiteScreenRoute(
  routes: [
    addTreeRoute,
    treeRoute,
    siteUnimplementedRoute,
    siteEventsDisplayRoute,
    appEventsDisplayRoute,
    siteEmailsDisplayRoute,
    siteMembersRoute,
    renameSiteRoute,
    reorderTreesRoute,
  ],
);

final landingScreenRoute = LandingScreenRoute(
  routes: [
    loginScreenRoute,
    serviceLoginScreenRoute,
    landingUnimplementedRoute,
  ],
);
