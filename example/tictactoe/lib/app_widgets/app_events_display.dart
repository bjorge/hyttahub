// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:tictactoe/app_blocs/app_replay.dart';
import 'package:tictactoe/proto/app_events.pb.dart';
import 'package:tictactoe/proto/app_replay_bloc.pb.dart';
import 'package:hyttahub/common_widgets/events_display.dart';
import 'package:hyttahub/collection_paths.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:flutter/material.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

class AppEventsDisplayScreen extends StatelessWidget {
  const AppEventsDisplayScreen({super.key, required this.siteId});
  final String siteId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EventsDisplay(
      config: AppEventsConfig(siteId, l10n.app_appEventsTitle, l10n.app_appStateTitle),
    );
  }
}

class AppEventsConfig
    extends EventsDisplayConfig<AppEventRecord, AppReplayBlocState> {
  AppEventsConfig(this.siteId, this.screenTitle, this.replayTitle);
  final String siteId;

  @override
  String get collectionPath => collectionSiteEventsPath(siteId);

  @override
  final String screenTitle;

  @override
  final String replayTitle;

  @override
  AppEventRecord parseRecord(
    Map<String, dynamic> data,
    String isoDate,
    String payload,
  ) {
    final siteEvent = SiteEvent.fromBuffer(base64Decode(payload));
    return AppEventRecord()
      ..isoDate = isoDate
      ..version = siteEvent.version
      ..appEvent =
          siteEvent.hasAppEvent()
              ? unpackAppEventWrapper(siteEvent.appEvent, () => AppEvent())
              : AppEvent()
      ..freeze();
  }

  @override
  int getVersion(AppEventRecord record) => record.version;
  @override
  String getIsoDate(AppEventRecord record) => record.isoDate;
  @override
  AppReplayBlocState replay(Map<int, String> base64Events) {
    return appReplay(AppReplayBlocState(), base64Events);
  }
}
