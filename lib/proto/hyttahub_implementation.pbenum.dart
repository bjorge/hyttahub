//
//  Generated code. Do not modify.
//  source: hyttahub_implementation.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class StorageEnum extends $pb.ProtobufEnum {
  static const StorageEnum cloud = StorageEnum._(0, _omitEnumNames ? '' : 'cloud');
  static const StorageEnum memory = StorageEnum._(1, _omitEnumNames ? '' : 'memory');
  static const StorageEnum local = StorageEnum._(2, _omitEnumNames ? '' : 'local');

  static const $core.List<StorageEnum> values = <StorageEnum> [
    cloud,
    memory,
    local,
  ];

  static final $core.Map<$core.int, StorageEnum> _byValue = $pb.ProtobufEnum.initByValue(values);
  static StorageEnum? valueOf($core.int value) => _byValue[value];

  const StorageEnum._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
