// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/common_widgets/events_display.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/service_events.pb.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:hyttahub/service_blocs/service_replay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServiceEventsDisplayScreen extends StatelessWidget {
  const ServiceEventsDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EventsDisplay(
      config: ServiceEventsConfig(HyttaHubLocalizations.of(context)!),
    );
  }
}

class ServiceEventsConfig
    extends EventsDisplayConfig<ServiceEventRecord, ServiceReplayBlocState> {
  ServiceEventsConfig(this.localizations);
  final HyttaHubLocalizations localizations;
  @override
  String get collectionPath =>
      firebaseServiceEventsPath(firebaseServiceCollectionName);

  @override
  String get screenTitle => localizations.serviceEventsTitle;

  @override
  String get replayTitle => localizations.serviceStateTitle;

  @override
  ServiceEventRecord parseRecord(
    Map<String, dynamic> data,
    Timestamp timestamp,
    String payload,
  ) {
    final serviceEvent = ServiceEvent.fromBuffer(base64Decode(payload));
    return ServiceEventRecord()
      ..isoDate = timestamp.toDate().toIso8601String()
      ..version = serviceEvent.version
      ..serviceEvent = serviceEvent
      ..freeze();
  }

  @override
  int getVersion(ServiceEventRecord record) => record.version;

  @override
  String getIsoDate(ServiceEventRecord record) => record.isoDate;

  @override
  ServiceReplayBlocState replay(Map<int, String> base64Events) {
    return serviceReplay(ServiceReplayBlocState(), base64Events);
  }
}
