//
//  Generated code. Do not modify.
//  source: site_replay_bloc.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'any.pb.dart' as $2;
import 'common_blocs.pbenum.dart' as $0;

class SiteReplayBlocState_Member extends $pb.GeneratedMessage {
  factory SiteReplayBlocState_Member({
    $core.String? name,
    $core.bool? admin,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (admin != null) {
      $result.admin = admin;
    }
    return $result;
  }
  SiteReplayBlocState_Member._() : super();
  factory SiteReplayBlocState_Member.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SiteReplayBlocState_Member.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SiteReplayBlocState.Member', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOB(2, _omitFieldNames ? '' : 'admin')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SiteReplayBlocState_Member clone() => SiteReplayBlocState_Member()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SiteReplayBlocState_Member copyWith(void Function(SiteReplayBlocState_Member) updates) => super.copyWith((message) => updates(message as SiteReplayBlocState_Member)) as SiteReplayBlocState_Member;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteReplayBlocState_Member create() => SiteReplayBlocState_Member._();
  SiteReplayBlocState_Member createEmptyInstance() => create();
  static $pb.PbList<SiteReplayBlocState_Member> createRepeated() => $pb.PbList<SiteReplayBlocState_Member>();
  @$core.pragma('dart2js:noInline')
  static SiteReplayBlocState_Member getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SiteReplayBlocState_Member>(create);
  static SiteReplayBlocState_Member? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get admin => $_getBF(1);
  @$pb.TagNumber(2)
  set admin($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAdmin() => $_has(1);
  @$pb.TagNumber(2)
  void clearAdmin() => clearField(2);
}

class SiteReplayBlocState extends $pb.GeneratedMessage {
  factory SiteReplayBlocState({
    $0.CommonReplayStateEnum? state,
    $core.Map<$core.int, $core.String>? events,
    $core.String? name,
    $core.Map<$core.int, SiteReplayBlocState_Member>? members,
    $core.Map<$core.int, SiteReplayBlocState_Member>? removedMembers,
    $2.Any? appBlocState,
  }) {
    final $result = create();
    if (state != null) {
      $result.state = state;
    }
    if (events != null) {
      $result.events.addAll(events);
    }
    if (name != null) {
      $result.name = name;
    }
    if (members != null) {
      $result.members.addAll(members);
    }
    if (removedMembers != null) {
      $result.removedMembers.addAll(removedMembers);
    }
    if (appBlocState != null) {
      $result.appBlocState = appBlocState;
    }
    return $result;
  }
  SiteReplayBlocState._() : super();
  factory SiteReplayBlocState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SiteReplayBlocState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SiteReplayBlocState', createEmptyInstance: create)
    ..e<$0.CommonReplayStateEnum>(1, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: $0.CommonReplayStateEnum.ok, valueOf: $0.CommonReplayStateEnum.valueOf, enumValues: $0.CommonReplayStateEnum.values)
    ..m<$core.int, $core.String>(2, _omitFieldNames ? '' : 'events', entryClassName: 'SiteReplayBlocState.EventsEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.OS)
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..m<$core.int, SiteReplayBlocState_Member>(4, _omitFieldNames ? '' : 'members', entryClassName: 'SiteReplayBlocState.MembersEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.OM, valueCreator: SiteReplayBlocState_Member.create, valueDefaultOrMaker: SiteReplayBlocState_Member.getDefault)
    ..m<$core.int, SiteReplayBlocState_Member>(5, _omitFieldNames ? '' : 'removedMembers', protoName: 'removedMembers', entryClassName: 'SiteReplayBlocState.RemovedMembersEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.OM, valueCreator: SiteReplayBlocState_Member.create, valueDefaultOrMaker: SiteReplayBlocState_Member.getDefault)
    ..aOM<$2.Any>(20, _omitFieldNames ? '' : 'appBlocState', protoName: 'appBlocState', subBuilder: $2.Any.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SiteReplayBlocState clone() => SiteReplayBlocState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SiteReplayBlocState copyWith(void Function(SiteReplayBlocState) updates) => super.copyWith((message) => updates(message as SiteReplayBlocState)) as SiteReplayBlocState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteReplayBlocState create() => SiteReplayBlocState._();
  SiteReplayBlocState createEmptyInstance() => create();
  static $pb.PbList<SiteReplayBlocState> createRepeated() => $pb.PbList<SiteReplayBlocState>();
  @$core.pragma('dart2js:noInline')
  static SiteReplayBlocState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SiteReplayBlocState>(create);
  static SiteReplayBlocState? _defaultInstance;

  @$pb.TagNumber(1)
  $0.CommonReplayStateEnum get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.CommonReplayStateEnum v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => clearField(1);

  @$pb.TagNumber(2)
  $core.Map<$core.int, $core.String> get events => $_getMap(1);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.Map<$core.int, SiteReplayBlocState_Member> get members => $_getMap(3);

  @$pb.TagNumber(5)
  $core.Map<$core.int, SiteReplayBlocState_Member> get removedMembers => $_getMap(4);

  @$pb.TagNumber(20)
  $2.Any get appBlocState => $_getN(5);
  @$pb.TagNumber(20)
  set appBlocState($2.Any v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasAppBlocState() => $_has(5);
  @$pb.TagNumber(20)
  void clearAppBlocState() => clearField(20);
  @$pb.TagNumber(20)
  $2.Any ensureAppBlocState() => $_ensure(5);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
