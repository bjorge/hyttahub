//
//  Generated code. Do not modify.
//  source: site_events.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use siteEventDescriptor instead')
const SiteEvent$json = {
  '1': 'SiteEvent',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 5, '10': 'version'},
    {'1': 'author', '3': 2, '4': 1, '5': 5, '10': 'author'},
    {'1': 'newSite', '3': 4, '4': 1, '5': 11, '6': '.SiteEvent.NewSite', '9': 0, '10': 'newSite'},
    {'1': 'addMember', '3': 5, '4': 1, '5': 11, '6': '.SiteEvent.AddMember', '9': 0, '10': 'addMember'},
    {'1': 'updateSiteName', '3': 6, '4': 1, '5': 11, '6': '.SiteEvent.UpdateSiteName', '9': 0, '10': 'updateSiteName'},
    {'1': 'removeMember', '3': 7, '4': 1, '5': 11, '6': '.SiteEvent.RemoveMember', '9': 0, '10': 'removeMember'},
    {'1': 'leaveSite', '3': 8, '4': 1, '5': 11, '6': '.SiteEvent.LeaveSite', '9': 0, '10': 'leaveSite'},
    {'1': 'restoreMember', '3': 9, '4': 1, '5': 11, '6': '.SiteEvent.RestoreMember', '9': 0, '10': 'restoreMember'},
    {'1': 'updateMember', '3': 10, '4': 1, '5': 11, '6': '.SiteEvent.UpdateMember', '9': 0, '10': 'updateMember'},
    {'1': 'exportEvent', '3': 11, '4': 1, '5': 11, '6': '.SiteEvent.ExportEvent', '9': 0, '10': 'exportEvent'},
    {'1': 'importEvent', '3': 12, '4': 1, '5': 11, '6': '.SiteEvent.ImportEvent', '9': 0, '10': 'importEvent'},
    {'1': 'appEvent', '3': 20, '4': 1, '5': 11, '6': '.Any', '9': 0, '10': 'appEvent'},
  ],
  '3': [SiteEvent_NewSite$json, SiteEvent_AddMember$json, SiteEvent_RemoveMember$json, SiteEvent_RestoreMember$json, SiteEvent_UpdateMember$json, SiteEvent_LeaveSite$json, SiteEvent_UpdateSiteName$json, SiteEvent_ExportEvent$json, SiteEvent_ImportEvent$json],
  '8': [
    {'1': 'event_type'},
  ],
};

@$core.Deprecated('Use siteEventDescriptor instead')
const SiteEvent_NewSite$json = {
  '1': 'NewSite',
  '2': [
    {'1': 'siteName', '3': 1, '4': 1, '5': 9, '10': 'siteName'},
    {'1': 'memberName', '3': 2, '4': 1, '5': 9, '10': 'memberName'},
    {'1': 'instance', '3': 3, '4': 1, '5': 9, '10': 'instance'},
  ],
};

@$core.Deprecated('Use siteEventDescriptor instead')
const SiteEvent_AddMember$json = {
  '1': 'AddMember',
  '2': [
    {'1': 'memberName', '3': 1, '4': 1, '5': 9, '10': 'memberName'},
    {'1': 'admin', '3': 2, '4': 1, '5': 8, '10': 'admin'},
  ],
};

@$core.Deprecated('Use siteEventDescriptor instead')
const SiteEvent_RemoveMember$json = {
  '1': 'RemoveMember',
  '2': [
    {'1': 'memberId', '3': 1, '4': 1, '5': 5, '10': 'memberId'},
  ],
};

@$core.Deprecated('Use siteEventDescriptor instead')
const SiteEvent_RestoreMember$json = {
  '1': 'RestoreMember',
  '2': [
    {'1': 'memberId', '3': 1, '4': 1, '5': 5, '10': 'memberId'},
    {'1': 'memberName', '3': 2, '4': 1, '5': 9, '10': 'memberName'},
    {'1': 'admin', '3': 3, '4': 1, '5': 8, '10': 'admin'},
  ],
};

@$core.Deprecated('Use siteEventDescriptor instead')
const SiteEvent_UpdateMember$json = {
  '1': 'UpdateMember',
  '2': [
    {'1': 'memberId', '3': 1, '4': 1, '5': 5, '10': 'memberId'},
    {'1': 'memberName', '3': 2, '4': 1, '5': 9, '10': 'memberName'},
    {'1': 'admin', '3': 3, '4': 1, '5': 8, '10': 'admin'},
  ],
};

