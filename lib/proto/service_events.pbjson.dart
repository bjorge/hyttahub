//
//  Generated code. Do not modify.
//  source: service_events.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use serviceEventDescriptor instead')
const ServiceEvent$json = {
  '1': 'ServiceEvent',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 5, '10': 'version'},
    {'1': 'author', '3': 2, '4': 1, '5': 5, '10': 'author'},
    {'1': 'initialEvent', '3': 3, '4': 1, '5': 11, '6': '.ServiceEvent.InitialEvent', '9': 0, '10': 'initialEvent'},
    {'1': 'serviceStatus', '3': 4, '4': 1, '5': 11, '6': '.ServiceEvent.ServiceStatus', '9': 0, '10': 'serviceStatus'},
    {'1': 'terms', '3': 5, '4': 1, '5': 11, '6': '.ServiceEvent.TermsOfService', '9': 0, '10': 'terms'},
    {'1': 'privacy', '3': 6, '4': 1, '5': 11, '6': '.ServiceEvent.PrivacyPolicy', '9': 0, '10': 'privacy'},
    {'1': 'addServiceAdmin', '3': 7, '4': 1, '5': 11, '6': '.ServiceEvent.AddServiceAdmin', '9': 0, '10': 'addServiceAdmin'},
    {'1': 'removeServiceAdmin', '3': 8, '4': 1, '5': 11, '6': '.ServiceEvent.RemoveServiceAdmin', '9': 0, '10': 'removeServiceAdmin'},
    {'1': 'minVersion', '3': 9, '4': 1, '5': 11, '6': '.ServiceEvent.MinimumVersionRequired', '9': 0, '10': 'minVersion'},
    {'1': 'betaUsersFilter', '3': 10, '4': 1, '5': 11, '6': '.BloomFilter', '9': 0, '10': 'betaUsersFilter'},
    {'1': 'updateServiceAdmin', '3': 11, '4': 1, '5': 11, '6': '.ServiceEvent.UpdateServiceAdmin', '9': 0, '10': 'updateServiceAdmin'},
    {'1': 'restoreServiceAdmin', '3': 12, '4': 1, '5': 11, '6': '.ServiceEvent.RestoreServiceAdmin', '9': 0, '10': 'restoreServiceAdmin'},
  ],
  '3': [ServiceEvent_InitialEvent$json, ServiceEvent_ServiceStatus$json, ServiceEvent_TermsOfService$json, ServiceEvent_PrivacyPolicy$json, ServiceEvent_AddServiceAdmin$json, ServiceEvent_RemoveServiceAdmin$json, ServiceEvent_UpdateServiceAdmin$json, ServiceEvent_RestoreServiceAdmin$json, ServiceEvent_MinimumVersionRequired$json],
  '8': [
    {'1': 'event_type'},
  ],
};

@$core.Deprecated('Use serviceEventDescriptor instead')
const ServiceEvent_InitialEvent$json = {
  '1': 'InitialEvent',
  '2': [
    {'1': 'instance', '3': 1, '4': 1, '5': 9, '10': 'instance'},
    {'1': 'alias', '3': 2, '4': 1, '5': 9, '10': 'alias'},
    {'1': 'filter', '3': 3, '4': 1, '5': 11, '6': '.BloomFilter', '10': 'filter'},
    {'1': 'appName', '3': 4, '4': 1, '5': 9, '10': 'appName'},
    {'1': 'appId', '3': 5, '4': 1, '5': 9, '10': 'appId'},
  ],
};

@$core.Deprecated('Use serviceEventDescriptor instead')
const ServiceEvent_ServiceStatus$json = {
  '1': 'ServiceStatus',
  '2': [
    {'1': 'unavailable', '3': 1, '4': 1, '5': 8, '10': 'unavailable'},
  ],
};

@$core.Deprecated('Use serviceEventDescriptor instead')
const ServiceEvent_TermsOfService$json = {
  '1': 'TermsOfService',
  '2': [
    {'1': 'content', '3': 1, '4': 1, '5': 9, '10': 'content'},
  ],
};

@$core.Deprecated('Use serviceEventDescriptor instead')
const ServiceEvent_PrivacyPolicy$json = {
  '1': 'PrivacyPolicy',
  '2': [
    {'1': 'content', '3': 1, '4': 1, '5': 9, '10': 'content'},
  ],
};

@$core.Deprecated('Use serviceEventDescriptor instead')
const ServiceEvent_AddServiceAdmin$json = {
  '1': 'AddServiceAdmin',
  '2': [
    {'1': 'alias', '3': 1, '4': 1, '5': 9, '10': 'alias'},
    {'1': 'filter', '3': 2, '4': 1, '5': 11, '6': '.BloomFilter', '10': 'filter'},
  ],
};

