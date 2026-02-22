// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hyttahub/common_blocs/base_replay_bloc.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
export 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/site_blocs/site_replay.dart';
export 'package:hyttahub/site_blocs/site_replay.dart';


// Top-level isolate handler for service replay. Runs in a background isolate
// via `compute()` and must be a top-level function.
FutureOr<Uint8List> siteReplayIsolateHandler(Map<String, dynamic> payload) {
  final Uint8List serializedState = payload['serialized_state'] as Uint8List;
  final Map<int, String> eventsMap = payload['events'];

  final SiteReplayBlocState state = SiteReplayBlocState.fromBuffer(
    serializedState,
  );

  final SiteReplayBlocState newState = siteReplay(state, eventsMap);
  return newState.writeToBuffer();
}

// Top-level isolate handler for constructing initial state from hydrated events.
FutureOr<Uint8List> siteHydrateIsolateHandler(Map<int, String> eventsMap) {
  final SiteReplayBlocState newState = siteReplay(
    SiteReplayBlocState(),
    eventsMap,
  );

  return newState.writeToBuffer();
}

class SiteReplayBloc extends BaseReplayBloc<SiteReplayBlocState> {
  SiteReplayBloc(this.collectionName, {BaseHyttaHubStorage? storage})
    : super(
        SiteReplayBlocState(state: CommonReplayStateEnum.hydrating),
        storage: storage,
        replayIsolateHandler: siteReplayIsolateHandler,
        hydrateIsolateHandler: siteHydrateIsolateHandler,
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
  SiteReplayBlocState replayEvents(
    SiteReplayBlocState currentState,
    Map<int, String> newEventsData,
  ) {
    return siteReplay(currentState, newEventsData);
  }

  @override
  SiteReplayBlocState stateCopyWithStatus(
    SiteReplayBlocState currentState,
    CommonReplayStateEnum newStatusEnum,
  ) {
    return (currentState.deepCopy()..state = newStatusEnum);
  }

  @override
  Map<int, String> stateGetEventsMap(SiteReplayBlocState state) => state.events;

  @override
  SiteReplayBlocState fromBuffer(Uint8List bytes) {
    return SiteReplayBlocState.fromBuffer(bytes);
  }

  @override
  Uint8List toBuffer(SiteReplayBlocState state) {
    return state.writeToBuffer();
  }
}
