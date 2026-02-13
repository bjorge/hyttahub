// Copyright (c) 2025 bjorge

import 'dart:convert';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_name_replay_bloc.pb.dart';
import 'package:protobuf/protobuf.dart';

// update the passed in replay state with the new events
SiteNameReplayBlocState siteNameReplay(
  SiteNameReplayBlocState siteNameReplay,
  Map<int, String> base64Events,
) {
  final eventKeys = base64Events.keys
      .where((key) => key > (siteNameReplay.events.keys.fold(0, (previousValue, element) => element > previousValue ? element : previousValue)))
      .toList()
    ..sort();

  if (eventKeys.isEmpty) {
    return siteNameReplay;
  }

  final replay = siteNameReplay.deepCopy();
  replay.events.addAll(base64Events);

  for (int i = 0; i < eventKeys.length; i++) {
    final eventVersion = eventKeys[i];
    final base64Event = base64Events[eventVersion];
    final event = SiteEvent.fromBuffer(base64Decode(base64Event!));

    if (event.hasNewSite()) {
      replay.name = event.newSite.siteName;
    }

    if (event.hasUpdateSiteName()) {
      replay.name = event.updateSiteName.name;
    }

    if (event.hasImportEvent()) {
      if (event.importEvent.hasSiteName()) {
        replay.name = event.importEvent.siteName;
      } else {
        replay.name = '~${replay.name}~';
      }
    }
  }

  return replay;
}