@$core.Deprecated('Use serviceEventDescriptor instead')
const ServiceEvent_RemoveServiceAdmin$json = {
  '1': 'RemoveServiceAdmin',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'filter', '3': 2, '4': 1, '5': 11, '6': '.BloomFilter', '10': 'filter'},
  ],
};

@$core.Deprecated('Use serviceEventDescriptor instead')
const ServiceEvent_UpdateServiceAdmin$json = {
  '1': 'UpdateServiceAdmin',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'alias', '3': 2, '4': 1, '5': 9, '10': 'alias'},
    {'1': 'filter', '3': 3, '4': 1, '5': 11, '6': '.BloomFilter', '10': 'filter'},
  ],
};

@$core.Deprecated('Use serviceEventDescriptor instead')
const ServiceEvent_RestoreServiceAdmin$json = {
  '1': 'RestoreServiceAdmin',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'alias', '3': 2, '4': 1, '5': 9, '10': 'alias'},
    {'1': 'filter', '3': 3, '4': 1, '5': 11, '6': '.BloomFilter', '10': 'filter'},
  ],
};

@$core.Deprecated('Use serviceEventDescriptor instead')
const ServiceEvent_MinimumVersionRequired$json = {
  '1': 'MinimumVersionRequired',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 5, '10': 'value'},
  ],
};

/// Descriptor for `ServiceEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceEventDescriptor = $convert.base64Decode(
    'CgxTZXJ2aWNlRXZlbnQSGAoHdmVyc2lvbhgBIAEoBVIHdmVyc2lvbhIWCgZhdXRob3IYAiABKA'
    'VSBmF1dGhvchJACgxpbml0aWFsRXZlbnQYAyABKAsyGi5TZXJ2aWNlRXZlbnQuSW5pdGlhbEV2'
    'ZW50SABSDGluaXRpYWxFdmVudBJDCg1zZXJ2aWNlU3RhdHVzGAQgASgLMhsuU2VydmljZUV2ZW'
    '50LlNlcnZpY2VTdGF0dXNIAFINc2VydmljZVN0YXR1cxI0CgV0ZXJtcxgFIAEoCzIcLlNlcnZp'
    'Y2VFdmVudC5UZXJtc09mU2VydmljZUgAUgV0ZXJtcxI3Cgdwcml2YWN5GAYgASgLMhsuU2Vydm'
    'ljZUV2ZW50LlByaXZhY3lQb2xpY3lIAFIHcHJpdmFjeRJJCg9hZGRTZXJ2aWNlQWRtaW4YByAB'
    'KAsyHS5TZXJ2aWNlRXZlbnQuQWRkU2VydmljZUFkbWluSABSD2FkZFNlcnZpY2VBZG1pbhJSCh'
    'JyZW1vdmVTZXJ2aWNlQWRtaW4YCCABKAsyIC5TZXJ2aWNlRXZlbnQuUmVtb3ZlU2VydmljZUFk'
    'bWluSABSEnJlbW92ZVNlcnZpY2VBZG1pbhJGCgptaW5WZXJzaW9uGAkgASgLMiQuU2VydmljZU'
    'V2ZW50Lk1pbmltdW1WZXJzaW9uUmVxdWlyZWRIAFIKbWluVmVyc2lvbhI4Cg9iZXRhVXNlcnNG'
    'aWx0ZXIYCiABKAsyDC5CbG9vbUZpbHRlckgAUg9iZXRhVXNlcnNGaWx0ZXISUgoSdXBkYXRlU2'
    'VydmljZUFkbWluGAsgASgLMiAuU2VydmljZUV2ZW50LlVwZGF0ZVNlcnZpY2VBZG1pbkgAUhJ1'
    'cGRhdGVTZXJ2aWNlQWRtaW4SVQoTcmVzdG9yZVNlcnZpY2VBZG1pbhgMIAEoCzIhLlNlcnZpY2'
    'VFdmVudC5SZXN0b3JlU2VydmljZUFkbWluSABSE3Jlc3RvcmVTZXJ2aWNlQWRtaW4algEKDElu'
    'aXRpYWxFdmVudBIaCghpbnN0YW5jZRgBIAEoCVIIaW5zdGFuY2USFAoFYWxpYXMYAiABKAlSBW'
    'FsaWFzEiQKBmZpbHRlchgDIAEoCzIMLkJsb29tRmlsdGVyUgZmaWx0ZXISGAoHYXBwTmFtZRgE'
    'IAEoCVIHYXBwTmFtZRIUCgVhcHBJZBgFIAEoCVIFYXBwSWQaMQoNU2VydmljZVN0YXR1cxIgCg'
    't1bmF2YWlsYWJsZRgBIAEoCFILdW5hdmFpbGFibGUaKgoOVGVybXNPZlNlcnZpY2USGAoHY29u'
    'dGVudBgBIAEoCVIHY29udGVudBopCg1Qcml2YWN5UG9saWN5EhgKB2NvbnRlbnQYASABKAlSB2'
    'NvbnRlbnQaTQoPQWRkU2VydmljZUFkbWluEhQKBWFsaWFzGAEgASgJUgVhbGlhcxIkCgZmaWx0'
    'ZXIYAiABKAsyDC5CbG9vbUZpbHRlclIGZmlsdGVyGkoKElJlbW92ZVNlcnZpY2VBZG1pbhIOCg'
    'JpZBgBIAEoBVICaWQSJAoGZmlsdGVyGAIgASgLMgwuQmxvb21GaWx0ZXJSBmZpbHRlchpgChJV'
    'cGRhdGVTZXJ2aWNlQWRtaW4SDgoCaWQYASABKAVSAmlkEhQKBWFsaWFzGAIgASgJUgVhbGlhcx'
    'IkCgZmaWx0ZXIYAyABKAsyDC5CbG9vbUZpbHRlclIGZmlsdGVyGmEKE1Jlc3RvcmVTZXJ2aWNl'
    'QWRtaW4SDgoCaWQYASABKAVSAmlkEhQKBWFsaWFzGAIgASgJUgVhbGlhcxIkCgZmaWx0ZXIYAy'
    'ABKAsyDC5CbG9vbUZpbHRlclIGZmlsdGVyGi4KFk1pbmltdW1WZXJzaW9uUmVxdWlyZWQSFAoF'
    'dmFsdWUYASABKAVSBXZhbHVlQgwKCmV2ZW50X3R5cGU=');

