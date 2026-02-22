// This is a generated file - do not edit.
//
// Generated from common_blocs.proto.

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

@$core.Deprecated('Use commonReplayStateEnumDescriptor instead')
const CommonReplayStateEnum$json = {
  '1': 'CommonReplayStateEnum',
  '2': [
    {'1': 'hydrating', '2': 0},
    {'1': 'listening', '2': 1},
    {'1': 'uninitializedListening', '2': 2},
    {'1': 'networkError', '2': 3},
    {'1': 'permissionDenied', '2': 4},
  ],
};

/// Descriptor for `CommonReplayStateEnum`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List commonReplayStateEnumDescriptor = $convert.base64Decode(
    'ChVDb21tb25SZXBsYXlTdGF0ZUVudW0SDQoJaHlkcmF0aW5nEAASDQoJbGlzdGVuaW5nEAESGg'
    'oWdW5pbml0aWFsaXplZExpc3RlbmluZxACEhAKDG5ldHdvcmtFcnJvchADEhQKEHBlcm1pc3Np'
    'b25EZW5pZWQQBA==');

@$core.Deprecated('Use commonReplayBlocEventDescriptor instead')
const CommonReplayBlocEvent$json = {
  '1': 'CommonReplayBlocEvent',
  '2': [
    {'1': 'listen', '3': 1, '4': 1, '5': 8, '9': 0, '10': 'listen'},
    {
      '1': 'newEvents',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.CommonReplayBlocEvent.NewEvents',
      '9': 0,
      '10': 'newEvents'
    },
  ],
  '3': [CommonReplayBlocEvent_NewEvents$json],
  '8': [
    {'1': 'event_type'},
  ],
};

@$core.Deprecated('Use commonReplayBlocEventDescriptor instead')
const CommonReplayBlocEvent_NewEvents$json = {
  '1': 'NewEvents',
  '2': [
    {
      '1': 'events',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.CommonReplayBlocEvent.NewEvents.EventsEntry',
      '10': 'events'
    },
  ],
  '3': [CommonReplayBlocEvent_NewEvents_EventsEntry$json],
};

@$core.Deprecated('Use commonReplayBlocEventDescriptor instead')
const CommonReplayBlocEvent_NewEvents_EventsEntry$json = {
  '1': 'EventsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `CommonReplayBlocEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commonReplayBlocEventDescriptor = $convert.base64Decode(
    'ChVDb21tb25SZXBsYXlCbG9jRXZlbnQSGAoGbGlzdGVuGAEgASgISABSBmxpc3RlbhJACgluZX'
    'dFdmVudHMYAiABKAsyIC5Db21tb25SZXBsYXlCbG9jRXZlbnQuTmV3RXZlbnRzSABSCW5ld0V2'
    'ZW50cxqMAQoJTmV3RXZlbnRzEkQKBmV2ZW50cxgBIAMoCzIsLkNvbW1vblJlcGxheUJsb2NFdm'
    'VudC5OZXdFdmVudHMuRXZlbnRzRW50cnlSBmV2ZW50cxo5CgtFdmVudHNFbnRyeRIQCgNrZXkY'
    'ASABKAVSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgBQgwKCmV2ZW50X3R5cGU=');

@$core.Deprecated('Use eventMapProtoDescriptor instead')
const EventMapProto$json = {
  '1': 'EventMapProto',
  '2': [
    {
      '1': 'events',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.EventMapProto.EventsEntry',
      '10': 'events'
    },
  ],
  '3': [EventMapProto_EventsEntry$json],
};

@$core.Deprecated('Use eventMapProtoDescriptor instead')
const EventMapProto_EventsEntry$json = {
  '1': 'EventsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `EventMapProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventMapProtoDescriptor = $convert.base64Decode(
    'Cg1FdmVudE1hcFByb3RvEjIKBmV2ZW50cxgBIAMoCzIaLkV2ZW50TWFwUHJvdG8uRXZlbnRzRW'
    '50cnlSBmV2ZW50cxo5CgtFdmVudHNFbnRyeRIQCgNrZXkYASABKAVSA2tleRIUCgV2YWx1ZRgC'
    'IAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use commonSubmitBlocEventDescriptor instead')
const CommonSubmitBlocEvent$json = {
  '1': 'CommonSubmitBlocEvent',
  '2': [
    {
      '1': 'updatedPayload',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'updatedPayload'
    },
    {'1': 'isFormValid', '3': 3, '4': 1, '5': 8, '9': 0, '10': 'isFormValid'},
    {
      '1': 'submit',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.CommonSubmitBlocEvent.SubmitNow',
      '9': 0,
      '10': 'submit'
    },
  ],
  '3': [CommonSubmitBlocEvent_SubmitNow$json],
  '8': [
    {'1': 'event_type'},
  ],
};

