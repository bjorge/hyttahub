//
//  Generated code. Do not modify.
//  source: cloud_functions.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use cloudFunctionsStateDescriptor instead')
const CloudFunctionsState$json = {
  '1': 'CloudFunctionsState',
  '2': [
    {'1': 'initial', '3': 1, '4': 1, '5': 11, '6': '.hyttahub.CloudFunctionsInitial', '9': 0, '10': 'initial'},
    {'1': 'loading', '3': 2, '4': 1, '5': 11, '6': '.hyttahub.CloudFunctionsLoading', '9': 0, '10': 'loading'},
    {'1': 'export_success', '3': 3, '4': 1, '5': 11, '6': '.hyttahub.ExportSuccess', '9': 0, '10': 'exportSuccess'},
    {'1': 'export_list_success', '3': 4, '4': 1, '5': 11, '6': '.hyttahub.ExportListSuccess', '9': 0, '10': 'exportListSuccess'},
    {'1': 'export_delete_success', '3': 5, '4': 1, '5': 11, '6': '.hyttahub.ExportDeleteSuccess', '9': 0, '10': 'exportDeleteSuccess'},
    {'1': 'export_details_success', '3': 6, '4': 1, '5': 11, '6': '.hyttahub.ExportDetailsSuccess', '9': 0, '10': 'exportDetailsSuccess'},
    {'1': 'failure', '3': 7, '4': 1, '5': 11, '6': '.hyttahub.CloudFunctionsFailure', '9': 0, '10': 'failure'},
  ],
  '8': [
    {'1': 'state'},
  ],
};

/// Descriptor for `CloudFunctionsState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudFunctionsStateDescriptor = $convert.base64Decode(
    'ChNDbG91ZEZ1bmN0aW9uc1N0YXRlEjsKB2luaXRpYWwYASABKAsyHy5oeXR0YWh1Yi5DbG91ZE'
    'Z1bmN0aW9uc0luaXRpYWxIAFIHaW5pdGlhbBI7Cgdsb2FkaW5nGAIgASgLMh8uaHl0dGFodWIu'
    'Q2xvdWRGdW5jdGlvbnNMb2FkaW5nSABSB2xvYWRpbmcSQAoOZXhwb3J0X3N1Y2Nlc3MYAyABKA'
    'syFy5oeXR0YWh1Yi5FeHBvcnRTdWNjZXNzSABSDWV4cG9ydFN1Y2Nlc3MSTQoTZXhwb3J0X2xp'
    'c3Rfc3VjY2VzcxgEIAEoCzIbLmh5dHRhaHViLkV4cG9ydExpc3RTdWNjZXNzSABSEWV4cG9ydE'
    'xpc3RTdWNjZXNzElMKFWV4cG9ydF9kZWxldGVfc3VjY2VzcxgFIAEoCzIdLmh5dHRhaHViLkV4'
    'cG9ydERlbGV0ZVN1Y2Nlc3NIAFITZXhwb3J0RGVsZXRlU3VjY2VzcxJWChZleHBvcnRfZGV0YW'
    'lsc19zdWNjZXNzGAYgASgLMh4uaHl0dGFodWIuRXhwb3J0RGV0YWlsc1N1Y2Nlc3NIAFIUZXhw'
    'b3J0RGV0YWlsc1N1Y2Nlc3MSOwoHZmFpbHVyZRgHIAEoCzIfLmh5dHRhaHViLkNsb3VkRnVuY3'
    'Rpb25zRmFpbHVyZUgAUgdmYWlsdXJlQgcKBXN0YXRl');

@$core.Deprecated('Use cloudFunctionsInitialDescriptor instead')
const CloudFunctionsInitial$json = {
  '1': 'CloudFunctionsInitial',
};

/// Descriptor for `CloudFunctionsInitial`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudFunctionsInitialDescriptor = $convert.base64Decode(
    'ChVDbG91ZEZ1bmN0aW9uc0luaXRpYWw=');

@$core.Deprecated('Use cloudFunctionsLoadingDescriptor instead')
const CloudFunctionsLoading$json = {
  '1': 'CloudFunctionsLoading',
};

/// Descriptor for `CloudFunctionsLoading`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudFunctionsLoadingDescriptor = $convert.base64Decode(
    'ChVDbG91ZEZ1bmN0aW9uc0xvYWRpbmc=');

@$core.Deprecated('Use exportSuccessDescriptor instead')
const ExportSuccess$json = {
  '1': 'ExportSuccess',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ExportSuccess`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportSuccessDescriptor = $convert.base64Decode(
    'Cg1FeHBvcnRTdWNjZXNzEhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use exportFileDescriptor instead')
const ExportFile$json = {
  '1': 'ExportFile',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
  ],
};

/// Descriptor for `ExportFile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportFileDescriptor = $convert.base64Decode(
    'CgpFeHBvcnRGaWxlEhIKBG5hbWUYASABKAlSBG5hbWUSEAoDdXJsGAIgASgJUgN1cmw=');

@$core.Deprecated('Use exportListSuccessDescriptor instead')
const ExportListSuccess$json = {
  '1': 'ExportListSuccess',
  '2': [
    {'1': 'files', '3': 1, '4': 3, '5': 11, '6': '.hyttahub.ExportFile', '10': 'files'},
  ],
};

/// Descriptor for `ExportListSuccess`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportListSuccessDescriptor = $convert.base64Decode(
    'ChFFeHBvcnRMaXN0U3VjY2VzcxIqCgVmaWxlcxgBIAMoCzIULmh5dHRhaHViLkV4cG9ydEZpbG'
    'VSBWZpbGVz');

@$core.Deprecated('Use exportDeleteSuccessDescriptor instead')
const ExportDeleteSuccess$json = {
  '1': 'ExportDeleteSuccess',
};

/// Descriptor for `ExportDeleteSuccess`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportDeleteSuccessDescriptor = $convert.base64Decode(
    'ChNFeHBvcnREZWxldGVTdWNjZXNz');

@$core.Deprecated('Use exportDetailsSuccessDescriptor instead')
const ExportDetailsSuccess$json = {
  '1': 'ExportDetailsSuccess',
  '2': [
    {'1': 'events', '3': 1, '4': 1, '5': 9, '10': 'events'},
  ],
};

/// Descriptor for `ExportDetailsSuccess`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportDetailsSuccessDescriptor = $convert.base64Decode(
    'ChRFeHBvcnREZXRhaWxzU3VjY2VzcxIWCgZldmVudHMYASABKAlSBmV2ZW50cw==');

@$core.Deprecated('Use cloudFunctionsFailureDescriptor instead')
const CloudFunctionsFailure$json = {
  '1': 'CloudFunctionsFailure',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 9, '10': 'error'},
  ],
};

/// Descriptor for `CloudFunctionsFailure`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudFunctionsFailureDescriptor = $convert.base64Decode(
    'ChVDbG91ZEZ1bmN0aW9uc0ZhaWx1cmUSFAoFZXJyb3IYASABKAlSBWVycm9y');

