// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hyttahub/account_blocs/acount_replay.dart';
import 'package:hyttahub/common_blocs/base_replay_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/account_events.pb.dart';
import 'package:hyttahub/proto/account_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protobuf/protobuf.dart';

class AccountReplayBloc extends BaseReplayBloc<AccountReplayBlocState> {
  AccountReplayBloc(this.collectionName, {FirebaseFirestore? firestore})
    : super(AccountReplayBlocState(), firestore: firestore);

  @override
  final String collectionName;

  @override
  Future<String?> getCollectionPath() async {
    return firebaseAccountEventsPath(collectionName);
  }

  @override
  AccountReplayBlocState replayEvents(
    AccountReplayBlocState currentState,
    Map<int, String> newEventsData,
  ) {
    return accountReplay(currentState, newEventsData);
  }

  @override
  AccountReplayBlocState stateCopyWithStatus(
    AccountReplayBlocState currentState,
    CommonReplayStateEnum newStatusEnum,
  ) {
    return (currentState.deepCopy()..state = newStatusEnum);
  }

  @override
  Map<int, String> stateGetEventsMap(AccountReplayBlocState state) =>
      state.events;

  @override
  Future<bool> validateLocalEventCache(
    AccountReplayBlocState localState,
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

    final firstEventInCache = AccountEvent.fromBuffer(
      base64Decode(cachedEventsMap[1]!),
    );

    final firstEventOnServer = AccountEvent.fromBuffer(
      base64Decode(base64Event),
    );

    if (kDebugMode) {
      print(
        "AccountReplayBloc: validateLocalEventCache: firstEventInCache: ${firstEventInCache.toProto3Json()}",
      );
      print(
        "AccountReplayBloc: validateLocalEventCache: firstEventOnServer: ${firstEventOnServer.toProto3Json()}",
      );
      print("cache matches server: ${firstEventInCache == firstEventOnServer}");
    }

    return firstEventInCache == firstEventOnServer;
  }

  @override
  void handleEmptyInitialSnapshot(
    Emitter<AccountReplayBlocState> emit,
    AccountReplayBlocState currentState,
  ) {
    emit(
      AccountReplayBlocState()
        ..state = CommonReplayStateEnum.uninitialized
        ..freeze(),
    );
  }

  @override
  AccountReplayBlocState stateFromJson(
    Map<String, dynamic> json,
    Map<int, String> hydratedEvents,
  ) {
    final restoredState = accountReplay(
      AccountReplayBlocState(),
      hydratedEvents,
    );

    return restoredState..freeze();
  }

  @override
  Map<String, dynamic> stateToJson(AccountReplayBlocState state) {
    return {};
  }

  @override
  CommonReplayStateEnum stateGetStatusEnum(AccountReplayBlocState state) {
    return state.state;
  }
}
