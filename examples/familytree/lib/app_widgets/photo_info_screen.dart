// Copyright (c) 2025 bjorge

import 'package:familytree/l10n/intl_localizations.dart';
import 'package:familytree/proto/app_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';

class PhotoInfoScreen extends StatelessWidget {
  const PhotoInfoScreen({
    super.key,
    required this.siteId,
    required this.photoId,
    required this.treeId,
  });

  final String siteId;
  final int treeId;
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
            final l10n = AppLocalizations.of(context)!;
            if (!siteState.hasState() ||
                siteState.state == CommonReplayStateEnum.fetchingConfig) {
              return const Center(child: CircularProgressIndicator());
            } else if (siteState.state == CommonReplayStateEnum.uninitialized) {
              throw UnimplementedError('Site state is uninitialized');
            }

            // final photoInfo = siteState.appBlocState.photos[photoId];
            final appBlocState =
                unpackAppReplayWrapper(
                  siteState.appBlocState,
                  () => AppReplayBlocState(),
                )!;

            final photoInfo = appBlocState.trees
                .firstWhere((test) => test.id == treeId)
                .treePersons
                .fold<Photo?>(null, (previousValue, treePerson) {
                  if (previousValue != null) {
                    return previousValue;
                  }
                  final index = treePerson.photos.indexWhere(
                    (test) => test.id == photoId,
                  );
                  if (index == -1) {
                    return null;
                  }
                  return treePerson.photos[index];
                });

            // final appBlocState =
            //     unpackAny(siteState.appBlocState, () => AppReplayBlocState())!;

            final treeName =
                appBlocState.trees.firstWhere((test) => test.id == treeId).name;

            if (photoInfo == null) {
              return Center(child: Text(l10n.app_photoNotFound));
            }

            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                ListTile(
                  title: Text(l10n.app_treeLabel),
                  subtitle: Text(treeName),
                  leading: const Icon(Icons.account_tree_outlined),
                ),
                ListTile(
                  title: Text(l10n.app_originalNameLabel),
                  subtitle: Text(
                    photoInfo.hasName()
                        ? photoInfo.name
                        : l10n.app_notAvailable,
                  ),
                  leading: const Icon(Icons.label_outline),
                ),
                ListTile(
                  title: Text(l10n.app_sizeLabel),
                  subtitle: Text(
                    photoInfo.hasSize()
                        ? l10n.app_photoSizeInKB(
                          (photoInfo.size / 1024).toStringAsFixed(2),
                        )
                        : l10n.app_notAvailable,
                  ),
                  leading: const Icon(Icons.sd_storage_outlined),
                ),
                ListTile(
                  // title: Text(l10n.app_storageUrlLabel),
                  title: Text("app_storageUrlLabel"),
                  leading: const Icon(Icons.link_outlined),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
