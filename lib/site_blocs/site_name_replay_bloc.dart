// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hyttahub/common_blocs/base_replay_bloc.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/site_name_replay_bloc.pb.dart';
export 'package:hyttahub/proto/site_name_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/site_blocs/site_name_replay.dart';
import 'package:protobuf/protobuf.dart';

// Top-level isolate handler for site name replay.
FutureOr<Uint8List> siteNameReplayIsolateHandler(Map<String, dynamic> payload) {
  final Uint8List serializedState = payload['serialized_state'] as Uint8List;
  final Map<int, String> eventsMap = payload['events'];

  final SiteNameReplayBlocState state = SiteNameReplayBlocState.fromBuffer(
    serializedState,
  );

  final SiteNameReplayBlocState newState = siteNameReplay(state, eventsMap);
  return newState.writeToBuffer();
}

// Top-level isolate handler for constructing initial state from hydrated events.
FutureOr<Uint8List> siteNameHydrateIsolateHandler(Map<int, String> eventsMap) {
  final SiteNameReplayBlocState newState = siteNameReplay(
    SiteNameReplayBlocState(),
    eventsMap,
  );

  return newState.writeToBuffer();
}

class SiteNameReplayBloc extends BaseReplayBloc<SiteNameReplayBlocState> {
  SiteNameReplayBloc(this.collectionName, {BaseHyttaHubStorage? storage})
    : super(
        SiteNameReplayBlocState(state: CommonReplayStateEnum.hydrating),
        storage: storage,
        replayIsolateHandler: siteNameReplayIsolateHandler,
        hydrateIsolateHandler: siteNameHydrateIsolateHandler,
      );

  @override
  StorageEnum get storageType =>
      HyttaHubOptions.implementation?.storage ?? StorageEnum.cloud;

  @override
  final String collectionName;

  @override
  Future<String?> getCollectionPath() async {
    return firebaseSiteEventsPath(collectionName);
  }

  @override
  SiteNameReplayBlocState replayEvents(
    SiteNameReplayBlocState currentState,
    Map<int, String> newEventsData,
  ) {
    return siteNameReplay(currentState, newEventsData);
  }

  @override
  SiteNameReplayBlocState stateCopyWithStatus(
    SiteNameReplayBlocState currentState,
    CommonReplayStateEnum newStatusEnum,
  ) {
    return (currentState.deepCopy()..state = newStatusEnum);
  }

  @override
  Map<int, String> stateGetEventsMap(SiteNameReplayBlocState state) =>
      state.events;

  @override
  SiteNameReplayBlocState fromBuffer(Uint8List bytes) {
    return SiteNameReplayBlocState.fromBuffer(bytes);
  }

  @override
  Uint8List toBuffer(SiteNameReplayBlocState state) {
    return state.writeToBuffer();
  }
}
