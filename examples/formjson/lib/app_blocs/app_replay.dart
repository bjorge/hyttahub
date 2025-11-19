// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:formjson/models/app_events.dart';
import 'package:formjson/models/app_replay_bloc.dart';
import 'package:hyttahub/proto/app_wrapper.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';

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
  var appBlocState = appBlocStateWrapper.hasPayload()
      ? AppReplayBlocState.fromJson(
          jsonDecode(utf8.decode(appBlocStateWrapper.payload)))
      : const AppReplayBlocState();

  if (siteEvent.hasAppEvent()) {
    final appEvent =
        AppEvent.fromJson(jsonDecode(utf8.decode(siteEvent.appEvent.payload)));

    appEvent.when(
      updateText: (text) {
        appBlocState = appBlocState.copyWith(text: text);
      },
    );
  }

  return packAppReplayWrapper(
    utf8.encode(
      jsonEncode(
        appBlocState.toJson(),
      ),
    ),
  );
}
