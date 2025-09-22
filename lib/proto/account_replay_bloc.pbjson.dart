//
//  Generated code. Do not modify.
//  source: account_replay_bloc.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use accountReplayBlocStateDescriptor instead')
const AccountReplayBlocState$json = {
  '1': 'AccountReplayBlocState',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 14, '6': '.CommonReplayStateEnum', '10': 'state'},
    {'1': 'termsVersion', '3': 2, '4': 1, '5': 5, '10': 'termsVersion'},
    {'1': 'privacyVersion', '3': 3, '4': 1, '5': 5, '10': 'privacyVersion'},
    {'1': 'events', '3': 4, '4': 3, '5': 11, '6': '.AccountReplayBlocState.EventsEntry', '10': 'events'},
    {'1': 'sitesIds', '3': 5, '4': 3, '5': 9, '10': 'sitesIds'},
  ],
  '3': [AccountReplayBlocState_EventsEntry$json],
};

@$core.Deprecated('Use accountReplayBlocStateDescriptor instead')
const AccountReplayBlocState_EventsEntry$json = {
  '1': 'EventsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `AccountReplayBlocState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountReplayBlocStateDescriptor = $convert.base64Decode(
    'ChZBY2NvdW50UmVwbGF5QmxvY1N0YXRlEiwKBXN0YXRlGAEgASgOMhYuQ29tbW9uUmVwbGF5U3'
    'RhdGVFbnVtUgVzdGF0ZRIiCgx0ZXJtc1ZlcnNpb24YAiABKAVSDHRlcm1zVmVyc2lvbhImCg5w'
    'cml2YWN5VmVyc2lvbhgDIAEoBVIOcHJpdmFjeVZlcnNpb24SOwoGZXZlbnRzGAQgAygLMiMuQW'
    'Njb3VudFJlcGxheUJsb2NTdGF0ZS5FdmVudHNFbnRyeVIGZXZlbnRzEhoKCHNpdGVzSWRzGAUg'
    'AygJUghzaXRlc0lkcxo5CgtFdmVudHNFbnRyeRIQCgNrZXkYASABKAVSA2tleRIUCgV2YWx1ZR'
    'gCIAEoCVIFdmFsdWU6AjgB');

