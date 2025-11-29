// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:formproto/proto/app_events.pb.dart';
import 'package:formproto/proto/app_replay_bloc.pb.dart';
import 'package:hyttahub/proto/app_wrapper.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';
import 'package:protobuf/protobuf.dart';

AppReplayWrapper appReplay(
  SiteReplayBlocState siteReplay,
  SiteEvent siteEvent,
) {
  // Unpack existing AppBlocState from SiteReplayBlocState
  final appBlocStateWrapper =
      siteReplay.hasAppBlocState()
          ? siteReplay.appBlocState
          : AppReplayWrapper();

  // Deserialize AppBlocState or create a new one
  final appBlocState =
      appBlocStateWrapper.hasPayload()
          ? AppReplayBlocState.fromBuffer(appBlocStateWrapper.payload)
          : AppReplayBlocState();

  if (siteEvent.hasAppEvent()) {
    final appEvent = unpackAppEventWrapper(siteEvent.appEvent, AppEvent.create);
    if (appEvent.hasUpdateText()) {
      appBlocState.text = appEvent.updateText.text;
    }
  }

  return packAppReplayWrapper(appBlocState.writeToBuffer());
}

AppReplayBlocState appReplay1(
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
