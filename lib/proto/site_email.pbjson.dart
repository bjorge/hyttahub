//
//  Generated code. Do not modify.
//  source: site_email.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use markForDeletionDescriptor instead')
const MarkForDeletion$json = {
  '1': 'MarkForDeletion',
  '2': [
    {'1': 'deleteReason', '3': 1, '4': 1, '5': 14, '6': '.MarkForDeletion.DeleteReason', '10': 'deleteReason'},
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

