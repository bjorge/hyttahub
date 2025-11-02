//
//  Generated code. Do not modify.
//  source: site_events.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'app_wrapper.pb.dart' as $2;

/// events should be messages to allow for ease in future updates
class SiteEvent_NewSite extends $pb.GeneratedMessage {
  factory SiteEvent_NewSite({
    $core.String? siteName,
    $core.String? memberName,
    $core.String? instance,
  }) {
    final $result = create();
    if (siteName != null) {
      $result.siteName = siteName;
    }
    if (memberName != null) {
      $result.memberName = memberName;
    }
    if (instance != null) {
      $result.instance = instance;
    }
    return $result;
  }
  SiteEvent_NewSite._() : super();
  factory SiteEvent_NewSite.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SiteEvent_NewSite.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SiteEvent.NewSite', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'siteName', protoName: 'siteName')
    ..aOS(2, _omitFieldNames ? '' : 'memberName', protoName: 'memberName')
    ..aOS(3, _omitFieldNames ? '' : 'instance')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SiteEvent_NewSite clone() => SiteEvent_NewSite()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SiteEvent_NewSite copyWith(void Function(SiteEvent_NewSite) updates) => super.copyWith((message) => updates(message as SiteEvent_NewSite)) as SiteEvent_NewSite;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteEvent_NewSite create() => SiteEvent_NewSite._();
  SiteEvent_NewSite createEmptyInstance() => create();
  static $pb.PbList<SiteEvent_NewSite> createRepeated() => $pb.PbList<SiteEvent_NewSite>();
  @$core.pragma('dart2js:noInline')
  static SiteEvent_NewSite getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SiteEvent_NewSite>(create);
  static SiteEvent_NewSite? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get siteName => $_getSZ(0);
  @$pb.TagNumber(1)
  set siteName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSiteName() => $_has(0);
  @$pb.TagNumber(1)
  void clearSiteName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get memberName => $_getSZ(1);
  @$pb.TagNumber(2)
  set memberName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMemberName() => $_has(1);
  @$pb.TagNumber(2)
  void clearMemberName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get instance => $_getSZ(2);
  @$pb.TagNumber(3)
  set instance($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasInstance() => $_has(2);
  @$pb.TagNumber(3)
  void clearInstance() => clearField(3);
}

class SiteEvent_AddMember extends $pb.GeneratedMessage {
  factory SiteEvent_AddMember({
    $core.String? memberName,
    $core.bool? admin,
  }) {
    final $result = create();
    if (memberName != null) {
      $result.memberName = memberName;
    }
    if (admin != null) {
      $result.admin = admin;
    }
    return $result;
  }
  SiteEvent_AddMember._() : super();
  factory SiteEvent_AddMember.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SiteEvent_AddMember.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SiteEvent.AddMember', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'memberName', protoName: 'memberName')
    ..aOB(2, _omitFieldNames ? '' : 'admin')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SiteEvent_AddMember clone() => SiteEvent_AddMember()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SiteEvent_AddMember copyWith(void Function(SiteEvent_AddMember) updates) => super.copyWith((message) => updates(message as SiteEvent_AddMember)) as SiteEvent_AddMember;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteEvent_AddMember create() => SiteEvent_AddMember._();
  SiteEvent_AddMember createEmptyInstance() => create();
  static $pb.PbList<SiteEvent_AddMember> createRepeated() => $pb.PbList<SiteEvent_AddMember>();
  @$core.pragma('dart2js:noInline')
  static SiteEvent_AddMember getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SiteEvent_AddMember>(create);
  static SiteEvent_AddMember? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get memberName => $_getSZ(0);
  @$pb.TagNumber(1)
  set memberName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMemberName() => $_has(0);
  @$pb.TagNumber(1)
  void clearMemberName() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get admin => $_getBF(1);
  @$pb.TagNumber(2)
  set admin($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAdmin() => $_has(1);
  @$pb.TagNumber(2)
  void clearAdmin() => clearField(2);
}

/// admin removes a member from the site
class SiteEvent_RemoveMember extends $pb.GeneratedMessage {
  factory SiteEvent_RemoveMember({
    $core.int? memberId,
  }) {
    final $result = create();
    if (memberId != null) {
      $result.memberId = memberId;
    }
    return $result;
  }
  SiteEvent_RemoveMember._() : super();
  factory SiteEvent_RemoveMember.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SiteEvent_RemoveMember.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SiteEvent.RemoveMember', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'memberId', $pb.PbFieldType.O3, protoName: 'memberId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SiteEvent_RemoveMember clone() => SiteEvent_RemoveMember()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SiteEvent_RemoveMember copyWith(void Function(SiteEvent_RemoveMember) updates) => super.copyWith((message) => updates(message as SiteEvent_RemoveMember)) as SiteEvent_RemoveMember;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteEvent_RemoveMember create() => SiteEvent_RemoveMember._();
  SiteEvent_RemoveMember createEmptyInstance() => create();
  static $pb.PbList<SiteEvent_RemoveMember> createRepeated() => $pb.PbList<SiteEvent_RemoveMember>();
  @$core.pragma('dart2js:noInline')
  static SiteEvent_RemoveMember getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SiteEvent_RemoveMember>(create);
  static SiteEvent_RemoveMember? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get memberId => $_getIZ(0);
  @$pb.TagNumber(1)
  set memberId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMemberId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMemberId() => clearField(1);
}

class SiteEvent_RestoreMember extends $pb.GeneratedMessage {
  factory SiteEvent_RestoreMember({
    $core.int? memberId,
    $core.String? memberName,
    $core.bool? admin,
  }) {
    final $result = create();
    if (memberId != null) {
      $result.memberId = memberId;
    }
    if (memberName != null) {
      $result.memberName = memberName;
    }
    if (admin != null) {
      $result.admin = admin;
    }
    return $result;
  }
  SiteEvent_RestoreMember._() : super();
  factory SiteEvent_RestoreMember.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SiteEvent_RestoreMember.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SiteEvent.RestoreMember', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'memberId', $pb.PbFieldType.O3, protoName: 'memberId')
    ..aOS(2, _omitFieldNames ? '' : 'memberName', protoName: 'memberName')
    ..aOB(3, _omitFieldNames ? '' : 'admin')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SiteEvent_RestoreMember clone() => SiteEvent_RestoreMember()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SiteEvent_RestoreMember copyWith(void Function(SiteEvent_RestoreMember) updates) => super.copyWith((message) => updates(message as SiteEvent_RestoreMember)) as SiteEvent_RestoreMember;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteEvent_RestoreMember create() => SiteEvent_RestoreMember._();
  SiteEvent_RestoreMember createEmptyInstance() => create();
  static $pb.PbList<SiteEvent_RestoreMember> createRepeated() => $pb.PbList<SiteEvent_RestoreMember>();
  @$core.pragma('dart2js:noInline')
  static SiteEvent_RestoreMember getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SiteEvent_RestoreMember>(create);
  static SiteEvent_RestoreMember? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get memberId => $_getIZ(0);
  @$pb.TagNumber(1)
  set memberId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMemberId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMemberId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get memberName => $_getSZ(1);
  @$pb.TagNumber(2)
  set memberName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMemberName() => $_has(1);
  @$pb.TagNumber(2)
  void clearMemberName() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get admin => $_getBF(2);
  @$pb.TagNumber(3)
  set admin($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAdmin() => $_has(2);
  @$pb.TagNumber(3)
  void clearAdmin() => clearField(3);
}

class SiteEvent_UpdateMember extends $pb.GeneratedMessage {
  factory SiteEvent_UpdateMember({
    $core.int? memberId,
    $core.String? memberName,
    $core.bool? admin,
  }) {
    final $result = create();
    if (memberId != null) {
      $result.memberId = memberId;
    }
    if (memberName != null) {
      $result.memberName = memberName;
    }
    if (admin != null) {
      $result.admin = admin;
    }
    return $result;
  }
  SiteEvent_UpdateMember._() : super();
  factory SiteEvent_UpdateMember.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SiteEvent_UpdateMember.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SiteEvent.UpdateMember', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'memberId', $pb.PbFieldType.O3, protoName: 'memberId')
    ..aOS(2, _omitFieldNames ? '' : 'memberName', protoName: 'memberName')
    ..aOB(3, _omitFieldNames ? '' : 'admin')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SiteEvent_UpdateMember clone() => SiteEvent_UpdateMember()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SiteEvent_UpdateMember copyWith(void Function(SiteEvent_UpdateMember) updates) => super.copyWith((message) => updates(message as SiteEvent_UpdateMember)) as SiteEvent_UpdateMember;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteEvent_UpdateMember create() => SiteEvent_UpdateMember._();
  SiteEvent_UpdateMember createEmptyInstance() => create();
  static $pb.PbList<SiteEvent_UpdateMember> createRepeated() => $pb.PbList<SiteEvent_UpdateMember>();
  @$core.pragma('dart2js:noInline')
  static SiteEvent_UpdateMember getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SiteEvent_UpdateMember>(create);
  static SiteEvent_UpdateMember? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get memberId => $_getIZ(0);
  @$pb.TagNumber(1)
  set memberId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMemberId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMemberId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get memberName => $_getSZ(1);
  @$pb.TagNumber(2)
  set memberName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMemberName() => $_has(1);
  @$pb.TagNumber(2)
  void clearMemberName() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get admin => $_getBF(2);
  @$pb.TagNumber(3)
  set admin($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAdmin() => $_has(2);
  @$pb.TagNumber(3)
  void clearAdmin() => clearField(3);
}

/// member leaves the site
class SiteEvent_LeaveSite extends $pb.GeneratedMessage {
  factory SiteEvent_LeaveSite({
    $core.int? memberId,
  }) {
    final $result = create();
    if (memberId != null) {
      $result.memberId = memberId;
    }
    return $result;
  }
  SiteEvent_LeaveSite._() : super();
  factory SiteEvent_LeaveSite.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SiteEvent_LeaveSite.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SiteEvent.LeaveSite', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'memberId', $pb.PbFieldType.O3, protoName: 'memberId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SiteEvent_LeaveSite clone() => SiteEvent_LeaveSite()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SiteEvent_LeaveSite copyWith(void Function(SiteEvent_LeaveSite) updates) => super.copyWith((message) => updates(message as SiteEvent_LeaveSite)) as SiteEvent_LeaveSite;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteEvent_LeaveSite create() => SiteEvent_LeaveSite._();
  SiteEvent_LeaveSite createEmptyInstance() => create();
  static $pb.PbList<SiteEvent_LeaveSite> createRepeated() => $pb.PbList<SiteEvent_LeaveSite>();
  @$core.pragma('dart2js:noInline')
  static SiteEvent_LeaveSite getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SiteEvent_LeaveSite>(create);
  static SiteEvent_LeaveSite? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get memberId => $_getIZ(0);
  @$pb.TagNumber(1)
  set memberId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMemberId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMemberId() => clearField(1);
}

class SiteEvent_UpdateSiteName extends $pb.GeneratedMessage {
  factory SiteEvent_UpdateSiteName({
    $core.String? name,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  SiteEvent_UpdateSiteName._() : super();
  factory SiteEvent_UpdateSiteName.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SiteEvent_UpdateSiteName.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SiteEvent.UpdateSiteName', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SiteEvent_UpdateSiteName clone() => SiteEvent_UpdateSiteName()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SiteEvent_UpdateSiteName copyWith(void Function(SiteEvent_UpdateSiteName) updates) => super.copyWith((message) => updates(message as SiteEvent_UpdateSiteName)) as SiteEvent_UpdateSiteName;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteEvent_UpdateSiteName create() => SiteEvent_UpdateSiteName._();
  SiteEvent_UpdateSiteName createEmptyInstance() => create();
  static $pb.PbList<SiteEvent_UpdateSiteName> createRepeated() => $pb.PbList<SiteEvent_UpdateSiteName>();
  @$core.pragma('dart2js:noInline')
  static SiteEvent_UpdateSiteName getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SiteEvent_UpdateSiteName>(create);
  static SiteEvent_UpdateSiteName? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);
}

class SiteEvent_ExportEvent extends $pb.GeneratedMessage {
  factory SiteEvent_ExportEvent({
    $core.String? previousSiteId,
    $core.String? appId,
    $core.String? appName,
  }) {
    final $result = create();
    if (previousSiteId != null) {
      $result.previousSiteId = previousSiteId;
    }
    if (appId != null) {
      $result.appId = appId;
    }
    if (appName != null) {
      $result.appName = appName;
    }
    return $result;
  }
  SiteEvent_ExportEvent._() : super();
  factory SiteEvent_ExportEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SiteEvent_ExportEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SiteEvent.ExportEvent', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'previousSiteId', protoName: 'previousSiteId')
    ..aOS(2, _omitFieldNames ? '' : 'appId', protoName: 'appId')
    ..aOS(3, _omitFieldNames ? '' : 'appName', protoName: 'appName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SiteEvent_ExportEvent clone() => SiteEvent_ExportEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SiteEvent_ExportEvent copyWith(void Function(SiteEvent_ExportEvent) updates) => super.copyWith((message) => updates(message as SiteEvent_ExportEvent)) as SiteEvent_ExportEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteEvent_ExportEvent create() => SiteEvent_ExportEvent._();
  SiteEvent_ExportEvent createEmptyInstance() => create();
  static $pb.PbList<SiteEvent_ExportEvent> createRepeated() => $pb.PbList<SiteEvent_ExportEvent>();
  @$core.pragma('dart2js:noInline')
  static SiteEvent_ExportEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SiteEvent_ExportEvent>(create);
  static SiteEvent_ExportEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get previousSiteId => $_getSZ(0);
  @$pb.TagNumber(1)
  set previousSiteId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPreviousSiteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreviousSiteId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get appId => $_getSZ(1);
  @$pb.TagNumber(2)
  set appId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAppId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAppId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get appName => $_getSZ(2);
  @$pb.TagNumber(3)
  set appName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAppName() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppName() => clearField(3);
}

class SiteEvent_ImportEvent extends $pb.GeneratedMessage {
  factory SiteEvent_ImportEvent({
    $core.String? siteName,
  }) {
    final $result = create();
    if (siteName != null) {
      $result.siteName = siteName;
    }
    return $result;
  }
  SiteEvent_ImportEvent._() : super();
  factory SiteEvent_ImportEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SiteEvent_ImportEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SiteEvent.ImportEvent', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'siteName', protoName: 'siteName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SiteEvent_ImportEvent clone() => SiteEvent_ImportEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SiteEvent_ImportEvent copyWith(void Function(SiteEvent_ImportEvent) updates) => super.copyWith((message) => updates(message as SiteEvent_ImportEvent)) as SiteEvent_ImportEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteEvent_ImportEvent create() => SiteEvent_ImportEvent._();
  SiteEvent_ImportEvent createEmptyInstance() => create();
  static $pb.PbList<SiteEvent_ImportEvent> createRepeated() => $pb.PbList<SiteEvent_ImportEvent>();
  @$core.pragma('dart2js:noInline')
  static SiteEvent_ImportEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SiteEvent_ImportEvent>(create);
  static SiteEvent_ImportEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get siteName => $_getSZ(0);
  @$pb.TagNumber(1)
  set siteName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSiteName() => $_has(0);
  @$pb.TagNumber(1)
  void clearSiteName() => clearField(1);
}

enum SiteEvent_EventType {
  newSite, 
  addMember, 
  updateSiteName, 
  removeMember, 
  leaveSite, 
  restoreMember, 
  updateMember, 
  exportEvent, 
  importEvent, 
  appEvent, 
  notSet
}

/// The SiteEvent is persisted in immutable firestore collection
/// do not store email addresses or any other PII in this message
class SiteEvent extends $pb.GeneratedMessage {
  factory SiteEvent({
    $core.int? version,
    $core.int? author,
    SiteEvent_NewSite? newSite,
    SiteEvent_AddMember? addMember,
    SiteEvent_UpdateSiteName? updateSiteName,
    SiteEvent_RemoveMember? removeMember,
    SiteEvent_LeaveSite? leaveSite,
    SiteEvent_RestoreMember? restoreMember,
    SiteEvent_UpdateMember? updateMember,
    SiteEvent_ExportEvent? exportEvent,
    SiteEvent_ImportEvent? importEvent,
    $2.AppEventWrapper? appEvent,
  }) {
    final $result = create();
    if (version != null) {
      $result.version = version;
    }
    if (author != null) {
      $result.author = author;
    }
    if (newSite != null) {
      $result.newSite = newSite;
    }
    if (addMember != null) {
      $result.addMember = addMember;
    }
    if (updateSiteName != null) {
      $result.updateSiteName = updateSiteName;
    }
    if (removeMember != null) {
      $result.removeMember = removeMember;
    }
    if (leaveSite != null) {
      $result.leaveSite = leaveSite;
    }
    if (restoreMember != null) {
      $result.restoreMember = restoreMember;
    }
    if (updateMember != null) {
      $result.updateMember = updateMember;
    }
    if (exportEvent != null) {
      $result.exportEvent = exportEvent;
    }
    if (importEvent != null) {
      $result.importEvent = importEvent;
    }
    if (appEvent != null) {
      $result.appEvent = appEvent;
    }
    return $result;
  }
  SiteEvent._() : super();
  factory SiteEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SiteEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, SiteEvent_EventType> _SiteEvent_EventTypeByTag = {
    4 : SiteEvent_EventType.newSite,
    5 : SiteEvent_EventType.addMember,
    6 : SiteEvent_EventType.updateSiteName,
    7 : SiteEvent_EventType.removeMember,
    8 : SiteEvent_EventType.leaveSite,
    9 : SiteEvent_EventType.restoreMember,
    10 : SiteEvent_EventType.updateMember,
    11 : SiteEvent_EventType.exportEvent,
    12 : SiteEvent_EventType.importEvent,
    20 : SiteEvent_EventType.appEvent,
    0 : SiteEvent_EventType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SiteEvent', createEmptyInstance: create)
    ..oo(0, [4, 5, 6, 7, 8, 9, 10, 11, 12, 20])
    ..a<$core.int>(1, _omitFieldNames ? '' : 'version', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'author', $pb.PbFieldType.O3)
    ..aOM<SiteEvent_NewSite>(4, _omitFieldNames ? '' : 'newSite', protoName: 'newSite', subBuilder: SiteEvent_NewSite.create)
    ..aOM<SiteEvent_AddMember>(5, _omitFieldNames ? '' : 'addMember', protoName: 'addMember', subBuilder: SiteEvent_AddMember.create)
    ..aOM<SiteEvent_UpdateSiteName>(6, _omitFieldNames ? '' : 'updateSiteName', protoName: 'updateSiteName', subBuilder: SiteEvent_UpdateSiteName.create)
    ..aOM<SiteEvent_RemoveMember>(7, _omitFieldNames ? '' : 'removeMember', protoName: 'removeMember', subBuilder: SiteEvent_RemoveMember.create)
    ..aOM<SiteEvent_LeaveSite>(8, _omitFieldNames ? '' : 'leaveSite', protoName: 'leaveSite', subBuilder: SiteEvent_LeaveSite.create)
    ..aOM<SiteEvent_RestoreMember>(9, _omitFieldNames ? '' : 'restoreMember', protoName: 'restoreMember', subBuilder: SiteEvent_RestoreMember.create)
    ..aOM<SiteEvent_UpdateMember>(10, _omitFieldNames ? '' : 'updateMember', protoName: 'updateMember', subBuilder: SiteEvent_UpdateMember.create)
    ..aOM<SiteEvent_ExportEvent>(11, _omitFieldNames ? '' : 'exportEvent', protoName: 'exportEvent', subBuilder: SiteEvent_ExportEvent.create)
    ..aOM<SiteEvent_ImportEvent>(12, _omitFieldNames ? '' : 'importEvent', protoName: 'importEvent', subBuilder: SiteEvent_ImportEvent.create)
    ..aOM<$2.AppEventWrapper>(20, _omitFieldNames ? '' : 'appEvent', protoName: 'appEvent', subBuilder: $2.AppEventWrapper.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SiteEvent clone() => SiteEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SiteEvent copyWith(void Function(SiteEvent) updates) => super.copyWith((message) => updates(message as SiteEvent)) as SiteEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteEvent create() => SiteEvent._();
  SiteEvent createEmptyInstance() => create();
  static $pb.PbList<SiteEvent> createRepeated() => $pb.PbList<SiteEvent>();
  @$core.pragma('dart2js:noInline')
  static SiteEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SiteEvent>(create);
  static SiteEvent? _defaultInstance;

  SiteEvent_EventType whichEventType() => _SiteEvent_EventTypeByTag[$_whichOneof(0)]!;
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
  $core.int get author => $_getIZ(1);
  @$pb.TagNumber(2)
  set author($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAuthor() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthor() => clearField(2);

  @$pb.TagNumber(4)
  SiteEvent_NewSite get newSite => $_getN(2);
  @$pb.TagNumber(4)
  set newSite(SiteEvent_NewSite v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasNewSite() => $_has(2);
  @$pb.TagNumber(4)
  void clearNewSite() => clearField(4);
  @$pb.TagNumber(4)
  SiteEvent_NewSite ensureNewSite() => $_ensure(2);

  @$pb.TagNumber(5)
  SiteEvent_AddMember get addMember => $_getN(3);
  @$pb.TagNumber(5)
  set addMember(SiteEvent_AddMember v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasAddMember() => $_has(3);
  @$pb.TagNumber(5)
  void clearAddMember() => clearField(5);
  @$pb.TagNumber(5)
  SiteEvent_AddMember ensureAddMember() => $_ensure(3);

  @$pb.TagNumber(6)
  SiteEvent_UpdateSiteName get updateSiteName => $_getN(4);
  @$pb.TagNumber(6)
  set updateSiteName(SiteEvent_UpdateSiteName v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasUpdateSiteName() => $_has(4);
  @$pb.TagNumber(6)
  void clearUpdateSiteName() => clearField(6);
  @$pb.TagNumber(6)
  SiteEvent_UpdateSiteName ensureUpdateSiteName() => $_ensure(4);

  @$pb.TagNumber(7)
  SiteEvent_RemoveMember get removeMember => $_getN(5);
  @$pb.TagNumber(7)
  set removeMember(SiteEvent_RemoveMember v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasRemoveMember() => $_has(5);
  @$pb.TagNumber(7)
  void clearRemoveMember() => clearField(7);
  @$pb.TagNumber(7)
  SiteEvent_RemoveMember ensureRemoveMember() => $_ensure(5);

  @$pb.TagNumber(8)
  SiteEvent_LeaveSite get leaveSite => $_getN(6);
  @$pb.TagNumber(8)
  set leaveSite(SiteEvent_LeaveSite v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasLeaveSite() => $_has(6);
  @$pb.TagNumber(8)
  void clearLeaveSite() => clearField(8);
  @$pb.TagNumber(8)
  SiteEvent_LeaveSite ensureLeaveSite() => $_ensure(6);

  @$pb.TagNumber(9)
  SiteEvent_RestoreMember get restoreMember => $_getN(7);
  @$pb.TagNumber(9)
  set restoreMember(SiteEvent_RestoreMember v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasRestoreMember() => $_has(7);
  @$pb.TagNumber(9)
  void clearRestoreMember() => clearField(9);
  @$pb.TagNumber(9)
  SiteEvent_RestoreMember ensureRestoreMember() => $_ensure(7);

  @$pb.TagNumber(10)
  SiteEvent_UpdateMember get updateMember => $_getN(8);
  @$pb.TagNumber(10)
  set updateMember(SiteEvent_UpdateMember v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasUpdateMember() => $_has(8);
  @$pb.TagNumber(10)
  void clearUpdateMember() => clearField(10);
  @$pb.TagNumber(10)
  SiteEvent_UpdateMember ensureUpdateMember() => $_ensure(8);

  @$pb.TagNumber(11)
  SiteEvent_ExportEvent get exportEvent => $_getN(9);
  @$pb.TagNumber(11)
  set exportEvent(SiteEvent_ExportEvent v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasExportEvent() => $_has(9);
  @$pb.TagNumber(11)
  void clearExportEvent() => clearField(11);
  @$pb.TagNumber(11)
  SiteEvent_ExportEvent ensureExportEvent() => $_ensure(9);

  @$pb.TagNumber(12)
  SiteEvent_ImportEvent get importEvent => $_getN(10);
  @$pb.TagNumber(12)
  set importEvent(SiteEvent_ImportEvent v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasImportEvent() => $_has(10);
  @$pb.TagNumber(12)
  void clearImportEvent() => clearField(12);
  @$pb.TagNumber(12)
  SiteEvent_ImportEvent ensureImportEvent() => $_ensure(10);

  @$pb.TagNumber(20)
  $2.AppEventWrapper get appEvent => $_getN(11);
  @$pb.TagNumber(20)
  set appEvent($2.AppEventWrapper v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasAppEvent() => $_has(11);
  @$pb.TagNumber(20)
  void clearAppEvent() => clearField(20);
  @$pb.TagNumber(20)
  $2.AppEventWrapper ensureAppEvent() => $_ensure(11);
}

/// The SubmitSiteEvent is passed to the submit bloc handler
/// PII (ex. email) is allowed in this message since not stored to immutable
/// records
class SubmitSiteEvent extends $pb.GeneratedMessage {
  factory SubmitSiteEvent({
    SiteEvent? event,
    $core.String? authorEmail,
    $core.String? addMemberEmail,
    $core.String? removeMemberEmail,
    $core.String? updateMemberNewEmail,
    $core.String? updateMemberOriginalEmail,
  }) {
    final $result = create();
    if (event != null) {
      $result.event = event;
    }
    if (authorEmail != null) {
      $result.authorEmail = authorEmail;
    }
    if (addMemberEmail != null) {
      $result.addMemberEmail = addMemberEmail;
    }
    if (removeMemberEmail != null) {
      $result.removeMemberEmail = removeMemberEmail;
    }
    if (updateMemberNewEmail != null) {
      $result.updateMemberNewEmail = updateMemberNewEmail;
    }
    if (updateMemberOriginalEmail != null) {
      $result.updateMemberOriginalEmail = updateMemberOriginalEmail;
    }
    return $result;
  }
  SubmitSiteEvent._() : super();
  factory SubmitSiteEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitSiteEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitSiteEvent', createEmptyInstance: create)
    ..aOM<SiteEvent>(1, _omitFieldNames ? '' : 'event', subBuilder: SiteEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'authorEmail', protoName: 'authorEmail')
    ..aOS(4, _omitFieldNames ? '' : 'addMemberEmail', protoName: 'addMemberEmail')
    ..aOS(5, _omitFieldNames ? '' : 'removeMemberEmail', protoName: 'removeMemberEmail')
    ..aOS(6, _omitFieldNames ? '' : 'updateMemberNewEmail', protoName: 'updateMemberNewEmail')
    ..aOS(7, _omitFieldNames ? '' : 'updateMemberOriginalEmail', protoName: 'updateMemberOriginalEmail')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitSiteEvent clone() => SubmitSiteEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitSiteEvent copyWith(void Function(SubmitSiteEvent) updates) => super.copyWith((message) => updates(message as SubmitSiteEvent)) as SubmitSiteEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitSiteEvent create() => SubmitSiteEvent._();
  SubmitSiteEvent createEmptyInstance() => create();
  static $pb.PbList<SubmitSiteEvent> createRepeated() => $pb.PbList<SubmitSiteEvent>();
  @$core.pragma('dart2js:noInline')
  static SubmitSiteEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitSiteEvent>(create);
  static SubmitSiteEvent? _defaultInstance;

  @$pb.TagNumber(1)
  SiteEvent get event => $_getN(0);
  @$pb.TagNumber(1)
  set event(SiteEvent v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvent() => clearField(1);
  @$pb.TagNumber(1)
  SiteEvent ensureEvent() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get authorEmail => $_getSZ(1);
  @$pb.TagNumber(2)
  set authorEmail($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAuthorEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthorEmail() => clearField(2);

  @$pb.TagNumber(4)
  $core.String get addMemberEmail => $_getSZ(2);
  @$pb.TagNumber(4)
  set addMemberEmail($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasAddMemberEmail() => $_has(2);
  @$pb.TagNumber(4)
  void clearAddMemberEmail() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get removeMemberEmail => $_getSZ(3);
  @$pb.TagNumber(5)
  set removeMemberEmail($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasRemoveMemberEmail() => $_has(3);
  @$pb.TagNumber(5)
  void clearRemoveMemberEmail() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get updateMemberNewEmail => $_getSZ(4);
  @$pb.TagNumber(6)
  set updateMemberNewEmail($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasUpdateMemberNewEmail() => $_has(4);
  @$pb.TagNumber(6)
  void clearUpdateMemberNewEmail() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get updateMemberOriginalEmail => $_getSZ(5);
  @$pb.TagNumber(7)
  set updateMemberOriginalEmail($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(7)
  $core.bool hasUpdateMemberOriginalEmail() => $_has(5);
  @$pb.TagNumber(7)
  void clearUpdateMemberOriginalEmail() => clearField(7);
}

/// The SiteEventRecord is a representation of the actual record stored in the
/// database This record is used for display purposes in the client and to store
/// backup records
class SiteEventRecord extends $pb.GeneratedMessage {
  factory SiteEventRecord({
    $core.String? isoDate,
    $core.int? version,
    SiteEvent? siteEvent,
  }) {
    final $result = create();
    if (isoDate != null) {
      $result.isoDate = isoDate;
    }
    if (version != null) {
      $result.version = version;
    }
    if (siteEvent != null) {
      $result.siteEvent = siteEvent;
    }
    return $result;
  }
  SiteEventRecord._() : super();
  factory SiteEventRecord.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SiteEventRecord.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SiteEventRecord', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'isoDate', protoName: 'isoDate')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'version', $pb.PbFieldType.O3)
    ..aOM<SiteEvent>(3, _omitFieldNames ? '' : 'siteEvent', protoName: 'siteEvent', subBuilder: SiteEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SiteEventRecord clone() => SiteEventRecord()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SiteEventRecord copyWith(void Function(SiteEventRecord) updates) => super.copyWith((message) => updates(message as SiteEventRecord)) as SiteEventRecord;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteEventRecord create() => SiteEventRecord._();
  SiteEventRecord createEmptyInstance() => create();
  static $pb.PbList<SiteEventRecord> createRepeated() => $pb.PbList<SiteEventRecord>();
  @$core.pragma('dart2js:noInline')
  static SiteEventRecord getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SiteEventRecord>(create);
  static SiteEventRecord? _defaultInstance;

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
  SiteEvent get siteEvent => $_getN(2);
  @$pb.TagNumber(3)
  set siteEvent(SiteEvent v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSiteEvent() => $_has(2);
  @$pb.TagNumber(3)
  void clearSiteEvent() => clearField(3);
  @$pb.TagNumber(3)
  SiteEvent ensureSiteEvent() => $_ensure(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
