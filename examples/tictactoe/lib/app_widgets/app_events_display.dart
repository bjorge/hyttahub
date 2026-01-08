// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:tictactoe/app_blocs/app_replay.dart';
import 'package:tictactoe/proto/app_events.pb.dart';
import 'package:tictactoe/proto/app_replay_bloc.pb.dart';
import 'package:hyttahub/common_widgets/events_display.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:flutter/material.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';

class AppEventsDisplayScreen extends StatelessWidget {
  const AppEventsDisplayScreen({super.key, required this.siteId});
  final String siteId;

  @override
  Widget build(BuildContext context) {
    return EventsDisplay(
      config: AppEventsConfig(siteId, 'App Events', 'App State'),
    );
  }
}

class AppEventsConfig
    extends EventsDisplayConfig<AppEventRecord, AppReplayBlocState> {
  AppEventsConfig(this.siteId, this.screenTitle, this.replayTitle);
  final String siteId;

  @override
  String get collectionPath => firebaseSiteEventsPath(siteId);

  @override
  final String screenTitle;

  @override
  final String replayTitle;

  @override
  AppEventRecord parseRecord(
    Map<String, dynamic> data,
    dynamic timestamp,
    String payload,
  ) {
    final siteEvent = SiteEvent.fromBuffer(base64Decode(payload));
    return AppEventRecord()
      ..isoDate = timestamp.toDate().toIso8601String()
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
