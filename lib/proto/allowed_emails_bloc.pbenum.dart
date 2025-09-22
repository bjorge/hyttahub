//
//  Generated code. Do not modify.
//  source: allowed_emails_bloc.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AllowedEmailsBlocState_State extends $pb.ProtobufEnum {
  static const AllowedEmailsBlocState_State fetching = AllowedEmailsBlocState_State._(0, _omitEnumNames ? '' : 'fetching');
  static const AllowedEmailsBlocState_State success = AllowedEmailsBlocState_State._(1, _omitEnumNames ? '' : 'success');
  static const AllowedEmailsBlocState_State error = AllowedEmailsBlocState_State._(2, _omitEnumNames ? '' : 'error');
  static const AllowedEmailsBlocState_State permissionDenied = AllowedEmailsBlocState_State._(3, _omitEnumNames ? '' : 'permissionDenied');

  static const $core.List<AllowedEmailsBlocState_State> values = <AllowedEmailsBlocState_State> [
    fetching,
    success,
    error,
    permissionDenied,
  ];

  static final $core.Map<$core.int, AllowedEmailsBlocState_State> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AllowedEmailsBlocState_State? valueOf($core.int value) => _byValue[value];

  const AllowedEmailsBlocState_State._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
