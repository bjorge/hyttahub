//
//  Generated code. Do not modify.
//  source: account_events.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// these are the terms and policies that the user has accepted
class AccountEvent_Terms extends $pb.GeneratedMessage {
  factory AccountEvent_Terms({
    $core.int? termsVersion,
    $core.int? policyVersion,
  }) {
    final $result = create();
    if (termsVersion != null) {
      $result.termsVersion = termsVersion;
    }
    if (policyVersion != null) {
      $result.policyVersion = policyVersion;
    }
    return $result;
  }
  AccountEvent_Terms._() : super();
  factory AccountEvent_Terms.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AccountEvent_Terms.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountEvent.Terms', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'termsVersion', $pb.PbFieldType.O3, protoName: 'termsVersion')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'policyVersion', $pb.PbFieldType.O3, protoName: 'policyVersion')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AccountEvent_Terms clone() => AccountEvent_Terms()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AccountEvent_Terms copyWith(void Function(AccountEvent_Terms) updates) => super.copyWith((message) => updates(message as AccountEvent_Terms)) as AccountEvent_Terms;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountEvent_Terms create() => AccountEvent_Terms._();
  AccountEvent_Terms createEmptyInstance() => create();
  static $pb.PbList<AccountEvent_Terms> createRepeated() => $pb.PbList<AccountEvent_Terms>();
  @$core.pragma('dart2js:noInline')
  static AccountEvent_Terms getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountEvent_Terms>(create);
  static AccountEvent_Terms? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get termsVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set termsVersion($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTermsVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearTermsVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get policyVersion => $_getIZ(1);
  @$pb.TagNumber(2)
  set policyVersion($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPolicyVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearPolicyVersion() => clearField(2);
}

class AccountEvent_InitialEvent extends $pb.GeneratedMessage {
  factory AccountEvent_InitialEvent({
    AccountEvent_Terms? terms,
  }) {
    final $result = create();
    if (terms != null) {
      $result.terms = terms;
    }
    return $result;
  }
  AccountEvent_InitialEvent._() : super();
  factory AccountEvent_InitialEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AccountEvent_InitialEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountEvent.InitialEvent', createEmptyInstance: create)
    ..aOM<AccountEvent_Terms>(1, _omitFieldNames ? '' : 'terms', subBuilder: AccountEvent_Terms.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AccountEvent_InitialEvent clone() => AccountEvent_InitialEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AccountEvent_InitialEvent copyWith(void Function(AccountEvent_InitialEvent) updates) => super.copyWith((message) => updates(message as AccountEvent_InitialEvent)) as AccountEvent_InitialEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountEvent_InitialEvent create() => AccountEvent_InitialEvent._();
  AccountEvent_InitialEvent createEmptyInstance() => create();
  static $pb.PbList<AccountEvent_InitialEvent> createRepeated() => $pb.PbList<AccountEvent_InitialEvent>();
  @$core.pragma('dart2js:noInline')
  static AccountEvent_InitialEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountEvent_InitialEvent>(create);
  static AccountEvent_InitialEvent? _defaultInstance;

  @$pb.TagNumber(1)
  AccountEvent_Terms get terms => $_getN(0);
  @$pb.TagNumber(1)
  set terms(AccountEvent_Terms v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTerms() => $_has(0);
  @$pb.TagNumber(1)
  void clearTerms() => clearField(1);
  @$pb.TagNumber(1)
  AccountEvent_Terms ensureTerms() => $_ensure(0);
}

enum AccountEvent_EventType {
  initialEvent, 
  terms, 
  allowEmailNotifications, 
  createSite, 
  removeSite, 
  joinSite, 
  leaveSite, 
  notSet
}

class AccountEvent extends $pb.GeneratedMessage {
  factory AccountEvent({
    $core.int? version,
    AccountEvent_InitialEvent? initialEvent,
    AccountEvent_Terms? terms,
    $core.bool? allowEmailNotifications,
    $core.String? createSite,
    $core.String? removeSite,
    $core.String? joinSite,
    $core.String? leaveSite,
  }) {
    final $result = create();
    if (version != null) {
      $result.version = version;
    }
    if (initialEvent != null) {
      $result.initialEvent = initialEvent;
    }
    if (terms != null) {
      $result.terms = terms;
    }
    if (allowEmailNotifications != null) {
      $result.allowEmailNotifications = allowEmailNotifications;
    }
    if (createSite != null) {
      $result.createSite = createSite;
    }
    if (removeSite != null) {
      $result.removeSite = removeSite;
    }
    if (joinSite != null) {
      $result.joinSite = joinSite;
    }
    if (leaveSite != null) {
      $result.leaveSite = leaveSite;
    }
    return $result;
  }
  AccountEvent._() : super();
  factory AccountEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AccountEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, AccountEvent_EventType> _AccountEvent_EventTypeByTag = {
    2 : AccountEvent_EventType.initialEvent,
    3 : AccountEvent_EventType.terms,
    4 : AccountEvent_EventType.allowEmailNotifications,
    5 : AccountEvent_EventType.createSite,
    6 : AccountEvent_EventType.removeSite,
    7 : AccountEvent_EventType.joinSite,
    8 : AccountEvent_EventType.leaveSite,
    0 : AccountEvent_EventType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountEvent', createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8])
    ..a<$core.int>(1, _omitFieldNames ? '' : 'version', $pb.PbFieldType.O3)
    ..aOM<AccountEvent_InitialEvent>(2, _omitFieldNames ? '' : 'initialEvent', protoName: 'initialEvent', subBuilder: AccountEvent_InitialEvent.create)
    ..aOM<AccountEvent_Terms>(3, _omitFieldNames ? '' : 'terms', subBuilder: AccountEvent_Terms.create)
    ..aOB(4, _omitFieldNames ? '' : 'allowEmailNotifications', protoName: 'allowEmailNotifications')
    ..aOS(5, _omitFieldNames ? '' : 'createSite', protoName: 'createSite')
    ..aOS(6, _omitFieldNames ? '' : 'removeSite', protoName: 'removeSite')
    ..aOS(7, _omitFieldNames ? '' : 'joinSite', protoName: 'joinSite')
    ..aOS(8, _omitFieldNames ? '' : 'leaveSite', protoName: 'leaveSite')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AccountEvent clone() => AccountEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AccountEvent copyWith(void Function(AccountEvent) updates) => super.copyWith((message) => updates(message as AccountEvent)) as AccountEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountEvent create() => AccountEvent._();
  AccountEvent createEmptyInstance() => create();
  static $pb.PbList<AccountEvent> createRepeated() => $pb.PbList<AccountEvent>();
  @$core.pragma('dart2js:noInline')
  static AccountEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountEvent>(create);
  static AccountEvent? _defaultInstance;

  AccountEvent_EventType whichEventType() => _AccountEvent_EventTypeByTag[$_whichOneof(0)]!;
  void clearEventType() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => clearField(1);

  @$pb.TagNumber(2)
  AccountEvent_InitialEvent get initialEvent => $_getN(1);
  @$pb.TagNumber(2)
  set initialEvent(AccountEvent_InitialEvent v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasInitialEvent() => $_has(1);
  @$pb.TagNumber(2)
  void clearInitialEvent() => clearField(2);
  @$pb.TagNumber(2)
  AccountEvent_InitialEvent ensureInitialEvent() => $_ensure(1);

  @$pb.TagNumber(3)
  AccountEvent_Terms get terms => $_getN(2);
  @$pb.TagNumber(3)
  set terms(AccountEvent_Terms v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTerms() => $_has(2);
  @$pb.TagNumber(3)
  void clearTerms() => clearField(3);
  @$pb.TagNumber(3)
  AccountEvent_Terms ensureTerms() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get allowEmailNotifications => $_getBF(3);
  @$pb.TagNumber(4)
  set allowEmailNotifications($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAllowEmailNotifications() => $_has(3);
  @$pb.TagNumber(4)
  void clearAllowEmailNotifications() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get createSite => $_getSZ(4);
  @$pb.TagNumber(5)
  set createSite($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCreateSite() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreateSite() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get removeSite => $_getSZ(5);
  @$pb.TagNumber(6)
  set removeSite($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasRemoveSite() => $_has(5);
  @$pb.TagNumber(6)
  void clearRemoveSite() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get joinSite => $_getSZ(6);
  @$pb.TagNumber(7)
  set joinSite($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasJoinSite() => $_has(6);
  @$pb.TagNumber(7)
  void clearJoinSite() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get leaveSite => $_getSZ(7);
  @$pb.TagNumber(8)
  set leaveSite($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasLeaveSite() => $_has(7);
  @$pb.TagNumber(8)
  void clearLeaveSite() => clearField(8);
}

/// The SubmitAccountEvent is passed to the submit bloc handler
class SubmitAccountEvent extends $pb.GeneratedMessage {
  factory SubmitAccountEvent({
    AccountEvent? event,
    $core.String? createSiteName,
    $core.String? createSiteUserName,
  }) {
    final $result = create();
    if (event != null) {
      $result.event = event;
    }
    if (createSiteName != null) {
      $result.createSiteName = createSiteName;
    }
    if (createSiteUserName != null) {
      $result.createSiteUserName = createSiteUserName;
    }
    return $result;
  }
  SubmitAccountEvent._() : super();
  factory SubmitAccountEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitAccountEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitAccountEvent', createEmptyInstance: create)
    ..aOM<AccountEvent>(1, _omitFieldNames ? '' : 'event', subBuilder: AccountEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'createSiteName', protoName: 'createSiteName')
    ..aOS(3, _omitFieldNames ? '' : 'createSiteUserName', protoName: 'createSiteUserName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitAccountEvent clone() => SubmitAccountEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitAccountEvent copyWith(void Function(SubmitAccountEvent) updates) => super.copyWith((message) => updates(message as SubmitAccountEvent)) as SubmitAccountEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitAccountEvent create() => SubmitAccountEvent._();
  SubmitAccountEvent createEmptyInstance() => create();
  static $pb.PbList<SubmitAccountEvent> createRepeated() => $pb.PbList<SubmitAccountEvent>();
  @$core.pragma('dart2js:noInline')
  static SubmitAccountEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitAccountEvent>(create);
  static SubmitAccountEvent? _defaultInstance;

  @$pb.TagNumber(1)
  AccountEvent get event => $_getN(0);
  @$pb.TagNumber(1)
  set event(AccountEvent v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvent() => clearField(1);
  @$pb.TagNumber(1)
  AccountEvent ensureEvent() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get createSiteName => $_getSZ(1);
  @$pb.TagNumber(2)
  set createSiteName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCreateSiteName() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreateSiteName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get createSiteUserName => $_getSZ(2);
  @$pb.TagNumber(3)
  set createSiteUserName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCreateSiteUserName() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreateSiteUserName() => clearField(3);
}

/// The AccountEventRecord is a representation of the actual record stored in the database
/// This record is used just for display purposes in the client
class AccountEventRecord extends $pb.GeneratedMessage {
  factory AccountEventRecord({
    $core.String? isoDate,
    $core.int? version,
    AccountEvent? accountEvent,
  }) {
    final $result = create();
    if (isoDate != null) {
      $result.isoDate = isoDate;
    }
    if (version != null) {
      $result.version = version;
    }
    if (accountEvent != null) {
      $result.accountEvent = accountEvent;
    }
    return $result;
  }
  AccountEventRecord._() : super();
  factory AccountEventRecord.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AccountEventRecord.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountEventRecord', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'isoDate', protoName: 'isoDate')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'version', $pb.PbFieldType.O3)
    ..aOM<AccountEvent>(3, _omitFieldNames ? '' : 'accountEvent', protoName: 'accountEvent', subBuilder: AccountEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AccountEventRecord clone() => AccountEventRecord()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AccountEventRecord copyWith(void Function(AccountEventRecord) updates) => super.copyWith((message) => updates(message as AccountEventRecord)) as AccountEventRecord;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountEventRecord create() => AccountEventRecord._();
  AccountEventRecord createEmptyInstance() => create();
  static $pb.PbList<AccountEventRecord> createRepeated() => $pb.PbList<AccountEventRecord>();
  @$core.pragma('dart2js:noInline')
  static AccountEventRecord getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountEventRecord>(create);
  static AccountEventRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get isoDate => $_getSZ(0);
  @$pb.TagNumber(1)
  set isoDate($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIsoDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsoDate() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get version => $_getIZ(1);
  @$pb.TagNumber(2)
  set version($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => clearField(2);

  @$pb.TagNumber(3)
  AccountEvent get accountEvent => $_getN(2);
  @$pb.TagNumber(3)
  set accountEvent(AccountEvent v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAccountEvent() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccountEvent() => clearField(3);
  @$pb.TagNumber(3)
  AccountEvent ensureAccountEvent() => $_ensure(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
