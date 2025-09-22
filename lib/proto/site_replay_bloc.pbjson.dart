//
//  Generated code. Do not modify.
//  source: site_replay_bloc.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use siteReplayBlocStateDescriptor instead')
const SiteReplayBlocState$json = {
  '1': 'SiteReplayBlocState',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 14, '6': '.CommonReplayStateEnum', '10': 'state'},
    {'1': 'events', '3': 2, '4': 3, '5': 11, '6': '.SiteReplayBlocState.EventsEntry', '10': 'events'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'members', '3': 4, '4': 3, '5': 11, '6': '.SiteReplayBlocState.MembersEntry', '10': 'members'},
    {'1': 'removedMembers', '3': 5, '4': 3, '5': 11, '6': '.SiteReplayBlocState.RemovedMembersEntry', '10': 'removedMembers'},
    {'1': 'appBlocState', '3': 20, '4': 1, '5': 11, '6': '.Any', '10': 'appBlocState'},
  ],
  '3': [SiteReplayBlocState_Member$json, SiteReplayBlocState_EventsEntry$json, SiteReplayBlocState_MembersEntry$json, SiteReplayBlocState_RemovedMembersEntry$json],
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
    {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.SiteReplayBlocState.Member', '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use siteReplayBlocStateDescriptor instead')
const SiteReplayBlocState_RemovedMembersEntry$json = {
  '1': 'RemovedMembersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.SiteReplayBlocState.Member', '10': 'value'},
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
    '92ZWRNZW1iZXJzEigKDGFwcEJsb2NTdGF0ZRgUIAEoCzIELkFueVIMYXBwQmxvY1N0YXRlGjIK'
    'Bk1lbWJlchISCgRuYW1lGAEgASgJUgRuYW1lEhQKBWFkbWluGAIgASgIUgVhZG1pbho5CgtFdm'
    'VudHNFbnRyeRIQCgNrZXkYASABKAVSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgBGlcK'
    'DE1lbWJlcnNFbnRyeRIQCgNrZXkYASABKAVSA2tleRIxCgV2YWx1ZRgCIAEoCzIbLlNpdGVSZX'
    'BsYXlCbG9jU3RhdGUuTWVtYmVyUgV2YWx1ZToCOAEaXgoTUmVtb3ZlZE1lbWJlcnNFbnRyeRIQ'
    'CgNrZXkYASABKAVSA2tleRIxCgV2YWx1ZRgCIAEoCzIbLlNpdGVSZXBsYXlCbG9jU3RhdGUuTW'
    'VtYmVyUgV2YWx1ZToCOAE=');

