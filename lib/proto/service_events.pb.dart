//
//  Generated code. Do not modify.
//  source: service_events.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'bloom_filter.pb.dart' as $1;

class ServiceEvent_InitialEvent extends $pb.GeneratedMessage {
  factory ServiceEvent_InitialEvent({
    $core.String? instance,
    $core.String? alias,
    $1.BloomFilter? filter,
  }) {
    final $result = create();
    if (instance != null) {
      $result.instance = instance;
    }
    if (alias != null) {
      $result.alias = alias;
    }
    if (filter != null) {
      $result.filter = filter;
    }
    return $result;
  }
  ServiceEvent_InitialEvent._() : super();
  factory ServiceEvent_InitialEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceEvent_InitialEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceEvent.InitialEvent', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'instance')
    ..aOS(2, _omitFieldNames ? '' : 'alias')
    ..aOM<$1.BloomFilter>(3, _omitFieldNames ? '' : 'filter', subBuilder: $1.BloomFilter.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceEvent_InitialEvent clone() => ServiceEvent_InitialEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceEvent_InitialEvent copyWith(void Function(ServiceEvent_InitialEvent) updates) => super.copyWith((message) => updates(message as ServiceEvent_InitialEvent)) as ServiceEvent_InitialEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_InitialEvent create() => ServiceEvent_InitialEvent._();
  ServiceEvent_InitialEvent createEmptyInstance() => create();
  static $pb.PbList<ServiceEvent_InitialEvent> createRepeated() => $pb.PbList<ServiceEvent_InitialEvent>();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_InitialEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceEvent_InitialEvent>(create);
  static ServiceEvent_InitialEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instance => $_getSZ(0);
  @$pb.TagNumber(1)
  set instance($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasInstance() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstance() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get alias => $_getSZ(1);
  @$pb.TagNumber(2)
  set alias($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAlias() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlias() => clearField(2);

  @$pb.TagNumber(3)
  $1.BloomFilter get filter => $_getN(2);
  @$pb.TagNumber(3)
  set filter($1.BloomFilter v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilter() => clearField(3);
  @$pb.TagNumber(3)
  $1.BloomFilter ensureFilter() => $_ensure(2);
}

class ServiceEvent_ServiceStatus extends $pb.GeneratedMessage {
  factory ServiceEvent_ServiceStatus({
    $core.bool? unavailable,
  }) {
    final $result = create();
    if (unavailable != null) {
      $result.unavailable = unavailable;
    }
    return $result;
  }
  ServiceEvent_ServiceStatus._() : super();
  factory ServiceEvent_ServiceStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceEvent_ServiceStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceEvent.ServiceStatus', createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'unavailable')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceEvent_ServiceStatus clone() => ServiceEvent_ServiceStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceEvent_ServiceStatus copyWith(void Function(ServiceEvent_ServiceStatus) updates) => super.copyWith((message) => updates(message as ServiceEvent_ServiceStatus)) as ServiceEvent_ServiceStatus;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_ServiceStatus create() => ServiceEvent_ServiceStatus._();
  ServiceEvent_ServiceStatus createEmptyInstance() => create();
  static $pb.PbList<ServiceEvent_ServiceStatus> createRepeated() => $pb.PbList<ServiceEvent_ServiceStatus>();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_ServiceStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceEvent_ServiceStatus>(create);
  static ServiceEvent_ServiceStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get unavailable => $_getBF(0);
  @$pb.TagNumber(1)
  set unavailable($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUnavailable() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnavailable() => clearField(1);
}

class ServiceEvent_TermsOfService extends $pb.GeneratedMessage {
  factory ServiceEvent_TermsOfService({
    $core.String? content,
  }) {
    final $result = create();
    if (content != null) {
      $result.content = content;
    }
    return $result;
  }
  ServiceEvent_TermsOfService._() : super();
  factory ServiceEvent_TermsOfService.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceEvent_TermsOfService.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceEvent.TermsOfService', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceEvent_TermsOfService clone() => ServiceEvent_TermsOfService()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceEvent_TermsOfService copyWith(void Function(ServiceEvent_TermsOfService) updates) => super.copyWith((message) => updates(message as ServiceEvent_TermsOfService)) as ServiceEvent_TermsOfService;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_TermsOfService create() => ServiceEvent_TermsOfService._();
  ServiceEvent_TermsOfService createEmptyInstance() => create();
  static $pb.PbList<ServiceEvent_TermsOfService> createRepeated() => $pb.PbList<ServiceEvent_TermsOfService>();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_TermsOfService getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceEvent_TermsOfService>(create);
  static ServiceEvent_TermsOfService? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get content => $_getSZ(0);
  @$pb.TagNumber(1)
  set content($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => clearField(1);
}

class ServiceEvent_PrivacyPolicy extends $pb.GeneratedMessage {
  factory ServiceEvent_PrivacyPolicy({
    $core.String? content,
  }) {
    final $result = create();
    if (content != null) {
      $result.content = content;
    }
    return $result;
  }
  ServiceEvent_PrivacyPolicy._() : super();
  factory ServiceEvent_PrivacyPolicy.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceEvent_PrivacyPolicy.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceEvent.PrivacyPolicy', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceEvent_PrivacyPolicy clone() => ServiceEvent_PrivacyPolicy()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceEvent_PrivacyPolicy copyWith(void Function(ServiceEvent_PrivacyPolicy) updates) => super.copyWith((message) => updates(message as ServiceEvent_PrivacyPolicy)) as ServiceEvent_PrivacyPolicy;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_PrivacyPolicy create() => ServiceEvent_PrivacyPolicy._();
  ServiceEvent_PrivacyPolicy createEmptyInstance() => create();
  static $pb.PbList<ServiceEvent_PrivacyPolicy> createRepeated() => $pb.PbList<ServiceEvent_PrivacyPolicy>();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_PrivacyPolicy getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceEvent_PrivacyPolicy>(create);
  static ServiceEvent_PrivacyPolicy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get content => $_getSZ(0);
  @$pb.TagNumber(1)
  set content($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => clearField(1);
}

class ServiceEvent_AddServiceAdmin extends $pb.GeneratedMessage {
  factory ServiceEvent_AddServiceAdmin({
    $core.String? alias,
    $1.BloomFilter? filter,
  }) {
    final $result = create();
    if (alias != null) {
      $result.alias = alias;
    }
    if (filter != null) {
      $result.filter = filter;
    }
    return $result;
  }
  ServiceEvent_AddServiceAdmin._() : super();
  factory ServiceEvent_AddServiceAdmin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceEvent_AddServiceAdmin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceEvent.AddServiceAdmin', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'alias')
    ..aOM<$1.BloomFilter>(2, _omitFieldNames ? '' : 'filter', subBuilder: $1.BloomFilter.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceEvent_AddServiceAdmin clone() => ServiceEvent_AddServiceAdmin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceEvent_AddServiceAdmin copyWith(void Function(ServiceEvent_AddServiceAdmin) updates) => super.copyWith((message) => updates(message as ServiceEvent_AddServiceAdmin)) as ServiceEvent_AddServiceAdmin;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_AddServiceAdmin create() => ServiceEvent_AddServiceAdmin._();
  ServiceEvent_AddServiceAdmin createEmptyInstance() => create();
  static $pb.PbList<ServiceEvent_AddServiceAdmin> createRepeated() => $pb.PbList<ServiceEvent_AddServiceAdmin>();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_AddServiceAdmin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceEvent_AddServiceAdmin>(create);
  static ServiceEvent_AddServiceAdmin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get alias => $_getSZ(0);
  @$pb.TagNumber(1)
  set alias($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAlias() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlias() => clearField(1);

  @$pb.TagNumber(2)
  $1.BloomFilter get filter => $_getN(1);
  @$pb.TagNumber(2)
  set filter($1.BloomFilter v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearFilter() => clearField(2);
  @$pb.TagNumber(2)
  $1.BloomFilter ensureFilter() => $_ensure(1);
}

class ServiceEvent_RemoveServiceAdmin extends $pb.GeneratedMessage {
  factory ServiceEvent_RemoveServiceAdmin({
    $core.int? id,
    $1.BloomFilter? filter,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (filter != null) {
      $result.filter = filter;
    }
    return $result;
  }
  ServiceEvent_RemoveServiceAdmin._() : super();
  factory ServiceEvent_RemoveServiceAdmin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceEvent_RemoveServiceAdmin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceEvent.RemoveServiceAdmin', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOM<$1.BloomFilter>(2, _omitFieldNames ? '' : 'filter', subBuilder: $1.BloomFilter.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceEvent_RemoveServiceAdmin clone() => ServiceEvent_RemoveServiceAdmin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceEvent_RemoveServiceAdmin copyWith(void Function(ServiceEvent_RemoveServiceAdmin) updates) => super.copyWith((message) => updates(message as ServiceEvent_RemoveServiceAdmin)) as ServiceEvent_RemoveServiceAdmin;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_RemoveServiceAdmin create() => ServiceEvent_RemoveServiceAdmin._();
  ServiceEvent_RemoveServiceAdmin createEmptyInstance() => create();
  static $pb.PbList<ServiceEvent_RemoveServiceAdmin> createRepeated() => $pb.PbList<ServiceEvent_RemoveServiceAdmin>();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_RemoveServiceAdmin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceEvent_RemoveServiceAdmin>(create);
  static ServiceEvent_RemoveServiceAdmin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $1.BloomFilter get filter => $_getN(1);
  @$pb.TagNumber(2)
  set filter($1.BloomFilter v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearFilter() => clearField(2);
  @$pb.TagNumber(2)
  $1.BloomFilter ensureFilter() => $_ensure(1);
}

class ServiceEvent_UpdateServiceAdmin extends $pb.GeneratedMessage {
  factory ServiceEvent_UpdateServiceAdmin({
    $core.int? id,
    $core.String? alias,
    $1.BloomFilter? filter,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (alias != null) {
      $result.alias = alias;
    }
    if (filter != null) {
      $result.filter = filter;
    }
    return $result;
  }
  ServiceEvent_UpdateServiceAdmin._() : super();
  factory ServiceEvent_UpdateServiceAdmin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceEvent_UpdateServiceAdmin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceEvent.UpdateServiceAdmin', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'alias')
    ..aOM<$1.BloomFilter>(3, _omitFieldNames ? '' : 'filter', subBuilder: $1.BloomFilter.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceEvent_UpdateServiceAdmin clone() => ServiceEvent_UpdateServiceAdmin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceEvent_UpdateServiceAdmin copyWith(void Function(ServiceEvent_UpdateServiceAdmin) updates) => super.copyWith((message) => updates(message as ServiceEvent_UpdateServiceAdmin)) as ServiceEvent_UpdateServiceAdmin;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_UpdateServiceAdmin create() => ServiceEvent_UpdateServiceAdmin._();
  ServiceEvent_UpdateServiceAdmin createEmptyInstance() => create();
  static $pb.PbList<ServiceEvent_UpdateServiceAdmin> createRepeated() => $pb.PbList<ServiceEvent_UpdateServiceAdmin>();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_UpdateServiceAdmin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceEvent_UpdateServiceAdmin>(create);
  static ServiceEvent_UpdateServiceAdmin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get alias => $_getSZ(1);
  @$pb.TagNumber(2)
  set alias($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAlias() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlias() => clearField(2);

  @$pb.TagNumber(3)
  $1.BloomFilter get filter => $_getN(2);
  @$pb.TagNumber(3)
  set filter($1.BloomFilter v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilter() => clearField(3);
  @$pb.TagNumber(3)
  $1.BloomFilter ensureFilter() => $_ensure(2);
}

class ServiceEvent_RestoreServiceAdmin extends $pb.GeneratedMessage {
  factory ServiceEvent_RestoreServiceAdmin({
    $core.int? id,
    $core.String? alias,
    $1.BloomFilter? filter,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (alias != null) {
      $result.alias = alias;
    }
    if (filter != null) {
      $result.filter = filter;
    }
    return $result;
  }
  ServiceEvent_RestoreServiceAdmin._() : super();
  factory ServiceEvent_RestoreServiceAdmin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceEvent_RestoreServiceAdmin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceEvent.RestoreServiceAdmin', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'alias')
    ..aOM<$1.BloomFilter>(3, _omitFieldNames ? '' : 'filter', subBuilder: $1.BloomFilter.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceEvent_RestoreServiceAdmin clone() => ServiceEvent_RestoreServiceAdmin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceEvent_RestoreServiceAdmin copyWith(void Function(ServiceEvent_RestoreServiceAdmin) updates) => super.copyWith((message) => updates(message as ServiceEvent_RestoreServiceAdmin)) as ServiceEvent_RestoreServiceAdmin;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_RestoreServiceAdmin create() => ServiceEvent_RestoreServiceAdmin._();
  ServiceEvent_RestoreServiceAdmin createEmptyInstance() => create();
  static $pb.PbList<ServiceEvent_RestoreServiceAdmin> createRepeated() => $pb.PbList<ServiceEvent_RestoreServiceAdmin>();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_RestoreServiceAdmin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceEvent_RestoreServiceAdmin>(create);
  static ServiceEvent_RestoreServiceAdmin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get alias => $_getSZ(1);
  @$pb.TagNumber(2)
  set alias($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAlias() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlias() => clearField(2);

  @$pb.TagNumber(3)
  $1.BloomFilter get filter => $_getN(2);
  @$pb.TagNumber(3)
  set filter($1.BloomFilter v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilter() => clearField(3);
  @$pb.TagNumber(3)
  $1.BloomFilter ensureFilter() => $_ensure(2);
}

class ServiceEvent_MinimumVersionRequired extends $pb.GeneratedMessage {
  factory ServiceEvent_MinimumVersionRequired({
    $core.int? value,
  }) {
    final $result = create();
    if (value != null) {
      $result.value = value;
    }
    return $result;
  }
  ServiceEvent_MinimumVersionRequired._() : super();
  factory ServiceEvent_MinimumVersionRequired.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceEvent_MinimumVersionRequired.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceEvent.MinimumVersionRequired', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'value', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceEvent_MinimumVersionRequired clone() => ServiceEvent_MinimumVersionRequired()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceEvent_MinimumVersionRequired copyWith(void Function(ServiceEvent_MinimumVersionRequired) updates) => super.copyWith((message) => updates(message as ServiceEvent_MinimumVersionRequired)) as ServiceEvent_MinimumVersionRequired;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_MinimumVersionRequired create() => ServiceEvent_MinimumVersionRequired._();
  ServiceEvent_MinimumVersionRequired createEmptyInstance() => create();
  static $pb.PbList<ServiceEvent_MinimumVersionRequired> createRepeated() => $pb.PbList<ServiceEvent_MinimumVersionRequired>();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_MinimumVersionRequired getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceEvent_MinimumVersionRequired>(create);
  static ServiceEvent_MinimumVersionRequired? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get value => $_getIZ(0);
  @$pb.TagNumber(1)
  set value($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

enum ServiceEvent_EventType {
  initialEvent, 
  serviceStatus, 
  terms, 
  privacy, 
  addServiceAdmin, 
  removeServiceAdmin, 
  minVersion, 
  betaUsersFilter, 
  updateServiceAdmin, 
  restoreServiceAdmin, 
  notSet
}

/// these records are permanently stored in firebase and read by the client,
/// so do not include email or any other PII
class ServiceEvent extends $pb.GeneratedMessage {
  factory ServiceEvent({
    $core.int? version,
    $core.int? author,
    ServiceEvent_InitialEvent? initialEvent,
    ServiceEvent_ServiceStatus? serviceStatus,
    ServiceEvent_TermsOfService? terms,
    ServiceEvent_PrivacyPolicy? privacy,
    ServiceEvent_AddServiceAdmin? addServiceAdmin,
    ServiceEvent_RemoveServiceAdmin? removeServiceAdmin,
    ServiceEvent_MinimumVersionRequired? minVersion,
    $1.BloomFilter? betaUsersFilter,
    ServiceEvent_UpdateServiceAdmin? updateServiceAdmin,
    ServiceEvent_RestoreServiceAdmin? restoreServiceAdmin,
  }) {
    final $result = create();
    if (version != null) {
      $result.version = version;
    }
    if (author != null) {
      $result.author = author;
    }
    if (initialEvent != null) {
      $result.initialEvent = initialEvent;
    }
    if (serviceStatus != null) {
      $result.serviceStatus = serviceStatus;
    }
    if (terms != null) {
      $result.terms = terms;
    }
    if (privacy != null) {
      $result.privacy = privacy;
    }
    if (addServiceAdmin != null) {
      $result.addServiceAdmin = addServiceAdmin;
    }
    if (removeServiceAdmin != null) {
      $result.removeServiceAdmin = removeServiceAdmin;
    }
    if (minVersion != null) {
      $result.minVersion = minVersion;
    }
    if (betaUsersFilter != null) {
      $result.betaUsersFilter = betaUsersFilter;
    }
    if (updateServiceAdmin != null) {
      $result.updateServiceAdmin = updateServiceAdmin;
    }
    if (restoreServiceAdmin != null) {
      $result.restoreServiceAdmin = restoreServiceAdmin;
    }
    return $result;
  }
  ServiceEvent._() : super();
  factory ServiceEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, ServiceEvent_EventType> _ServiceEvent_EventTypeByTag = {
    3 : ServiceEvent_EventType.initialEvent,
    4 : ServiceEvent_EventType.serviceStatus,
    5 : ServiceEvent_EventType.terms,
    6 : ServiceEvent_EventType.privacy,
    7 : ServiceEvent_EventType.addServiceAdmin,
    8 : ServiceEvent_EventType.removeServiceAdmin,
    9 : ServiceEvent_EventType.minVersion,
    10 : ServiceEvent_EventType.betaUsersFilter,
    11 : ServiceEvent_EventType.updateServiceAdmin,
    12 : ServiceEvent_EventType.restoreServiceAdmin,
    0 : ServiceEvent_EventType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceEvent', createEmptyInstance: create)
    ..oo(0, [3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
    ..a<$core.int>(1, _omitFieldNames ? '' : 'version', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'author', $pb.PbFieldType.O3)
    ..aOM<ServiceEvent_InitialEvent>(3, _omitFieldNames ? '' : 'initialEvent', protoName: 'initialEvent', subBuilder: ServiceEvent_InitialEvent.create)
    ..aOM<ServiceEvent_ServiceStatus>(4, _omitFieldNames ? '' : 'serviceStatus', protoName: 'serviceStatus', subBuilder: ServiceEvent_ServiceStatus.create)
    ..aOM<ServiceEvent_TermsOfService>(5, _omitFieldNames ? '' : 'terms', subBuilder: ServiceEvent_TermsOfService.create)
    ..aOM<ServiceEvent_PrivacyPolicy>(6, _omitFieldNames ? '' : 'privacy', subBuilder: ServiceEvent_PrivacyPolicy.create)
    ..aOM<ServiceEvent_AddServiceAdmin>(7, _omitFieldNames ? '' : 'addServiceAdmin', protoName: 'addServiceAdmin', subBuilder: ServiceEvent_AddServiceAdmin.create)
    ..aOM<ServiceEvent_RemoveServiceAdmin>(8, _omitFieldNames ? '' : 'removeServiceAdmin', protoName: 'removeServiceAdmin', subBuilder: ServiceEvent_RemoveServiceAdmin.create)
    ..aOM<ServiceEvent_MinimumVersionRequired>(9, _omitFieldNames ? '' : 'minVersion', protoName: 'minVersion', subBuilder: ServiceEvent_MinimumVersionRequired.create)
    ..aOM<$1.BloomFilter>(10, _omitFieldNames ? '' : 'betaUsersFilter', protoName: 'betaUsersFilter', subBuilder: $1.BloomFilter.create)
    ..aOM<ServiceEvent_UpdateServiceAdmin>(11, _omitFieldNames ? '' : 'updateServiceAdmin', protoName: 'updateServiceAdmin', subBuilder: ServiceEvent_UpdateServiceAdmin.create)
    ..aOM<ServiceEvent_RestoreServiceAdmin>(12, _omitFieldNames ? '' : 'restoreServiceAdmin', protoName: 'restoreServiceAdmin', subBuilder: ServiceEvent_RestoreServiceAdmin.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceEvent clone() => ServiceEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceEvent copyWith(void Function(ServiceEvent) updates) => super.copyWith((message) => updates(message as ServiceEvent)) as ServiceEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent create() => ServiceEvent._();
  ServiceEvent createEmptyInstance() => create();
  static $pb.PbList<ServiceEvent> createRepeated() => $pb.PbList<ServiceEvent>();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceEvent>(create);
  static ServiceEvent? _defaultInstance;

  ServiceEvent_EventType whichEventType() => _ServiceEvent_EventTypeByTag[$_whichOneof(0)]!;
  void clearEventType() => clearField($_whichOneof(0));

  /// note: do not store timestamp here, it can be pulled from firebase if needed
  /// the event version, these must be unique and incrementing
  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => clearField(1);

  /// user user that stored this event
  @$pb.TagNumber(2)
  $core.int get author => $_getIZ(1);
  @$pb.TagNumber(2)
  set author($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAuthor() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthor() => clearField(2);

  @$pb.TagNumber(3)
  ServiceEvent_InitialEvent get initialEvent => $_getN(2);
  @$pb.TagNumber(3)
  set initialEvent(ServiceEvent_InitialEvent v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasInitialEvent() => $_has(2);
  @$pb.TagNumber(3)
  void clearInitialEvent() => clearField(3);
  @$pb.TagNumber(3)
  ServiceEvent_InitialEvent ensureInitialEvent() => $_ensure(2);

  @$pb.TagNumber(4)
  ServiceEvent_ServiceStatus get serviceStatus => $_getN(3);
  @$pb.TagNumber(4)
  set serviceStatus(ServiceEvent_ServiceStatus v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasServiceStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearServiceStatus() => clearField(4);
  @$pb.TagNumber(4)
  ServiceEvent_ServiceStatus ensureServiceStatus() => $_ensure(3);

  @$pb.TagNumber(5)
  ServiceEvent_TermsOfService get terms => $_getN(4);
  @$pb.TagNumber(5)
  set terms(ServiceEvent_TermsOfService v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasTerms() => $_has(4);
  @$pb.TagNumber(5)
  void clearTerms() => clearField(5);
  @$pb.TagNumber(5)
  ServiceEvent_TermsOfService ensureTerms() => $_ensure(4);

  @$pb.TagNumber(6)
  ServiceEvent_PrivacyPolicy get privacy => $_getN(5);
  @$pb.TagNumber(6)
  set privacy(ServiceEvent_PrivacyPolicy v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasPrivacy() => $_has(5);
  @$pb.TagNumber(6)
  void clearPrivacy() => clearField(6);
  @$pb.TagNumber(6)
  ServiceEvent_PrivacyPolicy ensurePrivacy() => $_ensure(5);

  @$pb.TagNumber(7)
  ServiceEvent_AddServiceAdmin get addServiceAdmin => $_getN(6);
  @$pb.TagNumber(7)
  set addServiceAdmin(ServiceEvent_AddServiceAdmin v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasAddServiceAdmin() => $_has(6);
  @$pb.TagNumber(7)
  void clearAddServiceAdmin() => clearField(7);
  @$pb.TagNumber(7)
  ServiceEvent_AddServiceAdmin ensureAddServiceAdmin() => $_ensure(6);

  @$pb.TagNumber(8)
  ServiceEvent_RemoveServiceAdmin get removeServiceAdmin => $_getN(7);
  @$pb.TagNumber(8)
  set removeServiceAdmin(ServiceEvent_RemoveServiceAdmin v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasRemoveServiceAdmin() => $_has(7);
  @$pb.TagNumber(8)
  void clearRemoveServiceAdmin() => clearField(8);
  @$pb.TagNumber(8)
  ServiceEvent_RemoveServiceAdmin ensureRemoveServiceAdmin() => $_ensure(7);

  @$pb.TagNumber(9)
  ServiceEvent_MinimumVersionRequired get minVersion => $_getN(8);
  @$pb.TagNumber(9)
  set minVersion(ServiceEvent_MinimumVersionRequired v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasMinVersion() => $_has(8);
  @$pb.TagNumber(9)
  void clearMinVersion() => clearField(9);
  @$pb.TagNumber(9)
  ServiceEvent_MinimumVersionRequired ensureMinVersion() => $_ensure(8);

  @$pb.TagNumber(10)
  $1.BloomFilter get betaUsersFilter => $_getN(9);
  @$pb.TagNumber(10)
  set betaUsersFilter($1.BloomFilter v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasBetaUsersFilter() => $_has(9);
  @$pb.TagNumber(10)
  void clearBetaUsersFilter() => clearField(10);
  @$pb.TagNumber(10)
  $1.BloomFilter ensureBetaUsersFilter() => $_ensure(9);

  @$pb.TagNumber(11)
  ServiceEvent_UpdateServiceAdmin get updateServiceAdmin => $_getN(10);
  @$pb.TagNumber(11)
  set updateServiceAdmin(ServiceEvent_UpdateServiceAdmin v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasUpdateServiceAdmin() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdateServiceAdmin() => clearField(11);
  @$pb.TagNumber(11)
  ServiceEvent_UpdateServiceAdmin ensureUpdateServiceAdmin() => $_ensure(10);

  @$pb.TagNumber(12)
  ServiceEvent_RestoreServiceAdmin get restoreServiceAdmin => $_getN(11);
  @$pb.TagNumber(12)
  set restoreServiceAdmin(ServiceEvent_RestoreServiceAdmin v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasRestoreServiceAdmin() => $_has(11);
  @$pb.TagNumber(12)
  void clearRestoreServiceAdmin() => clearField(12);
  @$pb.TagNumber(12)
  ServiceEvent_RestoreServiceAdmin ensureRestoreServiceAdmin() => $_ensure(11);
}

/// The SubmitServiceEvent is passed to the submit bloc handler, so it can
/// contain PII
class SubmitServiceEvent extends $pb.GeneratedMessage {
  factory SubmitServiceEvent({
    ServiceEvent? event,
    $core.String? email,
    $core.String? betaUsers,
    $core.String? addServiceAdminEmail,
    $core.String? updateServiceAdminOriginalEmail,
    $core.String? updateServiceAdminNewEmail,
    $core.String? removeServiceAdminEmail,
  }) {
    final $result = create();
    if (event != null) {
      $result.event = event;
    }
    if (email != null) {
      $result.email = email;
    }
    if (betaUsers != null) {
      $result.betaUsers = betaUsers;
    }
    if (addServiceAdminEmail != null) {
      $result.addServiceAdminEmail = addServiceAdminEmail;
    }
    if (updateServiceAdminOriginalEmail != null) {
      $result.updateServiceAdminOriginalEmail = updateServiceAdminOriginalEmail;
    }
    if (updateServiceAdminNewEmail != null) {
      $result.updateServiceAdminNewEmail = updateServiceAdminNewEmail;
    }
    if (removeServiceAdminEmail != null) {
      $result.removeServiceAdminEmail = removeServiceAdminEmail;
    }
    return $result;
  }
  SubmitServiceEvent._() : super();
  factory SubmitServiceEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitServiceEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitServiceEvent', createEmptyInstance: create)
    ..aOM<ServiceEvent>(1, _omitFieldNames ? '' : 'event', subBuilder: ServiceEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..aOS(3, _omitFieldNames ? '' : 'betaUsers', protoName: 'betaUsers')
    ..aOS(4, _omitFieldNames ? '' : 'addServiceAdminEmail', protoName: 'addServiceAdminEmail')
    ..aOS(5, _omitFieldNames ? '' : 'updateServiceAdminOriginalEmail', protoName: 'updateServiceAdminOriginalEmail')
    ..aOS(6, _omitFieldNames ? '' : 'updateServiceAdminNewEmail', protoName: 'updateServiceAdminNewEmail')
    ..aOS(7, _omitFieldNames ? '' : 'removeServiceAdminEmail', protoName: 'removeServiceAdminEmail')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitServiceEvent clone() => SubmitServiceEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitServiceEvent copyWith(void Function(SubmitServiceEvent) updates) => super.copyWith((message) => updates(message as SubmitServiceEvent)) as SubmitServiceEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitServiceEvent create() => SubmitServiceEvent._();
  SubmitServiceEvent createEmptyInstance() => create();
  static $pb.PbList<SubmitServiceEvent> createRepeated() => $pb.PbList<SubmitServiceEvent>();
  @$core.pragma('dart2js:noInline')
  static SubmitServiceEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitServiceEvent>(create);
  static SubmitServiceEvent? _defaultInstance;

  @$pb.TagNumber(1)
  ServiceEvent get event => $_getN(0);
  @$pb.TagNumber(1)
  set event(ServiceEvent v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvent() => clearField(1);
  @$pb.TagNumber(1)
  ServiceEvent ensureEvent() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get betaUsers => $_getSZ(2);
  @$pb.TagNumber(3)
  set betaUsers($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBetaUsers() => $_has(2);
  @$pb.TagNumber(3)
  void clearBetaUsers() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get addServiceAdminEmail => $_getSZ(3);
  @$pb.TagNumber(4)
  set addServiceAdminEmail($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAddServiceAdminEmail() => $_has(3);
  @$pb.TagNumber(4)
  void clearAddServiceAdminEmail() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get updateServiceAdminOriginalEmail => $_getSZ(4);
  @$pb.TagNumber(5)
  set updateServiceAdminOriginalEmail($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasUpdateServiceAdminOriginalEmail() => $_has(4);
  @$pb.TagNumber(5)
  void clearUpdateServiceAdminOriginalEmail() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get updateServiceAdminNewEmail => $_getSZ(5);
  @$pb.TagNumber(6)
  set updateServiceAdminNewEmail($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasUpdateServiceAdminNewEmail() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpdateServiceAdminNewEmail() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get removeServiceAdminEmail => $_getSZ(6);
  @$pb.TagNumber(7)
  set removeServiceAdminEmail($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasRemoveServiceAdminEmail() => $_has(6);
  @$pb.TagNumber(7)
  void clearRemoveServiceAdminEmail() => clearField(7);
}

/// The ServiceEventRecord is a representation of the actual record stored in the
/// database This record is used just for display purposes in the client
class ServiceEventRecord extends $pb.GeneratedMessage {
  factory ServiceEventRecord({
    $core.String? isoDate,
    $core.int? version,
    ServiceEvent? serviceEvent,
  }) {
    final $result = create();
    if (isoDate != null) {
      $result.isoDate = isoDate;
    }
    if (version != null) {
      $result.version = version;
    }
    if (serviceEvent != null) {
      $result.serviceEvent = serviceEvent;
    }
    return $result;
  }
  ServiceEventRecord._() : super();
  factory ServiceEventRecord.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceEventRecord.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceEventRecord', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'isoDate', protoName: 'isoDate')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'version', $pb.PbFieldType.O3)
    ..aOM<ServiceEvent>(3, _omitFieldNames ? '' : 'serviceEvent', protoName: 'serviceEvent', subBuilder: ServiceEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceEventRecord clone() => ServiceEventRecord()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceEventRecord copyWith(void Function(ServiceEventRecord) updates) => super.copyWith((message) => updates(message as ServiceEventRecord)) as ServiceEventRecord;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEventRecord create() => ServiceEventRecord._();
  ServiceEventRecord createEmptyInstance() => create();
  static $pb.PbList<ServiceEventRecord> createRepeated() => $pb.PbList<ServiceEventRecord>();
  @$core.pragma('dart2js:noInline')
  static ServiceEventRecord getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceEventRecord>(create);
  static ServiceEventRecord? _defaultInstance;

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
  ServiceEvent get serviceEvent => $_getN(2);
  @$pb.TagNumber(3)
  set serviceEvent(ServiceEvent v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasServiceEvent() => $_has(2);
  @$pb.TagNumber(3)
  void clearServiceEvent() => clearField(3);
  @$pb.TagNumber(3)
  ServiceEvent ensureServiceEvent() => $_ensure(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
