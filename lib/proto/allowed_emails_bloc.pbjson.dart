//
//  Generated code. Do not modify.
//  source: allowed_emails_bloc.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use allowedEmailsBlocEventDescriptor instead')
const AllowedEmailsBlocEvent$json = {
  '1': 'AllowedEmailsBlocEvent',
  '2': [
    {'1': 'fetchNow', '3': 1, '4': 1, '5': 11, '6': '.AllowedEmailsBlocEvent.FetchedAllowedEmails', '9': 0, '10': 'fetchNow'},
    {'1': 'updateNow', '3': 2, '4': 1, '5': 11, '6': '.AllowedEmailsBlocState', '9': 0, '10': 'updateNow'},
  ],
  '3': [AllowedEmailsBlocEvent_FetchedAllowedEmails$json],
  '8': [
    {'1': 'event_type'},
  ],
};

@$core.Deprecated('Use allowedEmailsBlocEventDescriptor instead')
const AllowedEmailsBlocEvent_FetchedAllowedEmails$json = {
  '1': 'FetchedAllowedEmails',
};

/// Descriptor for `AllowedEmailsBlocEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List allowedEmailsBlocEventDescriptor = $convert.base64Decode(
    'ChZBbGxvd2VkRW1haWxzQmxvY0V2ZW50EkoKCGZldGNoTm93GAEgASgLMiwuQWxsb3dlZEVtYW'
    'lsc0Jsb2NFdmVudC5GZXRjaGVkQWxsb3dlZEVtYWlsc0gAUghmZXRjaE5vdxI3Cgl1cGRhdGVO'
    'b3cYAiABKAsyFy5BbGxvd2VkRW1haWxzQmxvY1N0YXRlSABSCXVwZGF0ZU5vdxoWChRGZXRjaG'
    'VkQWxsb3dlZEVtYWlsc0IMCgpldmVudF90eXBl');

@$core.Deprecated('Use allowedEmailsBlocStateDescriptor instead')
const AllowedEmailsBlocState$json = {
  '1': 'AllowedEmailsBlocState',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 14, '6': '.AllowedEmailsBlocState.State', '10': 'state'},
    {'1': 'emails', '3': 2, '4': 3, '5': 11, '6': '.AllowedEmailsBlocState.EmailsEntry', '10': 'emails'},
  ],
  '3': [AllowedEmailsBlocState_UserInfo$json, AllowedEmailsBlocState_EmailsEntry$json],
  '4': [AllowedEmailsBlocState_State$json],
};

@$core.Deprecated('Use allowedEmailsBlocStateDescriptor instead')
const AllowedEmailsBlocState_UserInfo$json = {
  '1': 'UserInfo',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 5, '10': 'userId'},
  ],
};

@$core.Deprecated('Use allowedEmailsBlocStateDescriptor instead')
const AllowedEmailsBlocState_EmailsEntry$json = {
  '1': 'EmailsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.AllowedEmailsBlocState.UserInfo', '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use allowedEmailsBlocStateDescriptor instead')
const AllowedEmailsBlocState_State$json = {
  '1': 'State',
  '2': [
    {'1': 'fetching', '2': 0},
    {'1': 'success', '2': 1},
    {'1': 'error', '2': 2},
    {'1': 'permissionDenied', '2': 3},
  ],
};

/// Descriptor for `AllowedEmailsBlocState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List allowedEmailsBlocStateDescriptor = $convert.base64Decode(
    'ChZBbGxvd2VkRW1haWxzQmxvY1N0YXRlEjMKBXN0YXRlGAEgASgOMh0uQWxsb3dlZEVtYWlsc0'
    'Jsb2NTdGF0ZS5TdGF0ZVIFc3RhdGUSOwoGZW1haWxzGAIgAygLMiMuQWxsb3dlZEVtYWlsc0Js'
    'b2NTdGF0ZS5FbWFpbHNFbnRyeVIGZW1haWxzGiMKCFVzZXJJbmZvEhcKB3VzZXJfaWQYASABKA'
    'VSBnVzZXJJZBpbCgtFbWFpbHNFbnRyeRIQCgNrZXkYASABKAlSA2tleRI2CgV2YWx1ZRgCIAEo'
    'CzIgLkFsbG93ZWRFbWFpbHNCbG9jU3RhdGUuVXNlckluZm9SBXZhbHVlOgI4ASJDCgVTdGF0ZR'
    'IMCghmZXRjaGluZxAAEgsKB3N1Y2Nlc3MQARIJCgVlcnJvchACEhQKEHBlcm1pc3Npb25EZW5p'
    'ZWQQAw==');

