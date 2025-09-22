//
//  Generated code. Do not modify.
//  source: site_email.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class MarkForDeletion_DeleteReason extends $pb.ProtobufEnum {
  static const MarkForDeletion_DeleteReason memberLeftSite = MarkForDeletion_DeleteReason._(0, _omitEnumNames ? '' : 'memberLeftSite');
  static const MarkForDeletion_DeleteReason memberRemovedFromSite = MarkForDeletion_DeleteReason._(1, _omitEnumNames ? '' : 'memberRemovedFromSite');
  static const MarkForDeletion_DeleteReason memberEmailUpdated = MarkForDeletion_DeleteReason._(2, _omitEnumNames ? '' : 'memberEmailUpdated');

  static const $core.List<MarkForDeletion_DeleteReason> values = <MarkForDeletion_DeleteReason> [
    memberLeftSite,
    memberRemovedFromSite,
    memberEmailUpdated,
  ];

  static final $core.Map<$core.int, MarkForDeletion_DeleteReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MarkForDeletion_DeleteReason? valueOf($core.int value) => _byValue[value];

  const MarkForDeletion_DeleteReason._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
