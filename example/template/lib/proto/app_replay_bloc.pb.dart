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

class AppReplayBlocState_Photo extends $pb.GeneratedMessage {
  factory AppReplayBlocState_Photo({
    $core.String? name,
    $core.int? version,
    $core.int? size,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (version != null) result.version = version;
    if (size != null) result.size = size;
    return result;
  }

  AppReplayBlocState_Photo._();

  factory AppReplayBlocState_Photo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppReplayBlocState_Photo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppReplayBlocState.Photo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'hyttahub.example.template'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aI(2, _omitFieldNames ? '' : 'version')
    ..aI(3, _omitFieldNames ? '' : 'size')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppReplayBlocState_Photo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppReplayBlocState_Photo copyWith(
          void Function(AppReplayBlocState_Photo) updates) =>
      super.copyWith((message) => updates(message as AppReplayBlocState_Photo))
          as AppReplayBlocState_Photo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppReplayBlocState_Photo create() => AppReplayBlocState_Photo._();
  @$core.override
  AppReplayBlocState_Photo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppReplayBlocState_Photo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppReplayBlocState_Photo>(create);
  static AppReplayBlocState_Photo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get version => $_getIZ(1);
  @$pb.TagNumber(2)
  set version($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get size => $_getIZ(2);
  @$pb.TagNumber(3)
  set size($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearSize() => $_clearField(3);
}

class AppReplayBlocState extends $pb.GeneratedMessage {
  factory AppReplayBlocState({
    $core.Iterable<$core.MapEntry<$core.int, $core.String>>? events,
    AppReplayStateEnum? state,
    $core.String? textValue,
    $core.String? codeValue,
    $core.bool? checkboxValue,
    $core.String? dropdownValue,
    $core.Iterable<$0.AppEvent_ReorderableItem>? listItems,
    AppReplayBlocState_Photo? photo,
  }) {
    final result = create();
    if (events != null) result.events.addEntries(events);
    if (state != null) result.state = state;
    if (textValue != null) result.textValue = textValue;
    if (codeValue != null) result.codeValue = codeValue;
    if (checkboxValue != null) result.checkboxValue = checkboxValue;
    if (dropdownValue != null) result.dropdownValue = dropdownValue;
    if (listItems != null) result.listItems.addAll(listItems);
    if (photo != null) result.photo = photo;
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
    ..aOM<AppReplayBlocState_Photo>(8, _omitFieldNames ? '' : 'photo',
        subBuilder: AppReplayBlocState_Photo.create)
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
  AppReplayBlocState_Photo get photo => $_getN(7);
  @$pb.TagNumber(8)
  set photo(AppReplayBlocState_Photo value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPhoto() => $_has(7);
  @$pb.TagNumber(8)
  void clearPhoto() => $_clearField(8);
  @$pb.TagNumber(8)
  AppReplayBlocState_Photo ensurePhoto() => $_ensure(7);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
