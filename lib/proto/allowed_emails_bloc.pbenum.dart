// This is a generated file - do not edit.
//
// Generated from allowed_emails_bloc.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AllowedEmailsBlocState_State extends $pb.ProtobufEnum {
  static const AllowedEmailsBlocState_State fetching =
      AllowedEmailsBlocState_State._(0, _omitEnumNames ? '' : 'fetching');
  static const AllowedEmailsBlocState_State success =
      AllowedEmailsBlocState_State._(1, _omitEnumNames ? '' : 'success');
  static const AllowedEmailsBlocState_State error =
      AllowedEmailsBlocState_State._(2, _omitEnumNames ? '' : 'error');
  static const AllowedEmailsBlocState_State permissionDenied =
      AllowedEmailsBlocState_State._(
          3, _omitEnumNames ? '' : 'permissionDenied');

  static const $core.List<AllowedEmailsBlocState_State> values =
      <AllowedEmailsBlocState_State>[
    fetching,
    success,
    error,
    permissionDenied,
  ];

  static final $core.List<AllowedEmailsBlocState_State?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static AllowedEmailsBlocState_State? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AllowedEmailsBlocState_State._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
