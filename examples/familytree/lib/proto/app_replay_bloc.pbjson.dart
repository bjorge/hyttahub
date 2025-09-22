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

@$core.Deprecated('Use treeConnectionInfoDescriptor instead')
const TreeConnectionInfo$json = {
  '1': 'TreeConnectionInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'connection', '3': 2, '4': 1, '5': 11, '6': '.TreeConnection', '10': 'connection'},
    {'1': 'toTreeMemberId', '3': 3, '4': 1, '5': 5, '10': 'toTreeMemberId'},
  ],
};

/// Descriptor for `TreeConnectionInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List treeConnectionInfoDescriptor = $convert.base64Decode(
    'ChJUcmVlQ29ubmVjdGlvbkluZm8SDgoCaWQYASABKAVSAmlkEi8KCmNvbm5lY3Rpb24YAiABKA'
    'syDy5UcmVlQ29ubmVjdGlvblIKY29ubmVjdGlvbhImCg50b1RyZWVNZW1iZXJJZBgDIAEoBVIO'
    'dG9UcmVlTWVtYmVySWQ=');

@$core.Deprecated('Use photoDescriptor instead')
const Photo$json = {
  '1': 'Photo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'size', '3': 4, '4': 1, '5': 5, '10': 'size'},
    {'1': 'caption', '3': 5, '4': 1, '5': 9, '10': 'caption'},
  ],
};

/// Descriptor for `Photo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List photoDescriptor = $convert.base64Decode(
    'CgVQaG90bxIOCgJpZBgBIAEoBVICaWQSEgoEbmFtZRgDIAEoCVIEbmFtZRISCgRzaXplGAQgAS'
    'gFUgRzaXplEhgKB2NhcHRpb24YBSABKAlSB2NhcHRpb24=');

@$core.Deprecated('Use treePersonInfoDescriptor instead')
const TreePersonInfo$json = {
  '1': 'TreePersonInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'photos', '3': 3, '4': 3, '5': 11, '6': '.Photo', '10': 'photos'},
    {'1': 'connections', '3': 4, '4': 3, '5': 11, '6': '.TreeConnectionInfo', '10': 'connections'},
  ],
};

/// Descriptor for `TreePersonInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List treePersonInfoDescriptor = $convert.base64Decode(
    'Cg5UcmVlUGVyc29uSW5mbxIOCgJpZBgBIAEoBVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIeCg'
    'ZwaG90b3MYAyADKAsyBi5QaG90b1IGcGhvdG9zEjUKC2Nvbm5lY3Rpb25zGAQgAygLMhMuVHJl'
    'ZUNvbm5lY3Rpb25JbmZvUgtjb25uZWN0aW9ucw==');

@$core.Deprecated('Use treeInfoDescriptor instead')
const TreeInfo$json = {
  '1': 'TreeInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'treePersons', '3': 3, '4': 3, '5': 11, '6': '.TreePersonInfo', '10': 'treePersons'},
  ],
};

/// Descriptor for `TreeInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List treeInfoDescriptor = $convert.base64Decode(
    'CghUcmVlSW5mbxIOCgJpZBgBIAEoBVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIxCgt0cmVlUG'
    'Vyc29ucxgDIAMoCzIPLlRyZWVQZXJzb25JbmZvUgt0cmVlUGVyc29ucw==');

@$core.Deprecated('Use appReplayBlocStateDescriptor instead')
const AppReplayBlocState$json = {
  '1': 'AppReplayBlocState',
  '2': [
    {'1': 'trees', '3': 1, '4': 3, '5': 11, '6': '.TreeInfo', '10': 'trees'},
  ],
};

/// Descriptor for `AppReplayBlocState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appReplayBlocStateDescriptor = $convert.base64Decode(
    'ChJBcHBSZXBsYXlCbG9jU3RhdGUSHwoFdHJlZXMYASADKAsyCS5UcmVlSW5mb1IFdHJlZXM=');

