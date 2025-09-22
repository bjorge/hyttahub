//
//  Generated code. Do not modify.
//  source: auth_bloc.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'auth_bloc.pbenum.dart';

export 'auth_bloc.pbenum.dart';

class AuthBlocState extends $pb.GeneratedMessage {
  factory AuthBlocState({
    AuthState? authState,
    $core.String? email,
    $core.String? errorMessage,
    $core.bool? isServiceAdmin,
  }) {
    final $result = create();
    if (authState != null) {
      $result.authState = authState;
    }
    if (email != null) {
      $result.email = email;
    }
    if (errorMessage != null) {
      $result.errorMessage = errorMessage;
    }
    if (isServiceAdmin != null) {
      $result.isServiceAdmin = isServiceAdmin;
    }
    return $result;
  }
  AuthBlocState._() : super();
  factory AuthBlocState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthBlocState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthBlocState', createEmptyInstance: create)
    ..e<AuthState>(1, _omitFieldNames ? '' : 'authState', $pb.PbFieldType.OE, protoName: 'authState', defaultOrMaker: AuthState.initializing, valueOf: AuthState.valueOf, enumValues: AuthState.values)
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..aOS(3, _omitFieldNames ? '' : 'errorMessage', protoName: 'errorMessage')
    ..aOB(4, _omitFieldNames ? '' : 'isServiceAdmin', protoName: 'isServiceAdmin')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AuthBlocState clone() => AuthBlocState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AuthBlocState copyWith(void Function(AuthBlocState) updates) => super.copyWith((message) => updates(message as AuthBlocState)) as AuthBlocState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthBlocState create() => AuthBlocState._();
  AuthBlocState createEmptyInstance() => create();
  static $pb.PbList<AuthBlocState> createRepeated() => $pb.PbList<AuthBlocState>();
  @$core.pragma('dart2js:noInline')
  static AuthBlocState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthBlocState>(create);
  static AuthBlocState? _defaultInstance;

