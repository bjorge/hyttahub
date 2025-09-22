// Copyright (c) 2025 bjorge

import 'package:albums/app_widgets/add_album_screen.dart';
import 'package:albums/app_widgets/add_photo_screen.dart';
import 'package:albums/app_widgets/album_screen.dart';
import 'package:albums/app_widgets/app_events_display.dart';
import 'package:albums/app_widgets/delete_album_screen.dart';
import 'package:albums/app_widgets/delete_photo_screen.dart';
import 'package:albums/app_widgets/photo_info_screen.dart';
import 'package:albums/app_widgets/reorder_albums_screen.dart';
import 'package:albums/app_widgets/reorder_photos_screen.dart';
import 'package:albums/app_widgets/update_album_screen.dart';
import 'package:albums/app_widgets/update_photo_caption_screen.dart';
import 'package:albums/routers/landing.dart';
import 'package:hyttahub/common_widgets/unimplemented_screen.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/site_widgets/rename_site_screen.dart';
import 'package:hyttahub/site_widgets/site_emails_display.dart';
import 'package:hyttahub/site_widgets/site_events_display.dart';
import 'package:albums/app_widgets/site_screen.dart';
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

/// A route for adding a new album.
class AddAlbumRoute extends GoRoute {
  /// Creates an [AddAlbumRoute].
  AddAlbumRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          final event = state.uri.queryParameters['event'] ?? '';
          // return UnimplementedScreen();
          return AddAlbumScreen(event: event, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'addalbum';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId}) =>
      '${SiteScreenRoute.fullPath(siteId)}/$pathSegment';
}

/// A route for the album screen.
class AlbumRoute extends GoRoute {
  /// Creates an [AlbumRoute].
  AlbumRoute({required super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final albumId =
              int.tryParse(state.pathParameters['albumId'] ?? '') ?? 0;
          final siteId = state.pathParameters['siteId'] ?? '';
          return AlbumScreen(albumId: albumId, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'album/:albumId';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId, required int albumId}) =>
      '${SiteScreenRoute.fullPath(siteId)}/album/$albumId';
}

/// A route for the album person.
class AlbumPersonRoute extends GoRoute {
  /// Creates an [AlbumPersonRoute].
  AlbumPersonRoute({required super.routes})
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          // final albumId =
          //     int.tryParse(state.pathParameters['albumId'] ?? '') ?? 0;
          // final siteId = state.pathParameters['siteId'] ?? '';
          // final albumPersonId =
          //     int.tryParse(state.pathParameters['albumPersonId'] ?? '') ?? 0;
          return UnimplementedScreen();

          // return AlbumPersonScreen(
          //   albumId: albumId,
          //   siteId: siteId,
          //   albumPersonId: albumPersonId,
          // );
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'albumperson/:albumPersonId';

  static String fullPath({
    required String siteId,
    required int albumId,
    required int albumPersonId,
  }) =>
      '${AlbumRoute.fullPath(siteId: siteId, albumId: albumId)}/albumperson/$albumPersonId';
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

final addAlbumRoute = AddAlbumRoute();

/// A route for adding a new album member.
class AddAlbumMemberRoute extends GoRoute {
  /// Creates an [AddAlbumMemberRoute].
  AddAlbumMemberRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          // final event = state.uri.queryParameters['event'] ?? '';
          // final siteId = state.pathParameters['siteId'] ?? '';
          return UnimplementedScreen();

          // return AddAlbumMemberScreen(event: event, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'addmember';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId, required int albumId}) =>
      '${AlbumRoute.fullPath(siteId: siteId, albumId: albumId)}/$pathSegment';
}

/// A route for renaming a album.
class UpdateAlbumRoute extends GoRoute {
  /// Creates a [UpdateAlbumRoute].
  UpdateAlbumRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          final siteId = state.pathParameters['siteId'] ?? '';
          final albumId =
              int.tryParse(state.pathParameters['albumId'] ?? '') ?? 0;
          return UpdateAlbumScreen(
            event: event,
            siteId: siteId,
            albumId: albumId,
          );
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'rename';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId, required int albumId}) =>
      '${AlbumRoute.fullPath(siteId: siteId, albumId: albumId)}/$pathSegment';
}

