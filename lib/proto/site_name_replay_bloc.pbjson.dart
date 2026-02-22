// This is a generated file - do not edit.
//
// Generated from site_name_replay_bloc.proto.

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

@$core.Deprecated('Use siteNameReplayBlocStateDescriptor instead')
const SiteNameReplayBlocState$json = {
  '1': 'SiteNameReplayBlocState',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.CommonReplayStateEnum',
      '10': 'state'
    },
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'events',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.SiteNameReplayBlocState.EventsEntry',
      '10': 'events'
    },
  ],
  '3': [SiteNameReplayBlocState_EventsEntry$json],
};

@$core.Deprecated('Use siteNameReplayBlocStateDescriptor instead')
const SiteNameReplayBlocState_EventsEntry$json = {
  '1': 'EventsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `SiteNameReplayBlocState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List siteNameReplayBlocStateDescriptor = $convert.base64Decode(
    'ChdTaXRlTmFtZVJlcGxheUJsb2NTdGF0ZRIsCgVzdGF0ZRgBIAEoDjIWLkNvbW1vblJlcGxheV'
    'N0YXRlRW51bVIFc3RhdGUSEgoEbmFtZRgCIAEoCVIEbmFtZRI8CgZldmVudHMYAyADKAsyJC5T'
    'aXRlTmFtZVJlcGxheUJsb2NTdGF0ZS5FdmVudHNFbnRyeVIGZXZlbnRzGjkKC0V2ZW50c0VudH'
    'J5EhAKA2tleRgBIAEoBVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');
