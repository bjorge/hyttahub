// This is a generated file - do not edit.
//
// Generated from service_events.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'bloom_filter.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ServiceEvent_InitialEvent extends $pb.GeneratedMessage {
  factory ServiceEvent_InitialEvent({
    $core.String? instance,
    $core.String? alias,
    $0.BloomFilter? filter,
    $core.String? appName,
    $core.String? appId,
  }) {
    final result = create();
    if (instance != null) result.instance = instance;
    if (alias != null) result.alias = alias;
    if (filter != null) result.filter = filter;
    if (appName != null) result.appName = appName;
    if (appId != null) result.appId = appId;
    return result;
  }

  ServiceEvent_InitialEvent._();

  factory ServiceEvent_InitialEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceEvent_InitialEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceEvent.InitialEvent',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'instance')
    ..aOS(2, _omitFieldNames ? '' : 'alias')
    ..aOM<$0.BloomFilter>(3, _omitFieldNames ? '' : 'filter',
        subBuilder: $0.BloomFilter.create)
    ..aOS(4, _omitFieldNames ? '' : 'appName', protoName: 'appName')
    ..aOS(5, _omitFieldNames ? '' : 'appId', protoName: 'appId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_InitialEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_InitialEvent copyWith(
          void Function(ServiceEvent_InitialEvent) updates) =>
      super.copyWith((message) => updates(message as ServiceEvent_InitialEvent))
          as ServiceEvent_InitialEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_InitialEvent create() => ServiceEvent_InitialEvent._();
  @$core.override
  ServiceEvent_InitialEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_InitialEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceEvent_InitialEvent>(create);
  static ServiceEvent_InitialEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instance => $_getSZ(0);
  @$pb.TagNumber(1)
  set instance($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstance() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstance() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get alias => $_getSZ(1);
  @$pb.TagNumber(2)
  set alias($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlias() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlias() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.BloomFilter get filter => $_getN(2);
  @$pb.TagNumber(3)
  set filter($0.BloomFilter value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilter() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.BloomFilter ensureFilter() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get appName => $_getSZ(3);
  @$pb.TagNumber(4)
  set appName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAppName() => $_has(3);
  @$pb.TagNumber(4)
  void clearAppName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get appId => $_getSZ(4);
  @$pb.TagNumber(5)
  set appId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAppId() => $_has(4);
  @$pb.TagNumber(5)
  void clearAppId() => $_clearField(5);
}

class ServiceEvent_ServiceStatus extends $pb.GeneratedMessage {
  factory ServiceEvent_ServiceStatus({
    $core.bool? unavailable,
  }) {
    final result = create();
    if (unavailable != null) result.unavailable = unavailable;
    return result;
  }

  ServiceEvent_ServiceStatus._();

  factory ServiceEvent_ServiceStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceEvent_ServiceStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceEvent.ServiceStatus',
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'unavailable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_ServiceStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_ServiceStatus copyWith(
          void Function(ServiceEvent_ServiceStatus) updates) =>
      super.copyWith(
              (message) => updates(message as ServiceEvent_ServiceStatus))
          as ServiceEvent_ServiceStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_ServiceStatus create() => ServiceEvent_ServiceStatus._();
  @$core.override
  ServiceEvent_ServiceStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_ServiceStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceEvent_ServiceStatus>(create);
  static ServiceEvent_ServiceStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get unavailable => $_getBF(0);
  @$pb.TagNumber(1)
  set unavailable($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnavailable() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnavailable() => $_clearField(1);
}

class ServiceEvent_TermsOfService extends $pb.GeneratedMessage {
  factory ServiceEvent_TermsOfService({
    $core.String? content,
  }) {
    final result = create();
    if (content != null) result.content = content;
    return result;
  }

  ServiceEvent_TermsOfService._();

  factory ServiceEvent_TermsOfService.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceEvent_TermsOfService.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceEvent.TermsOfService',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_TermsOfService clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_TermsOfService copyWith(
          void Function(ServiceEvent_TermsOfService) updates) =>
      super.copyWith(
              (message) => updates(message as ServiceEvent_TermsOfService))
          as ServiceEvent_TermsOfService;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_TermsOfService create() =>
      ServiceEvent_TermsOfService._();
  @$core.override
  ServiceEvent_TermsOfService createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_TermsOfService getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceEvent_TermsOfService>(create);
  static ServiceEvent_TermsOfService? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get content => $_getSZ(0);
  @$pb.TagNumber(1)
  set content($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);
}

class ServiceEvent_PrivacyPolicy extends $pb.GeneratedMessage {
  factory ServiceEvent_PrivacyPolicy({
    $core.String? content,
  }) {
    final result = create();
    if (content != null) result.content = content;
    return result;
  }

  ServiceEvent_PrivacyPolicy._();

  factory ServiceEvent_PrivacyPolicy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceEvent_PrivacyPolicy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceEvent.PrivacyPolicy',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_PrivacyPolicy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_PrivacyPolicy copyWith(
          void Function(ServiceEvent_PrivacyPolicy) updates) =>
      super.copyWith(
              (message) => updates(message as ServiceEvent_PrivacyPolicy))
          as ServiceEvent_PrivacyPolicy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_PrivacyPolicy create() => ServiceEvent_PrivacyPolicy._();
  @$core.override
  ServiceEvent_PrivacyPolicy createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_PrivacyPolicy getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceEvent_PrivacyPolicy>(create);
  static ServiceEvent_PrivacyPolicy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get content => $_getSZ(0);
  @$pb.TagNumber(1)
  set content($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);
}

