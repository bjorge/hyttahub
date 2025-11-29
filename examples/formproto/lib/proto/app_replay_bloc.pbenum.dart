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

class AppReplayStateEnum extends $pb.ProtobufEnum {
  static const AppReplayStateEnum hydrating = AppReplayStateEnum._(0, _omitEnumNames ? '' : 'hydrating');
  static const AppReplayStateEnum listening = AppReplayStateEnum._(1, _omitEnumNames ? '' : 'listening');
  static const AppReplayStateEnum uninitializedListening = AppReplayStateEnum._(2, _omitEnumNames ? '' : 'uninitializedListening');
  static const AppReplayStateEnum networkError = AppReplayStateEnum._(3, _omitEnumNames ? '' : 'networkError');
  static const AppReplayStateEnum permissionDenied = AppReplayStateEnum._(4, _omitEnumNames ? '' : 'permissionDenied');

  static const $core.List<AppReplayStateEnum> values = <AppReplayStateEnum> [
    hydrating,
    listening,
    uninitializedListening,
    networkError,
    permissionDenied,
  ];

  static final $core.Map<$core.int, AppReplayStateEnum> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AppReplayStateEnum? valueOf($core.int value) => _byValue[value];

  const AppReplayStateEnum._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
