// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:hyttahub/common_blocs/base_replay_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/site_blocs/site_replay.dart';
import 'package:bloc/bloc.dart';
import 'package:protobuf/protobuf.dart';

class SiteReplayBloc extends BaseReplayBloc<SiteReplayBlocState> {
  SiteReplayBloc(this.collectionName) : super(SiteReplayBlocState());

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
