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
    {'1': 'addAlbum', '3': 1, '4': 1, '5': 11, '6': '.AppEvent.AddAlbum', '9': 0, '10': 'addAlbum'},
    {'1': 'addPhoto', '3': 2, '4': 1, '5': 11, '6': '.AppEvent.AddPhoto', '9': 0, '10': 'addPhoto'},
    {'1': 'reorderAlbums', '3': 3, '4': 1, '5': 11, '6': '.AppEvent.ReorderAlbums', '9': 0, '10': 'reorderAlbums'},
    {'1': 'updateAlbum', '3': 4, '4': 1, '5': 11, '6': '.AppEvent.UpdateAlbum', '9': 0, '10': 'updateAlbum'},
    {'1': 'deleteAlbum', '3': 5, '4': 1, '5': 11, '6': '.AppEvent.DeleteAlbum', '9': 0, '10': 'deleteAlbum'},
    {'1': 'updateCaption', '3': 6, '4': 1, '5': 11, '6': '.AppEvent.UpdateCaption', '9': 0, '10': 'updateCaption'},
    {'1': 'deletePhoto', '3': 7, '4': 1, '5': 11, '6': '.AppEvent.DeletePhoto', '9': 0, '10': 'deletePhoto'},
    {'1': 'reorderPhotos', '3': 8, '4': 1, '5': 11, '6': '.AppEvent.ReorderPhotos', '9': 0, '10': 'reorderPhotos'},
  ],
  '3': [AppEvent_AddAlbum$json, AppEvent_AddPhoto$json, AppEvent_ReorderAlbums$json, AppEvent_UpdateAlbum$json, AppEvent_DeleteAlbum$json, AppEvent_UpdateCaption$json, AppEvent_DeletePhoto$json, AppEvent_ReorderPhotos$json],
  '8': [
    {'1': 'event_type'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_AddAlbum$json = {
  '1': 'AddAlbum',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_AddPhoto$json = {
  '1': 'AddPhoto',
  '2': [
    {'1': 'albumId', '3': 1, '4': 1, '5': 5, '10': 'albumId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'size', '3': 3, '4': 1, '5': 5, '10': 'size'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_ReorderAlbums$json = {
  '1': 'ReorderAlbums',
  '2': [
    {'1': 'albumIds', '3': 1, '4': 3, '5': 5, '10': 'albumIds'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_UpdateAlbum$json = {
  '1': 'UpdateAlbum',
  '2': [
    {'1': 'albumId', '3': 1, '4': 1, '5': 5, '10': 'albumId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_DeleteAlbum$json = {
  '1': 'DeleteAlbum',
  '2': [
    {'1': 'albumId', '3': 1, '4': 1, '5': 5, '10': 'albumId'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_UpdateCaption$json = {
  '1': 'UpdateCaption',
  '2': [
    {'1': 'photoId', '3': 1, '4': 1, '5': 5, '10': 'photoId'},
    {'1': 'caption', '3': 2, '4': 1, '5': 9, '10': 'caption'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_DeletePhoto$json = {
  '1': 'DeletePhoto',
  '2': [
    {'1': 'photoId', '3': 1, '4': 1, '5': 5, '10': 'photoId'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_ReorderPhotos$json = {
  '1': 'ReorderPhotos',
  '2': [
    {'1': 'albumId', '3': 1, '4': 1, '5': 5, '10': 'albumId'},
    {'1': 'photoIds', '3': 2, '4': 3, '5': 5, '10': 'photoIds'},
  ],
};

/// Descriptor for `AppEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appEventDescriptor = $convert.base64Decode(
    'CghBcHBFdmVudBIwCghhZGRBbGJ1bRgBIAEoCzISLkFwcEV2ZW50LkFkZEFsYnVtSABSCGFkZE'
    'FsYnVtEjAKCGFkZFBob3RvGAIgASgLMhIuQXBwRXZlbnQuQWRkUGhvdG9IAFIIYWRkUGhvdG8S'
    'PwoNcmVvcmRlckFsYnVtcxgDIAEoCzIXLkFwcEV2ZW50LlJlb3JkZXJBbGJ1bXNIAFINcmVvcm'
    'RlckFsYnVtcxI5Cgt1cGRhdGVBbGJ1bRgEIAEoCzIVLkFwcEV2ZW50LlVwZGF0ZUFsYnVtSABS'
    'C3VwZGF0ZUFsYnVtEjkKC2RlbGV0ZUFsYnVtGAUgASgLMhUuQXBwRXZlbnQuRGVsZXRlQWxidW'
    '1IAFILZGVsZXRlQWxidW0SPwoNdXBkYXRlQ2FwdGlvbhgGIAEoCzIXLkFwcEV2ZW50LlVwZGF0'
    'ZUNhcHRpb25IAFINdXBkYXRlQ2FwdGlvbhI5CgtkZWxldGVQaG90bxgHIAEoCzIVLkFwcEV2ZW'
    '50LkRlbGV0ZVBob3RvSABSC2RlbGV0ZVBob3RvEj8KDXJlb3JkZXJQaG90b3MYCCABKAsyFy5B'
    'cHBFdmVudC5SZW9yZGVyUGhvdG9zSABSDXJlb3JkZXJQaG90b3MaHgoIQWRkQWxidW0SEgoEbm'
    'FtZRgBIAEoCVIEbmFtZRpMCghBZGRQaG90bxIYCgdhbGJ1bUlkGAEgASgFUgdhbGJ1bUlkEhIK'
    'BG5hbWUYAiABKAlSBG5hbWUSEgoEc2l6ZRgDIAEoBVIEc2l6ZRorCg1SZW9yZGVyQWxidW1zEh'
    'oKCGFsYnVtSWRzGAEgAygFUghhbGJ1bUlkcxo7CgtVcGRhdGVBbGJ1bRIYCgdhbGJ1bUlkGAEg'
    'ASgFUgdhbGJ1bUlkEhIKBG5hbWUYAiABKAlSBG5hbWUaJwoLRGVsZXRlQWxidW0SGAoHYWxidW'
    '1JZBgBIAEoBVIHYWxidW1JZBpDCg1VcGRhdGVDYXB0aW9uEhgKB3Bob3RvSWQYASABKAVSB3Bo'
    'b3RvSWQSGAoHY2FwdGlvbhgCIAEoCVIHY2FwdGlvbhonCgtEZWxldGVQaG90bxIYCgdwaG90b0'
    'lkGAEgASgFUgdwaG90b0lkGkUKDVJlb3JkZXJQaG90b3MSGAoHYWxidW1JZBgBIAEoBVIHYWxi'
    'dW1JZBIaCghwaG90b0lkcxgCIAMoBVIIcGhvdG9JZHNCDAoKZXZlbnRfdHlwZQ==');

@$core.Deprecated('Use submitAppEventDescriptor instead')
const SubmitAppEvent$json = {
  '1': 'SubmitAppEvent',
  '2': [
    {'1': 'appEvent', '3': 1, '4': 1, '5': 11, '6': '.AppEvent', '10': 'appEvent'},
    {'1': 'siteEvent', '3': 2, '4': 1, '5': 11, '6': '.SubmitAppEvent.SiteEvent', '10': 'siteEvent'},
    {'1': 'authorEmail', '3': 3, '4': 1, '5': 9, '10': 'authorEmail'},
    {'1': 'images', '3': 10, '4': 3, '5': 11, '6': '.SubmitAppEvent.Image', '10': 'images'},
    {'1': 'photo_ids_to_delete', '3': 11, '4': 3, '5': 5, '10': 'photoIdsToDelete'},
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
    'Cg5TdWJtaXRBcHBFdmVudBIlCghhcHBFdmVudBgBIAEoCzIJLkFwcEV2ZW50UghhcHBFdmVudB'
    'I3CglzaXRlRXZlbnQYAiABKAsyGS5TdWJtaXRBcHBFdmVudC5TaXRlRXZlbnRSCXNpdGVFdmVu'
    'dBIgCgthdXRob3JFbWFpbBgDIAEoCVILYXV0aG9yRW1haWwSLQoGaW1hZ2VzGAogAygLMhUuU3'
    'VibWl0QXBwRXZlbnQuSW1hZ2VSBmltYWdlcxItChNwaG90b19pZHNfdG9fZGVsZXRlGAsgAygF'
    'UhBwaG90b0lkc1RvRGVsZXRlGj0KCVNpdGVFdmVudBIYCgd2ZXJzaW9uGAEgASgFUgd2ZXJzaW'
    '9uEhYKBmF1dGhvchgCIAEoBVIGYXV0aG9yGk8KBUltYWdlEh4KCmJhc2U2NERhdGEYASABKAlS'
    'CmJhc2U2NERhdGESEgoEbmFtZRgCIAEoCVIEbmFtZRISCgRzaXplGAMgASgFUgRzaXpl');

@$core.Deprecated('Use appEventRecordDescriptor instead')
const AppEventRecord$json = {
  '1': 'AppEventRecord',
  '2': [
    {'1': 'isoDate', '3': 1, '4': 1, '5': 9, '10': 'isoDate'},
    {'1': 'version', '3': 2, '4': 1, '5': 5, '10': 'version'},
    {'1': 'appEvent', '3': 3, '4': 1, '5': 11, '6': '.AppEvent', '10': 'appEvent'},
  ],
};

/// Descriptor for `AppEventRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appEventRecordDescriptor = $convert.base64Decode(
    'Cg5BcHBFdmVudFJlY29yZBIYCgdpc29EYXRlGAEgASgJUgdpc29EYXRlEhgKB3ZlcnNpb24YAi'
    'ABKAVSB3ZlcnNpb24SJQoIYXBwRXZlbnQYAyABKAsyCS5BcHBFdmVudFIIYXBwRXZlbnQ=');

