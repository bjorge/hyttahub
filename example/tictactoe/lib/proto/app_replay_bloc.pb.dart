// This is a generated file - do not edit.
//
// Generated from app_replay_bloc.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'app_replay_bloc.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'app_replay_bloc.pbenum.dart';

class AppReplayBlocState extends $pb.GeneratedMessage {
  factory AppReplayBlocState({
    $core.Iterable<$core.MapEntry<$core.int, $core.String>>? events,
    AppReplayStateEnum? state,
    $core.Iterable<$core.int>? board,
    $core.int? turn,
    $core.int? winner,
    GameStatus? status,
    $core.bool? vsBot,
    $core.int? gameCount,
    $core.Iterable<$core.MapEntry<$core.int, $core.bool>>? activeMemberIds,
    $core.int? xPlayerId,
    $core.int? oPlayerId,
  }) {
    final result = create();
    if (events != null) result.events.addEntries(events);
    if (state != null) result.state = state;
    if (board != null) result.board.addAll(board);
    if (turn != null) result.turn = turn;
    if (winner != null) result.winner = winner;
    if (status != null) result.status = status;
    if (vsBot != null) result.vsBot = vsBot;
    if (gameCount != null) result.gameCount = gameCount;
    if (activeMemberIds != null)
      result.activeMemberIds.addEntries(activeMemberIds);
    if (xPlayerId != null) result.xPlayerId = xPlayerId;
    if (oPlayerId != null) result.oPlayerId = oPlayerId;
    return result;
  }

  AppReplayBlocState._();

  factory AppReplayBlocState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppReplayBlocState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppReplayBlocState',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'hyttahub.example.tictactoe'),
      createEmptyInstance: create)
    ..m<$core.int, $core.String>(1, _omitFieldNames ? '' : 'events',
        entryClassName: 'AppReplayBlocState.EventsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('hyttahub.example.tictactoe'))
    ..aE<AppReplayStateEnum>(2, _omitFieldNames ? '' : 'state',
        enumValues: AppReplayStateEnum.values)
    ..p<$core.int>(3, _omitFieldNames ? '' : 'board', $pb.PbFieldType.K3)
    ..aI(4, _omitFieldNames ? '' : 'turn')
    ..aI(5, _omitFieldNames ? '' : 'winner')
    ..aE<GameStatus>(7, _omitFieldNames ? '' : 'status',
        enumValues: GameStatus.values)
    ..aOB(8, _omitFieldNames ? '' : 'vsBot')
    ..aI(9, _omitFieldNames ? '' : 'gameCount')
    ..m<$core.int, $core.bool>(10, _omitFieldNames ? '' : 'activeMemberIds',
        entryClassName: 'AppReplayBlocState.ActiveMemberIdsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OB,
        packageName: const $pb.PackageName('hyttahub.example.tictactoe'))
    ..aI(11, _omitFieldNames ? '' : 'xPlayerId')
    ..aI(12, _omitFieldNames ? '' : 'oPlayerId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppReplayBlocState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppReplayBlocState copyWith(void Function(AppReplayBlocState) updates) =>
      super.copyWith((message) => updates(message as AppReplayBlocState))
          as AppReplayBlocState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppReplayBlocState create() => AppReplayBlocState._();
  @$core.override
  AppReplayBlocState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppReplayBlocState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppReplayBlocState>(create);
  static AppReplayBlocState? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.int, $core.String> get events => $_getMap(0);

  @$pb.TagNumber(2)
  AppReplayStateEnum get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(AppReplayStateEnum value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  /// Board state: 0 = empty, 1 = X, 2 = O
  /// Represented as a list of 9 integers (row-major)
  @$pb.TagNumber(3)
  $pb.PbList<$core.int> get board => $_getList(2);

  /// Whose turn is it? 1 = X, 2 = O
  @$pb.TagNumber(4)
  $core.int get turn => $_getIZ(3);
  @$pb.TagNumber(4)
  set turn($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTurn() => $_has(3);
  @$pb.TagNumber(4)
  void clearTurn() => $_clearField(4);

  /// Winner: 0 = none/ongoing, 1 = X, 2 = O, 3 = Draw
  @$pb.TagNumber(5)
  $core.int get winner => $_getIZ(4);
  @$pb.TagNumber(5)
  set winner($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWinner() => $_has(4);
  @$pb.TagNumber(5)
  void clearWinner() => $_clearField(5);

  /// Game status
  @$pb.TagNumber(7)
  GameStatus get status => $_getN(5);
  @$pb.TagNumber(7)
  set status(GameStatus value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  /// Whether this is a vs bot game
  @$pb.TagNumber(8)
  $core.bool get vsBot => $_getBF(6);
  @$pb.TagNumber(8)
  set vsBot($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(8)
  $core.bool hasVsBot() => $_has(6);
  @$pb.TagNumber(8)
  void clearVsBot() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get gameCount => $_getIZ(7);
  @$pb.TagNumber(9)
  set gameCount($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(9)
  $core.bool hasGameCount() => $_has(7);
  @$pb.TagNumber(9)
  void clearGameCount() => $_clearField(9);

  /// Active site member IDs
  @$pb.TagNumber(10)
  $pb.PbMap<$core.int, $core.bool> get activeMemberIds => $_getMap(8);

  /// The site member IDs for X and O players
  @$pb.TagNumber(11)
  $core.int get xPlayerId => $_getIZ(9);
  @$pb.TagNumber(11)
  set xPlayerId($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(11)
  $core.bool hasXPlayerId() => $_has(9);
  @$pb.TagNumber(11)
  void clearXPlayerId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get oPlayerId => $_getIZ(10);
  @$pb.TagNumber(12)
  set oPlayerId($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(12)
  $core.bool hasOPlayerId() => $_has(10);
  @$pb.TagNumber(12)
  void clearOPlayerId() => $_clearField(12);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
