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

class AppReplayStateEnum extends $pb.ProtobufEnum {
  static const AppReplayStateEnum hydrating =
      AppReplayStateEnum._(0, _omitEnumNames ? '' : 'hydrating');
  static const AppReplayStateEnum listening =
      AppReplayStateEnum._(1, _omitEnumNames ? '' : 'listening');
  static const AppReplayStateEnum uninitializedListening =
      AppReplayStateEnum._(2, _omitEnumNames ? '' : 'uninitializedListening');
  static const AppReplayStateEnum networkError =
      AppReplayStateEnum._(3, _omitEnumNames ? '' : 'networkError');
  static const AppReplayStateEnum permissionDenied =
      AppReplayStateEnum._(4, _omitEnumNames ? '' : 'permissionDenied');

  static const $core.List<AppReplayStateEnum> values = <AppReplayStateEnum>[
    hydrating,
    listening,
    uninitializedListening,
    networkError,
    permissionDenied,
  ];

  static final $core.List<AppReplayStateEnum?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static AppReplayStateEnum? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AppReplayStateEnum._(super.value, super.name);
}

class GameStatus extends $pb.ProtobufEnum {
  static const GameStatus notStarted =
      GameStatus._(0, _omitEnumNames ? '' : 'notStarted');
  static const GameStatus playing =
      GameStatus._(1, _omitEnumNames ? '' : 'playing');
  static const GameStatus gameOver =
      GameStatus._(2, _omitEnumNames ? '' : 'gameOver');

  static const $core.List<GameStatus> values = <GameStatus>[
    notStarted,
    playing,
    gameOver,
  ];

  static final $core.List<GameStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static GameStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const GameStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
