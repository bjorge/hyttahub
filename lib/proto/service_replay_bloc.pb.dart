// This is a generated file - do not edit.
//
// Generated from service_replay_bloc.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'bloom_filter.pb.dart' as $0;
import 'common_blocs.pbenum.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ServiceAdmin extends $pb.GeneratedMessage {
  factory ServiceAdmin({
    $core.String? alias,
  }) {
    final result = create();
    if (alias != null) result.alias = alias;
    return result;
  }

  ServiceAdmin._();

  factory ServiceAdmin.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceAdmin.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceAdmin',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'alias')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceAdmin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceAdmin copyWith(void Function(ServiceAdmin) updates) =>
      super.copyWith((message) => updates(message as ServiceAdmin))
          as ServiceAdmin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceAdmin create() => ServiceAdmin._();
  @$core.override
  ServiceAdmin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceAdmin getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceAdmin>(create);
  static ServiceAdmin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get alias => $_getSZ(0);
  @$pb.TagNumber(1)
  set alias($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlias() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlias() => $_clearField(1);
}

class ServiceReplayBlocState extends $pb.GeneratedMessage {
  factory ServiceReplayBlocState({
    $core.int? minVersion,
    $core.bool? serviceUnavailable,
    $core.String? terms,
    $core.int? termsVersion,
    $core.String? privacy,
    $core.int? privacyVersion,
    $1.CommonReplayStateEnum? state,
    $core.Iterable<$core.MapEntry<$core.int, $core.String>>? events,
    $core.Iterable<$core.MapEntry<$core.int, ServiceAdmin>>? serviceAdmins,
    $0.BloomFilter? filter,
    $core.String? instance,
    $0.BloomFilter? betaUsersFilter,
    $core.Iterable<$core.MapEntry<$core.int, ServiceAdmin>>?
        removedServiceAdmins,
    $core.String? appName,
    $core.String? appId,
  }) {
    final result = create();
    if (minVersion != null) result.minVersion = minVersion;
    if (serviceUnavailable != null)
      result.serviceUnavailable = serviceUnavailable;
    if (terms != null) result.terms = terms;
    if (termsVersion != null) result.termsVersion = termsVersion;
    if (privacy != null) result.privacy = privacy;
    if (privacyVersion != null) result.privacyVersion = privacyVersion;
    if (state != null) result.state = state;
    if (events != null) result.events.addEntries(events);
    if (serviceAdmins != null) result.serviceAdmins.addEntries(serviceAdmins);
    if (filter != null) result.filter = filter;
    if (instance != null) result.instance = instance;
    if (betaUsersFilter != null) result.betaUsersFilter = betaUsersFilter;
    if (removedServiceAdmins != null)
      result.removedServiceAdmins.addEntries(removedServiceAdmins);
    if (appName != null) result.appName = appName;
    if (appId != null) result.appId = appId;
    return result;
  }

  ServiceReplayBlocState._();

