//
//  Generated code. Do not modify.
//  source: app_events.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class TreeConnectionType extends $pb.ProtobufEnum {
  static const TreeConnectionType parent = TreeConnectionType._(0, _omitEnumNames ? '' : 'parent');
  static const TreeConnectionType child = TreeConnectionType._(1, _omitEnumNames ? '' : 'child');
  static const TreeConnectionType partner = TreeConnectionType._(2, _omitEnumNames ? '' : 'partner');
  static const TreeConnectionType exPartner = TreeConnectionType._(3, _omitEnumNames ? '' : 'exPartner');
  static const TreeConnectionType friend = TreeConnectionType._(4, _omitEnumNames ? '' : 'friend');
  static const TreeConnectionType pet = TreeConnectionType._(5, _omitEnumNames ? '' : 'pet');

  static const $core.List<TreeConnectionType> values = <TreeConnectionType> [
    parent,
    child,
    partner,
    exPartner,
    friend,
    pet,
  ];

  static final $core.Map<$core.int, TreeConnectionType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TreeConnectionType? valueOf($core.int value) => _byValue[value];

  const TreeConnectionType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
