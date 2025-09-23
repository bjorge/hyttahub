// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:hyttahub/common_blocs/base_replay_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/common_blocs.pbenum.dart';
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
