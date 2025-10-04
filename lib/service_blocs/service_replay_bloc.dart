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

class ServiceReplayBloc extends BaseReplayBloc<ServiceReplayBlocState> {
  ServiceReplayBloc({FirebaseFirestore? firestore})
    : super(ServiceReplayBlocState(), firestore: firestore);

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
    return restoredState..freeze();
  }

  @override
  Map<String, dynamic> stateToJson(ServiceReplayBlocState state) {
    return {};
  }
}
