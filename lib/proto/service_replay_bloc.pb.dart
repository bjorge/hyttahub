//
//  Generated code. Do not modify.
//  source: service_replay_bloc.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'bloom_filter.pb.dart' as $1;
import 'common_blocs.pbenum.dart' as $0;

class ServiceAdmin extends $pb.GeneratedMessage {
  factory ServiceAdmin({
    $core.String? alias,
  }) {
    final $result = create();
    if (alias != null) {
      $result.alias = alias;
    }
    return $result;
  }
  ServiceAdmin._() : super();
  factory ServiceAdmin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceAdmin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceAdmin', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'alias')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceAdmin clone() => ServiceAdmin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceAdmin copyWith(void Function(ServiceAdmin) updates) => super.copyWith((message) => updates(message as ServiceAdmin)) as ServiceAdmin;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceAdmin create() => ServiceAdmin._();
  ServiceAdmin createEmptyInstance() => create();
  static $pb.PbList<ServiceAdmin> createRepeated() => $pb.PbList<ServiceAdmin>();
  @$core.pragma('dart2js:noInline')
  static ServiceAdmin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceAdmin>(create);
  static ServiceAdmin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get alias => $_getSZ(0);
  @$pb.TagNumber(1)
  set alias($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAlias() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlias() => clearField(1);
}

class ServiceReplayBlocState extends $pb.GeneratedMessage {
  factory ServiceReplayBlocState({
    $core.int? minVersion,
    $core.bool? serviceUnavailable,
    $core.String? terms,
    $core.int? termsVersion,
    $core.String? privacy,
    $core.int? privacyVersion,
    $0.CommonReplayStateEnum? state,
    $core.Map<$core.int, $core.String>? events,
    $core.Map<$core.int, ServiceAdmin>? serviceAdmins,
    $1.BloomFilter? filter,
    $core.String? instance,
    $1.BloomFilter? betaUsersFilter,
    $core.Map<$core.int, ServiceAdmin>? removedServiceAdmins,
    $core.String? appName,
    $core.String? appId,
  }) {
    final $result = create();
    if (minVersion != null) {
      $result.minVersion = minVersion;
    }
    if (serviceUnavailable != null) {
      $result.serviceUnavailable = serviceUnavailable;
    }
    if (terms != null) {
      $result.terms = terms;
    }
    if (termsVersion != null) {
      $result.termsVersion = termsVersion;
    }
    if (privacy != null) {
      $result.privacy = privacy;
    }
    if (privacyVersion != null) {
      $result.privacyVersion = privacyVersion;
    }
    if (state != null) {
      $result.state = state;
    }
    if (events != null) {
      $result.events.addAll(events);
    }
    if (serviceAdmins != null) {
      $result.serviceAdmins.addAll(serviceAdmins);
    }
    if (filter != null) {
      $result.filter = filter;
    }
    if (instance != null) {
      $result.instance = instance;
    }
    if (betaUsersFilter != null) {
      $result.betaUsersFilter = betaUsersFilter;
    }
    if (removedServiceAdmins != null) {
      $result.removedServiceAdmins.addAll(removedServiceAdmins);
    }
    if (appName != null) {
      $result.appName = appName;
    }
    if (appId != null) {
      $result.appId = appId;
    }
    return $result;
  }
  ServiceReplayBlocState._() : super();
  factory ServiceReplayBlocState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceReplayBlocState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceReplayBlocState', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'minVersion', $pb.PbFieldType.O3, protoName: 'minVersion')
    ..aOB(2, _omitFieldNames ? '' : 'serviceUnavailable', protoName: 'serviceUnavailable')
    ..aOS(3, _omitFieldNames ? '' : 'terms')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'termsVersion', $pb.PbFieldType.O3, protoName: 'termsVersion')
    ..aOS(5, _omitFieldNames ? '' : 'privacy')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'privacyVersion', $pb.PbFieldType.O3, protoName: 'privacyVersion')
    ..e<$0.CommonReplayStateEnum>(7, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: $0.CommonReplayStateEnum.ok, valueOf: $0.CommonReplayStateEnum.valueOf, enumValues: $0.CommonReplayStateEnum.values)
    ..m<$core.int, $core.String>(8, _omitFieldNames ? '' : 'events', entryClassName: 'ServiceReplayBlocState.EventsEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.OS)
    ..m<$core.int, ServiceAdmin>(9, _omitFieldNames ? '' : 'serviceAdmins', protoName: 'serviceAdmins', entryClassName: 'ServiceReplayBlocState.ServiceAdminsEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.OM, valueCreator: ServiceAdmin.create, valueDefaultOrMaker: ServiceAdmin.getDefault)
    ..aOM<$1.BloomFilter>(10, _omitFieldNames ? '' : 'filter', subBuilder: $1.BloomFilter.create)
    ..aOS(11, _omitFieldNames ? '' : 'instance')
    ..aOM<$1.BloomFilter>(12, _omitFieldNames ? '' : 'betaUsersFilter', protoName: 'betaUsersFilter', subBuilder: $1.BloomFilter.create)
    ..m<$core.int, ServiceAdmin>(13, _omitFieldNames ? '' : 'removedServiceAdmins', protoName: 'removedServiceAdmins', entryClassName: 'ServiceReplayBlocState.RemovedServiceAdminsEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.OM, valueCreator: ServiceAdmin.create, valueDefaultOrMaker: ServiceAdmin.getDefault)
    ..aOS(14, _omitFieldNames ? '' : 'appName', protoName: 'appName')
    ..aOS(15, _omitFieldNames ? '' : 'appId', protoName: 'appId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceReplayBlocState clone() => ServiceReplayBlocState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceReplayBlocState copyWith(void Function(ServiceReplayBlocState) updates) => super.copyWith((message) => updates(message as ServiceReplayBlocState)) as ServiceReplayBlocState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceReplayBlocState create() => ServiceReplayBlocState._();
  ServiceReplayBlocState createEmptyInstance() => create();
  static $pb.PbList<ServiceReplayBlocState> createRepeated() => $pb.PbList<ServiceReplayBlocState>();
  @$core.pragma('dart2js:noInline')
  static ServiceReplayBlocState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceReplayBlocState>(create);
  static ServiceReplayBlocState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get minVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set minVersion($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMinVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get serviceUnavailable => $_getBF(1);
  @$pb.TagNumber(2)
  set serviceUnavailable($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServiceUnavailable() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceUnavailable() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get terms => $_getSZ(2);
  @$pb.TagNumber(3)
  set terms($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTerms() => $_has(2);
  @$pb.TagNumber(3)
  void clearTerms() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get termsVersion => $_getIZ(3);
  @$pb.TagNumber(4)
  set termsVersion($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTermsVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearTermsVersion() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get privacy => $_getSZ(4);
  @$pb.TagNumber(5)
  set privacy($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPrivacy() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrivacy() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get privacyVersion => $_getIZ(5);
  @$pb.TagNumber(6)
  set privacyVersion($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPrivacyVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearPrivacyVersion() => clearField(6);

  @$pb.TagNumber(7)
  $0.CommonReplayStateEnum get state => $_getN(6);
  @$pb.TagNumber(7)
  set state($0.CommonReplayStateEnum v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasState() => $_has(6);
  @$pb.TagNumber(7)
  void clearState() => clearField(7);

  @$pb.TagNumber(8)
  $core.Map<$core.int, $core.String> get events => $_getMap(7);

  @$pb.TagNumber(9)
  $core.Map<$core.int, ServiceAdmin> get serviceAdmins => $_getMap(8);

  @$pb.TagNumber(10)
  $1.BloomFilter get filter => $_getN(9);
  @$pb.TagNumber(10)
  set filter($1.BloomFilter v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasFilter() => $_has(9);
  @$pb.TagNumber(10)
  void clearFilter() => clearField(10);
  @$pb.TagNumber(10)
  $1.BloomFilter ensureFilter() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get instance => $_getSZ(10);
  @$pb.TagNumber(11)
  set instance($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasInstance() => $_has(10);
  @$pb.TagNumber(11)
  void clearInstance() => clearField(11);

  @$pb.TagNumber(12)
  $1.BloomFilter get betaUsersFilter => $_getN(11);
  @$pb.TagNumber(12)
  set betaUsersFilter($1.BloomFilter v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasBetaUsersFilter() => $_has(11);
  @$pb.TagNumber(12)
  void clearBetaUsersFilter() => clearField(12);
  @$pb.TagNumber(12)
  $1.BloomFilter ensureBetaUsersFilter() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.Map<$core.int, ServiceAdmin> get removedServiceAdmins => $_getMap(12);

  @$pb.TagNumber(14)
  $core.String get appName => $_getSZ(13);
  @$pb.TagNumber(14)
  set appName($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasAppName() => $_has(13);
  @$pb.TagNumber(14)
  void clearAppName() => clearField(14);

  @$pb.TagNumber(15)
  $core.String get appId => $_getSZ(14);
  @$pb.TagNumber(15)
  set appId($core.String v) { $_setString(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasAppId() => $_has(14);
  @$pb.TagNumber(15)
  void clearAppId() => clearField(15);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
