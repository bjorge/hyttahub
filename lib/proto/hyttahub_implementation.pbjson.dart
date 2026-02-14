//
//  Generated code. Do not modify.
//  source: hyttahub_implementation.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use storageEnumDescriptor instead')
const StorageEnum$json = {
  '1': 'StorageEnum',
  '2': [
    {'1': 'cloud', '2': 0},
    {'1': 'memory', '2': 1},
    {'1': 'local', '2': 2},
  ],
};

/// Descriptor for `StorageEnum`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List storageEnumDescriptor = $convert.base64Decode(
    'CgtTdG9yYWdlRW51bRIJCgVjbG91ZBAAEgoKBm1lbW9yeRABEgkKBWxvY2FsEAI=');

@$core.Deprecated('Use hyttaHubImplementationDescriptor instead')
const HyttaHubImplementation$json = {
  '1': 'HyttaHubImplementation',
  '2': [
    {'1': 'storage', '3': 1, '4': 1, '5': 14, '6': '.StorageEnum', '10': 'storage'},
    {'1': 'appBuildNumber', '3': 2, '4': 1, '5': 5, '10': 'appBuildNumber'},
    {'1': 'appId', '3': 3, '4': 1, '5': 9, '10': 'appId'},
    {'1': 'firebaseRootCollection', '3': 4, '4': 1, '5': 9, '10': 'firebaseRootCollection'},
    {'1': 'disable_firestore_cache', '3': 5, '4': 1, '5': 8, '10': 'disableFirestoreCache'},
  ],
};

/// Descriptor for `HyttaHubImplementation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hyttaHubImplementationDescriptor = $convert.base64Decode(
    'ChZIeXR0YUh1YkltcGxlbWVudGF0aW9uEiYKB3N0b3JhZ2UYASABKA4yDC5TdG9yYWdlRW51bV'
    'IHc3RvcmFnZRImCg5hcHBCdWlsZE51bWJlchgCIAEoBVIOYXBwQnVpbGROdW1iZXISFAoFYXBw'
    'SWQYAyABKAlSBWFwcElkEjYKFmZpcmViYXNlUm9vdENvbGxlY3Rpb24YBCABKAlSFmZpcmViYX'
    'NlUm9vdENvbGxlY3Rpb24SNgoXZGlzYWJsZV9maXJlc3RvcmVfY2FjaGUYBSABKAhSFWRpc2Fi'
    'bGVGaXJlc3RvcmVDYWNoZQ==');

