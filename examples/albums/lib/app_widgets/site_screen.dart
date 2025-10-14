// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:albums/l10n/app_localizations.dart';
import 'package:albums/proto/app_replay_bloc.pb.dart';
import 'package:albums/routers/app_routes.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_blocs/allowed_emails_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:albums/proto/app_events.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/site_widgets/site_edit_mode_cubit.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/utilities/pack_any.dart';

class SiteScreen extends StatelessWidget {
  const SiteScreen({super.key, required this.siteId});

  final String siteId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SiteReplayBloc>(
          key: Key('SiteReplayBloc-albums-$siteId'),
          create:
              (_) =>
                  SiteReplayBloc(siteId)
                    ..add(CommonReplayBlocEvent(listen: true)),
        ),
        // BlocProvider<SiteEditModeCubit>(create: (_) => SiteEditModeCubit()),
        BlocProvider<AllowedEmailsBloc>(
          create:
              (_) => AllowedEmailsBloc(firebaseSiteUsersPath(siteId))..add(
                AllowedEmailsBlocEvent(
                  fetchNow: AllowedEmailsBlocEvent_FetchedAllowedEmails(),
                ),
              ),
        ),
      ],
      child: BlocBuilder<AllowedEmailsBloc, AllowedEmailsBlocState>(
        key: Key('AllowedEmailsBloc-site-screen-$siteId'),
        builder: (context, allowedEmailsState) {
          if (!allowedEmailsState.hasState() ||
              allowedEmailsState.state ==
                  AllowedEmailsBlocState_State.fetching) {
            return const Center(child: CircularProgressIndicator());
          }

          if (allowedEmailsState.state == AllowedEmailsBlocState_State.error) {
            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.app_errorTitle),
              ),
              body: Text(AppLocalizations.of(context)!.app_unexpectedError),
            );
          }

          if (allowedEmailsState.state ==
              AllowedEmailsBlocState_State.permissionDenied) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  AppLocalizations.of(context)!.app_accessDeniedTitle,
                ),
              ),
              body: Center(
                child: Text(
                  AppLocalizations.of(context)!.app_sitePermissionDenied,
                ),
              ),
            );
          }

          final userId =
              allowedEmailsState
                  .emails[GetIt.instance<AuthBloc>().state.email]
                  ?.userId;

          return BlocBuilder<SiteEditModeCubit, bool?>(
            builder: (context, editModeState) {
              return BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
                builder: (context, siteState) {
                  if (siteState.state == CommonReplayStateEnum.networkError) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(
                          AppLocalizations.of(context)!.app_errorTitle,
                        ),
                      ),
                      body: Center(
                        child: Text(
                          AppLocalizations.of(context)!.app_networkError,
                        ),
                      ),
                    );
                  }
                  if (siteState.state ==
                      CommonReplayStateEnum.permissionDenied) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(
                          AppLocalizations.of(context)!.app_accessDeniedTitle,
                        ),
                      ),
                      body: Center(
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.app_sitePermissionDenied,
                        ),
                      ),
                    );
                  }

                  // first check if the account state is initialized
                  if (!siteState.hasState() ||
                      siteState.state == CommonReplayStateEnum.fetchingConfig) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final isAdmin = siteState.members[userId]?.admin ?? false;

                  if (isAdmin && editModeState == null) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(
                          AppLocalizations.of(context)!.app_editModeTitle,
                        ),
                      ),
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.app_adminPrivileges,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              AppLocalizations.of(context)!.app_howToProceed,
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed:
                                      () =>
                                          context
                                              .read<SiteEditModeCubit>()
                                              .editModeOff(),
                                  icon: const Icon(Icons.visibility),
                                  label: Text(
                                    AppLocalizations.of(context)!.app_viewSite,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                ElevatedButton.icon(
                                  onPressed:
                                      () =>
                                          context
                                              .read<SiteEditModeCubit>()
                                              .editModeOn(),
                                  icon: const Icon(Icons.edit),
                                  label: Text(
                                    AppLocalizations.of(context)!.app_editSite,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final isEditModeOn =
                      context.read<SiteEditModeCubit>().state ?? false;

                  final appBlocState =
                      siteState.hasAppBlocState()
                          ? unpackAny(
                            siteState.appBlocState,
                            () => AppReplayBlocState(),
                          )!
                          : AppReplayBlocState();

                  return Builder(
                    builder: (context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: Text(siteState.name),

                          actions:
                              isEditModeOn
                                  ? [
                                    SiteSettingsButton(
                                      siteId: siteId,
                                      siteState: siteState,
                                    ),
                                  ]
                                  : null,
                        ),

                        body: CommonListViewLayout(
                          children:
                              appBlocState.albums.isEmpty
                                  ? [
                                    Center(
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.app_noAlbums,
                                      ),
                                    ),
                                  ]
                                  : appBlocState.albums
                                      .map(
                                        (entry) => ListTile(
                                          title: Text(entry.name),
                                          onTap: () {
                                            context.push(
                                              AlbumRoute.fullPath(
                                                siteId: siteId,
                                                albumId: entry.id,
                                              ),
                                            );
                                          },
                                          trailing:
                                              isEditModeOn
                                                  ? PopupMenuButton<String>(
                                                    onSelected: (value) {
                                                      final version =
                                                          siteState
                                                                  .events
                                                                  .isEmpty
                                                              ? 1
                                                              : siteState
                                                                      .events
                                                                      .keys
                                                                      .fold<
                                                                        int
                                                                      >(
                                                                        0,
                                                                        (
                                                                          p,
                                                                          e,
                                                                        ) =>
                                                                            e > p
                                                                                ? e
                                                                                : p,
                                                                      ) +
                                                                  1;
                                                      if (value == 'rename') {
                                                        final submmitValue = SubmitAppEvent(
                                                          siteEvent:
                                                              SubmitAppEvent_SiteEvent(
                                                                version:
                                                                    version,
                                                              ),
                                                          authorEmail:
                                                              GetIt.instance<
                                                                    AuthBloc
                                                                  >()
                                                                  .state
                                                                  .email,
                                                          appEvent: AppEvent(
                                                            updateAlbum:
                                                                AppEvent_UpdateAlbum(
                                                                  albumId:
                                                                      entry.id,
                                                                  name:
                                                                      entry
                                                                          .name,
                                                                ),
                                                          ),
                                                        );
                                                        final encodedSubmitValue =
                                                            base64UrlEncode(
                                                              submmitValue
                                                                  .writeToBuffer(),
                                                            );
                                                        context.push(
                                                          '${UpdateAlbumRoute.fullPath(siteId: siteId, albumId: entry.id)}?event=$encodedSubmitValue',
                                                        );
                                                      } else if (value ==
                                                          'delete') {
                                                        final album =
                                                            appBlocState.albums
                                                                .firstWhere(
                                                                  (a) =>
                                                                      a.id ==
                                                                      entry.id,
                                                                );
                                                        final photoIds =
                                                            album.photos
                                                                .map(
                                                                  (p) => p.id,
                                                                )
                                                                .toList();
                                                        final submmitValue = SubmitAppEvent(
                                                          siteEvent:
                                                              SubmitAppEvent_SiteEvent(
                                                                version:
                                                                    version,
                                                              ),
                                                          authorEmail:
                                                              GetIt.instance<
                                                                    AuthBloc
                                                                  >()
                                                                  .state
                                                                  .email,
                                                          appEvent: AppEvent(
                                                            deleteAlbum:
                                                                AppEvent_DeleteAlbum(
                                                                  albumId:
                                                                      entry.id,
                                                                ),
                                                          ),
                                                          photoIdsToDelete:
                                                              photoIds,
                                                        );
                                                        final encodedSubmitValue =
                                                            base64UrlEncode(
                                                              submmitValue
                                                                  .writeToBuffer(),
                                                            );
                                                        context.push(
                                                          '${DeleteAlbumRoute.fullPath(siteId: siteId, albumId: entry.id)}?event=$encodedSubmitValue',
                                                        );
                                                      }
                                                    },
                                                    itemBuilder:
                                                        (
                                                          BuildContext context,
                                                        ) => <
                                                          PopupMenuEntry<String>
                                                        >[
                                                          PopupMenuItem<String>(
                                                            value: 'rename',
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                context,
                                                              )!.app_renameAlbumTitle,
                                                            ),
                                                          ),
                                                          PopupMenuItem<String>(
                                                            value: 'delete',
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                context,
                                                              )!.app_deleteAlbumTitle,
                                                            ),
                                                          ),
                                                        ],
                                                  )
                                                  : null,
                                        ),
                                      )
                                      .toList(),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class SiteSettingsButton extends StatefulWidget {
  const SiteSettingsButton({
    super.key,
    required this.siteId,
    required this.siteState,
  });

  final String siteId;
  final SiteReplayBlocState siteState;

  @override
  State<SiteSettingsButton> createState() => _SiteSettingsButtonState();
}

