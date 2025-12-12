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
    {'1': 'updateText', '3': 1, '4': 1, '5': 11, '6': '.hyttahub.example.template.AppEvent.UpdateText', '9': 0, '10': 'updateText'},
    {'1': 'templateForm', '3': 2, '4': 1, '5': 11, '6': '.hyttahub.example.template.AppEvent.TemplateForm', '9': 0, '10': 'templateForm'},
  ],
  '3': [AppEvent_UpdateText$json, AppEvent_ReorderableItem$json, AppEvent_TemplateForm$json],
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

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_ReorderableItem$json = {
  '1': 'ReorderableItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_TemplateForm$json = {
  '1': 'TemplateForm',
  '2': [
    {'1': 'textValue', '3': 1, '4': 1, '5': 9, '10': 'textValue'},
    {'1': 'codeValue', '3': 2, '4': 1, '5': 9, '10': 'codeValue'},
    {'1': 'checkboxValue', '3': 3, '4': 1, '5': 8, '10': 'checkboxValue'},
    {'1': 'dropdownValue', '3': 4, '4': 1, '5': 9, '10': 'dropdownValue'},
    {'1': 'listItems', '3': 5, '4': 3, '5': 11, '6': '.hyttahub.example.template.AppEvent.ReorderableItem', '10': 'listItems'},
    {'1': 'dateValue', '3': 6, '4': 1, '5': 8, '10': 'dateValue'},
  ],
};

/// Descriptor for `AppEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appEventDescriptor = $convert.base64Decode(
    'CghBcHBFdmVudBJQCgp1cGRhdGVUZXh0GAEgASgLMi4uaHl0dGFodWIuZXhhbXBsZS50ZW1wbG'
    'F0ZS5BcHBFdmVudC5VcGRhdGVUZXh0SABSCnVwZGF0ZVRleHQSVgoMdGVtcGxhdGVGb3JtGAIg'
    'ASgLMjAuaHl0dGFodWIuZXhhbXBsZS50ZW1wbGF0ZS5BcHBFdmVudC5UZW1wbGF0ZUZvcm1IAF'
    'IMdGVtcGxhdGVGb3JtGiAKClVwZGF0ZVRleHQSEgoEdGV4dBgBIAEoCVIEdGV4dBo3Cg9SZW9y'
    'ZGVyYWJsZUl0ZW0SDgoCaWQYASABKAVSAmlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRqHAgoMVG'
    'VtcGxhdGVGb3JtEhwKCXRleHRWYWx1ZRgBIAEoCVIJdGV4dFZhbHVlEhwKCWNvZGVWYWx1ZRgC'
    'IAEoCVIJY29kZVZhbHVlEiQKDWNoZWNrYm94VmFsdWUYAyABKAhSDWNoZWNrYm94VmFsdWUSJA'
    'oNZHJvcGRvd25WYWx1ZRgEIAEoCVINZHJvcGRvd25WYWx1ZRJRCglsaXN0SXRlbXMYBSADKAsy'
    'My5oeXR0YWh1Yi5leGFtcGxlLnRlbXBsYXRlLkFwcEV2ZW50LlJlb3JkZXJhYmxlSXRlbVIJbG'
    'lzdEl0ZW1zEhwKCWRhdGVWYWx1ZRgGIAEoCFIJZGF0ZVZhbHVlQgcKBWV2ZW50');

@$core.Deprecated('Use submitAppEventDescriptor instead')
const SubmitAppEvent$json = {
  '1': 'SubmitAppEvent',
  '2': [
    {'1': 'appEvent', '3': 1, '4': 1, '5': 11, '6': '.hyttahub.example.template.AppEvent', '10': 'appEvent'},
    {'1': 'siteEvent', '3': 2, '4': 1, '5': 11, '6': '.hyttahub.example.template.SubmitAppEvent.SiteEvent', '10': 'siteEvent'},
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
    'Cg5TdWJtaXRBcHBFdmVudBI/CghhcHBFdmVudBgBIAEoCzIjLmh5dHRhaHViLmV4YW1wbGUudG'
    'VtcGxhdGUuQXBwRXZlbnRSCGFwcEV2ZW50ElEKCXNpdGVFdmVudBgCIAEoCzIzLmh5dHRhaHVi'
    'LmV4YW1wbGUudGVtcGxhdGUuU3VibWl0QXBwRXZlbnQuU2l0ZUV2ZW50UglzaXRlRXZlbnQSIA'
    'oLYXV0aG9yRW1haWwYAyABKAlSC2F1dGhvckVtYWlsGj0KCVNpdGVFdmVudBIYCgd2ZXJzaW9u'
    'GAEgASgFUgd2ZXJzaW9uEhYKBmF1dGhvchgCIAEoBVIGYXV0aG9y');

@$core.Deprecated('Use appEventRecordDescriptor instead')
const AppEventRecord$json = {
  '1': 'AppEventRecord',
  '2': [
    {'1': 'isoDate', '3': 1, '4': 1, '5': 9, '10': 'isoDate'},
    {'1': 'version', '3': 2, '4': 1, '5': 5, '10': 'version'},
    {'1': 'appEvent', '3': 3, '4': 1, '5': 11, '6': '.hyttahub.example.template.AppEvent', '10': 'appEvent'},
  ],
};

/// Descriptor for `AppEventRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appEventRecordDescriptor = $convert.base64Decode(
    'Cg5BcHBFdmVudFJlY29yZBIYCgdpc29EYXRlGAEgASgJUgdpc29EYXRlEhgKB3ZlcnNpb24YAi'
    'ABKAVSB3ZlcnNpb24SPwoIYXBwRXZlbnQYAyABKAsyIy5oeXR0YWh1Yi5leGFtcGxlLnRlbXBs'
    'YXRlLkFwcEV2ZW50UghhcHBFdmVudA==');

