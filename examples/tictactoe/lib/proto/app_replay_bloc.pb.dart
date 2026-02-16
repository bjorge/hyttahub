//
//  Generated code. Do not modify.
//  source: app_replay_bloc.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'app_replay_bloc.pbenum.dart';

export 'app_replay_bloc.pbenum.dart';

class AppReplayBlocState extends $pb.GeneratedMessage {
  factory AppReplayBlocState({
    $core.Map<$core.int, $core.String>? events,
    AppReplayStateEnum? state,
    $core.Iterable<$core.int>? board,
    $core.int? turn,
    $core.int? winner,
    GameStatus? status,
    $core.bool? vsBot,
    $core.int? gameCount,
    $core.Map<$core.int, $core.bool>? activeMemberIds,
    $core.int? xPlayerId,
    $core.int? oPlayerId,
  }) {
    final $result = create();
    if (events != null) {
      $result.events.addAll(events);
    }
    if (state != null) {
      $result.state = state;
    }
    if (board != null) {
      $result.board.addAll(board);
    }
    if (turn != null) {
      $result.turn = turn;
    }
    if (winner != null) {
      $result.winner = winner;
    }
    if (status != null) {
      $result.status = status;
    }
    if (vsBot != null) {
      $result.vsBot = vsBot;
    }
    if (gameCount != null) {
      $result.gameCount = gameCount;
    }
    if (activeMemberIds != null) {
      $result.activeMemberIds.addAll(activeMemberIds);
    }
    if (xPlayerId != null) {
      $result.xPlayerId = xPlayerId;
    }
    if (oPlayerId != null) {
      $result.oPlayerId = oPlayerId;
    }
    return $result;
  }
  AppReplayBlocState._() : super();
  factory AppReplayBlocState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppReplayBlocState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppReplayBlocState', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub.example.tictactoe'), createEmptyInstance: create)
    ..m<$core.int, $core.String>(1, _omitFieldNames ? '' : 'events', entryClassName: 'AppReplayBlocState.EventsEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('hyttahub.example.tictactoe'))
    ..e<AppReplayStateEnum>(2, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: AppReplayStateEnum.hydrating, valueOf: AppReplayStateEnum.valueOf, enumValues: AppReplayStateEnum.values)
    ..p<$core.int>(3, _omitFieldNames ? '' : 'board', $pb.PbFieldType.K3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'turn', $pb.PbFieldType.O3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'winner', $pb.PbFieldType.O3)
    ..e<GameStatus>(7, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: GameStatus.notStarted, valueOf: GameStatus.valueOf, enumValues: GameStatus.values)
    ..aOB(8, _omitFieldNames ? '' : 'vsBot')
    ..a<$core.int>(9, _omitFieldNames ? '' : 'gameCount', $pb.PbFieldType.O3)
    ..m<$core.int, $core.bool>(10, _omitFieldNames ? '' : 'activeMemberIds', entryClassName: 'AppReplayBlocState.ActiveMemberIdsEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.OB, packageName: const $pb.PackageName('hyttahub.example.tictactoe'))
    ..a<$core.int>(11, _omitFieldNames ? '' : 'xPlayerId', $pb.PbFieldType.O3)
    ..a<$core.int>(12, _omitFieldNames ? '' : 'oPlayerId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppReplayBlocState clone() => AppReplayBlocState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppReplayBlocState copyWith(void Function(AppReplayBlocState) updates) => super.copyWith((message) => updates(message as AppReplayBlocState)) as AppReplayBlocState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppReplayBlocState create() => AppReplayBlocState._();
  AppReplayBlocState createEmptyInstance() => create();
  static $pb.PbList<AppReplayBlocState> createRepeated() => $pb.PbList<AppReplayBlocState>();
  @$core.pragma('dart2js:noInline')
  static AppReplayBlocState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppReplayBlocState>(create);
  static AppReplayBlocState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.int, $core.String> get events => $_getMap(0);

  @$pb.TagNumber(2)
  AppReplayStateEnum get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(AppReplayStateEnum v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => clearField(2);

  /// Board state: 0 = empty, 1 = X, 2 = O
  /// Represented as a list of 9 integers (row-major)
  @$pb.TagNumber(3)
  $core.List<$core.int> get board => $_getList(2);

  /// Whose turn is it? 1 = X, 2 = O
  @$pb.TagNumber(4)
  $core.int get turn => $_getIZ(3);
  @$pb.TagNumber(4)
  set turn($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTurn() => $_has(3);
  @$pb.TagNumber(4)
  void clearTurn() => clearField(4);

  /// Winner: 0 = none/ongoing, 1 = X, 2 = O, 3 = Draw
  @$pb.TagNumber(5)
  $core.int get winner => $_getIZ(4);
  @$pb.TagNumber(5)
  set winner($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasWinner() => $_has(4);
  @$pb.TagNumber(5)
  void clearWinner() => clearField(5);

  /// Game status
  @$pb.TagNumber(7)
  GameStatus get status => $_getN(5);
  @$pb.TagNumber(7)
  set status(GameStatus v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(7)
  void clearStatus() => clearField(7);

  /// Whether this is a vs bot game
  @$pb.TagNumber(8)
  $core.bool get vsBot => $_getBF(6);
  @$pb.TagNumber(8)
  set vsBot($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(8)
  $core.bool hasVsBot() => $_has(6);
  @$pb.TagNumber(8)
  void clearVsBot() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get gameCount => $_getIZ(7);
  @$pb.TagNumber(9)
  set gameCount($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(9)
  $core.bool hasGameCount() => $_has(7);
  @$pb.TagNumber(9)
  void clearGameCount() => clearField(9);

  /// Active site member IDs
  @$pb.TagNumber(10)
  $core.Map<$core.int, $core.bool> get activeMemberIds => $_getMap(8);

  /// The site member IDs for X and O players
  @$pb.TagNumber(11)
  $core.int get xPlayerId => $_getIZ(9);
  @$pb.TagNumber(11)
  set xPlayerId($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(11)
  $core.bool hasXPlayerId() => $_has(9);
  @$pb.TagNumber(11)
  void clearXPlayerId() => clearField(11);

  @$pb.TagNumber(12)
  $core.int get oPlayerId => $_getIZ(10);
  @$pb.TagNumber(12)
  set oPlayerId($core.int v) { $_setSignedInt32(10, v); }
  @$pb.TagNumber(12)
  $core.bool hasOPlayerId() => $_has(10);
  @$pb.TagNumber(12)
  void clearOPlayerId() => clearField(12);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
