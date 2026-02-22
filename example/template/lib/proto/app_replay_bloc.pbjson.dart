// This is a generated file - do not edit.
//
// Generated from app_replay_bloc.proto.

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
    {
      '1': 'events',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.hyttahub.example.template.AppReplayBlocState.EventsEntry',
      '10': 'events'
    },
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.hyttahub.example.template.AppReplayStateEnum',
      '10': 'state'
    },
    {'1': 'textValue', '3': 3, '4': 1, '5': 9, '10': 'textValue'},
    {'1': 'codeValue', '3': 4, '4': 1, '5': 9, '10': 'codeValue'},
    {'1': 'checkboxValue', '3': 5, '4': 1, '5': 8, '10': 'checkboxValue'},
    {'1': 'dropdownValue', '3': 6, '4': 1, '5': 9, '10': 'dropdownValue'},
    {
      '1': 'listItems',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.hyttahub.example.template.AppEvent.ReorderableItem',
      '10': 'listItems'
    },
    {'1': 'photoName', '3': 8, '4': 1, '5': 9, '10': 'photoName'},
    {'1': 'photoVersion', '3': 9, '4': 1, '5': 5, '10': 'photoVersion'},
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
    'ChJBcHBSZXBsYXlCbG9jU3RhdGUSUQoGZXZlbnRzGAEgAygLMjkuaHl0dGFodWIuZXhhbXBsZS'
    '50ZW1wbGF0ZS5BcHBSZXBsYXlCbG9jU3RhdGUuRXZlbnRzRW50cnlSBmV2ZW50cxJDCgVzdGF0'
    'ZRgCIAEoDjItLmh5dHRhaHViLmV4YW1wbGUudGVtcGxhdGUuQXBwUmVwbGF5U3RhdGVFbnVtUg'
    'VzdGF0ZRIcCgl0ZXh0VmFsdWUYAyABKAlSCXRleHRWYWx1ZRIcCgljb2RlVmFsdWUYBCABKAlS'
    'CWNvZGVWYWx1ZRIkCg1jaGVja2JveFZhbHVlGAUgASgIUg1jaGVja2JveFZhbHVlEiQKDWRyb3'
    'Bkb3duVmFsdWUYBiABKAlSDWRyb3Bkb3duVmFsdWUSUQoJbGlzdEl0ZW1zGAcgAygLMjMuaHl0'
    'dGFodWIuZXhhbXBsZS50ZW1wbGF0ZS5BcHBFdmVudC5SZW9yZGVyYWJsZUl0ZW1SCWxpc3RJdG'
    'VtcxIcCglwaG90b05hbWUYCCABKAlSCXBob3RvTmFtZRIiCgxwaG90b1ZlcnNpb24YCSABKAVS'
    'DHBob3RvVmVyc2lvbho5CgtFdmVudHNFbnRyeRIQCgNrZXkYASABKAVSA2tleRIUCgV2YWx1ZR'
    'gCIAEoCVIFdmFsdWU6AjgB');
