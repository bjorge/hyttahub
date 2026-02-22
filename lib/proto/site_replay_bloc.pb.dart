// This is a generated file - do not edit.
//
// Generated from site_replay_bloc.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common_blocs.pbenum.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class SiteReplayBlocState_Member extends $pb.GeneratedMessage {
  factory SiteReplayBlocState_Member({
    $core.String? name,
    $core.bool? admin,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (admin != null) result.admin = admin;
    return result;
  }

  SiteReplayBlocState_Member._();

  factory SiteReplayBlocState_Member.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SiteReplayBlocState_Member.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SiteReplayBlocState.Member',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOB(2, _omitFieldNames ? '' : 'admin')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SiteReplayBlocState_Member clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SiteReplayBlocState_Member copyWith(
          void Function(SiteReplayBlocState_Member) updates) =>
      super.copyWith(
              (message) => updates(message as SiteReplayBlocState_Member))
          as SiteReplayBlocState_Member;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteReplayBlocState_Member create() => SiteReplayBlocState_Member._();
  @$core.override
  SiteReplayBlocState_Member createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SiteReplayBlocState_Member getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SiteReplayBlocState_Member>(create);
  static SiteReplayBlocState_Member? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get admin => $_getBF(1);
  @$pb.TagNumber(2)
  set admin($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAdmin() => $_has(1);
  @$pb.TagNumber(2)
  void clearAdmin() => $_clearField(2);
}

class SiteReplayBlocState extends $pb.GeneratedMessage {
  factory SiteReplayBlocState({
    $0.CommonReplayStateEnum? state,
    $core.Iterable<$core.MapEntry<$core.int, $core.String>>? events,
    $core.String? name,
    $core.Iterable<$core.MapEntry<$core.int, SiteReplayBlocState_Member>>?
        members,
    $core.Iterable<$core.MapEntry<$core.int, SiteReplayBlocState_Member>>?
        removedMembers,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (events != null) result.events.addEntries(events);
    if (name != null) result.name = name;
    if (members != null) result.members.addEntries(members);
    if (removedMembers != null)
      result.removedMembers.addEntries(removedMembers);
    return result;
  }

  SiteReplayBlocState._();

  factory SiteReplayBlocState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SiteReplayBlocState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SiteReplayBlocState',
      createEmptyInstance: create)
    ..aE<$0.CommonReplayStateEnum>(1, _omitFieldNames ? '' : 'state',
        enumValues: $0.CommonReplayStateEnum.values)
    ..m<$core.int, $core.String>(2, _omitFieldNames ? '' : 'events',
        entryClassName: 'SiteReplayBlocState.EventsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OS)
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..m<$core.int, SiteReplayBlocState_Member>(
        4, _omitFieldNames ? '' : 'members',
        entryClassName: 'SiteReplayBlocState.MembersEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: SiteReplayBlocState_Member.create,
        valueDefaultOrMaker: SiteReplayBlocState_Member.getDefault)
    ..m<$core.int, SiteReplayBlocState_Member>(
        5, _omitFieldNames ? '' : 'removedMembers',
        protoName: 'removedMembers',
        entryClassName: 'SiteReplayBlocState.RemovedMembersEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: SiteReplayBlocState_Member.create,
        valueDefaultOrMaker: SiteReplayBlocState_Member.getDefault)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SiteReplayBlocState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SiteReplayBlocState copyWith(void Function(SiteReplayBlocState) updates) =>
      super.copyWith((message) => updates(message as SiteReplayBlocState))
          as SiteReplayBlocState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteReplayBlocState create() => SiteReplayBlocState._();
  @$core.override
  SiteReplayBlocState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SiteReplayBlocState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SiteReplayBlocState>(create);
  static SiteReplayBlocState? _defaultInstance;

  @$pb.TagNumber(1)
  $0.CommonReplayStateEnum get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.CommonReplayStateEnum value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.int, $core.String> get events => $_getMap(1);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.int, SiteReplayBlocState_Member> get members => $_getMap(3);

  @$pb.TagNumber(5)
  $pb.PbMap<$core.int, SiteReplayBlocState_Member> get removedMembers =>
      $_getMap(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