/// A route for deleting a album.
class DeleteAlbumRoute extends GoRoute {
  /// Creates a [DeleteAlbumRoute].
  DeleteAlbumRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.uri.queryParameters['event'] ?? '';
          final siteId = state.pathParameters['siteId'] ?? '';
          return DeleteAlbumScreen(event: event, siteId: siteId);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'delete';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId, required int albumId}) =>
      '${AlbumRoute.fullPath(siteId: siteId, albumId: albumId)}/$pathSegment';
}

/// A route for updating a album member.
class UpdateAlbumMemberRoute extends GoRoute {
  /// Creates an [UpdateAlbumMemberRoute].
  UpdateAlbumMemberRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          // final event = state.uri.queryParameters['event'] ?? '';
          // final siteId = state.pathParameters['siteId'] ?? '';
          // return UpdateAlbumMemberScreen(event: event, siteId: siteId);
          return UnimplementedScreen();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'updatemember/:memberId';

  /// A builder for the full path to this route.
  static String fullPath({
    required String siteId,
    required int albumId,
    required int memberId,
  }) =>
      '${AlbumRoute.fullPath(siteId: siteId, albumId: albumId)}/updatemember/$memberId';
}

/// A route for removing a album member.
class RemoveAlbumMemberRoute extends GoRoute {
  /// Creates a [RemoveAlbumMemberRoute].
  RemoveAlbumMemberRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          // final event = state.uri.queryParameters['event'] ?? '';
          // final siteId = state.pathParameters['siteId'] ?? '';
          // return RemoveAlbumMemberScreen(event: event, siteId: siteId);
          return UnimplementedScreen();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'removemember/:memberId';

  /// A builder for the full path to this route.
  static String fullPath({
    required String siteId,
    required int albumId,
    required int memberId,
  }) =>
      '${AlbumRoute.fullPath(siteId: siteId, albumId: albumId)}/removemember/$memberId';
}

/// A route for adding a connection between album members.
class AddConnectionRoute extends GoRoute {
  /// Creates an [AddConnectionRoute].
  AddConnectionRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          // final event = state.uri.queryParameters['event'] ?? '';
          // final siteId = state.pathParameters['siteId'] ?? '';
          // final albumId =
          //     int.tryParse(state.pathParameters['albumId'] ?? '') ?? 0;
          // final fromAlbumMemberId =
          //     int.tryParse(state.pathParameters['fromAlbumMemberId'] ?? '') ??
          //     0;
          // return AddConnectionScreen(
          //   event: event,
          //   siteId: siteId,
          //   albumId: albumId,
          //   fromAlbumMemberId: fromAlbumMemberId,
          // );
          return UnimplementedScreen();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'addconnection/:fromAlbumMemberId';

  /// A builder for the full path to this route.
  static String fullPath({
    required String siteId,
    required int albumId,
    required int fromAlbumMemberId,
  }) =>
      '${AlbumRoute.fullPath(siteId: siteId, albumId: albumId)}/addconnection/$fromAlbumMemberId';
}

/// A route for removing a connection between album members.
class RemoveConnectionRoute extends GoRoute {
  /// Creates a [RemoveConnectionRoute].
  RemoveConnectionRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          // final event = state.uri.queryParameters['event'] ?? '';
          // final siteId = state.pathParameters['siteId'] ?? '';
          // return RemoveConnectionScreen(event: event, siteId: siteId);
          return UnimplementedScreen();
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'removeconnection/:connectionId';

  /// A builder for the full path to this route.
  static String fullPath({
    required String siteId,
    required int albumId,
    required int connectionId,
  }) =>
      '${AlbumRoute.fullPath(siteId: siteId, albumId: albumId)}/removeconnection/$connectionId';
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
  static const String pathSegment = 'addphoto';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId, required int albumId}) =>
      '${AlbumRoute.fullPath(siteId: siteId, albumId: albumId)}/$pathSegment';
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
    required int albumId,
    required int photoId,
  }) =>
      '${PhotoInfoRoute.fullPath(siteId: siteId, albumId: albumId, photoId: photoId)}/$pathSegment';
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
          final photoId =
              int.tryParse(state.pathParameters['photoId'] ?? '') ?? 0;
          return UpdatePhotoCaptionScreen(
            event: event,
            siteId: siteId,
            photoId: photoId,
          );
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'updatecaption';

  /// A builder for the full path to this route.
  static String fullPath({
    required String siteId,
    required int albumId,
    required int photoId,
  }) =>
      '${PhotoInfoRoute.fullPath(siteId: siteId, albumId: albumId, photoId: photoId)}/$pathSegment';
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
          final albumId =
              int.tryParse(state.pathParameters['albumId'] ?? '') ?? 0;
          return PhotoInfoScreen(
            photoId: photoId,
            siteId: siteId,
            albumId: albumId,
          );
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'photo/:photoId';

  /// A builder for the full path to this route.
  static String fullPath({
    required String siteId,
    required int albumId,
    required int photoId,
  }) =>
      '${AlbumRoute.fullPath(siteId: siteId, albumId: albumId)}/photo/$photoId';
}

