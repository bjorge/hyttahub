// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:template/app_blocs/app_replay_bloc.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';

AppReplayBlocState appReplay(
  AppReplayBlocState appBlocState,
  Map<int, String> base64Events,
) {
  final lastVersion = appBlocState.lastVersion;

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
        replay.textValue = appEvent.updateText.value;
      } else if (appEvent.hasUpdateCode()) {
        replay.codeValue = appEvent.updateCode.value;
      } else if (appEvent.hasUpdateCheckbox()) {
        replay.checkboxValue = appEvent.updateCheckbox.value;
      } else if (appEvent.hasUpdateDropdown()) {
        replay.dropdownValue = appEvent.updateDropdown.value;
      } else if (appEvent.hasUpdateList()) {
        replay.listItems.clear();
        replay.listItems.addAll(appEvent.updateList.items);
      } else if (appEvent.hasUpdatePhoto()) {
        replay.photoName = appEvent.updatePhoto.name;
        replay.photoVersion = appEvent.updatePhoto.version;
      }
    }
  }

  // Initialize list items if empty to show something
  if (replay.listItems.isEmpty) {
    replay.listItems.addAll([
      AppEvent_ReorderableItem(id: 1, title: 'Item 1'),
      AppEvent_ReorderableItem(id: 2, title: 'Item 2'),
      AppEvent_ReorderableItem(id: 3, title: 'Item 3'),
    ]);
  }

  return replay;
}
