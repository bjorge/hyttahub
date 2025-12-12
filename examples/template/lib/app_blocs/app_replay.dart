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
      if (appEvent.hasTemplateForm()) {
        replay.textValue = appEvent.templateForm.textValue;
        replay.codeValue = appEvent.templateForm.codeValue;
        replay.checkboxValue = appEvent.templateForm.checkboxValue;
        replay.dropdownValue = appEvent.templateForm.dropdownValue;
        replay.listItems.clear();
        replay.listItems.addAll(appEvent.templateForm.listItems);
        if (appEvent.templateForm.photoVersion > 0) {
          replay.photoVersion = appEvent.templateForm.photoVersion;
          replay.photoName = appEvent.templateForm.photoName;
        }
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
