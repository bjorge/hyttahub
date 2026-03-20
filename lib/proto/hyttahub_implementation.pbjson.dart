// This is a generated file - do not edit.
//
// Generated from hyttahub_implementation.proto.

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
    {
      '1': 'storage',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.StorageEnum',
      '10': 'storage'
    },
    {'1': 'appBuildNumber', '3': 2, '4': 1, '5': 5, '10': 'appBuildNumber'},
    {'1': 'appId', '3': 3, '4': 1, '5': 9, '10': 'appId'},
    {
      '1': 'cloudRootCollection',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'cloudRootCollection'
    },
    {
      '1': 'disable_cloud_cache',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'disableCloudCache'
    },
    {
      '1': 'implementation_id',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'implementationId'
    },
  ],
};

/// Descriptor for `HyttaHubImplementation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hyttaHubImplementationDescriptor = $convert.base64Decode(
    'ChZIeXR0YUh1YkltcGxlbWVudGF0aW9uEiYKB3N0b3JhZ2UYASABKA4yDC5TdG9yYWdlRW51bV'
    'IHc3RvcmFnZRImCg5hcHBCdWlsZE51bWJlchgCIAEoBVIOYXBwQnVpbGROdW1iZXISFAoFYXBw'
    'SWQYAyABKAlSBWFwcElkEjAKE2Nsb3VkUm9vdENvbGxlY3Rpb24YBCABKAlSE2Nsb3VkUm9vdE'
    'NvbGxlY3Rpb24SLgoTZGlzYWJsZV9jbG91ZF9jYWNoZRgFIAEoCFIRZGlzYWJsZUNsb3VkQ2Fj'
    'aGUSKwoRaW1wbGVtZW50YXRpb25faWQYBiABKAlSEGltcGxlbWVudGF0aW9uSWQ=');
