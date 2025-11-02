// Copyright (c) 2025 bjorge

import 'package:albums/proto/app_events.pb.dart';
import 'package:albums/proto/app_replay_bloc.pb.dart';
import 'package:hyttahub/proto/app_wrapper.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/utilities/pack_any.dart';

AppReplayWrapper appReplay(SiteReplayBlocState siteReplay, SiteEvent event) {
  if (!siteReplay.hasAppBlocState()) {
    return packAppReplayWrapper(AppReplayBlocState().writeToBuffer());
  }

  final appBlocState =
      siteReplay.hasAppBlocState()
          ? unpackAppReplayWrapper(
            siteReplay.appBlocState,
            () => AppReplayBlocState(),
          )!
          : AppReplayBlocState();

  if (event.hasAppEvent()) {
    final appEvent = unpackAppEventWrapper(event.appEvent, () => AppEvent())!;

    final eventVersion = event.version;

    if (appEvent.hasAddAlbum()) {
      appBlocState.albums.add(
        AppReplayBlocState_AlbumInfo(
          id: eventVersion,
          name: appEvent.addAlbum.name,
        ),
      );
    }

    if (appEvent.hasAddPhoto()) {
      final albumId = appEvent.addPhoto.albumId;

      final albumInfo = appBlocState.albums.firstWhere(
        (test) => test.id == albumId,
      );
      albumInfo.photos.add(
        AppReplayBlocState_Photo(
          id: eventVersion,
          name: appEvent.addPhoto.name,
          size: appEvent.addPhoto.size,
        ),
      );
    }

    if (appEvent.hasReorderAlbums()) {
      final albumIds = appEvent.reorderAlbums.albumIds;
      final newAlbumList = <AppReplayBlocState_AlbumInfo>[];
      for (final albumId in albumIds) {
        final album = appBlocState.albums.firstWhere(
          (test) => test.id == albumId,
        );
        newAlbumList.add(album);
      }
      appBlocState.albums.clear();
      appBlocState.albums.addAll(newAlbumList);
    }

    if (appEvent.hasUpdateAlbum()) {
      final albumId = appEvent.updateAlbum.albumId;
      final albumInfo = appBlocState.albums.firstWhere(
        (test) => test.id == albumId,
      );
      albumInfo.name = appEvent.updateAlbum.name;
    }

    if (appEvent.hasDeleteAlbum()) {
      final albumId = appEvent.deleteAlbum.albumId;
      appBlocState.albums.removeWhere((test) => test.id == albumId);
    }

    if (appEvent.hasUpdateCaption()) {
      final photoId = appEvent.updateCaption.photoId;
      for (final album in appBlocState.albums) {
        for (final photo in album.photos) {
          if (photo.id == photoId) {
            photo.caption = appEvent.updateCaption.caption;
            break;
          }
        }
      }
    }

    if (appEvent.hasDeletePhoto()) {
      final photoId = appEvent.deletePhoto.photoId;
      for (final album in appBlocState.albums) {
        album.photos.removeWhere((test) => test.id == photoId);
      }
    }

    if (appEvent.hasReorderPhotos()) {
      final albumId = appEvent.reorderPhotos.albumId;
      final albumInfo = appBlocState.albums.firstWhere(
        (test) => test.id == albumId,
      );
      final photoIds = appEvent.reorderPhotos.photoIds;
      final newPhotoList = <AppReplayBlocState_Photo>[];
      for (final photoId in photoIds) {
        final photo = albumInfo.photos.firstWhere((test) => test.id == photoId);
        newPhotoList.add(photo);
      }
      albumInfo.photos.clear();
      albumInfo.photos.addAll(newPhotoList);
    }
  }

  return packAppReplayWrapper(appBlocState.writeToBuffer());
}
