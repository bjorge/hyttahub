// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hyttahub/common_blocs/base_replay_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/common_blocs.pbenum.dart';
import 'package:hyttahub/proto/service_events.pb.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:hyttahub/service_blocs/service_replay.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protobuf/protobuf.dart';

// Top-level isolate handler for service replay. Runs in a background isolate
// via `compute()` and must be a top-level function.
FutureOr<String> serviceReplayIsolateHandler(Map<String, dynamic> payload) {
  final String stateB64 = payload['state_proto_base64'] as String;
  final dynamic eventsDynamic = payload['events'];

  final Map<int, String> eventsMap = <int, String>{};
  if (eventsDynamic is Map) {
    eventsDynamic.forEach((k, v) {
      final int key = int.tryParse(k.toString()) ?? (k is int ? k : 0);
      eventsMap[key] = v as String;
    });
  }

  final List<int> stateBytes = base64Decode(stateB64);
  final ServiceReplayBlocState state = ServiceReplayBlocState.fromBuffer(
    stateBytes,
  );

  final ServiceReplayBlocState newState = serviceReplay(state, eventsMap);

  return base64Encode(newState.writeToBuffer());
}

// Top-level isolate handler for constructing initial state from hydrated events.
FutureOr<String> serviceHydrateIsolateHandler(Map<String, dynamic> payload) {
  final dynamic eventsDynamic = payload['hydrated_events'];

  final Map<int, String> eventsMap = <int, String>{};
  if (eventsDynamic is Map) {
    eventsDynamic.forEach((k, v) {
      final int key = int.tryParse(k.toString()) ?? (k is int ? k : 0);
      eventsMap[key] = v as String;
    });
  }

  final ServiceReplayBlocState newState = serviceReplay(
    ServiceReplayBlocState(),
    eventsMap,
  );

  return base64Encode(newState.writeToBuffer());
}

class ServiceReplayBloc extends BaseReplayBloc<ServiceReplayBlocState> {
  ServiceReplayBloc({FirebaseFirestore? firestore})
    : super(
        ServiceReplayBlocState(),
        firestore: firestore,
        replayIsolateHandler: serviceReplayIsolateHandler,
        hydrateIsolateHandler: serviceHydrateIsolateHandler,
      );

  @override
  final String collectionName = firebaseServiceCollectionName;

  @override
  Future<String?> getCollectionPath() async {
    return firebaseServiceEventsPath(collectionName);
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
  ServiceReplayBlocState stateFromProtoBytes(List<int> bytes) {
    final restored = ServiceReplayBlocState.fromBuffer(bytes);
    return restored..freeze();
  }

  @override
  Future<bool> validateLocalEventCache(
    ServiceReplayBlocState localState,
    String collectionPath,
  ) async {
    final cachedEventsMap = stateGetEventsMap(localState);

    if (cachedEventsMap.isEmpty) {
      return true; // Local state is empty, so cache is valid.
    }

    if (!cachedEventsMap.containsKey(1)) {
      return false; // Local cache is invalid if it doesn't contain the first event.
    }

    // check if cache exists but data has been removed from server
    final firstEventDoc = await getFirstEventDocument(collectionPath);
    if (!firstEventDoc.exists ||
        !firstEventDoc.data()!.containsKey(payloadField)) {
      return false; // First event document does not exist, clear local cache
    }

    final base64Event = firstEventDoc.data()![payloadField] as String;

    final firstEventInCache = ServiceEvent.fromBuffer(
      base64Decode(cachedEventsMap[1]!),
    );

    final firstEventOnServer = ServiceEvent.fromBuffer(
      base64Decode(base64Event),
    );

    if (kDebugMode) {
      print(
        "ServiceReplayBloc: validateLocalEventCache: firstEventInCache: ${firstEventInCache.toProto3Json()}",
      );
      print(
        "ServiceReplayBloc: validateLocalEventCache: firstEventOnServer: ${firstEventOnServer.toProto3Json()}",
      );
      print("cache matches server: ${firstEventInCache == firstEventOnServer}");
    }

    return firstEventInCache == firstEventOnServer;
  }

  @override
  CommonReplayStateEnum stateGetStatusEnum(ServiceReplayBlocState state) =>
      state.state;

  @override
  void handleEmptyInitialSnapshot(
    Emitter<ServiceReplayBlocState> emit,
    ServiceReplayBlocState currentState,
  ) {
    // ServiceReplayBloc uses an 'uninitialized' state if empty initially.
    emit(
      ServiceReplayBlocState()
        ..state = CommonReplayStateEnum.uninitialized
        ..freeze(),
    );
  }

  @override
  ServiceReplayBlocState stateFromJson(
    Map<String, dynamic> json,
    Map<int, String> hydratedEvents,
  ) {
    final restoredState = serviceReplay(
      ServiceReplayBlocState(),
      hydratedEvents,
    );
    // Schedule async hydrate in a background isolate to perform full
    // protobuf-based reconstruction and replace the state when ready.
    scheduleAsyncHydration(hydratedEvents);
    return restoredState..freeze();
  }

  @override
  Map<String, dynamic> stateToJson(ServiceReplayBlocState state) {
    return {};
  }
}
