// Copyright (c) 2025 bjorge

import 'package:familytree/proto/app_events.pb.dart';
import 'package:familytree/proto/app_replay_bloc.pb.dart';
import 'package:hyttahub/proto/app_wrapper.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';

AppReplayWrapper appReplay(SiteReplayBlocState siteReplay, SiteEvent event) {
  if (!siteReplay.hasAppBlocState()) {
    return packAppReplayWrapper(AppReplayBlocState().writeToBuffer());
  }

  final appBlocState =
      siteReplay.hasAppBlocState()
          ? unpackAppReplayWrapper(
            siteReplay.appBlocState,
            () => AppReplayBlocState(),
          )
          : AppReplayBlocState();

  if (event.hasAppEvent()) {
    final appEvent = unpackAppEventWrapper(event.appEvent, () => AppEvent())!;

    final eventVersion = event.version;

    if (appEvent.hasAddTree()) {
      appBlocState.trees.add(
        TreeInfo(name: appEvent.addTree.name, id: eventVersion),
      );
      // appBlocState.treeIds.add(eventVersion);
    }

    if (appEvent.hasReorderTrees()) {
      final treeIds = appEvent.reorderTrees.treeIds;
      final newTreeList = <TreeInfo>[];
      for (final treeId in treeIds) {
        final tree = appBlocState.trees.firstWhere((test) => test.id == treeId);
        newTreeList.add(tree);
      }
      appBlocState.trees.clear();
      appBlocState.trees.addAll(newTreeList);
      // todo: reorder the trees according to the new order list
    }

    if (appEvent.hasUpdateTree()) {
      final treeId = appEvent.updateTree.treeId;
      final name = appEvent.updateTree.name;

      final tree = appBlocState.trees.firstWhere((test) => test.id == treeId);
      tree.name = name;
    }

    if (appEvent.hasDeleteTree()) {
      final treeId = appEvent.deleteTree.treeId;
      appBlocState.trees.removeWhere((treeInfo) => treeInfo.id == treeId);
    }

    if (appEvent.hasAddTreeMember()) {
      final treeId = appEvent.addTreeMember.treeId;
      final name = appEvent.addTreeMember.name;
      appBlocState.trees
          .firstWhere((test) => test.id == treeId)
          .treePersons
          .add(TreePersonInfo(name: name, id: eventVersion));
    }

    if (appEvent.hasRemoveTreeMember()) {
      final treeMemberId = appEvent.removeTreeMember.treeMemberId;
      for (var treeInfo in appBlocState.trees) {
        treeInfo.treePersons.removeWhere(
          (treePersonInfo) => treePersonInfo.id == treeMemberId,
        );
      }
    }

    if (appEvent.hasAddConnection()) {
      final fromTreeMemberId = appEvent.addConnection.fromTreeMemberId;
      final connection = appEvent.addConnection.connection;
      final toTreeMemberId = appEvent.addConnection.toTreeMemberId;

      for (var treeInfo in appBlocState.trees) {
        final index = treeInfo.treePersons.indexWhere(
          (test) => test.id == fromTreeMemberId,
        );

        if (index == -1) {
          continue;
        }

        treeInfo.treePersons[index].connections.add(
          TreeConnectionInfo(
            id: eventVersion,
            connection: connection,
            toTreeMemberId: toTreeMemberId,
          ),
        );
      }
    }

    if (appEvent.hasAddPhoto()) {
      final treeMemberId = appEvent.addPhoto.treeMemberId;
      final name = appEvent.addPhoto.name;
      final size = appEvent.addPhoto.size;

      for (var treeInfo in appBlocState.trees) {
        final index = treeInfo.treePersons.indexWhere(
          (test) => test.id == treeMemberId,
        );

        if (index == -1) {
          continue;
        }

        treeInfo.treePersons[index].photos.add(
          Photo(id: eventVersion, name: name, size: size),
        );
      }
    }
  }

  return packAppReplayWrapper(appBlocState.writeToBuffer());
}
