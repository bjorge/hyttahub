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
    {'1': 'updateText', '3': 3, '4': 1, '5': 11, '6': '.hyttahub.example.template.AppEvent.UpdateText', '9': 0, '10': 'updateText'},
    {'1': 'updateCode', '3': 4, '4': 1, '5': 11, '6': '.hyttahub.example.template.AppEvent.UpdateCode', '9': 0, '10': 'updateCode'},
    {'1': 'updateCheckbox', '3': 5, '4': 1, '5': 11, '6': '.hyttahub.example.template.AppEvent.UpdateCheckbox', '9': 0, '10': 'updateCheckbox'},
    {'1': 'updateDropdown', '3': 6, '4': 1, '5': 11, '6': '.hyttahub.example.template.AppEvent.UpdateDropdown', '9': 0, '10': 'updateDropdown'},
    {'1': 'updateList', '3': 7, '4': 1, '5': 11, '6': '.hyttahub.example.template.AppEvent.UpdateList', '9': 0, '10': 'updateList'},
    {'1': 'updatePhoto', '3': 8, '4': 1, '5': 11, '6': '.hyttahub.example.template.AppEvent.UpdatePhoto', '9': 0, '10': 'updatePhoto'},
  ],
  '3': [AppEvent_ReorderableItem$json, AppEvent_UpdateText$json, AppEvent_UpdateCode$json, AppEvent_UpdateCheckbox$json, AppEvent_UpdateDropdown$json, AppEvent_UpdateList$json, AppEvent_UpdatePhoto$json, AppEvent_TemplateForm$json],
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
const AppEvent_UpdateText$json = {
  '1': 'UpdateText',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_UpdateCode$json = {
  '1': 'UpdateCode',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_UpdateCheckbox$json = {
  '1': 'UpdateCheckbox',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 8, '10': 'value'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_UpdateDropdown$json = {
  '1': 'UpdateDropdown',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_UpdateList$json = {
  '1': 'UpdateList',
  '2': [
    {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.hyttahub.example.template.AppEvent.ReorderableItem', '10': 'items'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_UpdatePhoto$json = {
  '1': 'UpdatePhoto',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'version', '3': 2, '4': 1, '5': 5, '10': 'version'},
    {'1': 'size', '3': 3, '4': 1, '5': 5, '10': 'size'},
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
    'BsYXRlLkFwcEV2ZW50LlRlbXBsYXRlRm9ybUgAUgx0ZW1wbGF0ZUZvcm0SUAoKdXBkYXRlVGV4'
    'dBgDIAEoCzIuLmh5dHRhaHViLmV4YW1wbGUudGVtcGxhdGUuQXBwRXZlbnQuVXBkYXRlVGV4dE'
    'gAUgp1cGRhdGVUZXh0ElAKCnVwZGF0ZUNvZGUYBCABKAsyLi5oeXR0YWh1Yi5leGFtcGxlLnRl'
    'bXBsYXRlLkFwcEV2ZW50LlVwZGF0ZUNvZGVIAFIKdXBkYXRlQ29kZRJcCg51cGRhdGVDaGVja2'
    'JveBgFIAEoCzIyLmh5dHRhaHViLmV4YW1wbGUudGVtcGxhdGUuQXBwRXZlbnQuVXBkYXRlQ2hl'
    'Y2tib3hIAFIOdXBkYXRlQ2hlY2tib3gSXAoOdXBkYXRlRHJvcGRvd24YBiABKAsyMi5oeXR0YW'
    'h1Yi5leGFtcGxlLnRlbXBsYXRlLkFwcEV2ZW50LlVwZGF0ZURyb3Bkb3duSABSDnVwZGF0ZURy'
    'b3Bkb3duElAKCnVwZGF0ZUxpc3QYByABKAsyLi5oeXR0YWh1Yi5leGFtcGxlLnRlbXBsYXRlLk'
    'FwcEV2ZW50LlVwZGF0ZUxpc3RIAFIKdXBkYXRlTGlzdBJTCgt1cGRhdGVQaG90bxgIIAEoCzIv'
    'Lmh5dHRhaHViLmV4YW1wbGUudGVtcGxhdGUuQXBwRXZlbnQuVXBkYXRlUGhvdG9IAFILdXBkYX'
    'RlUGhvdG8aNwoPUmVvcmRlcmFibGVJdGVtEg4KAmlkGAEgASgFUgJpZBIUCgV0aXRsZRgCIAEo'
    'CVIFdGl0bGUaIgoKVXBkYXRlVGV4dBIUCgV2YWx1ZRgBIAEoCVIFdmFsdWUaIgoKVXBkYXRlQ2'
    '9kZRIUCgV2YWx1ZRgBIAEoCVIFdmFsdWUaJgoOVXBkYXRlQ2hlY2tib3gSFAoFdmFsdWUYASAB'
    'KAhSBXZhbHVlGiYKDlVwZGF0ZURyb3Bkb3duEhQKBXZhbHVlGAEgASgJUgV2YWx1ZRpXCgpVcG'
    'RhdGVMaXN0EkkKBWl0ZW1zGAEgAygLMjMuaHl0dGFodWIuZXhhbXBsZS50ZW1wbGF0ZS5BcHBF'
    'dmVudC5SZW9yZGVyYWJsZUl0ZW1SBWl0ZW1zGk8KC1VwZGF0ZVBob3RvEhIKBG5hbWUYASABKA'
    'lSBG5hbWUSGAoHdmVyc2lvbhgCIAEoBVIHdmVyc2lvbhISCgRzaXplGAMgASgFUgRzaXplGskC'
    'CgxUZW1wbGF0ZUZvcm0SHAoJdGV4dFZhbHVlGAEgASgJUgl0ZXh0VmFsdWUSHAoJY29kZVZhbH'
    'VlGAIgASgJUgljb2RlVmFsdWUSJAoNY2hlY2tib3hWYWx1ZRgDIAEoCFINY2hlY2tib3hWYWx1'
    'ZRIkCg1kcm9wZG93blZhbHVlGAQgASgJUg1kcm9wZG93blZhbHVlElEKCWxpc3RJdGVtcxgFIA'
    'MoCzIzLmh5dHRhaHViLmV4YW1wbGUudGVtcGxhdGUuQXBwRXZlbnQuUmVvcmRlcmFibGVJdGVt'
    'UglsaXN0SXRlbXMSHAoJcGhvdG9OYW1lGAcgASgJUglwaG90b05hbWUSIgoMcGhvdG9WZXJzaW'
    '9uGAggASgFUgxwaG90b1ZlcnNpb24SHAoJcGhvdG9TaXplGAkgASgFUglwaG90b1NpemVCBwoF'
    'ZXZlbnQ=');

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