@$core.Deprecated('Use siteEventDescriptor instead')
const SiteEvent_LeaveSite$json = {
  '1': 'LeaveSite',
  '2': [
    {'1': 'memberId', '3': 1, '4': 1, '5': 5, '10': 'memberId'},
  ],
};

@$core.Deprecated('Use siteEventDescriptor instead')
const SiteEvent_UpdateSiteName$json = {
  '1': 'UpdateSiteName',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

@$core.Deprecated('Use siteEventDescriptor instead')
const SiteEvent_ExportEvent$json = {
  '1': 'ExportEvent',
  '2': [
    {'1': 'previousSiteId', '3': 1, '4': 1, '5': 9, '10': 'previousSiteId'},
    {'1': 'appId', '3': 2, '4': 1, '5': 9, '10': 'appId'},
    {'1': 'appName', '3': 3, '4': 1, '5': 9, '10': 'appName'},
  ],
};

@$core.Deprecated('Use siteEventDescriptor instead')
const SiteEvent_ImportEvent$json = {
  '1': 'ImportEvent',
  '2': [
    {'1': 'siteName', '3': 1, '4': 1, '5': 9, '10': 'siteName'},
  ],
};

/// Descriptor for `SiteEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List siteEventDescriptor = $convert.base64Decode(
    'CglTaXRlRXZlbnQSGAoHdmVyc2lvbhgBIAEoBVIHdmVyc2lvbhIWCgZhdXRob3IYAiABKAVSBm'
    'F1dGhvchIuCgduZXdTaXRlGAQgASgLMhIuU2l0ZUV2ZW50Lk5ld1NpdGVIAFIHbmV3U2l0ZRI0'
    'CglhZGRNZW1iZXIYBSABKAsyFC5TaXRlRXZlbnQuQWRkTWVtYmVySABSCWFkZE1lbWJlchJDCg'
    '51cGRhdGVTaXRlTmFtZRgGIAEoCzIZLlNpdGVFdmVudC5VcGRhdGVTaXRlTmFtZUgAUg51cGRh'
    'dGVTaXRlTmFtZRI9CgxyZW1vdmVNZW1iZXIYByABKAsyFy5TaXRlRXZlbnQuUmVtb3ZlTWVtYm'
    'VySABSDHJlbW92ZU1lbWJlchI0CglsZWF2ZVNpdGUYCCABKAsyFC5TaXRlRXZlbnQuTGVhdmVT'
    'aXRlSABSCWxlYXZlU2l0ZRJACg1yZXN0b3JlTWVtYmVyGAkgASgLMhguU2l0ZUV2ZW50LlJlc3'
    'RvcmVNZW1iZXJIAFINcmVzdG9yZU1lbWJlchI9Cgx1cGRhdGVNZW1iZXIYCiABKAsyFy5TaXRl'
    'RXZlbnQuVXBkYXRlTWVtYmVySABSDHVwZGF0ZU1lbWJlchI6CgtleHBvcnRFdmVudBgLIAEoCz'
    'IWLlNpdGVFdmVudC5FeHBvcnRFdmVudEgAUgtleHBvcnRFdmVudBI6CgtpbXBvcnRFdmVudBgM'
    'IAEoCzIWLlNpdGVFdmVudC5JbXBvcnRFdmVudEgAUgtpbXBvcnRFdmVudBIiCghhcHBFdmVudB'
    'gUIAEoCzIELkFueUgAUghhcHBFdmVudBphCgdOZXdTaXRlEhoKCHNpdGVOYW1lGAEgASgJUghz'
    'aXRlTmFtZRIeCgptZW1iZXJOYW1lGAIgASgJUgptZW1iZXJOYW1lEhoKCGluc3RhbmNlGAMgAS'
    'gJUghpbnN0YW5jZRpBCglBZGRNZW1iZXISHgoKbWVtYmVyTmFtZRgBIAEoCVIKbWVtYmVyTmFt'
    'ZRIUCgVhZG1pbhgCIAEoCFIFYWRtaW4aKgoMUmVtb3ZlTWVtYmVyEhoKCG1lbWJlcklkGAEgAS'
    'gFUghtZW1iZXJJZBphCg1SZXN0b3JlTWVtYmVyEhoKCG1lbWJlcklkGAEgASgFUghtZW1iZXJJ'
    'ZBIeCgptZW1iZXJOYW1lGAIgASgJUgptZW1iZXJOYW1lEhQKBWFkbWluGAMgASgIUgVhZG1pbh'
    'pgCgxVcGRhdGVNZW1iZXISGgoIbWVtYmVySWQYASABKAVSCG1lbWJlcklkEh4KCm1lbWJlck5h'
    'bWUYAiABKAlSCm1lbWJlck5hbWUSFAoFYWRtaW4YAyABKAhSBWFkbWluGicKCUxlYXZlU2l0ZR'
    'IaCghtZW1iZXJJZBgBIAEoBVIIbWVtYmVySWQaJAoOVXBkYXRlU2l0ZU5hbWUSEgoEbmFtZRgB'
    'IAEoCVIEbmFtZRplCgtFeHBvcnRFdmVudBImCg5wcmV2aW91c1NpdGVJZBgBIAEoCVIOcHJldm'
    'lvdXNTaXRlSWQSFAoFYXBwSWQYAiABKAlSBWFwcElkEhgKB2FwcE5hbWUYAyABKAlSB2FwcE5h'
    'bWUaKQoLSW1wb3J0RXZlbnQSGgoIc2l0ZU5hbWUYASABKAlSCHNpdGVOYW1lQgwKCmV2ZW50X3'
    'R5cGU=');

