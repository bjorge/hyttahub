// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:familytree/app_routes/app_routes.dart';
import 'package:familytree/l10n/intl_localizations.dart';
import 'package:familytree/proto/app_replay_bloc.pb.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:familytree/proto/app_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/site_widgets/site_edit_mode_cubit.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';

class TreeScreen extends StatefulWidget {
  const TreeScreen({super.key, required this.treeId, required this.siteId});

  final int treeId;
  final String siteId;

  @override
  State<TreeScreen> createState() => _TreeScreenState();
}

class _TreeScreenState extends State<TreeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SiteReplayBloc>(
          key: Key("tree-screen-${widget.siteId}-${widget.treeId}"),
          create:
              (_) =>
                  SiteReplayBloc(widget.siteId)
                    ..add(CommonReplayBlocEvent(listen: true)),
        ),
      ],
      child: BlocConsumer<SiteReplayBloc, SiteReplayBlocState>(
        builder: (context, siteState) {
          if (!siteState.hasState() ||
              siteState.state == CommonReplayStateEnum.fetchingConfig) {
            return const Center(child: CircularProgressIndicator());
          } else if (siteState.state == CommonReplayStateEnum.uninitialized) {
            throw UnimplementedError('Site state is uninitialized');
          }
          return Builder(
            builder: (context) {
              final isEditMode =
                  context.watch<SiteEditModeCubit>().state ?? false;
              final appBlocState =
                  unpackAppReplayWrapper(
                    siteState.appBlocState,
                    () => AppReplayBlocState(),
                  )!;

              final treeInfo = appBlocState.trees.firstWhere(
                (test) => test.id == widget.treeId,
                // orElse: () => TreeInfo(id: widget.treeId, name: ''),
              );

              // final treePersonIds = treeInfo.treePersonIds;

              // if (treeInfo == null) {
              //   return const Center(
              //     child: Icon(
              //       Icons.error_outline,
              //       color: Colors.red,
              //       size: 48.0,
              //     ),
              //   );
              // }

              // final treePersonIds = treeInfo.treePersonIds;

              return Scaffold(
                appBar: AppBar(
                  title: Text(treeInfo.name),
                  actions: [
                    if (isEditMode)
                      TreeSettingsButton(
                        siteId: widget.siteId,
                        treeId: widget.treeId,
                      ),
                  ],
                ),
                body:
                    treeInfo.treePersons.isEmpty
                        ? Center(
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.app_noMembersInThisTree,
                          ),
                        )
                        : ListView.builder(
                          itemCount: treeInfo.treePersons.length,
                          itemBuilder: (context, index) {
                            final personId = treeInfo.treePersons[index].id;
                            final personInfo = treeInfo.treePersons[index];

                            final photoCount = personInfo.photos.length;
                            final connectionCount =
                                personInfo.connections.length;
                            String subtitleText = '';
                            if (photoCount > 0) {
                              subtitleText += AppLocalizations.of(
                                context,
                              )!.app_photosCount(photoCount);
                            }
                            if (connectionCount > 0) {
                              if (subtitleText.isNotEmpty) {
                                subtitleText += ' / ';
                              }
                              subtitleText += AppLocalizations.of(
                                context,
                              )!.app_connectionsCount(connectionCount);
                            }

                            return ListTile(
                              title: Text(personInfo.name),
                              subtitle:
                                  subtitleText.isNotEmpty
                                      ? Text(subtitleText)
                                      : null,
                              onTap:
                                  !isEditMode
                                      ? () {
                                        context.push(
                                          TreePersonRoute.fullPath(
                                            siteId: widget.siteId,
                                            treeId: widget.treeId,
                                            treePersonId: personInfo.id,
                                          ),
                                        );
                                      }
                                      : null,
                              trailing:
                                  isEditMode
                                      ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.add_link),
                                            tooltip:
                                                AppLocalizations.of(
                                                  context,
                                                )!.app_addConnectionTooltip,
                                            onPressed: () {
                                              final submmitValue = SubmitAppEvent(
                                                authorEmail:
                                                    GetIt.instance<AuthBloc>()
                                                        .state
                                                        .email,
                                                appEvent: AppEvent(
                                                  addConnection:
                                                      AppEvent_AddConnection(
                                                        fromTreeMemberId:
                                                            personId,
                                                        connection:
                                                            TreeConnection(),
                                                      ),
                                                ),
                                                siteEvent: SubmitAppEvent_SiteEvent(
                                                  version:
                                                      siteState.events.isEmpty
                                                          ? 1
                                                          : siteState
                                                                  .events
                                                                  .keys
                                                                  .fold<int>(
                                                                    0,
                                                                    (p, e) =>
                                                                        e > p
                                                                            ? e
                                                                            : p,
                                                                  ) +
                                                              1,
                                                ),
                                              );
                                              final encodedSubmitValue =
                                                  base64UrlEncode(
                                                    submmitValue
                                                        .writeToBuffer(),
                                                  );
                                              context.push(
                                                '${AddConnectionRoute.fullPath(siteId: widget.siteId, treeId: widget.treeId, fromTreeMemberId: personId)}?event=$encodedSubmitValue',
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add_a_photo),
                                            tooltip:
                                                AppLocalizations.of(
                                                  context,
                                                )!.app_addPhotoTooltip,
                                            onPressed: () {
                                              final submmitValue = SubmitAppEvent(
                                                authorEmail:
                                                    GetIt.instance<AuthBloc>()
                                                        .state
                                                        .email,
                                                appEvent: AppEvent(
                                                  addPhoto: AppEvent_AddPhoto(
                                                    treeMemberId: personId,
                                                  ),
                                                ),
                                                siteEvent: SubmitAppEvent_SiteEvent(
                                                  version:
                                                      siteState.events.isEmpty
                                                          ? 1
                                                          : siteState
                                                                  .events
                                                                  .keys
                                                                  .fold<int>(
                                                                    0,
                                                                    (p, e) =>
                                                                        e > p
                                                                            ? e
                                                                            : p,
                                                                  ) +
                                                              1,
                                                ),
                                              );
                                              final encodedSubmitValue =
                                                  base64UrlEncode(
                                                    submmitValue
                                                        .writeToBuffer(),
                                                  );
                                              context.push(
                                                '${AddPhotoRoute.fullPath(siteId: widget.siteId, treeId: widget.treeId, treeMemberId: personId)}?event=$encodedSubmitValue',
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                      : null,
                            );
                          },
                        ),
              );
            },
          );
        },
        listener: (BuildContext context, SiteReplayBlocState state) {},
      ),
    );
  }
}

