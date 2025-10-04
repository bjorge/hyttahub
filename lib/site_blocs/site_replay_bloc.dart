// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hyttahub/common_blocs/base_replay_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/site_blocs/site_replay.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protobuf/protobuf.dart';

class SiteReplayBloc extends BaseReplayBloc<SiteReplayBlocState> {
  SiteReplayBloc(this.collectionName, {FirebaseFirestore? firestore})
    : super(SiteReplayBlocState(), firestore: firestore);

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
  Future<bool> validateLocalEventCache(
    SiteReplayBlocState localState,
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

    final firstEventInCache = SiteEvent.fromBuffer(
      base64Decode(cachedEventsMap[1]!),
    );

    final firstEventOnServer = SiteEvent.fromBuffer(base64Decode(base64Event));

    if (kDebugMode) {
      print(
        "SiteReplayBloc: validateLocalEventCache: firstEventInCache: ${firstEventInCache.toProto3Json()}",
      );
      print(
        "SiteReplayBloc: validateLocalEventCache: firstEventOnServer: ${firstEventOnServer.toProto3Json()}",
      );
      print("cache matches server: ${firstEventInCache == firstEventOnServer}");
    }

    return firstEventInCache == firstEventOnServer;
  }

  @override
  void handleEmptyInitialSnapshot(
    Emitter<SiteReplayBlocState> emit,
    SiteReplayBlocState currentState,
  ) {
    emit(
      SiteReplayBlocState()
        ..state = CommonReplayStateEnum.uninitialized
        ..freeze(),
    );
  }

  @override
  SiteReplayBlocState stateFromJson(
    Map<String, dynamic> json,
    Map<int, String> hydratedEvents,
  ) {
    final restoredState = siteReplay(SiteReplayBlocState(), hydratedEvents);

    return restoredState..freeze();
  }

  @override
  Map<String, dynamic> stateToJson(SiteReplayBlocState state) {
    return {};
  }

  @override
  CommonReplayStateEnum stateGetStatusEnum(SiteReplayBlocState state) {
    return state.state;
  }
}
