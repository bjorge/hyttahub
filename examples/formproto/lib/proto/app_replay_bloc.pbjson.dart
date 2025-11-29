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

@$core.Deprecated('Use appReplayStateEnumDescriptor instead')
const AppReplayStateEnum$json = {
  '1': 'AppReplayStateEnum',
  '2': [
    {'1': 'hydrating', '2': 0},
    {'1': 'listening', '2': 1},
    {'1': 'uninitializedListening', '2': 2},
    {'1': 'networkError', '2': 3},
    {'1': 'permissionDenied', '2': 4},
  ],
};

/// Descriptor for `AppReplayStateEnum`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List appReplayStateEnumDescriptor = $convert.base64Decode(
    'ChJBcHBSZXBsYXlTdGF0ZUVudW0SDQoJaHlkcmF0aW5nEAASDQoJbGlzdGVuaW5nEAESGgoWdW'
    '5pbml0aWFsaXplZExpc3RlbmluZxACEhAKDG5ldHdvcmtFcnJvchADEhQKEHBlcm1pc3Npb25E'
    'ZW5pZWQQBA==');

@$core.Deprecated('Use appReplayBlocStateDescriptor instead')
const AppReplayBlocState$json = {
  '1': 'AppReplayBlocState',
  '2': [
    {'1': 'events', '3': 1, '4': 3, '5': 11, '6': '.hyttahub.example.formproto.AppReplayBlocState.EventsEntry', '10': 'events'},
    {'1': 'state', '3': 2, '4': 1, '5': 14, '6': '.hyttahub.example.formproto.AppReplayStateEnum', '10': 'state'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
  ],
  '3': [AppReplayBlocState_EventsEntry$json],
};

@$core.Deprecated('Use appReplayBlocStateDescriptor instead')
const AppReplayBlocState_EventsEntry$json = {
  '1': 'EventsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `AppReplayBlocState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appReplayBlocStateDescriptor = $convert.base64Decode(
    'ChJBcHBSZXBsYXlCbG9jU3RhdGUSUgoGZXZlbnRzGAEgAygLMjouaHl0dGFodWIuZXhhbXBsZS'
    '5mb3JtcHJvdG8uQXBwUmVwbGF5QmxvY1N0YXRlLkV2ZW50c0VudHJ5UgZldmVudHMSRAoFc3Rh'
    'dGUYAiABKA4yLi5oeXR0YWh1Yi5leGFtcGxlLmZvcm1wcm90by5BcHBSZXBsYXlTdGF0ZUVudW'
    '1SBXN0YXRlEhIKBHRleHQYAyABKAlSBHRleHQaOQoLRXZlbnRzRW50cnkSEAoDa2V5GAEgASgF'
    'UgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

