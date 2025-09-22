// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/account_blocs/acount_replay.dart';
import 'package:hyttahub/common_widgets/events_display.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/account_events.pb.dart';
import 'package:hyttahub/proto/account_replay_bloc.pb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AccountEventsDisplayScreen extends StatelessWidget {
  const AccountEventsDisplayScreen({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return EventsDisplay(
      config: AccountEventsConfig(
        email,
        HyttaHubLocalizations.of(context)!.accountEventsTitle,
        HyttaHubLocalizations.of(context)!.accountStateTitle,
      ),
    );
  }
}

class AccountEventsConfig
    extends EventsDisplayConfig<AccountEventRecord, AccountReplayBlocState> {
  AccountEventsConfig(this.email, this.screenTitle, this.replayTitle);
  final String email;

  @override
  String get collectionPath => firebaseAccountEventsPath(email);

  @override
  final String screenTitle;

  @override
  final String replayTitle;

  @override
  AccountEventRecord parseRecord(
    Map<String, dynamic> data,
    Timestamp timestamp,
    String payload,
  ) {
    final accountEvent = AccountEvent.fromBuffer(base64Decode(payload));
    return AccountEventRecord()
      ..isoDate = timestamp.toDate().toIso8601String()
      ..version = accountEvent.version
      ..accountEvent = accountEvent
      ..freeze();
  }

  @override
  int getVersion(AccountEventRecord record) => record.version;

  @override
  String getIsoDate(AccountEventRecord record) => record.isoDate;

  @override
  AccountReplayBlocState replay(Map<int, String> base64Events) {
    return accountReplay(AccountReplayBlocState(), base64Events);
  }
}
