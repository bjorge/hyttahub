//
//  Generated code. Do not modify.
//  source: app_replay_bloc.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'app_events.pb.dart' as $0;
import 'app_replay_bloc.pbenum.dart';

export 'app_replay_bloc.pbenum.dart';

class AppReplayBlocState extends $pb.GeneratedMessage {
  factory AppReplayBlocState({
    $core.Map<$core.int, $core.String>? events,
    AppReplayStateEnum? state,
    $core.String? textValue,
    $core.String? codeValue,
    $core.bool? checkboxValue,
    $core.String? dropdownValue,
    $core.Iterable<$0.AppEvent_ReorderableItem>? listItems,
  }) {
    final $result = create();
    if (events != null) {
      $result.events.addAll(events);
    }
    if (state != null) {
      $result.state = state;
    }
    if (textValue != null) {
      $result.textValue = textValue;
    }
    if (codeValue != null) {
      $result.codeValue = codeValue;
    }
    if (checkboxValue != null) {
      $result.checkboxValue = checkboxValue;
    }
    if (dropdownValue != null) {
      $result.dropdownValue = dropdownValue;
    }
    if (listItems != null) {
      $result.listItems.addAll(listItems);
    }
    return $result;
  }
  AppReplayBlocState._() : super();
  factory AppReplayBlocState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppReplayBlocState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppReplayBlocState', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub.example.template'), createEmptyInstance: create)
    ..m<$core.int, $core.String>(1, _omitFieldNames ? '' : 'events', entryClassName: 'AppReplayBlocState.EventsEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('hyttahub.example.template'))
    ..e<AppReplayStateEnum>(2, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: AppReplayStateEnum.hydrating, valueOf: AppReplayStateEnum.valueOf, enumValues: AppReplayStateEnum.values)
    ..aOS(3, _omitFieldNames ? '' : 'textValue', protoName: 'textValue')
    ..aOS(4, _omitFieldNames ? '' : 'codeValue', protoName: 'codeValue')
    ..aOB(5, _omitFieldNames ? '' : 'checkboxValue', protoName: 'checkboxValue')
    ..aOS(6, _omitFieldNames ? '' : 'dropdownValue', protoName: 'dropdownValue')
    ..pc<$0.AppEvent_ReorderableItem>(7, _omitFieldNames ? '' : 'listItems', $pb.PbFieldType.PM, protoName: 'listItems', subBuilder: $0.AppEvent_ReorderableItem.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppReplayBlocState clone() => AppReplayBlocState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppReplayBlocState copyWith(void Function(AppReplayBlocState) updates) => super.copyWith((message) => updates(message as AppReplayBlocState)) as AppReplayBlocState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppReplayBlocState create() => AppReplayBlocState._();
  AppReplayBlocState createEmptyInstance() => create();
  static $pb.PbList<AppReplayBlocState> createRepeated() => $pb.PbList<AppReplayBlocState>();
  @$core.pragma('dart2js:noInline')
  static AppReplayBlocState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppReplayBlocState>(create);
  static AppReplayBlocState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.int, $core.String> get events => $_getMap(0);

  @$pb.TagNumber(2)
  AppReplayStateEnum get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(AppReplayStateEnum v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get textValue => $_getSZ(2);
  @$pb.TagNumber(3)
  set textValue($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTextValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextValue() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get codeValue => $_getSZ(3);
  @$pb.TagNumber(4)
  set codeValue($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCodeValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearCodeValue() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get checkboxValue => $_getBF(4);
  @$pb.TagNumber(5)
  set checkboxValue($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCheckboxValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearCheckboxValue() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get dropdownValue => $_getSZ(5);
  @$pb.TagNumber(6)
  set dropdownValue($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDropdownValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearDropdownValue() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<$0.AppEvent_ReorderableItem> get listItems => $_getList(6);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