/// A route for reordering albums in a site.
class ReorderAlbumsRoute extends GoRoute {
  /// Creates a [ReorderAlbumsRoute].
  ReorderAlbumsRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          final event = state.uri.queryParameters['event'] ?? '';
          return ReorderAlbumsScreen(siteId: siteId, event: event);
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'reorderalbums';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId}) =>
      '${SiteScreenRoute.fullPath(siteId)}/$pathSegment';
}

/// A route for reordering photos in an album.
class ReorderPhotosRoute extends GoRoute {
  /// Creates a [ReorderPhotosRoute].
  ReorderPhotosRoute()
    : super(
        path: pathSegment,
        builder: (BuildContext context, GoRouterState state) {
          final siteId = state.pathParameters['siteId'] ?? '';
          final albumId =
              int.tryParse(state.pathParameters['albumId'] ?? '') ?? 0;
          final event = state.uri.queryParameters['event'] ?? '';
          return ReorderPhotosScreen(
            siteId: siteId,
            albumId: albumId,
            event: event,
          );
        },
      );

  /// The path segment for this route.
  static const String pathSegment = 'reorderphotos';

  /// A builder for the full path to this route.
  static String fullPath({required String siteId, required int albumId}) =>
      '${AlbumRoute.fullPath(siteId: siteId, albumId: albumId)}/$pathSegment';
}

final addAlbumMemberRoute = AddAlbumMemberRoute();
final updateAlbumRoute = UpdateAlbumRoute();
final deleteAlbumRoute = DeleteAlbumRoute();
final reorderPhotosRoute = ReorderPhotosRoute();
final updateAlbumMemberRoute = UpdateAlbumMemberRoute();
final removeAlbumMemberRoute = RemoveAlbumMemberRoute();
final addConnectionRoute = AddConnectionRoute();
final removeConnectionRoute = RemoveConnectionRoute();
final addPhotoRoute = AddPhotoRoute();
final deletePhotoRoute = DeletePhotoRoute();
final updatePhotoCaptionRoute = UpdatePhotoCaptionRoute();

final photoInfoRoute = PhotoInfoRoute(
  routes: [deletePhotoRoute, updatePhotoCaptionRoute],
);
final albumPersonRoute = AlbumPersonRoute(routes: [photoInfoRoute]);

final albumRoute = AlbumRoute(
  routes: [
    addAlbumMemberRoute,
    updateAlbumRoute,
    deleteAlbumRoute,
    reorderPhotosRoute,
    updateAlbumMemberRoute,
    removeAlbumMemberRoute,
    addConnectionRoute,
    removeConnectionRoute,
    addPhotoRoute,
    photoInfoRoute,
    albumPersonRoute,
  ],
);

final siteEventsDisplayRoute = SiteEventsDisplayRoute();
final appEventsDisplayRoute = AppEventsDisplayRoute();
final siteEmailsDisplayRoute = SiteEmailsDisplayRoute();
final siteUnimplementedRoute = SiteUnimplementedRoute();

final renameSiteRoute = RenameSiteRoute();

final reorderAlbumsRoute = ReorderAlbumsRoute();

final siteScreenRoute = SiteScreenRoute(
  routes: [
    addAlbumRoute,
    // addMemberRoute,
    // removeMemberRoute,
    albumRoute,
    siteUnimplementedRoute,
    siteEventsDisplayRoute,
    appEventsDisplayRoute,
    siteEmailsDisplayRoute,
    siteMembersRoute,
    renameSiteRoute,
    reorderAlbumsRoute,
  ],
);

final landingScreenRoute = LandingScreenRoute(
  routes: [
    loginScreenRoute,
    serviceLoginScreenRoute,
    landingUnimplementedRoute,
  ],
);