@$core.Deprecated('Use submitServiceEventDescriptor instead')
const SubmitServiceEvent$json = {
  '1': 'SubmitServiceEvent',
  '2': [
    {'1': 'event', '3': 1, '4': 1, '5': 11, '6': '.ServiceEvent', '10': 'event'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'betaUsers', '3': 3, '4': 1, '5': 9, '10': 'betaUsers'},
    {'1': 'addServiceAdminEmail', '3': 4, '4': 1, '5': 9, '10': 'addServiceAdminEmail'},
    {'1': 'updateServiceAdminOriginalEmail', '3': 5, '4': 1, '5': 9, '10': 'updateServiceAdminOriginalEmail'},
    {'1': 'updateServiceAdminNewEmail', '3': 6, '4': 1, '5': 9, '10': 'updateServiceAdminNewEmail'},
    {'1': 'removeServiceAdminEmail', '3': 7, '4': 1, '5': 9, '10': 'removeServiceAdminEmail'},
  ],
};

/// Descriptor for `SubmitServiceEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitServiceEventDescriptor = $convert.base64Decode(
    'ChJTdWJtaXRTZXJ2aWNlRXZlbnQSIwoFZXZlbnQYASABKAsyDS5TZXJ2aWNlRXZlbnRSBWV2ZW'
    '50EhQKBWVtYWlsGAIgASgJUgVlbWFpbBIcCgliZXRhVXNlcnMYAyABKAlSCWJldGFVc2VycxIy'
    'ChRhZGRTZXJ2aWNlQWRtaW5FbWFpbBgEIAEoCVIUYWRkU2VydmljZUFkbWluRW1haWwSSAofdX'
    'BkYXRlU2VydmljZUFkbWluT3JpZ2luYWxFbWFpbBgFIAEoCVIfdXBkYXRlU2VydmljZUFkbWlu'
    'T3JpZ2luYWxFbWFpbBI+Chp1cGRhdGVTZXJ2aWNlQWRtaW5OZXdFbWFpbBgGIAEoCVIadXBkYX'
    'RlU2VydmljZUFkbWluTmV3RW1haWwSOAoXcmVtb3ZlU2VydmljZUFkbWluRW1haWwYByABKAlS'
    'F3JlbW92ZVNlcnZpY2VBZG1pbkVtYWls');

@$core.Deprecated('Use serviceEventRecordDescriptor instead')
const ServiceEventRecord$json = {
  '1': 'ServiceEventRecord',
  '2': [
    {'1': 'isoDate', '3': 1, '4': 1, '5': 9, '10': 'isoDate'},
    {'1': 'version', '3': 2, '4': 1, '5': 5, '10': 'version'},
    {'1': 'serviceEvent', '3': 3, '4': 1, '5': 11, '6': '.ServiceEvent', '10': 'serviceEvent'},
  ],
};

/// Descriptor for `ServiceEventRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceEventRecordDescriptor = $convert.base64Decode(
    'ChJTZXJ2aWNlRXZlbnRSZWNvcmQSGAoHaXNvRGF0ZRgBIAEoCVIHaXNvRGF0ZRIYCgd2ZXJzaW'
    '9uGAIgASgFUgd2ZXJzaW9uEjEKDHNlcnZpY2VFdmVudBgDIAEoCzINLlNlcnZpY2VFdmVudFIM'
    'c2VydmljZUV2ZW50');

