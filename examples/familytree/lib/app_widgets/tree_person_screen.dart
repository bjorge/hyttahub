// Copyright (c) 2025 bjorge

import 'package:cloud_functions/cloud_functions.dart';
import 'package:familytree/app_routes/app_routes.dart';
import 'package:familytree/l10n/intl_localizations.dart';
import 'package:familytree/proto/app_events.pb.dart';
import 'package:familytree/proto/app_replay_bloc.pb.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';

class TreePersonScreen extends StatelessWidget {
  const TreePersonScreen({
    super.key,
    required this.siteId,
    required this.treeId,
    required this.treePersonId,
  });

  final String siteId;
  final int treeId;
  final int treePersonId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: Key("tree-person-screen-$siteId-$treeId-$treePersonId"),
      create:
          (_) =>
              SiteReplayBloc(siteId)..add(CommonReplayBlocEvent(listen: true)),
      child: BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
        builder: (context, siteState) {
          if (!siteState.hasState() ||
              siteState.state == CommonReplayStateEnum.fetchingConfig) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (siteState.state == CommonReplayStateEnum.uninitialized) {
            throw UnimplementedError('Site state is uninitialized');
          }

          final appBlocState =
              unpackAppReplayWrapper(
                siteState.appBlocState,
                () => AppReplayBlocState(),
              )!;

          final tree = appBlocState.trees.firstWhereOrNull(
            (t) => t.id == treeId,
          );
          final l10n = AppLocalizations.of(context)!;
          if (tree == null) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: Text(l10n.app_treeNotFound)),
            );
          }

          final person = tree.treePersons.firstWhereOrNull(
            (p) => p.id == treePersonId,
          );
          if (person == null) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: Text(l10n.app_personNotFound)),
            );
          }

          return Scaffold(
            appBar: AppBar(title: Text(person.name)),
            body: _buildBody(context, tree, person),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    TreeInfo tree,
    TreePersonInfo person,
  ) {
    return ListView(
      children: [
        _buildPhotoCarousel(person.photos),
        _buildConnections(context, tree, person),
      ],
    );
  }

  Future<String> _getSignedUrl(String fileName) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'getPhoto',
    );
    final result = await callable.call(<String, dynamic>{
      'appName': HyttaHubOptions.firebaseRootCollection,
      'siteId': siteId,
      'fileName': fileName,
    });

    // Cloud Function returns: { uploadUrl: "https://..." }
    final data = result.data as Map<String, dynamic>;
    return data['downloadUrl'] as String;
  }

  Widget _buildPhotoCarousel(List<Photo> photos) {
    if (photos.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),

              child: FutureBuilder<String>(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Icon(Icons.error);
                  } else {
                    return Image.network(
                      snapshot.data!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    );
                  }
                },

                future: _getSignedUrl(photo.id.toString()),
              ),
            ),
          );
        },
      ),
    );
  }

  String _connectionTypeToString(
    BuildContext context,
    TreeConnectionType type,
  ) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case TreeConnectionType.partner:
        return l10n.app_connectionTypePartner;
      case TreeConnectionType.exPartner:
        return l10n.app_connectionTypeExPartner;
      case TreeConnectionType.child:
        return l10n.app_connectionTypeChild;
      case TreeConnectionType.friend:
        return l10n.app_connectionTypeFriend;
      case TreeConnectionType.parent:
        return l10n.app_connectionTypeParent;
      case TreeConnectionType.pet:
        return l10n.app_connectionTypePet;
      default:
        return l10n.app_connectionTypeConnections;
    }
  }

  Widget _buildConnections(
    BuildContext context,
    TreeInfo tree,
    TreePersonInfo person,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (person.connections.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(child: Text(l10n.app_noConnections)),
      );
    }

    final groupedConnections = groupBy(
      person.connections,
      (TreeConnectionInfo conn) => conn.connection.type,
    );

    final connectionOrder = [
      TreeConnectionType.partner,
      TreeConnectionType.exPartner,
      TreeConnectionType.parent,
      TreeConnectionType.child,
      TreeConnectionType.friend,
      TreeConnectionType.pet,
    ];

    List<Widget> connectionWidgets = [];

    for (final type in connectionOrder) {
      if (groupedConnections.containsKey(type)) {
        final connectionsOfType = groupedConnections[type]!;
        connectionWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Text(
              _connectionTypeToString(context, type),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        );

        for (final connection in connectionsOfType) {
          final connectedPerson = tree.treePersons.firstWhereOrNull(
            (p) => p.id == connection.toTreeMemberId,
          );
          if (connectedPerson != null) {
            connectionWidgets.add(
              ListTile(
                title: Text(connectedPerson.name),
                subtitle:
                    connection.connection.hasInfo() &&
                            connection.connection.info.isNotEmpty
                        ? Text(connection.connection.info)
                        : null,
                onTap: () {
                  context.push(
                    TreePersonRoute.fullPath(
                      siteId: siteId,
                      treeId: tree.id,
                      treePersonId: connectedPerson.id,
                    ),
                  );
                },
                trailing: const Icon(Icons.chevron_right),
              ),
            );
          }
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: connectionWidgets,
    );
  }
}
