// This is a generated file - do not edit.
//
// Generated from app_replay_bloc.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'app_events.pb.dart' as $0;
import 'app_replay_bloc.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'app_replay_bloc.pbenum.dart';

class AppReplayBlocState extends $pb.GeneratedMessage {
  factory AppReplayBlocState({
    $core.Iterable<$core.MapEntry<$core.int, $core.String>>? events,
    AppReplayStateEnum? state,
    $core.String? textValue,
    $core.String? codeValue,
    $core.bool? checkboxValue,
    $core.String? dropdownValue,
    $core.Iterable<$0.AppEvent_ReorderableItem>? listItems,
    $core.String? photoName,
    $core.int? photoVersion,
  }) {
    final result = create();
    if (events != null) result.events.addEntries(events);
    if (state != null) result.state = state;
    if (textValue != null) result.textValue = textValue;
    if (codeValue != null) result.codeValue = codeValue;
    if (checkboxValue != null) result.checkboxValue = checkboxValue;
    if (dropdownValue != null) result.dropdownValue = dropdownValue;
    if (listItems != null) result.listItems.addAll(listItems);
    if (photoName != null) result.photoName = photoName;
    if (photoVersion != null) result.photoVersion = photoVersion;
    return result;
  }

  AppReplayBlocState._();

  factory AppReplayBlocState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppReplayBlocState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppReplayBlocState',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'hyttahub.example.template'),
      createEmptyInstance: create)
    ..m<$core.int, $core.String>(1, _omitFieldNames ? '' : 'events',
        entryClassName: 'AppReplayBlocState.EventsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('hyttahub.example.template'))
    ..aE<AppReplayStateEnum>(2, _omitFieldNames ? '' : 'state',
        enumValues: AppReplayStateEnum.values)
    ..aOS(3, _omitFieldNames ? '' : 'textValue', protoName: 'textValue')
    ..aOS(4, _omitFieldNames ? '' : 'codeValue', protoName: 'codeValue')
    ..aOB(5, _omitFieldNames ? '' : 'checkboxValue', protoName: 'checkboxValue')
    ..aOS(6, _omitFieldNames ? '' : 'dropdownValue', protoName: 'dropdownValue')
    ..pPM<$0.AppEvent_ReorderableItem>(7, _omitFieldNames ? '' : 'listItems',
        protoName: 'listItems', subBuilder: $0.AppEvent_ReorderableItem.create)
    ..aOS(8, _omitFieldNames ? '' : 'photoName', protoName: 'photoName')
    ..aI(9, _omitFieldNames ? '' : 'photoVersion', protoName: 'photoVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppReplayBlocState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppReplayBlocState copyWith(void Function(AppReplayBlocState) updates) =>
      super.copyWith((message) => updates(message as AppReplayBlocState))
          as AppReplayBlocState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppReplayBlocState create() => AppReplayBlocState._();
  @$core.override
  AppReplayBlocState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppReplayBlocState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppReplayBlocState>(create);
  static AppReplayBlocState? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.int, $core.String> get events => $_getMap(0);

  @$pb.TagNumber(2)
  AppReplayStateEnum get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(AppReplayStateEnum value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get textValue => $_getSZ(2);
  @$pb.TagNumber(3)
  set textValue($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTextValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextValue() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get codeValue => $_getSZ(3);
  @$pb.TagNumber(4)
  set codeValue($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCodeValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearCodeValue() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get checkboxValue => $_getBF(4);
  @$pb.TagNumber(5)
  set checkboxValue($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCheckboxValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearCheckboxValue() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get dropdownValue => $_getSZ(5);
  @$pb.TagNumber(6)
  set dropdownValue($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDropdownValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearDropdownValue() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$0.AppEvent_ReorderableItem> get listItems => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get photoName => $_getSZ(7);
  @$pb.TagNumber(8)
  set photoName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPhotoName() => $_has(7);
  @$pb.TagNumber(8)
  void clearPhotoName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get photoVersion => $_getIZ(8);
  @$pb.TagNumber(9)
  set photoVersion($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPhotoVersion() => $_has(8);
  @$pb.TagNumber(9)
  void clearPhotoVersion() => $_clearField(9);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
