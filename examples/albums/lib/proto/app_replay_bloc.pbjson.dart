//
//  Generated code. Do not modify.
//  source: app_replay_bloc.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use appReplayBlocStateDescriptor instead')
const AppReplayBlocState$json = {
  '1': 'AppReplayBlocState',
  '2': [
    {'1': 'albums', '3': 1, '4': 3, '5': 11, '6': '.AppReplayBlocState.AlbumInfo', '10': 'albums'},
  ],
  '3': [AppReplayBlocState_Photo$json, AppReplayBlocState_AlbumInfo$json],
};

@$core.Deprecated('Use appReplayBlocStateDescriptor instead')
const AppReplayBlocState_Photo$json = {
  '1': 'Photo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'size', '3': 4, '4': 1, '5': 5, '10': 'size'},
    {'1': 'caption', '3': 5, '4': 1, '5': 9, '10': 'caption'},
  ],
};

@$core.Deprecated('Use appReplayBlocStateDescriptor instead')
const AppReplayBlocState_AlbumInfo$json = {
  '1': 'AlbumInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'photos', '3': 3, '4': 3, '5': 11, '6': '.AppReplayBlocState.Photo', '10': 'photos'},
  ],
};

/// Descriptor for `AppReplayBlocState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appReplayBlocStateDescriptor = $convert.base64Decode(
    'ChJBcHBSZXBsYXlCbG9jU3RhdGUSNQoGYWxidW1zGAEgAygLMh0uQXBwUmVwbGF5QmxvY1N0YX'
    'RlLkFsYnVtSW5mb1IGYWxidW1zGlkKBVBob3RvEg4KAmlkGAEgASgFUgJpZBISCgRuYW1lGAMg'
    'ASgJUgRuYW1lEhIKBHNpemUYBCABKAVSBHNpemUSGAoHY2FwdGlvbhgFIAEoCVIHY2FwdGlvbh'
    'piCglBbGJ1bUluZm8SDgoCaWQYASABKAVSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSMQoGcGhv'
    'dG9zGAMgAygLMhkuQXBwUmVwbGF5QmxvY1N0YXRlLlBob3RvUgZwaG90b3M=');

