//
//  Generated code. Do not modify.
//  source: auth_bloc.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use authStateDescriptor instead')
const AuthState$json = {
  '1': 'AuthState',
  '2': [
    {'1': 'initializing', '2': 0},
    {'1': 'authenticating', '2': 1},
    {'1': 'registering', '2': 2},
    {'1': 'submittingEmailVerificationRequest', '2': 3},
    {'1': 'submittingForgottenPasswordRequest', '2': 4},
    {'1': 'submittingSignOutRequest', '2': 5},
    {'1': 'submittingRemoveAccountRequest', '2': 6},
    {'1': 'loginSuccess', '2': 7},
    {'1': 'authenticated', '2': 10},
    {'1': 'unauthenticated', '2': 11},
    {'1': 'authenticationError', '2': 12},
    {'1': 'emailVerificationSent', '2': 13},
    {'1': 'forgottenPasswordEmailSent', '2': 14},
  ],
};

/// Descriptor for `AuthState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List authStateDescriptor = $convert.base64Decode(
    'CglBdXRoU3RhdGUSEAoMaW5pdGlhbGl6aW5nEAASEgoOYXV0aGVudGljYXRpbmcQARIPCgtyZW'
    'dpc3RlcmluZxACEiYKInN1Ym1pdHRpbmdFbWFpbFZlcmlmaWNhdGlvblJlcXVlc3QQAxImCiJz'
    'dWJtaXR0aW5nRm9yZ290dGVuUGFzc3dvcmRSZXF1ZXN0EAQSHAoYc3VibWl0dGluZ1NpZ25PdX'
    'RSZXF1ZXN0EAUSIgoec3VibWl0dGluZ1JlbW92ZUFjY291bnRSZXF1ZXN0EAYSEAoMbG9naW5T'
    'dWNjZXNzEAcSEQoNYXV0aGVudGljYXRlZBAKEhMKD3VuYXV0aGVudGljYXRlZBALEhcKE2F1dG'
    'hlbnRpY2F0aW9uRXJyb3IQDBIZChVlbWFpbFZlcmlmaWNhdGlvblNlbnQQDRIeChpmb3Jnb3R0'
    'ZW5QYXNzd29yZEVtYWlsU2VudBAO');

@$core.Deprecated('Use authBlocStateDescriptor instead')
const AuthBlocState$json = {
  '1': 'AuthBlocState',
  '2': [
    {'1': 'authState', '3': 1, '4': 1, '5': 14, '6': '.AuthState', '10': 'authState'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'errorMessage', '3': 3, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'isServiceAdmin', '3': 4, '4': 1, '5': 8, '10': 'isServiceAdmin'},
  ],
};

/// Descriptor for `AuthBlocState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authBlocStateDescriptor = $convert.base64Decode(
    'Cg1BdXRoQmxvY1N0YXRlEigKCWF1dGhTdGF0ZRgBIAEoDjIKLkF1dGhTdGF0ZVIJYXV0aFN0YX'
    'RlEhQKBWVtYWlsGAIgASgJUgVlbWFpbBIiCgxlcnJvck1lc3NhZ2UYAyABKAlSDGVycm9yTWVz'
    'c2FnZRImCg5pc1NlcnZpY2VBZG1pbhgEIAEoCFIOaXNTZXJ2aWNlQWRtaW4=');

@$core.Deprecated('Use authBlocEventDescriptor instead')
const AuthBlocEvent$json = {
  '1': 'AuthBlocEvent',
  '2': [
    {'1': 'emailLogin', '3': 1, '4': 1, '5': 11, '6': '.AuthBlocEvent.EmailLogin', '9': 0, '10': 'emailLogin'},
    {'1': 'emailSignup', '3': 2, '4': 1, '5': 11, '6': '.AuthBlocEvent.EmailSignup', '9': 0, '10': 'emailSignup'},
    {'1': 'emailForgotPassword', '3': 3, '4': 1, '5': 11, '6': '.AuthBlocEvent.EmailForgotPassword', '9': 0, '10': 'emailForgotPassword'},
    {'1': 'logout', '3': 4, '4': 1, '5': 11, '6': '.AuthBlocEvent.Logout', '9': 0, '10': 'logout'},
    {'1': 'startup', '3': 5, '4': 1, '5': 11, '6': '.AuthBlocEvent.AppStartup', '9': 0, '10': 'startup'},
    {'1': 'removeAccount', '3': 6, '4': 1, '5': 11, '6': '.AuthBlocEvent.RemoveAccount', '9': 0, '10': 'removeAccount'},
  ],
  '3': [AuthBlocEvent_AppStartup$json, AuthBlocEvent_EmailLogin$json, AuthBlocEvent_EmailSignup$json, AuthBlocEvent_EmailForgotPassword$json, AuthBlocEvent_Logout$json, AuthBlocEvent_RemoveAccount$json],
  '8': [
    {'1': 'eventType'},
  ],
};