class _SiteSettingsButtonState extends State<SiteSettingsButton> {
  @override
  Widget build(BuildContext context) {
    final appBlocState =
        unpackAny(widget.siteState.appBlocState, () => AppReplayBlocState())!;

    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (BuildContext dialogContext) => SimpleDialog(
                title: Text(
                  AppLocalizations.of(context)!.app_siteSettingsTitle,
                ),
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      final submmitValue = SubmitAppEvent(
                        siteEvent: SubmitAppEvent_SiteEvent(
                          version:
                              widget.siteState.events.isEmpty
                                  ? 1
                                  : widget.siteState.events.keys.fold<int>(
                                        0,
                                        (p, e) => e > p ? e : p,
                                      ) +
                                      1,
                        ),
                        authorEmail: GetIt.instance<AuthBloc>().state.email,
                        appEvent: AppEvent(
                          addAlbum: AppEvent_AddAlbum(name: ''),
                        ),
                      );

                      final encodedSubmitValue = base64UrlEncode(
                        submmitValue.writeToBuffer(),
                      );

                      context.push(
                        "${AddAlbumRoute.fullPath(siteId: widget.siteId)}?event=$encodedSubmitValue",
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.app_addAlbumTitle,
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      final submmitValue = SubmitAppEvent(
                        authorEmail: GetIt.instance<AuthBloc>().state.email,
                        appEvent: AppEvent(
                          reorderAlbums: AppEvent_ReorderAlbums(
                            albumIds:
                                appBlocState.albums
                                    .map((toElement) => toElement.id)
                                    .toList(),
                          ),
                        ),
                        siteEvent: SubmitAppEvent_SiteEvent(
                          version:
                              widget.siteState.events.isEmpty
                                  ? 1
                                  : widget.siteState.events.keys.fold<int>(
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
                        "${ReorderAlbumsRoute.fullPath(siteId: widget.siteId)}?event=$encodedSubmitValue",
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.app_reorderAlbumsTitle,
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      final submmitValue = SubmitSiteEvent(
                        authorEmail: GetIt.instance<AuthBloc>().state.email,
                        event: SiteEvent(
                          updateSiteName: SiteEvent_UpdateSiteName(
                            name: widget.siteState.name,
                          ),
                          version:
                              widget.siteState.events.isEmpty
                                  ? 1
                                  : widget.siteState.events.keys.fold<int>(
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
                        "${RenameSiteRoute.fullPath(siteId: widget.siteId)}?event=$encodedSubmitValue",
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.app_renameSiteTitle,
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push(
                        ExportSiteRoute.fullPath(siteId: widget.siteId),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.app_exportSiteTitle,
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push(
                        ManageExportsRoute.fullPath(siteId: widget.siteId),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.app_manageExportsTitle,
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push(
                        SiteMembersRoute.fullPath(siteId: widget.siteId),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.app_manageSiteMembers,
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push(
                        SiteEventsDisplayRoute.fullPath(siteId: widget.siteId),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.app_showSiteEventsState,
                    ),
                  ),

                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push(
                        AppEventsDisplayRoute.fullPath(siteId: widget.siteId),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.app_showAppEventsState,
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push(
                        SiteEmailsDisplayRoute.fullPath(siteId: widget.siteId),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.app_showSiteAllowedEmails,
                    ),
                  ),
                ],
              ),
        );
      },

      icon: const Icon(Icons.settings),
    );
  }
}
