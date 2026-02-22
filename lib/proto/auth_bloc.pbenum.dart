// This is a generated file - do not edit.
//
// Generated from auth_bloc.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AuthState extends $pb.ProtobufEnum {
  /// transition states (show progress bar)
  static const AuthState initializing =
      AuthState._(0, _omitEnumNames ? '' : 'initializing');
  static const AuthState authenticating =
      AuthState._(1, _omitEnumNames ? '' : 'authenticating');
  static const AuthState registering =
      AuthState._(2, _omitEnumNames ? '' : 'registering');
  static const AuthState submittingEmailVerificationRequest = AuthState._(
      3, _omitEnumNames ? '' : 'submittingEmailVerificationRequest');
  static const AuthState submittingForgottenPasswordRequest = AuthState._(
      4, _omitEnumNames ? '' : 'submittingForgottenPasswordRequest');
  static const AuthState submittingSignOutRequest =
      AuthState._(5, _omitEnumNames ? '' : 'submittingSignOutRequest');
  static const AuthState submittingRemoveAccountRequest =
      AuthState._(6, _omitEnumNames ? '' : 'submittingRemoveAccountRequest');
  static const AuthState loginSuccess =
      AuthState._(7, _omitEnumNames ? '' : 'loginSuccess');

  /// final states (show/push a screen)
  static const AuthState authenticated =
      AuthState._(10, _omitEnumNames ? '' : 'authenticated');
  static const AuthState unauthenticated =
      AuthState._(11, _omitEnumNames ? '' : 'unauthenticated');
  static const AuthState authenticationError =
      AuthState._(12, _omitEnumNames ? '' : 'authenticationError');
  static const AuthState emailVerificationSent =
      AuthState._(13, _omitEnumNames ? '' : 'emailVerificationSent');
  static const AuthState forgottenPasswordEmailSent =
      AuthState._(14, _omitEnumNames ? '' : 'forgottenPasswordEmailSent');

  static const $core.List<AuthState> values = <AuthState>[
    initializing,
    authenticating,
    registering,
    submittingEmailVerificationRequest,
    submittingForgottenPasswordRequest,
    submittingSignOutRequest,
    submittingRemoveAccountRequest,
    loginSuccess,
    authenticated,
    unauthenticated,
    authenticationError,
    emailVerificationSent,
    forgottenPasswordEmailSent,
  ];

  static final $core.List<AuthState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 14);
  static AuthState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AuthState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
