// This is a generated file - do not edit.
//
// Generated from common_blocs.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class CommonReplayStateEnum extends $pb.ProtobufEnum {
  static const CommonReplayStateEnum hydrating =
      CommonReplayStateEnum._(0, _omitEnumNames ? '' : 'hydrating');
  static const CommonReplayStateEnum listening =
      CommonReplayStateEnum._(1, _omitEnumNames ? '' : 'listening');
  static const CommonReplayStateEnum uninitializedListening =
      CommonReplayStateEnum._(
          2, _omitEnumNames ? '' : 'uninitializedListening');
  static const CommonReplayStateEnum networkError =
      CommonReplayStateEnum._(3, _omitEnumNames ? '' : 'networkError');
  static const CommonReplayStateEnum permissionDenied =
      CommonReplayStateEnum._(4, _omitEnumNames ? '' : 'permissionDenied');

  static const $core.List<CommonReplayStateEnum> values =
      <CommonReplayStateEnum>[
    hydrating,
    listening,
    uninitializedListening,
    networkError,
    permissionDenied,
  ];

  static final $core.List<CommonReplayStateEnum?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CommonReplayStateEnum? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CommonReplayStateEnum._(super.value, super.name);
}

class CommonSubmitBlocState_State extends $pb.ProtobufEnum {
  static const CommonSubmitBlocState_State ready =
      CommonSubmitBlocState_State._(0, _omitEnumNames ? '' : 'ready');
  static const CommonSubmitBlocState_State canSubmit =
      CommonSubmitBlocState_State._(1, _omitEnumNames ? '' : 'canSubmit');
  static const CommonSubmitBlocState_State submitting =
      CommonSubmitBlocState_State._(2, _omitEnumNames ? '' : 'submitting');
  static const CommonSubmitBlocState_State error =
      CommonSubmitBlocState_State._(3, _omitEnumNames ? '' : 'error');
  static const CommonSubmitBlocState_State success =
      CommonSubmitBlocState_State._(4, _omitEnumNames ? '' : 'success');

  static const $core.List<CommonSubmitBlocState_State> values =
      <CommonSubmitBlocState_State>[
    ready,
    canSubmit,
    submitting,
    error,
    success,
  ];

  static final $core.List<CommonSubmitBlocState_State?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CommonSubmitBlocState_State? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CommonSubmitBlocState_State._(super.value, super.name);
}

class CommonSubmitBlocState_ErrorCode extends $pb.ProtobufEnum {
  static const CommonSubmitBlocState_ErrorCode none =
      CommonSubmitBlocState_ErrorCode._(0, _omitEnumNames ? '' : 'none');
  static const CommonSubmitBlocState_ErrorCode networkError =
      CommonSubmitBlocState_ErrorCode._(
          1, _omitEnumNames ? '' : 'networkError');
  static const CommonSubmitBlocState_ErrorCode permissionDenied =
      CommonSubmitBlocState_ErrorCode._(
          2, _omitEnumNames ? '' : 'permissionDenied');

  static const $core.List<CommonSubmitBlocState_ErrorCode> values =
      <CommonSubmitBlocState_ErrorCode>[
    none,
    networkError,
    permissionDenied,
  ];

  static final $core.List<CommonSubmitBlocState_ErrorCode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static CommonSubmitBlocState_ErrorCode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CommonSubmitBlocState_ErrorCode._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
