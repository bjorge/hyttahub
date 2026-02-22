// This is a generated file - do not edit.
//
// Generated from site_replay_bloc.proto.

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

@$core.Deprecated('Use siteReplayBlocStateDescriptor instead')
const SiteReplayBlocState$json = {
  '1': 'SiteReplayBlocState',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.CommonReplayStateEnum',
      '10': 'state'
    },
    {
      '1': 'events',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.SiteReplayBlocState.EventsEntry',
      '10': 'events'
    },
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'members',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.SiteReplayBlocState.MembersEntry',
      '10': 'members'
    },
    {
      '1': 'removedMembers',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.SiteReplayBlocState.RemovedMembersEntry',
      '10': 'removedMembers'
    },
  ],
  '3': [
    SiteReplayBlocState_Member$json,
    SiteReplayBlocState_EventsEntry$json,
    SiteReplayBlocState_MembersEntry$json,
    SiteReplayBlocState_RemovedMembersEntry$json
  ],
};

@$core.Deprecated('Use siteReplayBlocStateDescriptor instead')
const SiteReplayBlocState_Member$json = {
  '1': 'Member',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'admin', '3': 2, '4': 1, '5': 8, '10': 'admin'},
  ],
};

@$core.Deprecated('Use siteReplayBlocStateDescriptor instead')
const SiteReplayBlocState_EventsEntry$json = {
  '1': 'EventsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use siteReplayBlocStateDescriptor instead')
const SiteReplayBlocState_MembersEntry$json = {
  '1': 'MembersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.SiteReplayBlocState.Member',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use siteReplayBlocStateDescriptor instead')
const SiteReplayBlocState_RemovedMembersEntry$json = {
  '1': 'RemovedMembersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.SiteReplayBlocState.Member',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `SiteReplayBlocState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List siteReplayBlocStateDescriptor = $convert.base64Decode(
    'ChNTaXRlUmVwbGF5QmxvY1N0YXRlEiwKBXN0YXRlGAEgASgOMhYuQ29tbW9uUmVwbGF5U3RhdG'
    'VFbnVtUgVzdGF0ZRI4CgZldmVudHMYAiADKAsyIC5TaXRlUmVwbGF5QmxvY1N0YXRlLkV2ZW50'
    'c0VudHJ5UgZldmVudHMSEgoEbmFtZRgDIAEoCVIEbmFtZRI7CgdtZW1iZXJzGAQgAygLMiEuU2'
    'l0ZVJlcGxheUJsb2NTdGF0ZS5NZW1iZXJzRW50cnlSB21lbWJlcnMSUAoOcmVtb3ZlZE1lbWJl'
    'cnMYBSADKAsyKC5TaXRlUmVwbGF5QmxvY1N0YXRlLlJlbW92ZWRNZW1iZXJzRW50cnlSDnJlbW'
    '92ZWRNZW1iZXJzGjIKBk1lbWJlchISCgRuYW1lGAEgASgJUgRuYW1lEhQKBWFkbWluGAIgASgI'
    'UgVhZG1pbho5CgtFdmVudHNFbnRyeRIQCgNrZXkYASABKAVSA2tleRIUCgV2YWx1ZRgCIAEoCV'
    'IFdmFsdWU6AjgBGlcKDE1lbWJlcnNFbnRyeRIQCgNrZXkYASABKAVSA2tleRIxCgV2YWx1ZRgC'
    'IAEoCzIbLlNpdGVSZXBsYXlCbG9jU3RhdGUuTWVtYmVyUgV2YWx1ZToCOAEaXgoTUmVtb3ZlZE'
    '1lbWJlcnNFbnRyeRIQCgNrZXkYASABKAVSA2tleRIxCgV2YWx1ZRgCIAEoCzIbLlNpdGVSZXBs'
    'YXlCbG9jU3RhdGUuTWVtYmVyUgV2YWx1ZToCOAE=');
