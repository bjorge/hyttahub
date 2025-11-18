// Copyright (c) 2025 bjorge

import 'package:hyttahub/blocs/site_replay_bloc.dart';
import 'package:hyttahub/proto/site_events.pb.dart';

SiteReplayBlocState appReplay(SiteReplayBlocState siteReplay, SiteEvent event) {
  // Since we cannot compile protos, we will simulate the replay with Maps.
  var appBlocState = siteReplay.appBlocState.isEmpty
      ? {'text': '', 'submitted': false}
      : Map<String, dynamic>.from(siteReplay.appBlocState[0]);

  final appEvent = Map<String, dynamic>.from(event.appEvent[0]);

  if (appEvent.containsKey('update_text')) {
    appBlocState['text'] = appEvent['update_text']['text'];
  } else if (appEvent.containsKey('update_submitted')) {
    appBlocState['submitted'] = appEvent['update_submitted']['submitted'];
  }

  return SiteReplayBlocState.fromBuffer(
    siteReplay.toBuffer(),
  )..appBlocState.replaceRange(0, 1, [appBlocState]);
}
