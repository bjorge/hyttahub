// Copyright (c) 2025 bjorge

import 'package:formproto/proto/app_events.pb.dart';
import 'package:formproto/proto/app_replay_bloc.pb.dart';
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
