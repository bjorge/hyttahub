//
//  Generated code. Do not modify.
//  source: common_blocs.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class CommonReplayStateEnum extends $pb.ProtobufEnum {
  static const CommonReplayStateEnum ok = CommonReplayStateEnum._(0, _omitEnumNames ? '' : 'ok');
  static const CommonReplayStateEnum fetchingConfig = CommonReplayStateEnum._(1, _omitEnumNames ? '' : 'fetchingConfig');
  static const CommonReplayStateEnum uninitialized = CommonReplayStateEnum._(2, _omitEnumNames ? '' : 'uninitialized');
  static const CommonReplayStateEnum networkError = CommonReplayStateEnum._(3, _omitEnumNames ? '' : 'networkError');
  static const CommonReplayStateEnum permissionDenied = CommonReplayStateEnum._(4, _omitEnumNames ? '' : 'permissionDenied');

  static const $core.List<CommonReplayStateEnum> values = <CommonReplayStateEnum> [
    ok,
    fetchingConfig,
    uninitialized,
    networkError,
    permissionDenied,
  ];

  static final $core.Map<$core.int, CommonReplayStateEnum> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CommonReplayStateEnum? valueOf($core.int value) => _byValue[value];

  const CommonReplayStateEnum._($core.int v, $core.String n) : super(v, n);
}

class CommonSubmitBlocState_State extends $pb.ProtobufEnum {
  static const CommonSubmitBlocState_State ready = CommonSubmitBlocState_State._(0, _omitEnumNames ? '' : 'ready');
  static const CommonSubmitBlocState_State canSubmit = CommonSubmitBlocState_State._(1, _omitEnumNames ? '' : 'canSubmit');
  static const CommonSubmitBlocState_State submitting = CommonSubmitBlocState_State._(2, _omitEnumNames ? '' : 'submitting');
  static const CommonSubmitBlocState_State error = CommonSubmitBlocState_State._(3, _omitEnumNames ? '' : 'error');
  static const CommonSubmitBlocState_State success = CommonSubmitBlocState_State._(4, _omitEnumNames ? '' : 'success');

  static const $core.List<CommonSubmitBlocState_State> values = <CommonSubmitBlocState_State> [
    ready,
    canSubmit,
    submitting,
    error,
    success,
  ];

  static final $core.Map<$core.int, CommonSubmitBlocState_State> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CommonSubmitBlocState_State? valueOf($core.int value) => _byValue[value];

  const CommonSubmitBlocState_State._($core.int v, $core.String n) : super(v, n);
}

class CommonSubmitBlocState_ErrorCode extends $pb.ProtobufEnum {
  static const CommonSubmitBlocState_ErrorCode none = CommonSubmitBlocState_ErrorCode._(0, _omitEnumNames ? '' : 'none');
  static const CommonSubmitBlocState_ErrorCode networkError = CommonSubmitBlocState_ErrorCode._(1, _omitEnumNames ? '' : 'networkError');
  static const CommonSubmitBlocState_ErrorCode permissionDenied = CommonSubmitBlocState_ErrorCode._(2, _omitEnumNames ? '' : 'permissionDenied');

  static const $core.List<CommonSubmitBlocState_ErrorCode> values = <CommonSubmitBlocState_ErrorCode> [
    none,
    networkError,
    permissionDenied,
  ];

  static final $core.Map<$core.int, CommonSubmitBlocState_ErrorCode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CommonSubmitBlocState_ErrorCode? valueOf($core.int value) => _byValue[value];

  const CommonSubmitBlocState_ErrorCode._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
