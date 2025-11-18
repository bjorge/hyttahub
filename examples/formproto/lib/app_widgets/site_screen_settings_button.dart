// Copyright (c) 2025 bjorge

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formproto/l10n/app_localizations.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

import 'package:hyttahub/site_blocs/site_replay_bloc.dart';

class SiteSettingsButton extends StatefulWidget {
  const SiteSettingsButton({super.key, required this.siteId});

  final String siteId;

  @override
  State<SiteSettingsButton> createState() => _SiteSettingsButtonState();
}

class _SiteSettingsButtonState extends State<SiteSettingsButton> {
  @override
  Widget build(BuildContext context) {
    // final appBlocState =
    //     unpackAppReplayWrapper(
    //       widget.siteState.appBlocState,
    //       () => AppReplayBlocState(),
    //     )!;

    return BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
      builder: (context, siteState) {
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
                          final submmitValue = SubmitSiteEvent(
                            authorEmail: GetIt.instance<AuthBloc>().state.email,
                            event: SiteEvent(
                              updateSiteName: SiteEvent_UpdateSiteName(
                                name: siteState.name,
                              ),
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
                            SiteEventsDisplayRoute.fullPath(
                              siteId: widget.siteId,
                            ),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.app_showSiteEventsState,
                        ),
                      ),

                      SimpleDialogOption(
                        onPressed: null,
                        // onPressed: () {
                        //   Navigator.pop(context);
                        //   context.push(
                        //     AppEventsDisplayRoute.fullPath(siteId: widget.siteId),
                        //   );
                        // },
                        child: Text(
                          AppLocalizations.of(context)!.app_showAppEventsState,
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context);
                          context.push(
                            SiteEmailsDisplayRoute.fullPath(
                              siteId: widget.siteId,
                            ),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.app_showSiteAllowedEmails,
                        ),
                      ),
                    ],
                  ),
            );
          },

          icon: const Icon(Icons.settings),
        );
      },
    );
  }
}
