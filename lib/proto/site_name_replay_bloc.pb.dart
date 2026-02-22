// This is a generated file - do not edit.
//
// Generated from site_name_replay_bloc.proto.

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

class SiteNameReplayBlocState extends $pb.GeneratedMessage {
  factory SiteNameReplayBlocState({
    $0.CommonReplayStateEnum? state,
    $core.String? name,
    $core.Iterable<$core.MapEntry<$core.int, $core.String>>? events,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (name != null) result.name = name;
    if (events != null) result.events.addEntries(events);
    return result;
  }

  SiteNameReplayBlocState._();

  factory SiteNameReplayBlocState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SiteNameReplayBlocState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SiteNameReplayBlocState',
      createEmptyInstance: create)
    ..aE<$0.CommonReplayStateEnum>(1, _omitFieldNames ? '' : 'state',
        enumValues: $0.CommonReplayStateEnum.values)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..m<$core.int, $core.String>(3, _omitFieldNames ? '' : 'events',
        entryClassName: 'SiteNameReplayBlocState.EventsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OS)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SiteNameReplayBlocState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SiteNameReplayBlocState copyWith(
          void Function(SiteNameReplayBlocState) updates) =>
      super.copyWith((message) => updates(message as SiteNameReplayBlocState))
          as SiteNameReplayBlocState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteNameReplayBlocState create() => SiteNameReplayBlocState._();
  @$core.override
  SiteNameReplayBlocState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SiteNameReplayBlocState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SiteNameReplayBlocState>(create);
  static SiteNameReplayBlocState? _defaultInstance;

  @$pb.TagNumber(1)
  $0.CommonReplayStateEnum get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.CommonReplayStateEnum value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.int, $core.String> get events => $_getMap(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
