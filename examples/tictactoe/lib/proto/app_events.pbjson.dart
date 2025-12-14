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
    {'1': 'move', '3': 1, '4': 1, '5': 11, '6': '.hyttahub.example.tictactoe.AppEvent.Move', '9': 0, '10': 'move'},
  ],
  '3': [AppEvent_Move$json],
  '8': [
    {'1': 'event'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_Move$json = {
  '1': 'Move',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 5, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 5, '10': 'y'},
    {'1': 'player', '3': 3, '4': 1, '5': 5, '10': 'player'},
  ],
};

/// Descriptor for `AppEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appEventDescriptor = $convert.base64Decode(
    'CghBcHBFdmVudBI/CgRtb3ZlGAEgASgLMikuaHl0dGFodWIuZXhhbXBsZS50aWN0YWN0b2UuQX'
    'BwRXZlbnQuTW92ZUgAUgRtb3ZlGjoKBE1vdmUSDAoBeBgBIAEoBVIBeBIMCgF5GAIgASgFUgF5'
    'EhYKBnBsYXllchgDIAEoBVIGcGxheWVyQgcKBWV2ZW50');

@$core.Deprecated('Use submitAppEventDescriptor instead')
const SubmitAppEvent$json = {
  '1': 'SubmitAppEvent',
  '2': [
    {'1': 'appEvent', '3': 1, '4': 1, '5': 11, '6': '.hyttahub.example.tictactoe.AppEvent', '10': 'appEvent'},
    {'1': 'siteEvent', '3': 2, '4': 1, '5': 11, '6': '.hyttahub.example.tictactoe.SubmitAppEvent.SiteEvent', '10': 'siteEvent'},
    {'1': 'authorEmail', '3': 3, '4': 1, '5': 9, '10': 'authorEmail'},
    {'1': 'images', '3': 4, '4': 3, '5': 11, '6': '.hyttahub.example.tictactoe.SubmitAppEvent.Image', '10': 'images'},
    {'1': 'pause_delay', '3': 5, '4': 1, '5': 5, '10': 'pauseDelay'},
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
    'Cg5TdWJtaXRBcHBFdmVudBJACghhcHBFdmVudBgBIAEoCzIkLmh5dHRhaHViLmV4YW1wbGUudG'
    'ljdGFjdG9lLkFwcEV2ZW50UghhcHBFdmVudBJSCglzaXRlRXZlbnQYAiABKAsyNC5oeXR0YWh1'
    'Yi5leGFtcGxlLnRpY3RhY3RvZS5TdWJtaXRBcHBFdmVudC5TaXRlRXZlbnRSCXNpdGVFdmVudB'
    'IgCgthdXRob3JFbWFpbBgDIAEoCVILYXV0aG9yRW1haWwSSAoGaW1hZ2VzGAQgAygLMjAuaHl0'
    'dGFodWIuZXhhbXBsZS50aWN0YWN0b2UuU3VibWl0QXBwRXZlbnQuSW1hZ2VSBmltYWdlcxIfCg'
    'twYXVzZV9kZWxheRgFIAEoBVIKcGF1c2VEZWxheRo9CglTaXRlRXZlbnQSGAoHdmVyc2lvbhgB'
    'IAEoBVIHdmVyc2lvbhIWCgZhdXRob3IYAiABKAVSBmF1dGhvchpPCgVJbWFnZRIeCgpiYXNlNj'
    'REYXRhGAEgASgJUgpiYXNlNjREYXRhEhIKBG5hbWUYAiABKAlSBG5hbWUSEgoEc2l6ZRgDIAEo'
    'BVIEc2l6ZQ==');

@$core.Deprecated('Use appEventRecordDescriptor instead')
const AppEventRecord$json = {
  '1': 'AppEventRecord',
  '2': [
    {'1': 'isoDate', '3': 1, '4': 1, '5': 9, '10': 'isoDate'},
    {'1': 'version', '3': 2, '4': 1, '5': 5, '10': 'version'},
    {'1': 'appEvent', '3': 3, '4': 1, '5': 11, '6': '.hyttahub.example.tictactoe.AppEvent', '10': 'appEvent'},
  ],
};

/// Descriptor for `AppEventRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appEventRecordDescriptor = $convert.base64Decode(
    'Cg5BcHBFdmVudFJlY29yZBIYCgdpc29EYXRlGAEgASgJUgdpc29EYXRlEhgKB3ZlcnNpb24YAi'
    'ABKAVSB3ZlcnNpb24SQAoIYXBwRXZlbnQYAyABKAsyJC5oeXR0YWh1Yi5leGFtcGxlLnRpY3Rh'
    'Y3RvZS5BcHBFdmVudFIIYXBwRXZlbnQ=');

