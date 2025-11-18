//
//  Generated code. Do not modify.
//  source: app_events.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent$json = {
  '1': 'AppEvent',
  '2': [
    {'1': 'updateText', '3': 1, '4': 1, '5': 11, '6': '.hyttahub.example.formproto.AppEvent.UpdateText', '9': 0, '10': 'updateText'},
  ],
  '3': [AppEvent_UpdateText$json],
  '8': [
    {'1': 'event'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_UpdateText$json = {
  '1': 'UpdateText',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
  ],
};

/// Descriptor for `AppEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appEventDescriptor = $convert.base64Decode(
    'CghBcHBFdmVudBJRCgp1cGRhdGVUZXh0GAEgASgLMi8uaHl0dGFodWIuZXhhbXBsZS5mb3JtcH'
    'JvdG8uQXBwRXZlbnQuVXBkYXRlVGV4dEgAUgp1cGRhdGVUZXh0GiAKClVwZGF0ZVRleHQSEgoE'
    'dGV4dBgBIAEoCVIEdGV4dEIHCgVldmVudA==');

@$core.Deprecated('Use submitAppEventDescriptor instead')
const SubmitAppEvent$json = {
  '1': 'SubmitAppEvent',
  '2': [
    {'1': 'appEvent', '3': 1, '4': 1, '5': 11, '6': '.hyttahub.example.formproto.AppEvent', '10': 'appEvent'},
    {'1': 'siteEvent', '3': 2, '4': 1, '5': 11, '6': '.hyttahub.example.formproto.SubmitAppEvent.SiteEvent', '10': 'siteEvent'},
    {'1': 'authorEmail', '3': 3, '4': 1, '5': 9, '10': 'authorEmail'},
  ],
  '3': [SubmitAppEvent_SiteEvent$json],
};

@$core.Deprecated('Use submitAppEventDescriptor instead')
const SubmitAppEvent_SiteEvent$json = {
  '1': 'SiteEvent',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 5, '10': 'version'},
    {'1': 'author', '3': 2, '4': 1, '5': 5, '10': 'author'},
  ],
};

/// Descriptor for `SubmitAppEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitAppEventDescriptor = $convert.base64Decode(
    'Cg5TdWJtaXRBcHBFdmVudBJACghhcHBFdmVudBgBIAEoCzIkLmh5dHRhaHViLmV4YW1wbGUuZm'
    '9ybXByb3RvLkFwcEV2ZW50UghhcHBFdmVudBJSCglzaXRlRXZlbnQYAiABKAsyNC5oeXR0YWh1'
    'Yi5leGFtcGxlLmZvcm1wcm90by5TdWJtaXRBcHBFdmVudC5TaXRlRXZlbnRSCXNpdGVFdmVudB'
    'IgCgthdXRob3JFbWFpbBgDIAEoCVILYXV0aG9yRW1haWwaPQoJU2l0ZUV2ZW50EhgKB3ZlcnNp'
    'b24YASABKAVSB3ZlcnNpb24SFgoGYXV0aG9yGAIgASgFUgZhdXRob3I=');

@$core.Deprecated('Use appEventRecordDescriptor instead')
const AppEventRecord$json = {
  '1': 'AppEventRecord',
  '2': [
    {'1': 'isoDate', '3': 1, '4': 1, '5': 9, '10': 'isoDate'},
    {'1': 'version', '3': 2, '4': 1, '5': 5, '10': 'version'},
    {'1': 'appEvent', '3': 3, '4': 1, '5': 11, '6': '.hyttahub.example.formproto.AppEvent', '10': 'appEvent'},
  ],
};

/// Descriptor for `AppEventRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appEventRecordDescriptor = $convert.base64Decode(
    'Cg5BcHBFdmVudFJlY29yZBIYCgdpc29EYXRlGAEgASgJUgdpc29EYXRlEhgKB3ZlcnNpb24YAi'
    'ABKAVSB3ZlcnNpb24SQAoIYXBwRXZlbnQYAyABKAsyJC5oeXR0YWh1Yi5leGFtcGxlLmZvcm1w'
    'cm90by5BcHBFdmVudFIIYXBwRXZlbnQ=');