@$core.Deprecated('Use commonSubmitBlocEventDescriptor instead')
const CommonSubmitBlocEvent_SubmitNow$json = {
  '1': 'SubmitNow',
};

/// Descriptor for `CommonSubmitBlocEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commonSubmitBlocEventDescriptor = $convert.base64Decode(
    'ChVDb21tb25TdWJtaXRCbG9jRXZlbnQSKAoOdXBkYXRlZFBheWxvYWQYAiABKAlIAFIOdXBkYX'
    'RlZFBheWxvYWQSIgoLaXNGb3JtVmFsaWQYAyABKAhIAFILaXNGb3JtVmFsaWQSOgoGc3VibWl0'
    'GAQgASgLMiAuQ29tbW9uU3VibWl0QmxvY0V2ZW50LlN1Ym1pdE5vd0gAUgZzdWJtaXQaCwoJU3'
    'VibWl0Tm93QgwKCmV2ZW50X3R5cGU=');

@$core.Deprecated('Use commonSubmitBlocStateDescriptor instead')
const CommonSubmitBlocState$json = {
  '1': 'CommonSubmitBlocState',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.CommonSubmitBlocState.State',
      '10': 'state'
    },
    {
      '1': 'errorCode',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.CommonSubmitBlocState.ErrorCode',
      '10': 'errorCode'
    },
    {
      '1': 'progress',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.CommonSubmitBlocState.SubmitProgress',
      '10': 'progress'
    },
  ],
  '3': [CommonSubmitBlocState_SubmitProgress$json],
  '4': [CommonSubmitBlocState_State$json, CommonSubmitBlocState_ErrorCode$json],
};

@$core.Deprecated('Use commonSubmitBlocStateDescriptor instead')
const CommonSubmitBlocState_SubmitProgress$json = {
  '1': 'SubmitProgress',
  '2': [
    {'1': 'count', '3': 1, '4': 1, '5': 5, '10': 'count'},
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

@$core.Deprecated('Use commonSubmitBlocStateDescriptor instead')
const CommonSubmitBlocState_State$json = {
  '1': 'State',
  '2': [
    {'1': 'ready', '2': 0},
    {'1': 'canSubmit', '2': 1},
    {'1': 'submitting', '2': 2},
    {'1': 'error', '2': 3},
    {'1': 'success', '2': 4},
  ],
};

@$core.Deprecated('Use commonSubmitBlocStateDescriptor instead')
const CommonSubmitBlocState_ErrorCode$json = {
  '1': 'ErrorCode',
  '2': [
    {'1': 'none', '2': 0},
    {'1': 'networkError', '2': 1},
    {'1': 'permissionDenied', '2': 2},
  ],
};

/// Descriptor for `CommonSubmitBlocState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commonSubmitBlocStateDescriptor = $convert.base64Decode(
    'ChVDb21tb25TdWJtaXRCbG9jU3RhdGUSMgoFc3RhdGUYASABKA4yHC5Db21tb25TdWJtaXRCbG'
    '9jU3RhdGUuU3RhdGVSBXN0YXRlEj4KCWVycm9yQ29kZRgIIAEoDjIgLkNvbW1vblN1Ym1pdEJs'
    'b2NTdGF0ZS5FcnJvckNvZGVSCWVycm9yQ29kZRJBCghwcm9ncmVzcxgJIAEoCzIlLkNvbW1vbl'
    'N1Ym1pdEJsb2NTdGF0ZS5TdWJtaXRQcm9ncmVzc1IIcHJvZ3Jlc3MaPAoOU3VibWl0UHJvZ3Jl'
    'c3MSFAoFY291bnQYASABKAVSBWNvdW50EhQKBXRvdGFsGAIgASgFUgV0b3RhbCJJCgVTdGF0ZR'
    'IJCgVyZWFkeRAAEg0KCWNhblN1Ym1pdBABEg4KCnN1Ym1pdHRpbmcQAhIJCgVlcnJvchADEgsK'
    'B3N1Y2Nlc3MQBCI9CglFcnJvckNvZGUSCAoEbm9uZRAAEhAKDG5ldHdvcmtFcnJvchABEhQKEH'
    'Blcm1pc3Npb25EZW5pZWQQAg==');
