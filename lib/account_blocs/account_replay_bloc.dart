// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:hyttahub/account_blocs/acount_replay.dart';
import 'package:hyttahub/common_blocs/base_replay_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/account_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:bloc/bloc.dart';
import 'package:protobuf/protobuf.dart';

class AccountReplayBloc extends BaseReplayBloc<AccountReplayBlocState> {
  AccountReplayBloc(this.collectionName) : super(AccountReplayBlocState());

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
