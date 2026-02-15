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

@$core.Deprecated('Use appReplayStateEnumDescriptor instead')
const AppReplayStateEnum$json = {
  '1': 'AppReplayStateEnum',
  '2': [
    {'1': 'hydrating', '2': 0},
    {'1': 'listening', '2': 1},
    {'1': 'uninitializedListening', '2': 2},
    {'1': 'networkError', '2': 3},
    {'1': 'permissionDenied', '2': 4},
  ],
};

/// Descriptor for `AppReplayStateEnum`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List appReplayStateEnumDescriptor = $convert.base64Decode(
    'ChJBcHBSZXBsYXlTdGF0ZUVudW0SDQoJaHlkcmF0aW5nEAASDQoJbGlzdGVuaW5nEAESGgoWdW'
    '5pbml0aWFsaXplZExpc3RlbmluZxACEhAKDG5ldHdvcmtFcnJvchADEhQKEHBlcm1pc3Npb25E'
    'ZW5pZWQQBA==');

@$core.Deprecated('Use gameStatusDescriptor instead')
const GameStatus$json = {
  '1': 'GameStatus',
  '2': [
    {'1': 'notStarted', '2': 0},
    {'1': 'playing', '2': 1},
    {'1': 'gameOver', '2': 2},
  ],
};

/// Descriptor for `GameStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List gameStatusDescriptor = $convert.base64Decode(
    'CgpHYW1lU3RhdHVzEg4KCm5vdFN0YXJ0ZWQQABILCgdwbGF5aW5nEAESDAoIZ2FtZU92ZXIQAg'
    '==');

@$core.Deprecated('Use appReplayBlocStateDescriptor instead')
const AppReplayBlocState$json = {
  '1': 'AppReplayBlocState',
  '2': [
    {'1': 'events', '3': 1, '4': 3, '5': 11, '6': '.hyttahub.example.tictactoe.AppReplayBlocState.EventsEntry', '10': 'events'},
    {'1': 'state', '3': 2, '4': 1, '5': 14, '6': '.hyttahub.example.tictactoe.AppReplayStateEnum', '10': 'state'},
    {'1': 'board', '3': 3, '4': 3, '5': 5, '10': 'board'},
    {'1': 'turn', '3': 4, '4': 1, '5': 5, '10': 'turn'},
    {'1': 'winner', '3': 5, '4': 1, '5': 5, '10': 'winner'},
    {'1': 'status', '3': 7, '4': 1, '5': 14, '6': '.hyttahub.example.tictactoe.GameStatus', '10': 'status'},
    {'1': 'vs_bot', '3': 8, '4': 1, '5': 8, '10': 'vsBot'},
    {'1': 'game_count', '3': 9, '4': 1, '5': 5, '10': 'gameCount'},
    {'1': 'members', '3': 10, '4': 3, '5': 11, '6': '.hyttahub.example.tictactoe.AppReplayBlocState.MembersEntry', '10': 'members'},
    {'1': 'x_player_id', '3': 11, '4': 1, '5': 5, '10': 'xPlayerId'},
    {'1': 'o_player_id', '3': 12, '4': 1, '5': 5, '10': 'oPlayerId'},
  ],
  '3': [AppReplayBlocState_EventsEntry$json, AppReplayBlocState_MembersEntry$json],
};

@$core.Deprecated('Use appReplayBlocStateDescriptor instead')
const AppReplayBlocState_EventsEntry$json = {
  '1': 'EventsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use appReplayBlocStateDescriptor instead')
const AppReplayBlocState_MembersEntry$json = {
  '1': 'MembersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `AppReplayBlocState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appReplayBlocStateDescriptor = $convert.base64Decode(
    'ChJBcHBSZXBsYXlCbG9jU3RhdGUSUgoGZXZlbnRzGAEgAygLMjouaHl0dGFodWIuZXhhbXBsZS'
    '50aWN0YWN0b2UuQXBwUmVwbGF5QmxvY1N0YXRlLkV2ZW50c0VudHJ5UgZldmVudHMSRAoFc3Rh'
    'dGUYAiABKA4yLi5oeXR0YWh1Yi5leGFtcGxlLnRpY3RhY3RvZS5BcHBSZXBsYXlTdGF0ZUVudW'
    '1SBXN0YXRlEhQKBWJvYXJkGAMgAygFUgVib2FyZBISCgR0dXJuGAQgASgFUgR0dXJuEhYKBndp'
    'bm5lchgFIAEoBVIGd2lubmVyEj4KBnN0YXR1cxgHIAEoDjImLmh5dHRhaHViLmV4YW1wbGUudG'
    'ljdGFjdG9lLkdhbWVTdGF0dXNSBnN0YXR1cxIVCgZ2c19ib3QYCCABKAhSBXZzQm90Eh0KCmdh'
    'bWVfY291bnQYCSABKAVSCWdhbWVDb3VudBJVCgdtZW1iZXJzGAogAygLMjsuaHl0dGFodWIuZX'
    'hhbXBsZS50aWN0YWN0b2UuQXBwUmVwbGF5QmxvY1N0YXRlLk1lbWJlcnNFbnRyeVIHbWVtYmVy'
    'cxIeCgt4X3BsYXllcl9pZBgLIAEoBVIJeFBsYXllcklkEh4KC29fcGxheWVyX2lkGAwgASgFUg'
    'lvUGxheWVySWQaOQoLRXZlbnRzRW50cnkSEAoDa2V5GAEgASgFUgNrZXkSFAoFdmFsdWUYAiAB'
    'KAlSBXZhbHVlOgI4ARo6CgxNZW1iZXJzRW50cnkSEAoDa2V5GAEgASgFUgNrZXkSFAoFdmFsdW'
    'UYAiABKAlSBXZhbHVlOgI4AQ==');

