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

@$core.Deprecated('Use treeConnectionTypeDescriptor instead')
const TreeConnectionType$json = {
  '1': 'TreeConnectionType',
  '2': [
    {'1': 'parent', '2': 0},
    {'1': 'child', '2': 1},
    {'1': 'partner', '2': 2},
    {'1': 'exPartner', '2': 3},
    {'1': 'friend', '2': 4},
    {'1': 'pet', '2': 5},
  ],
};

/// Descriptor for `TreeConnectionType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List treeConnectionTypeDescriptor = $convert.base64Decode(
    'ChJUcmVlQ29ubmVjdGlvblR5cGUSCgoGcGFyZW50EAASCQoFY2hpbGQQARILCgdwYXJ0bmVyEA'
    'ISDQoJZXhQYXJ0bmVyEAMSCgoGZnJpZW5kEAQSBwoDcGV0EAU=');

@$core.Deprecated('Use treeConnectionDescriptor instead')
const TreeConnection$json = {
  '1': 'TreeConnection',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.TreeConnectionType', '10': 'type'},
    {'1': 'info', '3': 2, '4': 1, '5': 9, '10': 'info'},
  ],
};

/// Descriptor for `TreeConnection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List treeConnectionDescriptor = $convert.base64Decode(
    'Cg5UcmVlQ29ubmVjdGlvbhInCgR0eXBlGAEgASgOMhMuVHJlZUNvbm5lY3Rpb25UeXBlUgR0eX'
    'BlEhIKBGluZm8YAiABKAlSBGluZm8=');

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent$json = {
  '1': 'AppEvent',
  '2': [
    {'1': 'addTree', '3': 1, '4': 1, '5': 11, '6': '.AppEvent.AddTree', '9': 0, '10': 'addTree'},
    {'1': 'updateTree', '3': 2, '4': 1, '5': 11, '6': '.AppEvent.UpdateTree', '9': 0, '10': 'updateTree'},
    {'1': 'deleteTree', '3': 3, '4': 1, '5': 11, '6': '.AppEvent.DeleteTree', '9': 0, '10': 'deleteTree'},
    {'1': 'reorderTrees', '3': 4, '4': 1, '5': 11, '6': '.AppEvent.ReorderTrees', '9': 0, '10': 'reorderTrees'},
    {'1': 'addTreeMember', '3': 5, '4': 1, '5': 11, '6': '.AppEvent.AddTreeMember', '9': 0, '10': 'addTreeMember'},
    {'1': 'updateTreeMember', '3': 6, '4': 1, '5': 11, '6': '.AppEvent.UpdateTreeMember', '9': 0, '10': 'updateTreeMember'},
    {'1': 'removeTreeMember', '3': 7, '4': 1, '5': 11, '6': '.AppEvent.RemoveTreeMember', '9': 0, '10': 'removeTreeMember'},
    {'1': 'reorderTreeMembers', '3': 8, '4': 1, '5': 11, '6': '.AppEvent.ReorderTreeMembers', '9': 0, '10': 'reorderTreeMembers'},
    {'1': 'addConnection', '3': 9, '4': 1, '5': 11, '6': '.AppEvent.AddConnection', '9': 0, '10': 'addConnection'},
    {'1': 'updateConnection', '3': 10, '4': 1, '5': 11, '6': '.AppEvent.UpdateConnection', '9': 0, '10': 'updateConnection'},
    {'1': 'removeConnection', '3': 11, '4': 1, '5': 11, '6': '.AppEvent.RemoveConnection', '9': 0, '10': 'removeConnection'},
    {'1': 'addPhoto', '3': 12, '4': 1, '5': 11, '6': '.AppEvent.AddPhoto', '9': 0, '10': 'addPhoto'},
    {'1': 'deletePhoto', '3': 13, '4': 1, '5': 11, '6': '.AppEvent.DeletePhoto', '9': 0, '10': 'deletePhoto'},
    {'1': 'updateCaption', '3': 14, '4': 1, '5': 11, '6': '.AppEvent.UpdateCaption', '9': 0, '10': 'updateCaption'},
  ],
  '3': [AppEvent_AddTree$json, AppEvent_UpdateTree$json, AppEvent_DeleteTree$json, AppEvent_ReorderTrees$json, AppEvent_AddTreeMember$json, AppEvent_UpdateTreeMember$json, AppEvent_RemoveTreeMember$json, AppEvent_ReorderTreeMembers$json, AppEvent_AddConnection$json, AppEvent_UpdateConnection$json, AppEvent_RemoveConnection$json, AppEvent_AddPhoto$json, AppEvent_DeletePhoto$json, AppEvent_UpdateCaption$json],
  '8': [
    {'1': 'event_type'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_AddTree$json = {
  '1': 'AddTree',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_UpdateTree$json = {
  '1': 'UpdateTree',
  '2': [
    {'1': 'treeId', '3': 1, '4': 1, '5': 5, '10': 'treeId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_DeleteTree$json = {
  '1': 'DeleteTree',
  '2': [
    {'1': 'treeId', '3': 1, '4': 1, '5': 5, '10': 'treeId'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_ReorderTrees$json = {
  '1': 'ReorderTrees',
  '2': [
    {'1': 'treeIds', '3': 1, '4': 3, '5': 5, '10': 'treeIds'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_AddTreeMember$json = {
  '1': 'AddTreeMember',
  '2': [
    {'1': 'treeId', '3': 1, '4': 1, '5': 5, '10': 'treeId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_UpdateTreeMember$json = {
  '1': 'UpdateTreeMember',
  '2': [
    {'1': 'treeMemberId', '3': 1, '4': 1, '5': 5, '10': 'treeMemberId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_RemoveTreeMember$json = {
  '1': 'RemoveTreeMember',
  '2': [
    {'1': 'treeMemberId', '3': 1, '4': 1, '5': 5, '10': 'treeMemberId'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_ReorderTreeMembers$json = {
  '1': 'ReorderTreeMembers',
  '2': [
    {'1': 'treeId', '3': 1, '4': 1, '5': 5, '10': 'treeId'},
    {'1': 'treeMemberIds', '3': 2, '4': 3, '5': 5, '10': 'treeMemberIds'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_AddConnection$json = {
  '1': 'AddConnection',
  '2': [
    {'1': 'connection', '3': 1, '4': 1, '5': 11, '6': '.TreeConnection', '10': 'connection'},
    {'1': 'fromTreeMemberId', '3': 2, '4': 1, '5': 5, '10': 'fromTreeMemberId'},
    {'1': 'toTreeMemberId', '3': 3, '4': 1, '5': 5, '10': 'toTreeMemberId'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_UpdateConnection$json = {
  '1': 'UpdateConnection',
  '2': [
    {'1': 'connectionId', '3': 1, '4': 1, '5': 5, '10': 'connectionId'},
    {'1': 'connection', '3': 2, '4': 1, '5': 11, '6': '.TreeConnection', '10': 'connection'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_RemoveConnection$json = {
  '1': 'RemoveConnection',
  '2': [
    {'1': 'treeConnectionId', '3': 1, '4': 1, '5': 5, '10': 'treeConnectionId'},
  ],
};

@$core.Deprecated('Use appEventDescriptor instead')
const AppEvent_AddPhoto$json = {
  '1': 'AddPhoto',
  '2': [
    {'1': 'treeMemberId', '3': 1, '4': 1, '5': 5, '10': 'treeMemberId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'size', '3': 4, '4': 1, '5': 5, '10': 'size'},
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
const AppEvent_UpdateCaption$json = {
  '1': 'UpdateCaption',
  '2': [
    {'1': 'caption', '3': 1, '4': 1, '5': 9, '10': 'caption'},
    {'1': 'photoId', '3': 2, '4': 1, '5': 5, '10': 'photoId'},
  ],
};

/// Descriptor for `AppEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appEventDescriptor = $convert.base64Decode(
    'CghBcHBFdmVudBItCgdhZGRUcmVlGAEgASgLMhEuQXBwRXZlbnQuQWRkVHJlZUgAUgdhZGRUcm'
    'VlEjYKCnVwZGF0ZVRyZWUYAiABKAsyFC5BcHBFdmVudC5VcGRhdGVUcmVlSABSCnVwZGF0ZVRy'
    'ZWUSNgoKZGVsZXRlVHJlZRgDIAEoCzIULkFwcEV2ZW50LkRlbGV0ZVRyZWVIAFIKZGVsZXRlVH'
    'JlZRI8CgxyZW9yZGVyVHJlZXMYBCABKAsyFi5BcHBFdmVudC5SZW9yZGVyVHJlZXNIAFIMcmVv'
    'cmRlclRyZWVzEj8KDWFkZFRyZWVNZW1iZXIYBSABKAsyFy5BcHBFdmVudC5BZGRUcmVlTWVtYm'
    'VySABSDWFkZFRyZWVNZW1iZXISSAoQdXBkYXRlVHJlZU1lbWJlchgGIAEoCzIaLkFwcEV2ZW50'
    'LlVwZGF0ZVRyZWVNZW1iZXJIAFIQdXBkYXRlVHJlZU1lbWJlchJIChByZW1vdmVUcmVlTWVtYm'
    'VyGAcgASgLMhouQXBwRXZlbnQuUmVtb3ZlVHJlZU1lbWJlckgAUhByZW1vdmVUcmVlTWVtYmVy'
    'Ek4KEnJlb3JkZXJUcmVlTWVtYmVycxgIIAEoCzIcLkFwcEV2ZW50LlJlb3JkZXJUcmVlTWVtYm'
    'Vyc0gAUhJyZW9yZGVyVHJlZU1lbWJlcnMSPwoNYWRkQ29ubmVjdGlvbhgJIAEoCzIXLkFwcEV2'
    'ZW50LkFkZENvbm5lY3Rpb25IAFINYWRkQ29ubmVjdGlvbhJIChB1cGRhdGVDb25uZWN0aW9uGA'
    'ogASgLMhouQXBwRXZlbnQuVXBkYXRlQ29ubmVjdGlvbkgAUhB1cGRhdGVDb25uZWN0aW9uEkgK'
    'EHJlbW92ZUNvbm5lY3Rpb24YCyABKAsyGi5BcHBFdmVudC5SZW1vdmVDb25uZWN0aW9uSABSEH'
    'JlbW92ZUNvbm5lY3Rpb24SMAoIYWRkUGhvdG8YDCABKAsyEi5BcHBFdmVudC5BZGRQaG90b0gA'
    'UghhZGRQaG90bxI5CgtkZWxldGVQaG90bxgNIAEoCzIVLkFwcEV2ZW50LkRlbGV0ZVBob3RvSA'
    'BSC2RlbGV0ZVBob3RvEj8KDXVwZGF0ZUNhcHRpb24YDiABKAsyFy5BcHBFdmVudC5VcGRhdGVD'
    'YXB0aW9uSABSDXVwZGF0ZUNhcHRpb24aHQoHQWRkVHJlZRISCgRuYW1lGAEgASgJUgRuYW1lGj'
    'gKClVwZGF0ZVRyZWUSFgoGdHJlZUlkGAEgASgFUgZ0cmVlSWQSEgoEbmFtZRgCIAEoCVIEbmFt'
    'ZRokCgpEZWxldGVUcmVlEhYKBnRyZWVJZBgBIAEoBVIGdHJlZUlkGigKDFJlb3JkZXJUcmVlcx'
    'IYCgd0cmVlSWRzGAEgAygFUgd0cmVlSWRzGjsKDUFkZFRyZWVNZW1iZXISFgoGdHJlZUlkGAEg'
    'ASgFUgZ0cmVlSWQSEgoEbmFtZRgCIAEoCVIEbmFtZRpKChBVcGRhdGVUcmVlTWVtYmVyEiIKDH'
    'RyZWVNZW1iZXJJZBgBIAEoBVIMdHJlZU1lbWJlcklkEhIKBG5hbWUYAiABKAlSBG5hbWUaNgoQ'
    'UmVtb3ZlVHJlZU1lbWJlchIiCgx0cmVlTWVtYmVySWQYASABKAVSDHRyZWVNZW1iZXJJZBpSCh'
    'JSZW9yZGVyVHJlZU1lbWJlcnMSFgoGdHJlZUlkGAEgASgFUgZ0cmVlSWQSJAoNdHJlZU1lbWJl'
    'cklkcxgCIAMoBVINdHJlZU1lbWJlcklkcxqUAQoNQWRkQ29ubmVjdGlvbhIvCgpjb25uZWN0aW'
    '9uGAEgASgLMg8uVHJlZUNvbm5lY3Rpb25SCmNvbm5lY3Rpb24SKgoQZnJvbVRyZWVNZW1iZXJJ'
    'ZBgCIAEoBVIQZnJvbVRyZWVNZW1iZXJJZBImCg50b1RyZWVNZW1iZXJJZBgDIAEoBVIOdG9Ucm'
    'VlTWVtYmVySWQaZwoQVXBkYXRlQ29ubmVjdGlvbhIiCgxjb25uZWN0aW9uSWQYASABKAVSDGNv'
    'bm5lY3Rpb25JZBIvCgpjb25uZWN0aW9uGAIgASgLMg8uVHJlZUNvbm5lY3Rpb25SCmNvbm5lY3'
    'Rpb24aPgoQUmVtb3ZlQ29ubmVjdGlvbhIqChB0cmVlQ29ubmVjdGlvbklkGAEgASgFUhB0cmVl'
    'Q29ubmVjdGlvbklkGlYKCEFkZFBob3RvEiIKDHRyZWVNZW1iZXJJZBgBIAEoBVIMdHJlZU1lbW'
    'JlcklkEhIKBG5hbWUYAyABKAlSBG5hbWUSEgoEc2l6ZRgEIAEoBVIEc2l6ZRonCgtEZWxldGVQ'
    'aG90bxIYCgdwaG90b0lkGAEgASgFUgdwaG90b0lkGkMKDVVwZGF0ZUNhcHRpb24SGAoHY2FwdG'
    'lvbhgBIAEoCVIHY2FwdGlvbhIYCgdwaG90b0lkGAIgASgFUgdwaG90b0lkQgwKCmV2ZW50X3R5'
    'cGU=');

@$core.Deprecated('Use submitAppEventDescriptor instead')
const SubmitAppEvent$json = {
  '1': 'SubmitAppEvent',
  '2': [
    {'1': 'appEvent', '3': 1, '4': 1, '5': 11, '6': '.AppEvent', '10': 'appEvent'},
    {'1': 'siteEvent', '3': 2, '4': 1, '5': 11, '6': '.SubmitAppEvent.SiteEvent', '10': 'siteEvent'},
    {'1': 'authorEmail', '3': 3, '4': 1, '5': 9, '10': 'authorEmail'},
    {'1': 'images', '3': 20, '4': 3, '5': 11, '6': '.SubmitAppEvent.Image', '10': 'images'},
    {'1': 'deletePhotoUrl', '3': 21, '4': 1, '5': 9, '10': 'deletePhotoUrl'},
    {'1': 'photo_urls', '3': 22, '4': 3, '5': 11, '6': '.SubmitAppEvent.PhotoUrlsEntry', '10': 'photoUrls'},
  ],
  '3': [SubmitAppEvent_SiteEvent$json, SubmitAppEvent_Image$json, SubmitAppEvent_PhotoUrlsEntry$json],
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
    {'1': 'size', '3': 4, '4': 1, '5': 5, '10': 'size'},
  ],
};

@$core.Deprecated('Use submitAppEventDescriptor instead')
const SubmitAppEvent_PhotoUrlsEntry$json = {
  '1': 'PhotoUrlsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `SubmitAppEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitAppEventDescriptor = $convert.base64Decode(
    'Cg5TdWJtaXRBcHBFdmVudBIlCghhcHBFdmVudBgBIAEoCzIJLkFwcEV2ZW50UghhcHBFdmVudB'
    'I3CglzaXRlRXZlbnQYAiABKAsyGS5TdWJtaXRBcHBFdmVudC5TaXRlRXZlbnRSCXNpdGVFdmVu'
    'dBIgCgthdXRob3JFbWFpbBgDIAEoCVILYXV0aG9yRW1haWwSLQoGaW1hZ2VzGBQgAygLMhUuU3'
    'VibWl0QXBwRXZlbnQuSW1hZ2VSBmltYWdlcxImCg5kZWxldGVQaG90b1VybBgVIAEoCVIOZGVs'
    'ZXRlUGhvdG9VcmwSPQoKcGhvdG9fdXJscxgWIAMoCzIeLlN1Ym1pdEFwcEV2ZW50LlBob3RvVX'
    'Jsc0VudHJ5UglwaG90b1VybHMaPQoJU2l0ZUV2ZW50EhgKB3ZlcnNpb24YASABKAVSB3ZlcnNp'
    'b24SFgoGYXV0aG9yGAIgASgFUgZhdXRob3IaTwoFSW1hZ2USHgoKYmFzZTY0RGF0YRgBIAEoCV'
    'IKYmFzZTY0RGF0YRISCgRuYW1lGAIgASgJUgRuYW1lEhIKBHNpemUYBCABKAVSBHNpemUaPAoO'
    'UGhvdG9VcmxzRW50cnkSEAoDa2V5GAEgASgFUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOg'
    'I4AQ==');

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