@$core.Deprecated('Use submitSiteEventDescriptor instead')
const SubmitSiteEvent$json = {
  '1': 'SubmitSiteEvent',
  '2': [
    {'1': 'event', '3': 1, '4': 1, '5': 11, '6': '.SiteEvent', '10': 'event'},
    {'1': 'authorEmail', '3': 2, '4': 1, '5': 9, '10': 'authorEmail'},
    {'1': 'addMemberEmail', '3': 4, '4': 1, '5': 9, '10': 'addMemberEmail'},
    {'1': 'removeMemberEmail', '3': 5, '4': 1, '5': 9, '10': 'removeMemberEmail'},
    {'1': 'updateMemberNewEmail', '3': 6, '4': 1, '5': 9, '10': 'updateMemberNewEmail'},
    {'1': 'updateMemberOriginalEmail', '3': 7, '4': 1, '5': 9, '10': 'updateMemberOriginalEmail'},
  ],
};

/// Descriptor for `SubmitSiteEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitSiteEventDescriptor = $convert.base64Decode(
    'Cg9TdWJtaXRTaXRlRXZlbnQSIAoFZXZlbnQYASABKAsyCi5TaXRlRXZlbnRSBWV2ZW50EiAKC2'
    'F1dGhvckVtYWlsGAIgASgJUgthdXRob3JFbWFpbBImCg5hZGRNZW1iZXJFbWFpbBgEIAEoCVIO'
    'YWRkTWVtYmVyRW1haWwSLAoRcmVtb3ZlTWVtYmVyRW1haWwYBSABKAlSEXJlbW92ZU1lbWJlck'
    'VtYWlsEjIKFHVwZGF0ZU1lbWJlck5ld0VtYWlsGAYgASgJUhR1cGRhdGVNZW1iZXJOZXdFbWFp'
    'bBI8Chl1cGRhdGVNZW1iZXJPcmlnaW5hbEVtYWlsGAcgASgJUhl1cGRhdGVNZW1iZXJPcmlnaW'
    '5hbEVtYWls');

@$core.Deprecated('Use siteEventRecordDescriptor instead')
const SiteEventRecord$json = {
  '1': 'SiteEventRecord',
  '2': [
    {'1': 'isoDate', '3': 1, '4': 1, '5': 9, '10': 'isoDate'},
    {'1': 'version', '3': 2, '4': 1, '5': 5, '10': 'version'},
    {'1': 'siteEvent', '3': 3, '4': 1, '5': 11, '6': '.SiteEvent', '10': 'siteEvent'},
  ],
};

/// Descriptor for `SiteEventRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List siteEventRecordDescriptor = $convert.base64Decode(
    'Cg9TaXRlRXZlbnRSZWNvcmQSGAoHaXNvRGF0ZRgBIAEoCVIHaXNvRGF0ZRIYCgd2ZXJzaW9uGA'
    'IgASgFUgd2ZXJzaW9uEigKCXNpdGVFdmVudBgDIAEoCzIKLlNpdGVFdmVudFIJc2l0ZUV2ZW50');

