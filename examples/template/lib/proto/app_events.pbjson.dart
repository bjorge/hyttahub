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
    {'1': 'templateForm', '3': 2, '4': 1, '5': 11, '6': '.hyttahub.example.template.AppEvent.TemplateForm', '9': 0, '10': 'templateForm'},
  ],
  '3': [AppEvent_ReorderableItem$json, AppEvent_TemplateForm$json],
  '8': [
    {'1': 'event'},
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
    {'1': 'photoName', '3': 7, '4': 1, '5': 9, '10': 'photoName'},
    {'1': 'photoVersion', '3': 8, '4': 1, '5': 5, '10': 'photoVersion'},
    {'1': 'photoSize', '3': 9, '4': 1, '5': 5, '10': 'photoSize'},
  ],
};

/// Descriptor for `AppEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appEventDescriptor = $convert.base64Decode(
    'CghBcHBFdmVudBJWCgx0ZW1wbGF0ZUZvcm0YAiABKAsyMC5oeXR0YWh1Yi5leGFtcGxlLnRlbX'
    'BsYXRlLkFwcEV2ZW50LlRlbXBsYXRlRm9ybUgAUgx0ZW1wbGF0ZUZvcm0aNwoPUmVvcmRlcmFi'
    'bGVJdGVtEg4KAmlkGAEgASgFUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUayQIKDFRlbXBsYX'
    'RlRm9ybRIcCgl0ZXh0VmFsdWUYASABKAlSCXRleHRWYWx1ZRIcCgljb2RlVmFsdWUYAiABKAlS'
    'CWNvZGVWYWx1ZRIkCg1jaGVja2JveFZhbHVlGAMgASgIUg1jaGVja2JveFZhbHVlEiQKDWRyb3'
    'Bkb3duVmFsdWUYBCABKAlSDWRyb3Bkb3duVmFsdWUSUQoJbGlzdEl0ZW1zGAUgAygLMjMuaHl0'
    'dGFodWIuZXhhbXBsZS50ZW1wbGF0ZS5BcHBFdmVudC5SZW9yZGVyYWJsZUl0ZW1SCWxpc3RJdG'
    'VtcxIcCglwaG90b05hbWUYByABKAlSCXBob3RvTmFtZRIiCgxwaG90b1ZlcnNpb24YCCABKAVS'
    'DHBob3RvVmVyc2lvbhIcCglwaG90b1NpemUYCSABKAVSCXBob3RvU2l6ZUIHCgVldmVudA==');

@$core.Deprecated('Use submitAppEventDescriptor instead')
const SubmitAppEvent$json = {
  '1': 'SubmitAppEvent',
  '2': [
    {'1': 'appEvent', '3': 1, '4': 1, '5': 11, '6': '.hyttahub.example.template.AppEvent', '10': 'appEvent'},
    {'1': 'siteEvent', '3': 2, '4': 1, '5': 11, '6': '.hyttahub.example.template.SubmitAppEvent.SiteEvent', '10': 'siteEvent'},
    {'1': 'authorEmail', '3': 3, '4': 1, '5': 9, '10': 'authorEmail'},
    {'1': 'images', '3': 4, '4': 3, '5': 11, '6': '.hyttahub.example.template.SubmitAppEvent.Image', '10': 'images'},
  ],
  '3': [SubmitAppEvent_SiteEvent$json, SubmitAppEvent_Image$json],
};

@$core.Deprecated('Use submitAppEventDescriptor instead')
const SubmitAppEvent_SiteEvent$json = {
  '1': 'SiteEvent',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 5, '10': 'version'},
    {'1': 'author', '3': 2, '4': 1, '5': 5, '10': 'author'},
  ],
};

@$core.Deprecated('Use submitAppEventDescriptor instead')
const SubmitAppEvent_Image$json = {
  '1': 'Image',
  '2': [
    {'1': 'base64Data', '3': 1, '4': 1, '5': 9, '10': 'base64Data'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'size', '3': 3, '4': 1, '5': 5, '10': 'size'},
  ],
};

/// Descriptor for `SubmitAppEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitAppEventDescriptor = $convert.base64Decode(
    'Cg5TdWJtaXRBcHBFdmVudBI/CghhcHBFdmVudBgBIAEoCzIjLmh5dHRhaHViLmV4YW1wbGUudG'
    'VtcGxhdGUuQXBwRXZlbnRSCGFwcEV2ZW50ElEKCXNpdGVFdmVudBgCIAEoCzIzLmh5dHRhaHVi'
    'LmV4YW1wbGUudGVtcGxhdGUuU3VibWl0QXBwRXZlbnQuU2l0ZUV2ZW50UglzaXRlRXZlbnQSIA'
    'oLYXV0aG9yRW1haWwYAyABKAlSC2F1dGhvckVtYWlsEkcKBmltYWdlcxgEIAMoCzIvLmh5dHRh'
    'aHViLmV4YW1wbGUudGVtcGxhdGUuU3VibWl0QXBwRXZlbnQuSW1hZ2VSBmltYWdlcxo9CglTaX'
    'RlRXZlbnQSGAoHdmVyc2lvbhgBIAEoBVIHdmVyc2lvbhIWCgZhdXRob3IYAiABKAVSBmF1dGhv'
    'chpPCgVJbWFnZRIeCgpiYXNlNjREYXRhGAEgASgJUgpiYXNlNjREYXRhEhIKBG5hbWUYAiABKA'
    'lSBG5hbWUSEgoEc2l6ZRgDIAEoBVIEc2l6ZQ==');

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

