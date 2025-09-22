//
//  Generated code. Do not modify.
//  source: service_replay_bloc.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use serviceAdminDescriptor instead')
const ServiceAdmin$json = {
  '1': 'ServiceAdmin',
  '2': [
    {'1': 'alias', '3': 1, '4': 1, '5': 9, '10': 'alias'},
  ],
};

/// Descriptor for `ServiceAdmin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceAdminDescriptor = $convert.base64Decode(
    'CgxTZXJ2aWNlQWRtaW4SFAoFYWxpYXMYASABKAlSBWFsaWFz');

@$core.Deprecated('Use serviceReplayBlocStateDescriptor instead')
const ServiceReplayBlocState$json = {
  '1': 'ServiceReplayBlocState',
  '2': [
    {'1': 'minVersion', '3': 1, '4': 1, '5': 5, '10': 'minVersion'},
    {'1': 'serviceUnavailable', '3': 2, '4': 1, '5': 8, '10': 'serviceUnavailable'},
    {'1': 'terms', '3': 3, '4': 1, '5': 9, '10': 'terms'},
    {'1': 'termsVersion', '3': 4, '4': 1, '5': 5, '10': 'termsVersion'},
    {'1': 'privacy', '3': 5, '4': 1, '5': 9, '10': 'privacy'},
    {'1': 'privacyVersion', '3': 6, '4': 1, '5': 5, '10': 'privacyVersion'},
    {'1': 'state', '3': 7, '4': 1, '5': 14, '6': '.CommonReplayStateEnum', '10': 'state'},
    {'1': 'events', '3': 8, '4': 3, '5': 11, '6': '.ServiceReplayBlocState.EventsEntry', '10': 'events'},
    {'1': 'serviceAdmins', '3': 9, '4': 3, '5': 11, '6': '.ServiceReplayBlocState.ServiceAdminsEntry', '10': 'serviceAdmins'},
    {'1': 'filter', '3': 10, '4': 1, '5': 11, '6': '.BloomFilter', '10': 'filter'},
    {'1': 'instance', '3': 11, '4': 1, '5': 9, '10': 'instance'},
    {'1': 'betaUsersFilter', '3': 12, '4': 1, '5': 11, '6': '.BloomFilter', '10': 'betaUsersFilter'},
    {'1': 'removedServiceAdmins', '3': 13, '4': 3, '5': 11, '6': '.ServiceReplayBlocState.RemovedServiceAdminsEntry', '10': 'removedServiceAdmins'},
  ],
  '3': [ServiceReplayBlocState_EventsEntry$json, ServiceReplayBlocState_ServiceAdminsEntry$json, ServiceReplayBlocState_RemovedServiceAdminsEntry$json],
};

@$core.Deprecated('Use serviceReplayBlocStateDescriptor instead')
const ServiceReplayBlocState_EventsEntry$json = {
  '1': 'EventsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use serviceReplayBlocStateDescriptor instead')
const ServiceReplayBlocState_ServiceAdminsEntry$json = {
  '1': 'ServiceAdminsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.ServiceAdmin', '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use serviceReplayBlocStateDescriptor instead')
const ServiceReplayBlocState_RemovedServiceAdminsEntry$json = {
  '1': 'RemovedServiceAdminsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.ServiceAdmin', '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ServiceReplayBlocState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceReplayBlocStateDescriptor = $convert.base64Decode(
    'ChZTZXJ2aWNlUmVwbGF5QmxvY1N0YXRlEh4KCm1pblZlcnNpb24YASABKAVSCm1pblZlcnNpb2'
    '4SLgoSc2VydmljZVVuYXZhaWxhYmxlGAIgASgIUhJzZXJ2aWNlVW5hdmFpbGFibGUSFAoFdGVy'
    'bXMYAyABKAlSBXRlcm1zEiIKDHRlcm1zVmVyc2lvbhgEIAEoBVIMdGVybXNWZXJzaW9uEhgKB3'
    'ByaXZhY3kYBSABKAlSB3ByaXZhY3kSJgoOcHJpdmFjeVZlcnNpb24YBiABKAVSDnByaXZhY3lW'
    'ZXJzaW9uEiwKBXN0YXRlGAcgASgOMhYuQ29tbW9uUmVwbGF5U3RhdGVFbnVtUgVzdGF0ZRI7Cg'
    'ZldmVudHMYCCADKAsyIy5TZXJ2aWNlUmVwbGF5QmxvY1N0YXRlLkV2ZW50c0VudHJ5UgZldmVu'
    'dHMSUAoNc2VydmljZUFkbWlucxgJIAMoCzIqLlNlcnZpY2VSZXBsYXlCbG9jU3RhdGUuU2Vydm'
    'ljZUFkbWluc0VudHJ5Ug1zZXJ2aWNlQWRtaW5zEiQKBmZpbHRlchgKIAEoCzIMLkJsb29tRmls'
    'dGVyUgZmaWx0ZXISGgoIaW5zdGFuY2UYCyABKAlSCGluc3RhbmNlEjYKD2JldGFVc2Vyc0ZpbH'
    'RlchgMIAEoCzIMLkJsb29tRmlsdGVyUg9iZXRhVXNlcnNGaWx0ZXISZQoUcmVtb3ZlZFNlcnZp'
    'Y2VBZG1pbnMYDSADKAsyMS5TZXJ2aWNlUmVwbGF5QmxvY1N0YXRlLlJlbW92ZWRTZXJ2aWNlQW'
    'RtaW5zRW50cnlSFHJlbW92ZWRTZXJ2aWNlQWRtaW5zGjkKC0V2ZW50c0VudHJ5EhAKA2tleRgB'
    'IAEoBVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAEaTwoSU2VydmljZUFkbWluc0VudH'
    'J5EhAKA2tleRgBIAEoBVIDa2V5EiMKBXZhbHVlGAIgASgLMg0uU2VydmljZUFkbWluUgV2YWx1'
    'ZToCOAEaVgoZUmVtb3ZlZFNlcnZpY2VBZG1pbnNFbnRyeRIQCgNrZXkYASABKAVSA2tleRIjCg'
    'V2YWx1ZRgCIAEoCzINLlNlcnZpY2VBZG1pblIFdmFsdWU6AjgB');

