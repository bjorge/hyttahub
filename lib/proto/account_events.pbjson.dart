//
//  Generated code. Do not modify.
//  source: account_events.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use accountEventDescriptor instead')
const AccountEvent$json = {
  '1': 'AccountEvent',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 5, '10': 'version'},
    {'1': 'initialEvent', '3': 2, '4': 1, '5': 11, '6': '.AccountEvent.InitialEvent', '9': 0, '10': 'initialEvent'},
    {'1': 'terms', '3': 3, '4': 1, '5': 11, '6': '.AccountEvent.Terms', '9': 0, '10': 'terms'},
    {'1': 'allowEmailNotifications', '3': 4, '4': 1, '5': 8, '9': 0, '10': 'allowEmailNotifications'},
    {'1': 'createSite', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'createSite'},
    {'1': 'removeSite', '3': 6, '4': 1, '5': 9, '9': 0, '10': 'removeSite'},
    {'1': 'joinSite', '3': 7, '4': 1, '5': 9, '9': 0, '10': 'joinSite'},
    {'1': 'leaveSite', '3': 8, '4': 1, '5': 9, '9': 0, '10': 'leaveSite'},
  ],
  '3': [AccountEvent_Terms$json, AccountEvent_InitialEvent$json],
  '8': [
    {'1': 'event_type'},
  ],
};

@$core.Deprecated('Use accountEventDescriptor instead')
const AccountEvent_Terms$json = {
  '1': 'Terms',
  '2': [
    {'1': 'termsVersion', '3': 1, '4': 1, '5': 5, '10': 'termsVersion'},
    {'1': 'policyVersion', '3': 2, '4': 1, '5': 5, '10': 'policyVersion'},
  ],
};

@$core.Deprecated('Use accountEventDescriptor instead')
const AccountEvent_InitialEvent$json = {
  '1': 'InitialEvent',
  '2': [
    {'1': 'terms', '3': 1, '4': 1, '5': 11, '6': '.AccountEvent.Terms', '10': 'terms'},
    {'1': 'instance', '3': 2, '4': 1, '5': 9, '10': 'instance'},
  ],
};

/// Descriptor for `AccountEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountEventDescriptor = $convert.base64Decode(
    'CgxBY2NvdW50RXZlbnQSGAoHdmVyc2lvbhgBIAEoBVIHdmVyc2lvbhJACgxpbml0aWFsRXZlbn'
    'QYAiABKAsyGi5BY2NvdW50RXZlbnQuSW5pdGlhbEV2ZW50SABSDGluaXRpYWxFdmVudBIrCgV0'
    'ZXJtcxgDIAEoCzITLkFjY291bnRFdmVudC5UZXJtc0gAUgV0ZXJtcxI6ChdhbGxvd0VtYWlsTm'
    '90aWZpY2F0aW9ucxgEIAEoCEgAUhdhbGxvd0VtYWlsTm90aWZpY2F0aW9ucxIgCgpjcmVhdGVT'
    'aXRlGAUgASgJSABSCmNyZWF0ZVNpdGUSIAoKcmVtb3ZlU2l0ZRgGIAEoCUgAUgpyZW1vdmVTaX'
    'RlEhwKCGpvaW5TaXRlGAcgASgJSABSCGpvaW5TaXRlEh4KCWxlYXZlU2l0ZRgIIAEoCUgAUgls'
    'ZWF2ZVNpdGUaUQoFVGVybXMSIgoMdGVybXNWZXJzaW9uGAEgASgFUgx0ZXJtc1ZlcnNpb24SJA'
    'oNcG9saWN5VmVyc2lvbhgCIAEoBVINcG9saWN5VmVyc2lvbhpVCgxJbml0aWFsRXZlbnQSKQoF'
    'dGVybXMYASABKAsyEy5BY2NvdW50RXZlbnQuVGVybXNSBXRlcm1zEhoKCGluc3RhbmNlGAIgAS'
    'gJUghpbnN0YW5jZUIMCgpldmVudF90eXBl');

@$core.Deprecated('Use submitAccountEventDescriptor instead')
const SubmitAccountEvent$json = {
  '1': 'SubmitAccountEvent',
  '2': [
    {'1': 'event', '3': 1, '4': 1, '5': 11, '6': '.AccountEvent', '10': 'event'},
    {'1': 'createSiteName', '3': 2, '4': 1, '5': 9, '10': 'createSiteName'},
    {'1': 'createSiteUserName', '3': 3, '4': 1, '5': 9, '10': 'createSiteUserName'},
  ],
};

/// Descriptor for `SubmitAccountEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitAccountEventDescriptor = $convert.base64Decode(
    'ChJTdWJtaXRBY2NvdW50RXZlbnQSIwoFZXZlbnQYASABKAsyDS5BY2NvdW50RXZlbnRSBWV2ZW'
    '50EiYKDmNyZWF0ZVNpdGVOYW1lGAIgASgJUg5jcmVhdGVTaXRlTmFtZRIuChJjcmVhdGVTaXRl'
    'VXNlck5hbWUYAyABKAlSEmNyZWF0ZVNpdGVVc2VyTmFtZQ==');

@$core.Deprecated('Use accountEventRecordDescriptor instead')
const AccountEventRecord$json = {
  '1': 'AccountEventRecord',
  '2': [
    {'1': 'isoDate', '3': 1, '4': 1, '5': 9, '10': 'isoDate'},
    {'1': 'version', '3': 2, '4': 1, '5': 5, '10': 'version'},
    {'1': 'accountEvent', '3': 3, '4': 1, '5': 11, '6': '.AccountEvent', '10': 'accountEvent'},
  ],
};

/// Descriptor for `AccountEventRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountEventRecordDescriptor = $convert.base64Decode(
    'ChJBY2NvdW50RXZlbnRSZWNvcmQSGAoHaXNvRGF0ZRgBIAEoCVIHaXNvRGF0ZRIYCgd2ZXJzaW'
    '9uGAIgASgFUgd2ZXJzaW9uEjEKDGFjY291bnRFdmVudBgDIAEoCzINLkFjY291bnRFdmVudFIM'
    'YWNjb3VudEV2ZW50');

