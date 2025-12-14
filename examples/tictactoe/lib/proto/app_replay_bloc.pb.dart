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

import 'app_events.pb.dart' as $0;
import 'app_replay_bloc.pbenum.dart';

export 'app_replay_bloc.pbenum.dart';

class AppReplayBlocState extends $pb.GeneratedMessage {
  factory AppReplayBlocState({
    $core.Map<$core.int, $core.String>? events,
    AppReplayStateEnum? state,
    $core.Iterable<$core.int>? board,
    $core.int? turn,
    $core.int? winner,
    $0.AppEvent_Move? nextMove,
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
    if (nextMove != null) {
      $result.nextMove = nextMove;
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
    ..aOM<$0.AppEvent_Move>(6, _omitFieldNames ? '' : 'nextMove', subBuilder: $0.AppEvent_Move.create)
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

  @$pb.TagNumber(6)
  $0.AppEvent_Move get nextMove => $_getN(5);
  @$pb.TagNumber(6)
  set nextMove($0.AppEvent_Move v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasNextMove() => $_has(5);
  @$pb.TagNumber(6)
  void clearNextMove() => clearField(6);
  @$pb.TagNumber(6)
  $0.AppEvent_Move ensureNextMove() => $_ensure(5);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
