// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/common_widgets/events_display.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/site_blocs/site_replay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SiteEventsDisplayScreen extends StatelessWidget {
  const SiteEventsDisplayScreen({super.key, required this.siteId});
  final String siteId;

  @override
  Widget build(BuildContext context) {
    return EventsDisplay(
      config: SiteEventsConfig(
        siteId,
        HyttaHubLocalizations.of(context)!.siteEventsTitle,
        HyttaHubLocalizations.of(context)!.siteStateTitle,
      ),
    );
  }
}

class SiteEventsConfig
    extends EventsDisplayConfig<SiteEventRecord, SiteReplayBlocState> {
  SiteEventsConfig(this.siteId, this.screenTitle, this.replayTitle);
  final String siteId;

  @override
  String get collectionPath => firebaseSiteEventsPath(siteId);

  @override
  final String screenTitle;

  @override
  final String replayTitle;

  @override
  SiteEventRecord parseRecord(
    Map<String, dynamic> data,
    Timestamp timestamp,
    String payload,
  ) {
    final siteEvent = SiteEvent.fromBuffer(base64Decode(payload));
    return SiteEventRecord()
      ..isoDate = timestamp.toDate().toIso8601String()
      ..version = siteEvent.version
      ..siteEvent = siteEvent
      ..freeze();
  }

  @override
  int getVersion(SiteEventRecord record) => record.version;
  @override
  String getIsoDate(SiteEventRecord record) => record.isoDate;
  @override
  SiteReplayBlocState replay(Map<int, String> base64Events) {
    return siteReplay(SiteReplayBlocState(), base64Events);
  }
}
