// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hyttahub/common_blocs/base_replay_bloc.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';
import 'package:hyttahub/collection_paths.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/common_blocs.pbenum.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
export 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:hyttahub/service_blocs/service_replay.dart';
export 'package:hyttahub/service_blocs/service_replay.dart';


// Top-level isolate handler for service replay. Runs in a background isolate
// via `compute()` and must be a top-level function.
FutureOr<Uint8List> serviceReplayIsolateHandler(Map<String, dynamic> payload) {
  final Uint8List serializedState = payload['serialized_state'] as Uint8List;
  final Map<int, String> eventsMap = payload['events'];

  final ServiceReplayBlocState state = ServiceReplayBlocState.fromBuffer(
    serializedState,
  );

  final ServiceReplayBlocState newState = serviceReplay(state, eventsMap);

  return newState.writeToBuffer();
}

// Top-level isolate handler for constructing initial state from hydrated events.
FutureOr<Uint8List> serviceHydrateIsolateHandler(Map<int, String> eventsMap) {
  final ServiceReplayBlocState newState = serviceReplay(
    ServiceReplayBlocState(),
    eventsMap,
  );

  return newState.writeToBuffer();
}

class ServiceReplayBloc extends BaseReplayBloc<ServiceReplayBlocState> {
  ServiceReplayBloc({BaseHyttaHubStorage? storage})
    : super(
        ServiceReplayBlocState(state: CommonReplayStateEnum.hydrating),
        storage: storage,
        replayIsolateHandler: serviceReplayIsolateHandler,
        hydrateIsolateHandler: serviceHydrateIsolateHandler,
      );

  @override
  StorageEnum get storageType =>
      HyttaHubOptions.implementation?.storage ?? StorageEnum.cloud;

  @override
  final String collectionName = collectionServiceCollectionName;

  @override
  Future<String?> getCollectionPath() async {
    return collectionServiceEventsPath(collectionName);
  }

  @override
  ServiceReplayBlocState replayEvents(
    ServiceReplayBlocState currentState,
    Map<int, String> newEventsData,
  ) {
    return serviceReplay(currentState, newEventsData);
  }

  @override
  ServiceReplayBlocState stateCopyWithStatus(
    ServiceReplayBlocState currentState,
    CommonReplayStateEnum newStatusEnum,
  ) {
    return (currentState.deepCopy()..state = newStatusEnum);
  }

  @override
  Map<int, String> stateGetEventsMap(ServiceReplayBlocState state) =>
      state.events;

  @override
  ServiceReplayBlocState fromBuffer(Uint8List bytes) {
    return ServiceReplayBlocState.fromBuffer(bytes);
  }

  @override
  Uint8List toBuffer(ServiceReplayBlocState state) {
    return state.writeToBuffer();
  }
}
