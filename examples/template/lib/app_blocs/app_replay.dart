// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:template/proto/app_events.pb.dart';
import 'package:template/proto/app_replay_bloc.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';
import 'package:protobuf/protobuf.dart';

AppReplayBlocState appReplay(
  AppReplayBlocState appBlocState,
  Map<int, String> base64Events,
) {
  final lastVersion = appBlocState.events.keys.fold(
    0,
    (previousValue, element) =>
        element > previousValue ? element : previousValue,
  );

  final eventKeys =
      base64Events.keys.where((key) => key > lastVersion).toList()..sort();

  if (eventKeys.isEmpty) {
    return appBlocState;
  }

  final replay = appBlocState.deepCopy();

  replay.events.addAll(base64Events);

  for (int i = 0; i < eventKeys.length; i++) {
    final eventVersion = eventKeys[i];
    final base64Event = base64Events[eventVersion];
    final event = SiteEvent.fromBuffer(base64Decode(base64Event!));

    if (event.hasAppEvent()) {
      final appEvent = unpackAppEventWrapper(event.appEvent, AppEvent.create);
      if (appEvent.hasUpdateText()) {
        replay.text = appEvent.updateText.text;
      }
    }
  }

  return replay;
}
