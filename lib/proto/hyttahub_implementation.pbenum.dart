// This is a generated file - do not edit.
//
// Generated from hyttahub_implementation.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class StorageEnum extends $pb.ProtobufEnum {
  static const StorageEnum cloud =
      StorageEnum._(0, _omitEnumNames ? '' : 'cloud');
  static const StorageEnum memory =
      StorageEnum._(1, _omitEnumNames ? '' : 'memory');
  static const StorageEnum local =
      StorageEnum._(2, _omitEnumNames ? '' : 'local');

  static const $core.List<StorageEnum> values = <StorageEnum>[
    cloud,
    memory,
    local,
  ];

  static final $core.List<StorageEnum?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static StorageEnum? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const StorageEnum._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
