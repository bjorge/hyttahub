// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tictactoe/app_blocs/app_replay.dart';
export 'package:tictactoe/app_blocs/app_submit_bloc.dart';
export 'package:tictactoe/proto/app_events.pb.dart';
import 'package:tictactoe/proto/app_replay_bloc.pb.dart';
export 'package:tictactoe/proto/app_replay_bloc.pb.dart';
import 'package:hyttahub/common_blocs/base_replay_bloc.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';


// Top-level isolate handler for service replay. Runs in a background isolate
// via `compute()` and must be a top-level function.
FutureOr<Uint8List> appReplayIsolateHandler(Map<String, dynamic> payload) {
  final Uint8List serializedState = payload['serialized_state'] as Uint8List;
  final Map<int, String> eventsMap = payload['events'];

  final AppReplayBlocState state = AppReplayBlocState.fromBuffer(
    serializedState,
  );

  final AppReplayBlocState newState = appReplay(state, eventsMap);
  return newState.writeToBuffer();
}

// Top-level isolate handler for constructing initial state from hydrated events.
FutureOr<Uint8List> appHydrateIsolateHandler(Map<int, String> eventsMap) {
  final AppReplayBlocState newState = appReplay(
    AppReplayBlocState(),
    eventsMap,
  );

  return newState.writeToBuffer();
}

class AppReplayBloc extends BaseReplayBloc<AppReplayBlocState> {
  AppReplayBloc(this.collectionName, {BaseHyttaHubStorage? storage})
    : super(
        AppReplayBlocState(),
        storage: storage,
        replayIsolateHandler: appReplayIsolateHandler,
        hydrateIsolateHandler: appHydrateIsolateHandler,
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
  AppReplayBlocState replayEvents(
    AppReplayBlocState currentState,
    Map<int, String> newEventsData,
  ) {
    return appReplay(currentState, newEventsData);
  }

  @override
  AppReplayBlocState stateCopyWithStatus(
    AppReplayBlocState currentState,
    CommonReplayStateEnum newStatusEnum,
  ) {
    // todo: create a lookup table instead
    switch (newStatusEnum) {
      case CommonReplayStateEnum.hydrating:
        return (currentState.deepCopy()..state = AppReplayStateEnum.hydrating);
      case CommonReplayStateEnum.listening:
        return (currentState.deepCopy()..state = AppReplayStateEnum.listening);
      case CommonReplayStateEnum.networkError:
        return (currentState.deepCopy()
          ..state = AppReplayStateEnum.networkError);
      case CommonReplayStateEnum.permissionDenied:
        return (currentState.deepCopy()
          ..state = AppReplayStateEnum.permissionDenied);
      case CommonReplayStateEnum.uninitializedListening:
        return (currentState.deepCopy()
          ..state = AppReplayStateEnum.uninitializedListening);
    }
    return (currentState.deepCopy()..state = AppReplayStateEnum.networkError);
  }

  @override
  Map<int, String> stateGetEventsMap(AppReplayBlocState state) => state.events;

  @override
  AppReplayBlocState fromBuffer(Uint8List bytes) {
    return AppReplayBlocState.fromBuffer(bytes);
  }

  @override
  Uint8List toBuffer(AppReplayBlocState state) {
    return state.writeToBuffer();
  }
}

extension AppReplayBlocStateX on AppReplayBlocState {
  int get lastVersion =>
      events.isEmpty ? 0 : events.keys.fold(0, (previousValue, element) => element > previousValue ? element : previousValue);
  int get nextVersion => lastVersion + 1;
}
