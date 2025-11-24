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

// Top-level isolate handler for account replay. Runs in a background isolate
// via `compute()` and must be a top-level function.
FutureOr<String> accountReplayIsolateHandler(Map<String, dynamic> payload) {
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
  final AccountReplayBlocState state = AccountReplayBlocState.fromBuffer(
    stateBytes,
  );

  final AccountReplayBlocState newState = accountReplay(state, eventsMap);

  return base64Encode(newState.writeToBuffer());
}

// Top-level isolate handler for constructing initial state from hydrated events.
FutureOr<String> accountHydrateIsolateHandler(Map<String, dynamic> payload) {
  final dynamic eventsDynamic = payload['hydrated_events'];

  final Map<int, String> eventsMap = <int, String>{};
  if (eventsDynamic is Map) {
    eventsDynamic.forEach((k, v) {
      final int key = int.tryParse(k.toString()) ?? (k is int ? k : 0);
      eventsMap[key] = v as String;
    });
  }

  final AccountReplayBlocState newState = accountReplay(
    AccountReplayBlocState(),
    eventsMap,
  );

  return base64Encode(newState.writeToBuffer());
}

class AccountReplayBloc extends BaseReplayBloc<AccountReplayBlocState> {
  AccountReplayBloc(this.collectionName, {FirebaseFirestore? firestore})
    : super(
        AccountReplayBlocState(),
        firestore: firestore,
        replayIsolateHandler: accountReplayIsolateHandler,
        hydrateIsolateHandler: accountHydrateIsolateHandler,
      );

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
  AccountReplayBlocState stateFromProtoBytes(List<int> bytes) {
    final restored = AccountReplayBlocState.fromBuffer(bytes);
    return restored..freeze();
  }

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

    // Schedule async isolate-based reconstruction and apply when ready.
    scheduleAsyncHydration(hydratedEvents);

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