  factory ServiceReplayBlocState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceReplayBlocState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceReplayBlocState',
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'minVersion', protoName: 'minVersion')
    ..aOB(2, _omitFieldNames ? '' : 'serviceUnavailable',
        protoName: 'serviceUnavailable')
    ..aOS(3, _omitFieldNames ? '' : 'terms')
    ..aI(4, _omitFieldNames ? '' : 'termsVersion', protoName: 'termsVersion')
    ..aOS(5, _omitFieldNames ? '' : 'privacy')
    ..aI(6, _omitFieldNames ? '' : 'privacyVersion',
        protoName: 'privacyVersion')
    ..aE<$1.CommonReplayStateEnum>(7, _omitFieldNames ? '' : 'state',
        enumValues: $1.CommonReplayStateEnum.values)
    ..m<$core.int, $core.String>(8, _omitFieldNames ? '' : 'events',
        entryClassName: 'ServiceReplayBlocState.EventsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OS)
    ..m<$core.int, ServiceAdmin>(9, _omitFieldNames ? '' : 'serviceAdmins',
        protoName: 'serviceAdmins',
        entryClassName: 'ServiceReplayBlocState.ServiceAdminsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: ServiceAdmin.create,
        valueDefaultOrMaker: ServiceAdmin.getDefault)
    ..aOM<$0.BloomFilter>(10, _omitFieldNames ? '' : 'filter',
        subBuilder: $0.BloomFilter.create)
    ..aOS(11, _omitFieldNames ? '' : 'instance')
    ..aOM<$0.BloomFilter>(12, _omitFieldNames ? '' : 'betaUsersFilter',
        protoName: 'betaUsersFilter', subBuilder: $0.BloomFilter.create)
    ..m<$core.int, ServiceAdmin>(
        13, _omitFieldNames ? '' : 'removedServiceAdmins',
        protoName: 'removedServiceAdmins',
        entryClassName: 'ServiceReplayBlocState.RemovedServiceAdminsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: ServiceAdmin.create,
        valueDefaultOrMaker: ServiceAdmin.getDefault)
    ..aOS(14, _omitFieldNames ? '' : 'appName', protoName: 'appName')
    ..aOS(15, _omitFieldNames ? '' : 'appId', protoName: 'appId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceReplayBlocState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceReplayBlocState copyWith(
          void Function(ServiceReplayBlocState) updates) =>
      super.copyWith((message) => updates(message as ServiceReplayBlocState))
          as ServiceReplayBlocState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceReplayBlocState create() => ServiceReplayBlocState._();
  @$core.override
  ServiceReplayBlocState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceReplayBlocState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceReplayBlocState>(create);
  static ServiceReplayBlocState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get minVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set minVersion($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMinVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get serviceUnavailable => $_getBF(1);
  @$pb.TagNumber(2)
  set serviceUnavailable($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServiceUnavailable() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceUnavailable() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get terms => $_getSZ(2);
  @$pb.TagNumber(3)
  set terms($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTerms() => $_has(2);
  @$pb.TagNumber(3)
  void clearTerms() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get termsVersion => $_getIZ(3);
  @$pb.TagNumber(4)
  set termsVersion($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTermsVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearTermsVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get privacy => $_getSZ(4);
  @$pb.TagNumber(5)
  set privacy($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPrivacy() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrivacy() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get privacyVersion => $_getIZ(5);
  @$pb.TagNumber(6)
  set privacyVersion($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPrivacyVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearPrivacyVersion() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.CommonReplayStateEnum get state => $_getN(6);
  @$pb.TagNumber(7)
  set state($1.CommonReplayStateEnum value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasState() => $_has(6);
  @$pb.TagNumber(7)
  void clearState() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbMap<$core.int, $core.String> get events => $_getMap(7);

  @$pb.TagNumber(9)
  $pb.PbMap<$core.int, ServiceAdmin> get serviceAdmins => $_getMap(8);

  @$pb.TagNumber(10)
  $0.BloomFilter get filter => $_getN(9);
  @$pb.TagNumber(10)
  set filter($0.BloomFilter value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasFilter() => $_has(9);
  @$pb.TagNumber(10)
  void clearFilter() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.BloomFilter ensureFilter() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get instance => $_getSZ(10);
  @$pb.TagNumber(11)
  set instance($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasInstance() => $_has(10);
  @$pb.TagNumber(11)
  void clearInstance() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.BloomFilter get betaUsersFilter => $_getN(11);
  @$pb.TagNumber(12)
  set betaUsersFilter($0.BloomFilter value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasBetaUsersFilter() => $_has(11);
  @$pb.TagNumber(12)
  void clearBetaUsersFilter() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.BloomFilter ensureBetaUsersFilter() => $_ensure(11);

  @$pb.TagNumber(13)
  $pb.PbMap<$core.int, ServiceAdmin> get removedServiceAdmins => $_getMap(12);

  @$pb.TagNumber(14)
  $core.String get appName => $_getSZ(13);
  @$pb.TagNumber(14)
  set appName($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasAppName() => $_has(13);
  @$pb.TagNumber(14)
  void clearAppName() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get appId => $_getSZ(14);
  @$pb.TagNumber(15)
  set appId($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasAppId() => $_has(14);
  @$pb.TagNumber(15)
  void clearAppId() => $_clearField(15);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
