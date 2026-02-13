//
//  Generated code. Do not modify.
//  source: site_name_replay_bloc.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common_blocs.pbenum.dart' as $0;

class SiteNameReplayBlocState extends $pb.GeneratedMessage {
  factory SiteNameReplayBlocState({
    $0.CommonReplayStateEnum? state,
    $core.String? name,
    $core.Map<$core.int, $core.String>? events,
  }) {
    final $result = create();
    if (state != null) {
      $result.state = state;
    }
    if (name != null) {
      $result.name = name;
    }
    if (events != null) {
      $result.events.addAll(events);
    }
    return $result;
  }
  SiteNameReplayBlocState._() : super();
  factory SiteNameReplayBlocState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SiteNameReplayBlocState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SiteNameReplayBlocState', createEmptyInstance: create)
    ..e<$0.CommonReplayStateEnum>(1, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: $0.CommonReplayStateEnum.hydrating, valueOf: $0.CommonReplayStateEnum.valueOf, enumValues: $0.CommonReplayStateEnum.values)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..m<$core.int, $core.String>(3, _omitFieldNames ? '' : 'events', entryClassName: 'SiteNameReplayBlocState.EventsEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.OS)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SiteNameReplayBlocState clone() => SiteNameReplayBlocState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SiteNameReplayBlocState copyWith(void Function(SiteNameReplayBlocState) updates) => super.copyWith((message) => updates(message as SiteNameReplayBlocState)) as SiteNameReplayBlocState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteNameReplayBlocState create() => SiteNameReplayBlocState._();
  SiteNameReplayBlocState createEmptyInstance() => create();
  static $pb.PbList<SiteNameReplayBlocState> createRepeated() => $pb.PbList<SiteNameReplayBlocState>();
  @$core.pragma('dart2js:noInline')
  static SiteNameReplayBlocState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SiteNameReplayBlocState>(create);
  static SiteNameReplayBlocState? _defaultInstance;

  @$pb.TagNumber(1)
  $0.CommonReplayStateEnum get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.CommonReplayStateEnum v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.Map<$core.int, $core.String> get events => $_getMap(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