class TreeSettingsButton extends StatelessWidget {
  const TreeSettingsButton({
    super.key,
    required this.siteId,
    required this.treeId,
  });

  final String siteId;
  final int treeId;

  @override
  Widget build(BuildContext context) {
    final siteState = context.read<SiteReplayBloc>().state;

    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            final l10n = AppLocalizations.of(context)!;
            return SimpleDialog(
              title: Text(l10n.app_treeSettingsTitle),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    final submmitValue = SubmitAppEvent(
                      authorEmail: GetIt.instance<AuthBloc>().state.email,
                      appEvent: AppEvent(
                        addTreeMember: AppEvent_AddTreeMember(treeId: treeId),
                      ),
                      siteEvent: SubmitAppEvent_SiteEvent(
                        version:
                            siteState.events.isEmpty
                                ? 1
                                : siteState.events.keys.fold<int>(
                                      0,
                                      (p, e) => e > p ? e : p,
                                    ) +
                                    1,
                      ),
                    );
                    final encodedSubmitValue = base64UrlEncode(
                      submmitValue.writeToBuffer(),
                    );

                    context.push(
                      '${AddTreeMemberRoute.fullPath(siteId: siteId, treeId: treeId)}?event=$encodedSubmitValue',
                    );
                  },
                  child: Text(l10n.app_addTreeMemberTitle),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(dialogContext);

                    final appBlocState =
                        unpackAppReplayWrapper(
                          siteState.appBlocState,
                          () => AppReplayBlocState(),
                        )!;

                    final submmitValue = SubmitAppEvent(
                      authorEmail: GetIt.instance<AuthBloc>().state.email,
                      appEvent: AppEvent(
                        updateTree: AppEvent_UpdateTree(
                          treeId: treeId,
                          name:
                              appBlocState.trees
                                  .firstWhere((test) => test.id == treeId)
                                  .name,
                        ),
                      ),
                      siteEvent: SubmitAppEvent_SiteEvent(
                        version:
                            siteState.events.isEmpty
                                ? 1
                                : siteState.events.keys.fold<int>(
                                      0,
                                      (p, e) => e > p ? e : p,
                                    ) +
                                    1,
                      ),
                    );
                    final encodedSubmitValue = base64UrlEncode(
                      submmitValue.writeToBuffer(),
                    );

                    context.push(
                      '${RenameTreeRoute.fullPath(siteId: siteId, treeId: treeId)}?event=$encodedSubmitValue',
                    );
                  },
                  child: Text(l10n.app_renameTreeTitle),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    final submmitValue = SubmitAppEvent(
                      authorEmail: GetIt.instance<AuthBloc>().state.email,
                      appEvent: AppEvent(
                        deleteTree: AppEvent_DeleteTree(treeId: treeId),
                      ),
                      siteEvent: SubmitAppEvent_SiteEvent(
                        version:
                            siteState.events.keys.fold<int>(
                              0,
                              (p, e) => e > p ? e : p,
                            ) +
                            1,
                      ),
                    );
                    final encodedSubmitValue = base64Url.encode(
                      submmitValue.writeToBuffer(),
                    );
                    context.push(
                      '${DeleteTreeRoute.fullPath(siteId: siteId, treeId: treeId)}?event=$encodedSubmitValue',
                    );
                  },
                  child: Text(l10n.app_deleteTreeTitle),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.settings),
    );
  }
}