@$core.Deprecated('Use authBlocEventDescriptor instead')
const AuthBlocEvent_AppStartup$json = {
  '1': 'AppStartup',
};

@$core.Deprecated('Use authBlocEventDescriptor instead')
const AuthBlocEvent_EmailLogin$json = {
  '1': 'EmailLogin',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    {'1': 'language', '3': 3, '4': 1, '5': 9, '10': 'language'},
    {'1': 'serviceAdmin', '3': 4, '4': 1, '5': 8, '10': 'serviceAdmin'},
  ],
};

@$core.Deprecated('Use authBlocEventDescriptor instead')
const AuthBlocEvent_EmailSignup$json = {
  '1': 'EmailSignup',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    {'1': 'termsVersion', '3': 4, '4': 1, '5': 5, '10': 'termsVersion'},
    {'1': 'privacyVersion', '3': 6, '4': 1, '5': 5, '10': 'privacyVersion'},
    {'1': 'language', '3': 7, '4': 1, '5': 9, '10': 'language'},
    {'1': 'serviceAdmin', '3': 8, '4': 1, '5': 8, '10': 'serviceAdmin'},
  ],
};

@$core.Deprecated('Use authBlocEventDescriptor instead')
const AuthBlocEvent_EmailForgotPassword$json = {
  '1': 'EmailForgotPassword',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'language', '3': 2, '4': 1, '5': 9, '10': 'language'},
  ],
};

@$core.Deprecated('Use authBlocEventDescriptor instead')
const AuthBlocEvent_Logout$json = {
  '1': 'Logout',
};

@$core.Deprecated('Use authBlocEventDescriptor instead')
const AuthBlocEvent_RemoveAccount$json = {
  '1': 'RemoveAccount',
};

/// Descriptor for `AuthBlocEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authBlocEventDescriptor = $convert.base64Decode(
    'Cg1BdXRoQmxvY0V2ZW50EjsKCmVtYWlsTG9naW4YASABKAsyGS5BdXRoQmxvY0V2ZW50LkVtYW'
    'lsTG9naW5IAFIKZW1haWxMb2dpbhI+CgtlbWFpbFNpZ251cBgCIAEoCzIaLkF1dGhCbG9jRXZl'
    'bnQuRW1haWxTaWdudXBIAFILZW1haWxTaWdudXASVgoTZW1haWxGb3Jnb3RQYXNzd29yZBgDIA'
    'EoCzIiLkF1dGhCbG9jRXZlbnQuRW1haWxGb3Jnb3RQYXNzd29yZEgAUhNlbWFpbEZvcmdvdFBh'
    'c3N3b3JkEi8KBmxvZ291dBgEIAEoCzIVLkF1dGhCbG9jRXZlbnQuTG9nb3V0SABSBmxvZ291dB'
    'I1CgdzdGFydHVwGAUgASgLMhkuQXV0aEJsb2NFdmVudC5BcHBTdGFydHVwSABSB3N0YXJ0dXAS'
    'RAoNcmVtb3ZlQWNjb3VudBgGIAEoCzIcLkF1dGhCbG9jRXZlbnQuUmVtb3ZlQWNjb3VudEgAUg'
    '1yZW1vdmVBY2NvdW50GgwKCkFwcFN0YXJ0dXAafgoKRW1haWxMb2dpbhIUCgVlbWFpbBgBIAEo'
    'CVIFZW1haWwSGgoIcGFzc3dvcmQYAiABKAlSCHBhc3N3b3JkEhoKCGxhbmd1YWdlGAMgASgJUg'
    'hsYW5ndWFnZRIiCgxzZXJ2aWNlQWRtaW4YBCABKAhSDHNlcnZpY2VBZG1pbhrLAQoLRW1haWxT'
    'aWdudXASFAoFZW1haWwYASABKAlSBWVtYWlsEhoKCHBhc3N3b3JkGAIgASgJUghwYXNzd29yZB'
    'IiCgx0ZXJtc1ZlcnNpb24YBCABKAVSDHRlcm1zVmVyc2lvbhImCg5wcml2YWN5VmVyc2lvbhgG'
    'IAEoBVIOcHJpdmFjeVZlcnNpb24SGgoIbGFuZ3VhZ2UYByABKAlSCGxhbmd1YWdlEiIKDHNlcn'
    'ZpY2VBZG1pbhgIIAEoCFIMc2VydmljZUFkbWluGkcKE0VtYWlsRm9yZ290UGFzc3dvcmQSFAoF'
    'ZW1haWwYASABKAlSBWVtYWlsEhoKCGxhbmd1YWdlGAIgASgJUghsYW5ndWFnZRoICgZMb2dvdX'
    'QaDwoNUmVtb3ZlQWNjb3VudEILCglldmVudFR5cGU=');

