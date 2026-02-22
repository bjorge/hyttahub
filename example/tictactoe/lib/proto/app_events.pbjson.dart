// This is a generated file - do not edit.
//
// Generated from app_events.proto.

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

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent$json = {
  '1': 'AppEvent',
  '2': [
    {
      '1': 'move',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hyttahub.example.tictactoe.AppEvent.Move',
      '9': 0,
      '10': 'move'
    },
    {
      '1': 'startGame',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.hyttahub.example.tictactoe.AppEvent.StartGame',
      '9': 0,
      '10': 'startGame'
    },
    {
      '1': 'playAgain',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.hyttahub.example.tictactoe.AppEvent.PlayAgain',
      '9': 0,
      '10': 'playAgain'
    },
  ],
  '3': [AppEvent_Move$json, AppEvent_StartGame$json, AppEvent_PlayAgain$json],
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

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_StartGame$json = {
  '1': 'StartGame',
  '2': [
    {'1': 'vs_bot', '3': 1, '4': 1, '5': 8, '10': 'vsBot'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_PlayAgain$json = {
  '1': 'PlayAgain',
};

/// Descriptor for `AppEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appEventDescriptor = $convert.base64Decode(
    'CghBcHBFdmVudBI/CgRtb3ZlGAEgASgLMikuaHl0dGFodWIuZXhhbXBsZS50aWN0YWN0b2UuQX'
    'BwRXZlbnQuTW92ZUgAUgRtb3ZlEk4KCXN0YXJ0R2FtZRgCIAEoCzIuLmh5dHRhaHViLmV4YW1w'
    'bGUudGljdGFjdG9lLkFwcEV2ZW50LlN0YXJ0R2FtZUgAUglzdGFydEdhbWUSTgoJcGxheUFnYW'
    'luGAMgASgLMi4uaHl0dGFodWIuZXhhbXBsZS50aWN0YWN0b2UuQXBwRXZlbnQuUGxheUFnYWlu'
    'SABSCXBsYXlBZ2Fpbho6CgRNb3ZlEgwKAXgYASABKAVSAXgSDAoBeRgCIAEoBVIBeRIWCgZwbG'
    'F5ZXIYAyABKAVSBnBsYXllchoiCglTdGFydEdhbWUSFQoGdnNfYm90GAEgASgIUgV2c0JvdBoL'
    'CglQbGF5QWdhaW5CBwoFZXZlbnQ=');

@$core.Deprecated('Use submitAppEventDescriptor instead')
const SubmitAppEvent$json = {
  '1': 'SubmitAppEvent',
  '2': [
    {
      '1': 'appEvent',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hyttahub.example.tictactoe.AppEvent',
      '10': 'appEvent'
    },
    {
      '1': 'siteEvent',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.hyttahub.example.tictactoe.SubmitAppEvent.SiteEvent',
      '10': 'siteEvent'
    },
    {'1': 'authorEmail', '3': 3, '4': 1, '5': 9, '10': 'authorEmail'},
    {
      '1': 'images',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.hyttahub.example.tictactoe.SubmitAppEvent.Image',
      '10': 'images'
    },
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
    {
      '1': 'appEvent',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.hyttahub.example.tictactoe.AppEvent',
      '10': 'appEvent'
    },
  ],
};

/// Descriptor for `AppEventRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appEventRecordDescriptor = $convert.base64Decode(
    'Cg5BcHBFdmVudFJlY29yZBIYCgdpc29EYXRlGAEgASgJUgdpc29EYXRlEhgKB3ZlcnNpb24YAi'
    'ABKAVSB3ZlcnNpb24SQAoIYXBwRXZlbnQYAyABKAsyJC5oeXR0YWh1Yi5leGFtcGxlLnRpY3Rh'
    'Y3RvZS5BcHBFdmVudFIIYXBwRXZlbnQ=');
