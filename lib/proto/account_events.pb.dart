// This is a generated file - do not edit.
//
// Generated from account_events.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// these are the terms and policies that the user has accepted
class AccountEvent_Terms extends $pb.GeneratedMessage {
  factory AccountEvent_Terms({
    $core.int? termsVersion,
    $core.int? policyVersion,
  }) {
    final result = create();
    if (termsVersion != null) result.termsVersion = termsVersion;
    if (policyVersion != null) result.policyVersion = policyVersion;
    return result;
  }

  AccountEvent_Terms._();

  factory AccountEvent_Terms.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountEvent_Terms.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccountEvent.Terms',
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'termsVersion', protoName: 'termsVersion')
    ..aI(2, _omitFieldNames ? '' : 'policyVersion', protoName: 'policyVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountEvent_Terms clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountEvent_Terms copyWith(void Function(AccountEvent_Terms) updates) =>
      super.copyWith((message) => updates(message as AccountEvent_Terms))
          as AccountEvent_Terms;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountEvent_Terms create() => AccountEvent_Terms._();
  @$core.override
  AccountEvent_Terms createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountEvent_Terms getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AccountEvent_Terms>(create);
  static AccountEvent_Terms? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get termsVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set termsVersion($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTermsVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearTermsVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get policyVersion => $_getIZ(1);
  @$pb.TagNumber(2)
  set policyVersion($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPolicyVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearPolicyVersion() => $_clearField(2);
}

class AccountEvent_InitialEvent extends $pb.GeneratedMessage {
  factory AccountEvent_InitialEvent({
    AccountEvent_Terms? terms,
    $core.String? instance,
  }) {
    final result = create();
    if (terms != null) result.terms = terms;
    if (instance != null) result.instance = instance;
    return result;
  }

  AccountEvent_InitialEvent._();

  factory AccountEvent_InitialEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountEvent_InitialEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccountEvent.InitialEvent',
      createEmptyInstance: create)
    ..aOM<AccountEvent_Terms>(1, _omitFieldNames ? '' : 'terms',
        subBuilder: AccountEvent_Terms.create)
    ..aOS(2, _omitFieldNames ? '' : 'instance')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountEvent_InitialEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountEvent_InitialEvent copyWith(
          void Function(AccountEvent_InitialEvent) updates) =>
      super.copyWith((message) => updates(message as AccountEvent_InitialEvent))
          as AccountEvent_InitialEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountEvent_InitialEvent create() => AccountEvent_InitialEvent._();
  @$core.override
  AccountEvent_InitialEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountEvent_InitialEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AccountEvent_InitialEvent>(create);
  static AccountEvent_InitialEvent? _defaultInstance;

  @$pb.TagNumber(1)
  AccountEvent_Terms get terms => $_getN(0);
  @$pb.TagNumber(1)
  set terms(AccountEvent_Terms value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTerms() => $_has(0);
  @$pb.TagNumber(1)
  void clearTerms() => $_clearField(1);
  @$pb.TagNumber(1)
  AccountEvent_Terms ensureTerms() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get instance => $_getSZ(1);
  @$pb.TagNumber(2)
  set instance($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInstance() => $_has(1);
  @$pb.TagNumber(2)
  void clearInstance() => $_clearField(2);
}

enum AccountEvent_EventType {
  initialEvent,
  terms,
  allowEmailNotifications,
  createSite,
  removeSite,
  joinSite,
  leaveSite,
  reorderSites,
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
    ReorderSites? reorderSites,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (initialEvent != null) result.initialEvent = initialEvent;
    if (terms != null) result.terms = terms;
    if (allowEmailNotifications != null)
      result.allowEmailNotifications = allowEmailNotifications;
    if (createSite != null) result.createSite = createSite;
    if (removeSite != null) result.removeSite = removeSite;
    if (joinSite != null) result.joinSite = joinSite;
    if (leaveSite != null) result.leaveSite = leaveSite;
    if (reorderSites != null) result.reorderSites = reorderSites;
    return result;
  }

  AccountEvent._();

  factory AccountEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, AccountEvent_EventType>
      _AccountEvent_EventTypeByTag = {
    2: AccountEvent_EventType.initialEvent,
    3: AccountEvent_EventType.terms,
    4: AccountEvent_EventType.allowEmailNotifications,
    5: AccountEvent_EventType.createSite,
    6: AccountEvent_EventType.removeSite,
    7: AccountEvent_EventType.joinSite,
    8: AccountEvent_EventType.leaveSite,
    9: AccountEvent_EventType.reorderSites,
    0: AccountEvent_EventType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccountEvent',
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8, 9])
    ..aI(1, _omitFieldNames ? '' : 'version')
    ..aOM<AccountEvent_InitialEvent>(2, _omitFieldNames ? '' : 'initialEvent',
        protoName: 'initialEvent', subBuilder: AccountEvent_InitialEvent.create)
    ..aOM<AccountEvent_Terms>(3, _omitFieldNames ? '' : 'terms',
        subBuilder: AccountEvent_Terms.create)
    ..aOB(4, _omitFieldNames ? '' : 'allowEmailNotifications',
        protoName: 'allowEmailNotifications')
    ..aOS(5, _omitFieldNames ? '' : 'createSite', protoName: 'createSite')
    ..aOS(6, _omitFieldNames ? '' : 'removeSite', protoName: 'removeSite')
    ..aOS(7, _omitFieldNames ? '' : 'joinSite', protoName: 'joinSite')
    ..aOS(8, _omitFieldNames ? '' : 'leaveSite', protoName: 'leaveSite')
    ..aOM<ReorderSites>(9, _omitFieldNames ? '' : 'reorderSites',
        protoName: 'reorderSites', subBuilder: ReorderSites.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountEvent copyWith(void Function(AccountEvent) updates) =>
      super.copyWith((message) => updates(message as AccountEvent))
          as AccountEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountEvent create() => AccountEvent._();
  @$core.override
  AccountEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AccountEvent>(create);
  static AccountEvent? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  AccountEvent_EventType whichEventType() =>
      _AccountEvent_EventTypeByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  void clearEventType() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  AccountEvent_InitialEvent get initialEvent => $_getN(1);
  @$pb.TagNumber(2)
  set initialEvent(AccountEvent_InitialEvent value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasInitialEvent() => $_has(1);
  @$pb.TagNumber(2)
  void clearInitialEvent() => $_clearField(2);
  @$pb.TagNumber(2)
  AccountEvent_InitialEvent ensureInitialEvent() => $_ensure(1);

  @$pb.TagNumber(3)
  AccountEvent_Terms get terms => $_getN(2);
  @$pb.TagNumber(3)
  set terms(AccountEvent_Terms value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTerms() => $_has(2);
  @$pb.TagNumber(3)
  void clearTerms() => $_clearField(3);
  @$pb.TagNumber(3)
  AccountEvent_Terms ensureTerms() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get allowEmailNotifications => $_getBF(3);
  @$pb.TagNumber(4)
  set allowEmailNotifications($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAllowEmailNotifications() => $_has(3);
  @$pb.TagNumber(4)
  void clearAllowEmailNotifications() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get createSite => $_getSZ(4);
  @$pb.TagNumber(5)
  set createSite($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreateSite() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreateSite() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get removeSite => $_getSZ(5);
  @$pb.TagNumber(6)
  set removeSite($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRemoveSite() => $_has(5);
  @$pb.TagNumber(6)
  void clearRemoveSite() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get joinSite => $_getSZ(6);
  @$pb.TagNumber(7)
  set joinSite($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasJoinSite() => $_has(6);
  @$pb.TagNumber(7)
  void clearJoinSite() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get leaveSite => $_getSZ(7);
  @$pb.TagNumber(8)
  set leaveSite($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLeaveSite() => $_has(7);
  @$pb.TagNumber(8)
  void clearLeaveSite() => $_clearField(8);

  @$pb.TagNumber(9)
  ReorderSites get reorderSites => $_getN(8);
  @$pb.TagNumber(9)
  set reorderSites(ReorderSites value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasReorderSites() => $_has(8);
  @$pb.TagNumber(9)
  void clearReorderSites() => $_clearField(9);
  @$pb.TagNumber(9)
  ReorderSites ensureReorderSites() => $_ensure(8);
}

class ReorderSites extends $pb.GeneratedMessage {
  factory ReorderSites({
    $core.Iterable<$core.String>? siteIds,
  }) {
    final result = create();
    if (siteIds != null) result.siteIds.addAll(siteIds);
    return result;
  }

  ReorderSites._();

  factory ReorderSites.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReorderSites.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReorderSites',
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'siteIds', protoName: 'siteIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReorderSites clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReorderSites copyWith(void Function(ReorderSites) updates) =>
      super.copyWith((message) => updates(message as ReorderSites))
          as ReorderSites;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReorderSites create() => ReorderSites._();
  @$core.override
  ReorderSites createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReorderSites getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReorderSites>(create);
  static ReorderSites? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get siteIds => $_getList(0);
}

/// The SubmitAccountEvent is passed to the submit bloc handler
class SubmitAccountEvent extends $pb.GeneratedMessage {
  factory SubmitAccountEvent({
    AccountEvent? event,
    $core.String? createSiteName,
    $core.String? createSiteUserName,
  }) {
    final result = create();
    if (event != null) result.event = event;
    if (createSiteName != null) result.createSiteName = createSiteName;
    if (createSiteUserName != null)
      result.createSiteUserName = createSiteUserName;
    return result;
  }

  SubmitAccountEvent._();

  factory SubmitAccountEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubmitAccountEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubmitAccountEvent',
      createEmptyInstance: create)
    ..aOM<AccountEvent>(1, _omitFieldNames ? '' : 'event',
        subBuilder: AccountEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'createSiteName',
        protoName: 'createSiteName')
    ..aOS(3, _omitFieldNames ? '' : 'createSiteUserName',
        protoName: 'createSiteUserName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitAccountEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitAccountEvent copyWith(void Function(SubmitAccountEvent) updates) =>
      super.copyWith((message) => updates(message as SubmitAccountEvent))
          as SubmitAccountEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitAccountEvent create() => SubmitAccountEvent._();
  @$core.override
  SubmitAccountEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubmitAccountEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubmitAccountEvent>(create);
  static SubmitAccountEvent? _defaultInstance;

  @$pb.TagNumber(1)
  AccountEvent get event => $_getN(0);
  @$pb.TagNumber(1)
  set event(AccountEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  AccountEvent ensureEvent() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get createSiteName => $_getSZ(1);
  @$pb.TagNumber(2)
  set createSiteName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreateSiteName() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreateSiteName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get createSiteUserName => $_getSZ(2);
  @$pb.TagNumber(3)
  set createSiteUserName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreateSiteUserName() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreateSiteUserName() => $_clearField(3);
}

/// The AccountEventRecord is a representation of the actual record stored in the
/// database This record is used just for display purposes in the client
class AccountEventRecord extends $pb.GeneratedMessage {
  factory AccountEventRecord({
    $core.String? isoDate,
    $core.int? version,
    AccountEvent? accountEvent,
  }) {
    final result = create();
    if (isoDate != null) result.isoDate = isoDate;
    if (version != null) result.version = version;
    if (accountEvent != null) result.accountEvent = accountEvent;
    return result;
  }

  AccountEventRecord._();

  factory AccountEventRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountEventRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccountEventRecord',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'isoDate', protoName: 'isoDate')
    ..aI(2, _omitFieldNames ? '' : 'version')
    ..aOM<AccountEvent>(3, _omitFieldNames ? '' : 'accountEvent',
        protoName: 'accountEvent', subBuilder: AccountEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountEventRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountEventRecord copyWith(void Function(AccountEventRecord) updates) =>
      super.copyWith((message) => updates(message as AccountEventRecord))
          as AccountEventRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountEventRecord create() => AccountEventRecord._();
  @$core.override
  AccountEventRecord createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountEventRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AccountEventRecord>(create);
  static AccountEventRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get isoDate => $_getSZ(0);
  @$pb.TagNumber(1)
  set isoDate($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsoDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsoDate() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get version => $_getIZ(1);
  @$pb.TagNumber(2)
  set version($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  AccountEvent get accountEvent => $_getN(2);
  @$pb.TagNumber(3)
  set accountEvent(AccountEvent value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAccountEvent() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccountEvent() => $_clearField(3);
  @$pb.TagNumber(3)
  AccountEvent ensureAccountEvent() => $_ensure(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
