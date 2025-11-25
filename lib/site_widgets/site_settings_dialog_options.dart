// Copyright (c) 2025 bjorge

import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

List<SimpleDialogOption> buildSiteSettingsDialogOptions(
  BuildContext context,

  BuildContext dialogContext,
  SiteReplayBlocState siteState,
  String widgetSiteId,
) {
  return <SimpleDialogOption>[
    SimpleDialogOption(
      onPressed: () {
        Navigator.pop(dialogContext);
        final submmitValue = SubmitSiteEvent(
          authorEmail: GetIt.instance<AuthBloc>().state.email,
          event: SiteEvent(
            updateSiteName: SiteEvent_UpdateSiteName(name: siteState.name),
            version: siteState.events.isEmpty
                ? 1
                : siteState.events.keys.fold<int>(0, (p, e) => e > p ? e : p) +
                      1,
          ),
        );
        final encodedSubmitValue = base64UrlEncode(
          submmitValue.writeToBuffer(),
        );

        context.push(
          "${RenameSiteRoute.fullPath(siteId: widgetSiteId)}?event=$encodedSubmitValue",
        );
      },
      child: Text(HyttaHubLocalizations.of(context)!.renameSiteTitle),
    ),
    SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        context.push(ExportSiteRoute.fullPath(siteId: widgetSiteId));
      },
      child: Text(HyttaHubLocalizations.of(context)!.exportSiteTitle),
    ),
    SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        context.push(ManageExportsRoute.fullPath(siteId: widgetSiteId));
      },
      child: Text(HyttaHubLocalizations.of(context)!.manageExportsTitle),
    ),
    SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        context.push(SiteMembersRoute.fullPath(siteId: widgetSiteId));
      },
      child: Text(HyttaHubLocalizations.of(context)!.manageSiteMembers),
    ),
    SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        context.push(SiteEventsDisplayRoute.fullPath(siteId: widgetSiteId));
      },
      child: Text(HyttaHubLocalizations.of(context)!.showSiteEventsState),
    ),

    // SimpleDialogOption(
    //   onPressed: null,
    //   // onPressed: () {
    //   //   Navigator.pop(context);
    //   //   context.push(
    //   //     AppEventsDisplayRoute.fullPath(siteId: widgetSiteId),
    //   //   );
    //   // },
    //   child: Text(HyttaHubLocalizations.of(context)!.showAppEventsState),
    // ),
    SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        context.push(SiteEmailsDisplayRoute.fullPath(siteId: widgetSiteId));
      },
      child: Text(HyttaHubLocalizations.of(context)!.showSiteAllowedEmails),
    ),
  ];
}