  @$pb.TagNumber(1)
  AuthState get authState => $_getN(0);
  @$pb.TagNumber(1)
  set authState(AuthState v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAuthState() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthState() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get errorMessage => $_getSZ(2);
  @$pb.TagNumber(3)
  set errorMessage($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasErrorMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorMessage() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isServiceAdmin => $_getBF(3);
  @$pb.TagNumber(4)
  set isServiceAdmin($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIsServiceAdmin() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsServiceAdmin() => clearField(4);
}

class AuthBlocEvent_AppStartup extends $pb.GeneratedMessage {
  factory AuthBlocEvent_AppStartup() => create();
  AuthBlocEvent_AppStartup._() : super();
  factory AuthBlocEvent_AppStartup.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthBlocEvent_AppStartup.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthBlocEvent.AppStartup', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AuthBlocEvent_AppStartup clone() => AuthBlocEvent_AppStartup()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AuthBlocEvent_AppStartup copyWith(void Function(AuthBlocEvent_AppStartup) updates) => super.copyWith((message) => updates(message as AuthBlocEvent_AppStartup)) as AuthBlocEvent_AppStartup;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthBlocEvent_AppStartup create() => AuthBlocEvent_AppStartup._();
  AuthBlocEvent_AppStartup createEmptyInstance() => create();
  static $pb.PbList<AuthBlocEvent_AppStartup> createRepeated() => $pb.PbList<AuthBlocEvent_AppStartup>();
  @$core.pragma('dart2js:noInline')
  static AuthBlocEvent_AppStartup getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthBlocEvent_AppStartup>(create);
  static AuthBlocEvent_AppStartup? _defaultInstance;
}

class AuthBlocEvent_EmailLogin extends $pb.GeneratedMessage {
  factory AuthBlocEvent_EmailLogin({
    $core.String? email,
    $core.String? password,
    $core.String? language,
    $core.bool? serviceAdmin,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (password != null) {
      $result.password = password;
    }
    if (language != null) {
      $result.language = language;
    }
    if (serviceAdmin != null) {
      $result.serviceAdmin = serviceAdmin;
    }
    return $result;
  }
  AuthBlocEvent_EmailLogin._() : super();
  factory AuthBlocEvent_EmailLogin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthBlocEvent_EmailLogin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthBlocEvent.EmailLogin', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..aOS(3, _omitFieldNames ? '' : 'language')
    ..aOB(4, _omitFieldNames ? '' : 'serviceAdmin', protoName: 'serviceAdmin')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AuthBlocEvent_EmailLogin clone() => AuthBlocEvent_EmailLogin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AuthBlocEvent_EmailLogin copyWith(void Function(AuthBlocEvent_EmailLogin) updates) => super.copyWith((message) => updates(message as AuthBlocEvent_EmailLogin)) as AuthBlocEvent_EmailLogin;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthBlocEvent_EmailLogin create() => AuthBlocEvent_EmailLogin._();
  AuthBlocEvent_EmailLogin createEmptyInstance() => create();
  static $pb.PbList<AuthBlocEvent_EmailLogin> createRepeated() => $pb.PbList<AuthBlocEvent_EmailLogin>();
  @$core.pragma('dart2js:noInline')
  static AuthBlocEvent_EmailLogin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthBlocEvent_EmailLogin>(create);
  static AuthBlocEvent_EmailLogin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get language => $_getSZ(2);
  @$pb.TagNumber(3)
  set language($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLanguage() => $_has(2);
  @$pb.TagNumber(3)
  void clearLanguage() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get serviceAdmin => $_getBF(3);
  @$pb.TagNumber(4)
  set serviceAdmin($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasServiceAdmin() => $_has(3);
  @$pb.TagNumber(4)
  void clearServiceAdmin() => clearField(4);
}

class AuthBlocEvent_EmailSignup extends $pb.GeneratedMessage {
  factory AuthBlocEvent_EmailSignup({
    $core.String? email,
    $core.String? password,
    $core.int? termsVersion,
    $core.int? privacyVersion,
    $core.String? language,
    $core.bool? serviceAdmin,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (password != null) {
      $result.password = password;
    }
    if (termsVersion != null) {
      $result.termsVersion = termsVersion;
    }
    if (privacyVersion != null) {
      $result.privacyVersion = privacyVersion;
    }
    if (language != null) {
      $result.language = language;
    }
    if (serviceAdmin != null) {
      $result.serviceAdmin = serviceAdmin;
    }
    return $result;
  }
  AuthBlocEvent_EmailSignup._() : super();
  factory AuthBlocEvent_EmailSignup.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthBlocEvent_EmailSignup.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthBlocEvent.EmailSignup', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'termsVersion', $pb.PbFieldType.O3, protoName: 'termsVersion')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'privacyVersion', $pb.PbFieldType.O3, protoName: 'privacyVersion')
    ..aOS(7, _omitFieldNames ? '' : 'language')
    ..aOB(8, _omitFieldNames ? '' : 'serviceAdmin', protoName: 'serviceAdmin')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AuthBlocEvent_EmailSignup clone() => AuthBlocEvent_EmailSignup()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AuthBlocEvent_EmailSignup copyWith(void Function(AuthBlocEvent_EmailSignup) updates) => super.copyWith((message) => updates(message as AuthBlocEvent_EmailSignup)) as AuthBlocEvent_EmailSignup;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthBlocEvent_EmailSignup create() => AuthBlocEvent_EmailSignup._();
  AuthBlocEvent_EmailSignup createEmptyInstance() => create();
  static $pb.PbList<AuthBlocEvent_EmailSignup> createRepeated() => $pb.PbList<AuthBlocEvent_EmailSignup>();
  @$core.pragma('dart2js:noInline')
  static AuthBlocEvent_EmailSignup getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthBlocEvent_EmailSignup>(create);
  static AuthBlocEvent_EmailSignup? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => clearField(2);

  /// string terms = 3;
  @$pb.TagNumber(4)
  $core.int get termsVersion => $_getIZ(2);
  @$pb.TagNumber(4)
  set termsVersion($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasTermsVersion() => $_has(2);
  @$pb.TagNumber(4)
  void clearTermsVersion() => clearField(4);

  /// string privacy = 5;
  @$pb.TagNumber(6)
  $core.int get privacyVersion => $_getIZ(3);
  @$pb.TagNumber(6)
  set privacyVersion($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(6)
  $core.bool hasPrivacyVersion() => $_has(3);
  @$pb.TagNumber(6)
  void clearPrivacyVersion() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get language => $_getSZ(4);
  @$pb.TagNumber(7)
  set language($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(7)
  $core.bool hasLanguage() => $_has(4);
  @$pb.TagNumber(7)
  void clearLanguage() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get serviceAdmin => $_getBF(5);
  @$pb.TagNumber(8)
  set serviceAdmin($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(8)
  $core.bool hasServiceAdmin() => $_has(5);
  @$pb.TagNumber(8)
  void clearServiceAdmin() => clearField(8);
}

class AuthBlocEvent_EmailForgotPassword extends $pb.GeneratedMessage {
  factory AuthBlocEvent_EmailForgotPassword({
    $core.String? email,
    $core.String? language,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (language != null) {
      $result.language = language;
    }
    return $result;
  }
  AuthBlocEvent_EmailForgotPassword._() : super();
  factory AuthBlocEvent_EmailForgotPassword.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthBlocEvent_EmailForgotPassword.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthBlocEvent.EmailForgotPassword', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'language')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AuthBlocEvent_EmailForgotPassword clone() => AuthBlocEvent_EmailForgotPassword()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AuthBlocEvent_EmailForgotPassword copyWith(void Function(AuthBlocEvent_EmailForgotPassword) updates) => super.copyWith((message) => updates(message as AuthBlocEvent_EmailForgotPassword)) as AuthBlocEvent_EmailForgotPassword;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthBlocEvent_EmailForgotPassword create() => AuthBlocEvent_EmailForgotPassword._();
  AuthBlocEvent_EmailForgotPassword createEmptyInstance() => create();
  static $pb.PbList<AuthBlocEvent_EmailForgotPassword> createRepeated() => $pb.PbList<AuthBlocEvent_EmailForgotPassword>();
  @$core.pragma('dart2js:noInline')
  static AuthBlocEvent_EmailForgotPassword getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthBlocEvent_EmailForgotPassword>(create);
  static AuthBlocEvent_EmailForgotPassword? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get language => $_getSZ(1);
  @$pb.TagNumber(2)
  set language($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLanguage() => $_has(1);
  @$pb.TagNumber(2)
  void clearLanguage() => clearField(2);
}

class AuthBlocEvent_Logout extends $pb.GeneratedMessage {
  factory AuthBlocEvent_Logout() => create();
  AuthBlocEvent_Logout._() : super();
  factory AuthBlocEvent_Logout.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthBlocEvent_Logout.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthBlocEvent.Logout', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AuthBlocEvent_Logout clone() => AuthBlocEvent_Logout()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AuthBlocEvent_Logout copyWith(void Function(AuthBlocEvent_Logout) updates) => super.copyWith((message) => updates(message as AuthBlocEvent_Logout)) as AuthBlocEvent_Logout;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthBlocEvent_Logout create() => AuthBlocEvent_Logout._();
  AuthBlocEvent_Logout createEmptyInstance() => create();
  static $pb.PbList<AuthBlocEvent_Logout> createRepeated() => $pb.PbList<AuthBlocEvent_Logout>();
  @$core.pragma('dart2js:noInline')
  static AuthBlocEvent_Logout getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthBlocEvent_Logout>(create);
  static AuthBlocEvent_Logout? _defaultInstance;
}

class AuthBlocEvent_RemoveAccount extends $pb.GeneratedMessage {
  factory AuthBlocEvent_RemoveAccount() => create();
  AuthBlocEvent_RemoveAccount._() : super();
  factory AuthBlocEvent_RemoveAccount.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthBlocEvent_RemoveAccount.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthBlocEvent.RemoveAccount', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AuthBlocEvent_RemoveAccount clone() => AuthBlocEvent_RemoveAccount()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AuthBlocEvent_RemoveAccount copyWith(void Function(AuthBlocEvent_RemoveAccount) updates) => super.copyWith((message) => updates(message as AuthBlocEvent_RemoveAccount)) as AuthBlocEvent_RemoveAccount;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthBlocEvent_RemoveAccount create() => AuthBlocEvent_RemoveAccount._();
  AuthBlocEvent_RemoveAccount createEmptyInstance() => create();
  static $pb.PbList<AuthBlocEvent_RemoveAccount> createRepeated() => $pb.PbList<AuthBlocEvent_RemoveAccount>();
  @$core.pragma('dart2js:noInline')
  static AuthBlocEvent_RemoveAccount getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthBlocEvent_RemoveAccount>(create);
  static AuthBlocEvent_RemoveAccount? _defaultInstance;
}

enum AuthBlocEvent_EventType {
  emailLogin, 
  emailSignup, 
  emailForgotPassword, 
  logout, 
  startup, 
  removeAccount, 
  notSet
}

class AuthBlocEvent extends $pb.GeneratedMessage {
  factory AuthBlocEvent({
    AuthBlocEvent_EmailLogin? emailLogin,
    AuthBlocEvent_EmailSignup? emailSignup,
    AuthBlocEvent_EmailForgotPassword? emailForgotPassword,
    AuthBlocEvent_Logout? logout,
    AuthBlocEvent_AppStartup? startup,
    AuthBlocEvent_RemoveAccount? removeAccount,
  }) {
    final $result = create();
    if (emailLogin != null) {
      $result.emailLogin = emailLogin;
    }
    if (emailSignup != null) {
      $result.emailSignup = emailSignup;
    }
    if (emailForgotPassword != null) {
      $result.emailForgotPassword = emailForgotPassword;
    }
    if (logout != null) {
      $result.logout = logout;
    }
    if (startup != null) {
      $result.startup = startup;
    }
    if (removeAccount != null) {
      $result.removeAccount = removeAccount;
    }
    return $result;
  }
  AuthBlocEvent._() : super();
  factory AuthBlocEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthBlocEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, AuthBlocEvent_EventType> _AuthBlocEvent_EventTypeByTag = {
    1 : AuthBlocEvent_EventType.emailLogin,
    2 : AuthBlocEvent_EventType.emailSignup,
    3 : AuthBlocEvent_EventType.emailForgotPassword,
    4 : AuthBlocEvent_EventType.logout,
    5 : AuthBlocEvent_EventType.startup,
    6 : AuthBlocEvent_EventType.removeAccount,
    0 : AuthBlocEvent_EventType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthBlocEvent', createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6])
    ..aOM<AuthBlocEvent_EmailLogin>(1, _omitFieldNames ? '' : 'emailLogin', protoName: 'emailLogin', subBuilder: AuthBlocEvent_EmailLogin.create)
    ..aOM<AuthBlocEvent_EmailSignup>(2, _omitFieldNames ? '' : 'emailSignup', protoName: 'emailSignup', subBuilder: AuthBlocEvent_EmailSignup.create)
    ..aOM<AuthBlocEvent_EmailForgotPassword>(3, _omitFieldNames ? '' : 'emailForgotPassword', protoName: 'emailForgotPassword', subBuilder: AuthBlocEvent_EmailForgotPassword.create)
    ..aOM<AuthBlocEvent_Logout>(4, _omitFieldNames ? '' : 'logout', subBuilder: AuthBlocEvent_Logout.create)
    ..aOM<AuthBlocEvent_AppStartup>(5, _omitFieldNames ? '' : 'startup', subBuilder: AuthBlocEvent_AppStartup.create)
    ..aOM<AuthBlocEvent_RemoveAccount>(6, _omitFieldNames ? '' : 'removeAccount', protoName: 'removeAccount', subBuilder: AuthBlocEvent_RemoveAccount.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AuthBlocEvent clone() => AuthBlocEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AuthBlocEvent copyWith(void Function(AuthBlocEvent) updates) => super.copyWith((message) => updates(message as AuthBlocEvent)) as AuthBlocEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthBlocEvent create() => AuthBlocEvent._();
  AuthBlocEvent createEmptyInstance() => create();
  static $pb.PbList<AuthBlocEvent> createRepeated() => $pb.PbList<AuthBlocEvent>();
  @$core.pragma('dart2js:noInline')
  static AuthBlocEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthBlocEvent>(create);
  static AuthBlocEvent? _defaultInstance;

  AuthBlocEvent_EventType whichEventType() => _AuthBlocEvent_EventTypeByTag[$_whichOneof(0)]!;
  void clearEventType() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  AuthBlocEvent_EmailLogin get emailLogin => $_getN(0);
  @$pb.TagNumber(1)
  set emailLogin(AuthBlocEvent_EmailLogin v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmailLogin() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmailLogin() => clearField(1);
  @$pb.TagNumber(1)
  AuthBlocEvent_EmailLogin ensureEmailLogin() => $_ensure(0);

  @$pb.TagNumber(2)
  AuthBlocEvent_EmailSignup get emailSignup => $_getN(1);
  @$pb.TagNumber(2)
  set emailSignup(AuthBlocEvent_EmailSignup v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasEmailSignup() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmailSignup() => clearField(2);
  @$pb.TagNumber(2)
  AuthBlocEvent_EmailSignup ensureEmailSignup() => $_ensure(1);

  @$pb.TagNumber(3)
  AuthBlocEvent_EmailForgotPassword get emailForgotPassword => $_getN(2);
  @$pb.TagNumber(3)
  set emailForgotPassword(AuthBlocEvent_EmailForgotPassword v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasEmailForgotPassword() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmailForgotPassword() => clearField(3);
  @$pb.TagNumber(3)
  AuthBlocEvent_EmailForgotPassword ensureEmailForgotPassword() => $_ensure(2);

  @$pb.TagNumber(4)
  AuthBlocEvent_Logout get logout => $_getN(3);
  @$pb.TagNumber(4)
  set logout(AuthBlocEvent_Logout v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasLogout() => $_has(3);
  @$pb.TagNumber(4)
  void clearLogout() => clearField(4);
  @$pb.TagNumber(4)
  AuthBlocEvent_Logout ensureLogout() => $_ensure(3);

  @$pb.TagNumber(5)
  AuthBlocEvent_AppStartup get startup => $_getN(4);
  @$pb.TagNumber(5)
  set startup(AuthBlocEvent_AppStartup v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasStartup() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartup() => clearField(5);
  @$pb.TagNumber(5)
  AuthBlocEvent_AppStartup ensureStartup() => $_ensure(4);

  @$pb.TagNumber(6)
  AuthBlocEvent_RemoveAccount get removeAccount => $_getN(5);
  @$pb.TagNumber(6)
  set removeAccount(AuthBlocEvent_RemoveAccount v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasRemoveAccount() => $_has(5);
  @$pb.TagNumber(6)
  void clearRemoveAccount() => clearField(6);
  @$pb.TagNumber(6)
  AuthBlocEvent_RemoveAccount ensureRemoveAccount() => $_ensure(5);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
