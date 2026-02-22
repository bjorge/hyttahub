// This is a generated file - do not edit.
//
// Generated from site_email.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use markForDeletionDescriptor instead')
const MarkForDeletion$json = {
  '1': 'MarkForDeletion',
  '2': [
    {
      '1': 'deleteReason',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.MarkForDeletion.DeleteReason',
      '10': 'deleteReason'
    },
  ],
  '4': [MarkForDeletion_DeleteReason$json],
};

@$core.Deprecated('Use markForDeletionDescriptor instead')
const MarkForDeletion_DeleteReason$json = {
  '1': 'DeleteReason',
  '2': [
    {'1': 'memberLeftSite', '2': 0},
    {'1': 'memberRemovedFromSite', '2': 1},
    {'1': 'memberEmailUpdated', '2': 2},
  ],
};

/// Descriptor for `MarkForDeletion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markForDeletionDescriptor = $convert.base64Decode(
    'Cg9NYXJrRm9yRGVsZXRpb24SQQoMZGVsZXRlUmVhc29uGAEgASgOMh0uTWFya0ZvckRlbGV0aW'
    '9uLkRlbGV0ZVJlYXNvblIMZGVsZXRlUmVhc29uIlUKDERlbGV0ZVJlYXNvbhISCg5tZW1iZXJM'
    'ZWZ0U2l0ZRAAEhkKFW1lbWJlclJlbW92ZWRGcm9tU2l0ZRABEhYKEm1lbWJlckVtYWlsVXBkYX'
    'RlZBAC');
