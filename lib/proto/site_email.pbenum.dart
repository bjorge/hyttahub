// This is a generated file - do not edit.
//
// Generated from site_email.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class MarkForDeletion_DeleteReason extends $pb.ProtobufEnum {
  static const MarkForDeletion_DeleteReason memberLeftSite =
      MarkForDeletion_DeleteReason._(0, _omitEnumNames ? '' : 'memberLeftSite');
  static const MarkForDeletion_DeleteReason memberRemovedFromSite =
      MarkForDeletion_DeleteReason._(
          1, _omitEnumNames ? '' : 'memberRemovedFromSite');
  static const MarkForDeletion_DeleteReason memberEmailUpdated =
      MarkForDeletion_DeleteReason._(
          2, _omitEnumNames ? '' : 'memberEmailUpdated');

  static const $core.List<MarkForDeletion_DeleteReason> values =
      <MarkForDeletion_DeleteReason>[
    memberLeftSite,
    memberRemovedFromSite,
    memberEmailUpdated,
  ];

  static final $core.List<MarkForDeletion_DeleteReason?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static MarkForDeletion_DeleteReason? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MarkForDeletion_DeleteReason._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
