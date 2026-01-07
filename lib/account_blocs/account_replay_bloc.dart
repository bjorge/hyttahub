// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hyttahub/account_blocs/acount_replay.dart';
import 'package:hyttahub/common_blocs/base_replay_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/account_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protobuf/protobuf.dart';

// Top-level isolate handler for service replay. Runs in a background isolate
// via `compute()` and must be a top-level function.
FutureOr<Uint8List> accountReplayIsolateHandler(Map<String, dynamic> payload) {
  final Uint8List serializedState = payload['serialized_state'] as Uint8List;
  final Map<int, String> eventsMap = payload['events'];

  final AccountReplayBlocState state = AccountReplayBlocState.fromBuffer(
    serializedState,
  );

  final AccountReplayBlocState newState = accountReplay(state, eventsMap);
  return newState.writeToBuffer();
}

// Top-level isolate handler for constructing initial state from hydrated events.
FutureOr<Uint8List> accountHydrateIsolateHandler(Map<int, String> eventsMap) {
  final AccountReplayBlocState newState = accountReplay(
    AccountReplayBlocState(),
    eventsMap,
  );

  return newState.writeToBuffer();
}

class AccountReplayBloc extends BaseReplayBloc<AccountReplayBlocState> {
  AccountReplayBloc(this.collectionName, {FirebaseFirestore? firestore})
    : super(
        AccountReplayBlocState(state: CommonReplayStateEnum.hydrating),
        firestore: firestore,
        replayIsolateHandler: accountReplayIsolateHandler,
        hydrateIsolateHandler: accountHydrateIsolateHandler,
      );

  @override
  StorageEnum get storageType =>
      HyttaHubOptions.implementation?.storage ?? StorageEnum.firestore;

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
  AccountReplayBlocState fromBuffer(Uint8List bytes) {
    return AccountReplayBlocState.fromBuffer(bytes);
  }

  @override
  Uint8List toBuffer(AccountReplayBlocState state) {
    return state.writeToBuffer();
  }
}