class ServiceEvent_AddServiceAdmin extends $pb.GeneratedMessage {
  factory ServiceEvent_AddServiceAdmin({
    $core.String? alias,
    $0.BloomFilter? filter,
  }) {
    final result = create();
    if (alias != null) result.alias = alias;
    if (filter != null) result.filter = filter;
    return result;
  }

  ServiceEvent_AddServiceAdmin._();

  factory ServiceEvent_AddServiceAdmin.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceEvent_AddServiceAdmin.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceEvent.AddServiceAdmin',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'alias')
    ..aOM<$0.BloomFilter>(2, _omitFieldNames ? '' : 'filter',
        subBuilder: $0.BloomFilter.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_AddServiceAdmin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_AddServiceAdmin copyWith(
          void Function(ServiceEvent_AddServiceAdmin) updates) =>
      super.copyWith(
              (message) => updates(message as ServiceEvent_AddServiceAdmin))
          as ServiceEvent_AddServiceAdmin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_AddServiceAdmin create() =>
      ServiceEvent_AddServiceAdmin._();
  @$core.override
  ServiceEvent_AddServiceAdmin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_AddServiceAdmin getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceEvent_AddServiceAdmin>(create);
  static ServiceEvent_AddServiceAdmin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get alias => $_getSZ(0);
  @$pb.TagNumber(1)
  set alias($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlias() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlias() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.BloomFilter get filter => $_getN(1);
  @$pb.TagNumber(2)
  set filter($0.BloomFilter value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearFilter() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.BloomFilter ensureFilter() => $_ensure(1);
}

class ServiceEvent_RemoveServiceAdmin extends $pb.GeneratedMessage {
  factory ServiceEvent_RemoveServiceAdmin({
    $core.int? id,
    $0.BloomFilter? filter,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (filter != null) result.filter = filter;
    return result;
  }

  ServiceEvent_RemoveServiceAdmin._();

  factory ServiceEvent_RemoveServiceAdmin.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceEvent_RemoveServiceAdmin.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceEvent.RemoveServiceAdmin',
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOM<$0.BloomFilter>(2, _omitFieldNames ? '' : 'filter',
        subBuilder: $0.BloomFilter.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_RemoveServiceAdmin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_RemoveServiceAdmin copyWith(
          void Function(ServiceEvent_RemoveServiceAdmin) updates) =>
      super.copyWith(
              (message) => updates(message as ServiceEvent_RemoveServiceAdmin))
          as ServiceEvent_RemoveServiceAdmin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_RemoveServiceAdmin create() =>
      ServiceEvent_RemoveServiceAdmin._();
  @$core.override
  ServiceEvent_RemoveServiceAdmin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_RemoveServiceAdmin getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceEvent_RemoveServiceAdmin>(
          create);
  static ServiceEvent_RemoveServiceAdmin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.BloomFilter get filter => $_getN(1);
  @$pb.TagNumber(2)
  set filter($0.BloomFilter value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearFilter() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.BloomFilter ensureFilter() => $_ensure(1);
}

class ServiceEvent_UpdateServiceAdmin extends $pb.GeneratedMessage {
  factory ServiceEvent_UpdateServiceAdmin({
    $core.int? id,
    $core.String? alias,
    $0.BloomFilter? filter,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (alias != null) result.alias = alias;
    if (filter != null) result.filter = filter;
    return result;
  }

  ServiceEvent_UpdateServiceAdmin._();

  factory ServiceEvent_UpdateServiceAdmin.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceEvent_UpdateServiceAdmin.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceEvent.UpdateServiceAdmin',
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'alias')
    ..aOM<$0.BloomFilter>(3, _omitFieldNames ? '' : 'filter',
        subBuilder: $0.BloomFilter.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_UpdateServiceAdmin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_UpdateServiceAdmin copyWith(
          void Function(ServiceEvent_UpdateServiceAdmin) updates) =>
      super.copyWith(
              (message) => updates(message as ServiceEvent_UpdateServiceAdmin))
          as ServiceEvent_UpdateServiceAdmin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_UpdateServiceAdmin create() =>
      ServiceEvent_UpdateServiceAdmin._();
  @$core.override
  ServiceEvent_UpdateServiceAdmin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_UpdateServiceAdmin getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceEvent_UpdateServiceAdmin>(
          create);
  static ServiceEvent_UpdateServiceAdmin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get alias => $_getSZ(1);
  @$pb.TagNumber(2)
  set alias($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlias() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlias() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.BloomFilter get filter => $_getN(2);
  @$pb.TagNumber(3)
  set filter($0.BloomFilter value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilter() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.BloomFilter ensureFilter() => $_ensure(2);
}

class ServiceEvent_RestoreServiceAdmin extends $pb.GeneratedMessage {
  factory ServiceEvent_RestoreServiceAdmin({
    $core.int? id,
    $core.String? alias,
    $0.BloomFilter? filter,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (alias != null) result.alias = alias;
    if (filter != null) result.filter = filter;
    return result;
  }

  ServiceEvent_RestoreServiceAdmin._();

  factory ServiceEvent_RestoreServiceAdmin.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceEvent_RestoreServiceAdmin.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceEvent.RestoreServiceAdmin',
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'alias')
    ..aOM<$0.BloomFilter>(3, _omitFieldNames ? '' : 'filter',
        subBuilder: $0.BloomFilter.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_RestoreServiceAdmin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_RestoreServiceAdmin copyWith(
          void Function(ServiceEvent_RestoreServiceAdmin) updates) =>
      super.copyWith(
              (message) => updates(message as ServiceEvent_RestoreServiceAdmin))
          as ServiceEvent_RestoreServiceAdmin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_RestoreServiceAdmin create() =>
      ServiceEvent_RestoreServiceAdmin._();
  @$core.override
  ServiceEvent_RestoreServiceAdmin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_RestoreServiceAdmin getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceEvent_RestoreServiceAdmin>(
          create);
  static ServiceEvent_RestoreServiceAdmin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get alias => $_getSZ(1);
  @$pb.TagNumber(2)
  set alias($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlias() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlias() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.BloomFilter get filter => $_getN(2);
  @$pb.TagNumber(3)
  set filter($0.BloomFilter value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilter() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.BloomFilter ensureFilter() => $_ensure(2);
}

class ServiceEvent_MinimumVersionRequired extends $pb.GeneratedMessage {
  factory ServiceEvent_MinimumVersionRequired({
    $core.int? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  ServiceEvent_MinimumVersionRequired._();

  factory ServiceEvent_MinimumVersionRequired.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceEvent_MinimumVersionRequired.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceEvent.MinimumVersionRequired',
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_MinimumVersionRequired clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent_MinimumVersionRequired copyWith(
          void Function(ServiceEvent_MinimumVersionRequired) updates) =>
      super.copyWith((message) =>
              updates(message as ServiceEvent_MinimumVersionRequired))
          as ServiceEvent_MinimumVersionRequired;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent_MinimumVersionRequired create() =>
      ServiceEvent_MinimumVersionRequired._();
  @$core.override
  ServiceEvent_MinimumVersionRequired createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent_MinimumVersionRequired getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          ServiceEvent_MinimumVersionRequired>(create);
  static ServiceEvent_MinimumVersionRequired? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get value => $_getIZ(0);
  @$pb.TagNumber(1)
  set value($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
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
    $0.BloomFilter? betaUsersFilter,
    ServiceEvent_UpdateServiceAdmin? updateServiceAdmin,
    ServiceEvent_RestoreServiceAdmin? restoreServiceAdmin,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (author != null) result.author = author;
    if (initialEvent != null) result.initialEvent = initialEvent;
    if (serviceStatus != null) result.serviceStatus = serviceStatus;
    if (terms != null) result.terms = terms;
    if (privacy != null) result.privacy = privacy;
    if (addServiceAdmin != null) result.addServiceAdmin = addServiceAdmin;
    if (removeServiceAdmin != null)
      result.removeServiceAdmin = removeServiceAdmin;
    if (minVersion != null) result.minVersion = minVersion;
    if (betaUsersFilter != null) result.betaUsersFilter = betaUsersFilter;
    if (updateServiceAdmin != null)
      result.updateServiceAdmin = updateServiceAdmin;
    if (restoreServiceAdmin != null)
      result.restoreServiceAdmin = restoreServiceAdmin;
    return result;
  }

  ServiceEvent._();

  factory ServiceEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ServiceEvent_EventType>
      _ServiceEvent_EventTypeByTag = {
    3: ServiceEvent_EventType.initialEvent,
    4: ServiceEvent_EventType.serviceStatus,
    5: ServiceEvent_EventType.terms,
    6: ServiceEvent_EventType.privacy,
    7: ServiceEvent_EventType.addServiceAdmin,
    8: ServiceEvent_EventType.removeServiceAdmin,
    9: ServiceEvent_EventType.minVersion,
    10: ServiceEvent_EventType.betaUsersFilter,
    11: ServiceEvent_EventType.updateServiceAdmin,
    12: ServiceEvent_EventType.restoreServiceAdmin,
    0: ServiceEvent_EventType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceEvent',
      createEmptyInstance: create)
    ..oo(0, [3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
    ..aI(1, _omitFieldNames ? '' : 'version')
    ..aI(2, _omitFieldNames ? '' : 'author')
    ..aOM<ServiceEvent_InitialEvent>(3, _omitFieldNames ? '' : 'initialEvent',
        protoName: 'initialEvent', subBuilder: ServiceEvent_InitialEvent.create)
    ..aOM<ServiceEvent_ServiceStatus>(4, _omitFieldNames ? '' : 'serviceStatus',
        protoName: 'serviceStatus',
        subBuilder: ServiceEvent_ServiceStatus.create)
    ..aOM<ServiceEvent_TermsOfService>(5, _omitFieldNames ? '' : 'terms',
        subBuilder: ServiceEvent_TermsOfService.create)
    ..aOM<ServiceEvent_PrivacyPolicy>(6, _omitFieldNames ? '' : 'privacy',
        subBuilder: ServiceEvent_PrivacyPolicy.create)
    ..aOM<ServiceEvent_AddServiceAdmin>(
        7, _omitFieldNames ? '' : 'addServiceAdmin',
        protoName: 'addServiceAdmin',
        subBuilder: ServiceEvent_AddServiceAdmin.create)
    ..aOM<ServiceEvent_RemoveServiceAdmin>(
        8, _omitFieldNames ? '' : 'removeServiceAdmin',
        protoName: 'removeServiceAdmin',
        subBuilder: ServiceEvent_RemoveServiceAdmin.create)
    ..aOM<ServiceEvent_MinimumVersionRequired>(
        9, _omitFieldNames ? '' : 'minVersion',
        protoName: 'minVersion',
        subBuilder: ServiceEvent_MinimumVersionRequired.create)
    ..aOM<$0.BloomFilter>(10, _omitFieldNames ? '' : 'betaUsersFilter',
        protoName: 'betaUsersFilter', subBuilder: $0.BloomFilter.create)
    ..aOM<ServiceEvent_UpdateServiceAdmin>(
        11, _omitFieldNames ? '' : 'updateServiceAdmin',
        protoName: 'updateServiceAdmin',
        subBuilder: ServiceEvent_UpdateServiceAdmin.create)
    ..aOM<ServiceEvent_RestoreServiceAdmin>(
        12, _omitFieldNames ? '' : 'restoreServiceAdmin',
        protoName: 'restoreServiceAdmin',
        subBuilder: ServiceEvent_RestoreServiceAdmin.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvent copyWith(void Function(ServiceEvent) updates) =>
      super.copyWith((message) => updates(message as ServiceEvent))
          as ServiceEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvent create() => ServiceEvent._();
  @$core.override
  ServiceEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceEvent>(create);
  static ServiceEvent? _defaultInstance;

  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  ServiceEvent_EventType whichEventType() =>
      _ServiceEvent_EventTypeByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  void clearEventType() => $_clearField($_whichOneof(0));

  /// note: do not store timestamp here, it can be pulled from firebase if needed
  /// the event version, these must be unique and incrementing
  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  /// user user that stored this event
  @$pb.TagNumber(2)
  $core.int get author => $_getIZ(1);
  @$pb.TagNumber(2)
  set author($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAuthor() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthor() => $_clearField(2);

  @$pb.TagNumber(3)
  ServiceEvent_InitialEvent get initialEvent => $_getN(2);
  @$pb.TagNumber(3)
  set initialEvent(ServiceEvent_InitialEvent value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasInitialEvent() => $_has(2);
  @$pb.TagNumber(3)
  void clearInitialEvent() => $_clearField(3);
  @$pb.TagNumber(3)
  ServiceEvent_InitialEvent ensureInitialEvent() => $_ensure(2);

  @$pb.TagNumber(4)
  ServiceEvent_ServiceStatus get serviceStatus => $_getN(3);
  @$pb.TagNumber(4)
  set serviceStatus(ServiceEvent_ServiceStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasServiceStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearServiceStatus() => $_clearField(4);
  @$pb.TagNumber(4)
  ServiceEvent_ServiceStatus ensureServiceStatus() => $_ensure(3);

  @$pb.TagNumber(5)
  ServiceEvent_TermsOfService get terms => $_getN(4);
  @$pb.TagNumber(5)
  set terms(ServiceEvent_TermsOfService value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTerms() => $_has(4);
  @$pb.TagNumber(5)
  void clearTerms() => $_clearField(5);
  @$pb.TagNumber(5)
  ServiceEvent_TermsOfService ensureTerms() => $_ensure(4);

  @$pb.TagNumber(6)
  ServiceEvent_PrivacyPolicy get privacy => $_getN(5);
  @$pb.TagNumber(6)
  set privacy(ServiceEvent_PrivacyPolicy value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPrivacy() => $_has(5);
  @$pb.TagNumber(6)
  void clearPrivacy() => $_clearField(6);
  @$pb.TagNumber(6)
  ServiceEvent_PrivacyPolicy ensurePrivacy() => $_ensure(5);

  @$pb.TagNumber(7)
  ServiceEvent_AddServiceAdmin get addServiceAdmin => $_getN(6);
  @$pb.TagNumber(7)
  set addServiceAdmin(ServiceEvent_AddServiceAdmin value) =>
      $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAddServiceAdmin() => $_has(6);
  @$pb.TagNumber(7)
  void clearAddServiceAdmin() => $_clearField(7);
  @$pb.TagNumber(7)
  ServiceEvent_AddServiceAdmin ensureAddServiceAdmin() => $_ensure(6);

  @$pb.TagNumber(8)
  ServiceEvent_RemoveServiceAdmin get removeServiceAdmin => $_getN(7);
  @$pb.TagNumber(8)
  set removeServiceAdmin(ServiceEvent_RemoveServiceAdmin value) =>
      $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRemoveServiceAdmin() => $_has(7);
  @$pb.TagNumber(8)
  void clearRemoveServiceAdmin() => $_clearField(8);
  @$pb.TagNumber(8)
  ServiceEvent_RemoveServiceAdmin ensureRemoveServiceAdmin() => $_ensure(7);

  @$pb.TagNumber(9)
  ServiceEvent_MinimumVersionRequired get minVersion => $_getN(8);
  @$pb.TagNumber(9)
  set minVersion(ServiceEvent_MinimumVersionRequired value) =>
      $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasMinVersion() => $_has(8);
  @$pb.TagNumber(9)
  void clearMinVersion() => $_clearField(9);
  @$pb.TagNumber(9)
  ServiceEvent_MinimumVersionRequired ensureMinVersion() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.BloomFilter get betaUsersFilter => $_getN(9);
  @$pb.TagNumber(10)
  set betaUsersFilter($0.BloomFilter value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasBetaUsersFilter() => $_has(9);
  @$pb.TagNumber(10)
  void clearBetaUsersFilter() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.BloomFilter ensureBetaUsersFilter() => $_ensure(9);

  @$pb.TagNumber(11)
  ServiceEvent_UpdateServiceAdmin get updateServiceAdmin => $_getN(10);
  @$pb.TagNumber(11)
  set updateServiceAdmin(ServiceEvent_UpdateServiceAdmin value) =>
      $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUpdateServiceAdmin() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdateServiceAdmin() => $_clearField(11);
  @$pb.TagNumber(11)
  ServiceEvent_UpdateServiceAdmin ensureUpdateServiceAdmin() => $_ensure(10);

  @$pb.TagNumber(12)
  ServiceEvent_RestoreServiceAdmin get restoreServiceAdmin => $_getN(11);
  @$pb.TagNumber(12)
  set restoreServiceAdmin(ServiceEvent_RestoreServiceAdmin value) =>
      $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasRestoreServiceAdmin() => $_has(11);
  @$pb.TagNumber(12)
  void clearRestoreServiceAdmin() => $_clearField(12);
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
    final result = create();
    if (event != null) result.event = event;
    if (email != null) result.email = email;
    if (betaUsers != null) result.betaUsers = betaUsers;
    if (addServiceAdminEmail != null)
      result.addServiceAdminEmail = addServiceAdminEmail;
    if (updateServiceAdminOriginalEmail != null)
      result.updateServiceAdminOriginalEmail = updateServiceAdminOriginalEmail;
    if (updateServiceAdminNewEmail != null)
      result.updateServiceAdminNewEmail = updateServiceAdminNewEmail;
    if (removeServiceAdminEmail != null)
      result.removeServiceAdminEmail = removeServiceAdminEmail;
    return result;
  }

  SubmitServiceEvent._();

  factory SubmitServiceEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubmitServiceEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubmitServiceEvent',
      createEmptyInstance: create)
    ..aOM<ServiceEvent>(1, _omitFieldNames ? '' : 'event',
        subBuilder: ServiceEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..aOS(3, _omitFieldNames ? '' : 'betaUsers', protoName: 'betaUsers')
    ..aOS(4, _omitFieldNames ? '' : 'addServiceAdminEmail',
        protoName: 'addServiceAdminEmail')
    ..aOS(5, _omitFieldNames ? '' : 'updateServiceAdminOriginalEmail',
        protoName: 'updateServiceAdminOriginalEmail')
    ..aOS(6, _omitFieldNames ? '' : 'updateServiceAdminNewEmail',
        protoName: 'updateServiceAdminNewEmail')
    ..aOS(7, _omitFieldNames ? '' : 'removeServiceAdminEmail',
        protoName: 'removeServiceAdminEmail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitServiceEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitServiceEvent copyWith(void Function(SubmitServiceEvent) updates) =>
      super.copyWith((message) => updates(message as SubmitServiceEvent))
          as SubmitServiceEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitServiceEvent create() => SubmitServiceEvent._();
  @$core.override
  SubmitServiceEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubmitServiceEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubmitServiceEvent>(create);
  static SubmitServiceEvent? _defaultInstance;

  @$pb.TagNumber(1)
  ServiceEvent get event => $_getN(0);
  @$pb.TagNumber(1)
  set event(ServiceEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  ServiceEvent ensureEvent() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get betaUsers => $_getSZ(2);
  @$pb.TagNumber(3)
  set betaUsers($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBetaUsers() => $_has(2);
  @$pb.TagNumber(3)
  void clearBetaUsers() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get addServiceAdminEmail => $_getSZ(3);
  @$pb.TagNumber(4)
  set addServiceAdminEmail($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAddServiceAdminEmail() => $_has(3);
  @$pb.TagNumber(4)
  void clearAddServiceAdminEmail() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get updateServiceAdminOriginalEmail => $_getSZ(4);
  @$pb.TagNumber(5)
  set updateServiceAdminOriginalEmail($core.String value) =>
      $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUpdateServiceAdminOriginalEmail() => $_has(4);
  @$pb.TagNumber(5)
  void clearUpdateServiceAdminOriginalEmail() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get updateServiceAdminNewEmail => $_getSZ(5);
  @$pb.TagNumber(6)
  set updateServiceAdminNewEmail($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUpdateServiceAdminNewEmail() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpdateServiceAdminNewEmail() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get removeServiceAdminEmail => $_getSZ(6);
  @$pb.TagNumber(7)
  set removeServiceAdminEmail($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRemoveServiceAdminEmail() => $_has(6);
  @$pb.TagNumber(7)
  void clearRemoveServiceAdminEmail() => $_clearField(7);
}

/// The ServiceEventRecord is a representation of the actual record stored in the
/// database This record is used just for display purposes in the client
class ServiceEventRecord extends $pb.GeneratedMessage {
  factory ServiceEventRecord({
    $core.String? isoDate,
    $core.int? version,
    ServiceEvent? serviceEvent,
  }) {
    final result = create();
    if (isoDate != null) result.isoDate = isoDate;
    if (version != null) result.version = version;
    if (serviceEvent != null) result.serviceEvent = serviceEvent;
    return result;
  }

  ServiceEventRecord._();

  factory ServiceEventRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceEventRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceEventRecord',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'isoDate', protoName: 'isoDate')
    ..aI(2, _omitFieldNames ? '' : 'version')
    ..aOM<ServiceEvent>(3, _omitFieldNames ? '' : 'serviceEvent',
        protoName: 'serviceEvent', subBuilder: ServiceEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEventRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEventRecord copyWith(void Function(ServiceEventRecord) updates) =>
      super.copyWith((message) => updates(message as ServiceEventRecord))
          as ServiceEventRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEventRecord create() => ServiceEventRecord._();
  @$core.override
  ServiceEventRecord createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceEventRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceEventRecord>(create);
  static ServiceEventRecord? _defaultInstance;

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
  ServiceEvent get serviceEvent => $_getN(2);
  @$pb.TagNumber(3)
  set serviceEvent(ServiceEvent value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasServiceEvent() => $_has(2);
  @$pb.TagNumber(3)
  void clearServiceEvent() => $_clearField(3);
  @$pb.TagNumber(3)
  ServiceEvent ensureServiceEvent() => $_ensure(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
