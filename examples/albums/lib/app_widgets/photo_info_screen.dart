// Copyright (c) 2025 bjorge

import 'package:albums/l10n/app_localizations.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/utilities/pack_any.dart';
import 'package:albums/proto/app_replay_bloc.pb.dart';

class PhotoInfoScreen extends StatelessWidget {
  const PhotoInfoScreen({
    super.key,
    required this.siteId,
    required this.photoId,
    required this.albumId,
  });

  final String siteId;
  final int albumId;
  final int photoId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: Key("photo-info-screen-$photoId"),
      create:
          (_) =>
              SiteReplayBloc(siteId)..add(CommonReplayBlocEvent(listen: true)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.app_photoInfoTitle),
        ),
        body: BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
          builder: (context, siteState) {
            if (!siteState.hasState() ||
                siteState.state == CommonReplayStateEnum.fetchingConfig) {
              return const Center(child: CircularProgressIndicator());
            } else if (siteState.state == CommonReplayStateEnum.uninitialized) {
              throw UnimplementedError('Site state is uninitialized');
            }

            final appBlocState = unpackAny(siteState.appBlocState, () => AppReplayBlocState())!;
            final album = appBlocState.albums.firstWhere((a) => a.id == albumId, orElse: () => AppReplayBlocState_AlbumInfo());
            final photoInfo = album.photos.firstWhere((p) => p.id == photoId, orElse: () => AppReplayBlocState_Photo());


            if (photoInfo.id == 0) {
              return Center(
                child: Text(AppLocalizations.of(context)!.app_photoNotFound),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                ListTile(
                  title: Text(AppLocalizations.of(context)!.app_albumLabel),
                  subtitle: Text(
                    album.name.isNotEmpty ? album.name : AppLocalizations.of(context)!.app_notAvailable,
                  ),
                  leading: const Icon(Icons.photo_album_outlined),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.app_originalNameLabel),
                  subtitle: Text(
                    photoInfo.name.isNotEmpty
                        ? photoInfo.name
                        : AppLocalizations.of(context)!.app_notAvailable,
                  ),
                  leading: const Icon(Icons.label_outline),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.app_sizeLabel),
                  subtitle: Text(
                    photoInfo.hasSize()
                        ? AppLocalizations.of(context)!.app_photoSizeInKB(
                            (photoInfo.size / 1024).toStringAsFixed(2))
                        : AppLocalizations.of(context)!.app_notAvailable,
                  ),
                  leading: const Icon(Icons.sd_storage_outlined),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
