// This is a generated file - do not edit.
//
// Generated from app_events.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class AppEvent_ReorderableItem extends $pb.GeneratedMessage {
  factory AppEvent_ReorderableItem({
    $core.int? id,
    $core.String? title,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    return result;
  }

  AppEvent_ReorderableItem._();

  factory AppEvent_ReorderableItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppEvent_ReorderableItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppEvent.ReorderableItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'hyttahub.example.template'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent_ReorderableItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent_ReorderableItem copyWith(
          void Function(AppEvent_ReorderableItem) updates) =>
      super.copyWith((message) => updates(message as AppEvent_ReorderableItem))
          as AppEvent_ReorderableItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_ReorderableItem create() => AppEvent_ReorderableItem._();
  @$core.override
  AppEvent_ReorderableItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppEvent_ReorderableItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppEvent_ReorderableItem>(create);
  static AppEvent_ReorderableItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);
}

class AppEvent_UpdateText extends $pb.GeneratedMessage {
  factory AppEvent_UpdateText({
    $core.String? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  AppEvent_UpdateText._();

  factory AppEvent_UpdateText.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppEvent_UpdateText.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppEvent.UpdateText',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'hyttahub.example.template'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent_UpdateText clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent_UpdateText copyWith(void Function(AppEvent_UpdateText) updates) =>
      super.copyWith((message) => updates(message as AppEvent_UpdateText))
          as AppEvent_UpdateText;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateText create() => AppEvent_UpdateText._();
  @$core.override
  AppEvent_UpdateText createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateText getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppEvent_UpdateText>(create);
  static AppEvent_UpdateText? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get value => $_getSZ(0);
  @$pb.TagNumber(1)
  set value($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class AppEvent_UpdateCode extends $pb.GeneratedMessage {
  factory AppEvent_UpdateCode({
    $core.String? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  AppEvent_UpdateCode._();

  factory AppEvent_UpdateCode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppEvent_UpdateCode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppEvent.UpdateCode',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'hyttahub.example.template'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent_UpdateCode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent_UpdateCode copyWith(void Function(AppEvent_UpdateCode) updates) =>
      super.copyWith((message) => updates(message as AppEvent_UpdateCode))
          as AppEvent_UpdateCode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateCode create() => AppEvent_UpdateCode._();
  @$core.override
  AppEvent_UpdateCode createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateCode getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppEvent_UpdateCode>(create);
  static AppEvent_UpdateCode? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get value => $_getSZ(0);
  @$pb.TagNumber(1)
  set value($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class AppEvent_UpdateCheckbox extends $pb.GeneratedMessage {
  factory AppEvent_UpdateCheckbox({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  AppEvent_UpdateCheckbox._();

  factory AppEvent_UpdateCheckbox.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppEvent_UpdateCheckbox.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppEvent.UpdateCheckbox',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'hyttahub.example.template'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent_UpdateCheckbox clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent_UpdateCheckbox copyWith(
          void Function(AppEvent_UpdateCheckbox) updates) =>
      super.copyWith((message) => updates(message as AppEvent_UpdateCheckbox))
          as AppEvent_UpdateCheckbox;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateCheckbox create() => AppEvent_UpdateCheckbox._();
  @$core.override
  AppEvent_UpdateCheckbox createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateCheckbox getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppEvent_UpdateCheckbox>(create);
  static AppEvent_UpdateCheckbox? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class AppEvent_UpdateDropdown extends $pb.GeneratedMessage {
  factory AppEvent_UpdateDropdown({
    $core.String? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  AppEvent_UpdateDropdown._();

  factory AppEvent_UpdateDropdown.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppEvent_UpdateDropdown.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppEvent.UpdateDropdown',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'hyttahub.example.template'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent_UpdateDropdown clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent_UpdateDropdown copyWith(
          void Function(AppEvent_UpdateDropdown) updates) =>
      super.copyWith((message) => updates(message as AppEvent_UpdateDropdown))
          as AppEvent_UpdateDropdown;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateDropdown create() => AppEvent_UpdateDropdown._();
  @$core.override
  AppEvent_UpdateDropdown createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateDropdown getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppEvent_UpdateDropdown>(create);
  static AppEvent_UpdateDropdown? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get value => $_getSZ(0);
  @$pb.TagNumber(1)
  set value($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class AppEvent_UpdateList extends $pb.GeneratedMessage {
  factory AppEvent_UpdateList({
    $core.Iterable<AppEvent_ReorderableItem>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  AppEvent_UpdateList._();

  factory AppEvent_UpdateList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppEvent_UpdateList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppEvent.UpdateList',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'hyttahub.example.template'),
      createEmptyInstance: create)
    ..pPM<AppEvent_ReorderableItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: AppEvent_ReorderableItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent_UpdateList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent_UpdateList copyWith(void Function(AppEvent_UpdateList) updates) =>
      super.copyWith((message) => updates(message as AppEvent_UpdateList))
          as AppEvent_UpdateList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateList create() => AppEvent_UpdateList._();
  @$core.override
  AppEvent_UpdateList createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppEvent_UpdateList>(create);
  static AppEvent_UpdateList? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AppEvent_ReorderableItem> get items => $_getList(0);
}

class AppEvent_UpdatePhoto extends $pb.GeneratedMessage {
  factory AppEvent_UpdatePhoto({
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

  AppEvent_UpdatePhoto._();

  factory AppEvent_UpdatePhoto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppEvent_UpdatePhoto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppEvent.UpdatePhoto',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'hyttahub.example.template'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aI(2, _omitFieldNames ? '' : 'version')
    ..aI(3, _omitFieldNames ? '' : 'size')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent_UpdatePhoto clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent_UpdatePhoto copyWith(void Function(AppEvent_UpdatePhoto) updates) =>
      super.copyWith((message) => updates(message as AppEvent_UpdatePhoto))
          as AppEvent_UpdatePhoto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdatePhoto create() => AppEvent_UpdatePhoto._();
  @$core.override
  AppEvent_UpdatePhoto createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdatePhoto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppEvent_UpdatePhoto>(create);
  static AppEvent_UpdatePhoto? _defaultInstance;

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

class AppEvent_RemovePhoto extends $pb.GeneratedMessage {
  factory AppEvent_RemovePhoto({
    $core.int? version,
  }) {
    final result = create();
    if (version != null) result.version = version;
    return result;
  }

  AppEvent_RemovePhoto._();

  factory AppEvent_RemovePhoto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppEvent_RemovePhoto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppEvent.RemovePhoto',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'hyttahub.example.template'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent_RemovePhoto clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent_RemovePhoto copyWith(void Function(AppEvent_RemovePhoto) updates) =>
      super.copyWith((message) => updates(message as AppEvent_RemovePhoto))
          as AppEvent_RemovePhoto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_RemovePhoto create() => AppEvent_RemovePhoto._();
  @$core.override
  AppEvent_RemovePhoto createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppEvent_RemovePhoto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppEvent_RemovePhoto>(create);
  static AppEvent_RemovePhoto? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);
}

enum AppEvent_Event {
  updateText,
  updateCode,
  updateCheckbox,
  updateDropdown,
  updateList,
  updatePhoto,
  removePhoto,
  notSet
}

class AppEvent extends $pb.GeneratedMessage {
  factory AppEvent({
    AppEvent_UpdateText? updateText,
    AppEvent_UpdateCode? updateCode,
    AppEvent_UpdateCheckbox? updateCheckbox,
    AppEvent_UpdateDropdown? updateDropdown,
    AppEvent_UpdateList? updateList,
    AppEvent_UpdatePhoto? updatePhoto,
    AppEvent_RemovePhoto? removePhoto,
  }) {
    final result = create();
    if (updateText != null) result.updateText = updateText;
    if (updateCode != null) result.updateCode = updateCode;
    if (updateCheckbox != null) result.updateCheckbox = updateCheckbox;
    if (updateDropdown != null) result.updateDropdown = updateDropdown;
    if (updateList != null) result.updateList = updateList;
    if (updatePhoto != null) result.updatePhoto = updatePhoto;
    if (removePhoto != null) result.removePhoto = removePhoto;
    return result;
  }

  AppEvent._();

  factory AppEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, AppEvent_Event> _AppEvent_EventByTag = {
    3: AppEvent_Event.updateText,
    4: AppEvent_Event.updateCode,
    5: AppEvent_Event.updateCheckbox,
    6: AppEvent_Event.updateDropdown,
    7: AppEvent_Event.updateList,
    8: AppEvent_Event.updatePhoto,
    9: AppEvent_Event.removePhoto,
    0: AppEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppEvent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'hyttahub.example.template'),
      createEmptyInstance: create)
    ..oo(0, [3, 4, 5, 6, 7, 8, 9])
    ..aOM<AppEvent_UpdateText>(3, _omitFieldNames ? '' : 'updateText',
        protoName: 'updateText', subBuilder: AppEvent_UpdateText.create)
    ..aOM<AppEvent_UpdateCode>(4, _omitFieldNames ? '' : 'updateCode',
        protoName: 'updateCode', subBuilder: AppEvent_UpdateCode.create)
    ..aOM<AppEvent_UpdateCheckbox>(5, _omitFieldNames ? '' : 'updateCheckbox',
        protoName: 'updateCheckbox', subBuilder: AppEvent_UpdateCheckbox.create)
    ..aOM<AppEvent_UpdateDropdown>(6, _omitFieldNames ? '' : 'updateDropdown',
        protoName: 'updateDropdown', subBuilder: AppEvent_UpdateDropdown.create)
    ..aOM<AppEvent_UpdateList>(7, _omitFieldNames ? '' : 'updateList',
        protoName: 'updateList', subBuilder: AppEvent_UpdateList.create)
    ..aOM<AppEvent_UpdatePhoto>(8, _omitFieldNames ? '' : 'updatePhoto',
        protoName: 'updatePhoto', subBuilder: AppEvent_UpdatePhoto.create)
    ..aOM<AppEvent_RemovePhoto>(9, _omitFieldNames ? '' : 'removePhoto',
        protoName: 'removePhoto', subBuilder: AppEvent_RemovePhoto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEvent copyWith(void Function(AppEvent) updates) =>
      super.copyWith((message) => updates(message as AppEvent)) as AppEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent create() => AppEvent._();
  @$core.override
  AppEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppEvent getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent>(create);
  static AppEvent? _defaultInstance;

  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  AppEvent_Event whichEvent() => _AppEvent_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(3)
  AppEvent_UpdateText get updateText => $_getN(0);
  @$pb.TagNumber(3)
  set updateText(AppEvent_UpdateText value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUpdateText() => $_has(0);
  @$pb.TagNumber(3)
  void clearUpdateText() => $_clearField(3);
  @$pb.TagNumber(3)
  AppEvent_UpdateText ensureUpdateText() => $_ensure(0);

  @$pb.TagNumber(4)
  AppEvent_UpdateCode get updateCode => $_getN(1);
  @$pb.TagNumber(4)
  set updateCode(AppEvent_UpdateCode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUpdateCode() => $_has(1);
  @$pb.TagNumber(4)
  void clearUpdateCode() => $_clearField(4);
  @$pb.TagNumber(4)
  AppEvent_UpdateCode ensureUpdateCode() => $_ensure(1);

  @$pb.TagNumber(5)
  AppEvent_UpdateCheckbox get updateCheckbox => $_getN(2);
  @$pb.TagNumber(5)
  set updateCheckbox(AppEvent_UpdateCheckbox value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasUpdateCheckbox() => $_has(2);
  @$pb.TagNumber(5)
  void clearUpdateCheckbox() => $_clearField(5);
  @$pb.TagNumber(5)
  AppEvent_UpdateCheckbox ensureUpdateCheckbox() => $_ensure(2);

  @$pb.TagNumber(6)
  AppEvent_UpdateDropdown get updateDropdown => $_getN(3);
  @$pb.TagNumber(6)
  set updateDropdown(AppEvent_UpdateDropdown value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasUpdateDropdown() => $_has(3);
  @$pb.TagNumber(6)
  void clearUpdateDropdown() => $_clearField(6);
  @$pb.TagNumber(6)
  AppEvent_UpdateDropdown ensureUpdateDropdown() => $_ensure(3);

  @$pb.TagNumber(7)
  AppEvent_UpdateList get updateList => $_getN(4);
  @$pb.TagNumber(7)
  set updateList(AppEvent_UpdateList value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUpdateList() => $_has(4);
  @$pb.TagNumber(7)
  void clearUpdateList() => $_clearField(7);
  @$pb.TagNumber(7)
  AppEvent_UpdateList ensureUpdateList() => $_ensure(4);

  @$pb.TagNumber(8)
  AppEvent_UpdatePhoto get updatePhoto => $_getN(5);
  @$pb.TagNumber(8)
  set updatePhoto(AppEvent_UpdatePhoto value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasUpdatePhoto() => $_has(5);
  @$pb.TagNumber(8)
  void clearUpdatePhoto() => $_clearField(8);
  @$pb.TagNumber(8)
  AppEvent_UpdatePhoto ensureUpdatePhoto() => $_ensure(5);

  @$pb.TagNumber(9)
  AppEvent_RemovePhoto get removePhoto => $_getN(6);
  @$pb.TagNumber(9)
  set removePhoto(AppEvent_RemovePhoto value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasRemovePhoto() => $_has(6);
  @$pb.TagNumber(9)
  void clearRemovePhoto() => $_clearField(9);
  @$pb.TagNumber(9)
  AppEvent_RemovePhoto ensureRemovePhoto() => $_ensure(6);
}

/// the final site event will contain this app event
class SubmitAppEvent_SiteEvent extends $pb.GeneratedMessage {
  factory SubmitAppEvent_SiteEvent({
    $core.int? version,
    $core.int? author,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (author != null) result.author = author;
    return result;
  }

  SubmitAppEvent_SiteEvent._();

  factory SubmitAppEvent_SiteEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubmitAppEvent_SiteEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubmitAppEvent.SiteEvent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'hyttahub.example.template'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'version')
    ..aI(2, _omitFieldNames ? '' : 'author')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitAppEvent_SiteEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitAppEvent_SiteEvent copyWith(
          void Function(SubmitAppEvent_SiteEvent) updates) =>
      super.copyWith((message) => updates(message as SubmitAppEvent_SiteEvent))
          as SubmitAppEvent_SiteEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitAppEvent_SiteEvent create() => SubmitAppEvent_SiteEvent._();
  @$core.override
  SubmitAppEvent_SiteEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubmitAppEvent_SiteEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubmitAppEvent_SiteEvent>(create);
  static SubmitAppEvent_SiteEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get author => $_getIZ(1);
  @$pb.TagNumber(2)
  set author($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAuthor() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthor() => $_clearField(2);
}

class SubmitAppEvent_Image extends $pb.GeneratedMessage {
  factory SubmitAppEvent_Image({
    $core.String? base64Data,
    $core.String? name,
    $core.int? size,
  }) {
    final result = create();
    if (base64Data != null) result.base64Data = base64Data;
    if (name != null) result.name = name;
    if (size != null) result.size = size;
    return result;
  }

  SubmitAppEvent_Image._();

  factory SubmitAppEvent_Image.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubmitAppEvent_Image.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubmitAppEvent.Image',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'hyttahub.example.template'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'base64Data', protoName: 'base64Data')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'size')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitAppEvent_Image clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitAppEvent_Image copyWith(void Function(SubmitAppEvent_Image) updates) =>
      super.copyWith((message) => updates(message as SubmitAppEvent_Image))
          as SubmitAppEvent_Image;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitAppEvent_Image create() => SubmitAppEvent_Image._();
  @$core.override
  SubmitAppEvent_Image createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubmitAppEvent_Image getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubmitAppEvent_Image>(create);
  static SubmitAppEvent_Image? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get base64Data => $_getSZ(0);
  @$pb.TagNumber(1)
  set base64Data($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBase64Data() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase64Data() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get size => $_getIZ(2);
  @$pb.TagNumber(3)
  set size($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearSize() => $_clearField(3);
}

/// The SubmitAppEvent is passed to the submit bloc handler
/// PII (ex. email) is allowed in this message since not stored to immutable
/// records
class SubmitAppEvent extends $pb.GeneratedMessage {
  factory SubmitAppEvent({
    AppEvent? appEvent,
    SubmitAppEvent_SiteEvent? siteEvent,
    $core.String? authorEmail,
    $core.Iterable<SubmitAppEvent_Image>? images,
    $core.int? photoVersionToDelete,
  }) {
    final result = create();
    if (appEvent != null) result.appEvent = appEvent;
    if (siteEvent != null) result.siteEvent = siteEvent;
    if (authorEmail != null) result.authorEmail = authorEmail;
    if (images != null) result.images.addAll(images);
    if (photoVersionToDelete != null)
      result.photoVersionToDelete = photoVersionToDelete;
    return result;
  }

  SubmitAppEvent._();

  factory SubmitAppEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubmitAppEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubmitAppEvent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'hyttahub.example.template'),
      createEmptyInstance: create)
    ..aOM<AppEvent>(1, _omitFieldNames ? '' : 'appEvent',
        protoName: 'appEvent', subBuilder: AppEvent.create)
    ..aOM<SubmitAppEvent_SiteEvent>(2, _omitFieldNames ? '' : 'siteEvent',
        protoName: 'siteEvent', subBuilder: SubmitAppEvent_SiteEvent.create)
    ..aOS(3, _omitFieldNames ? '' : 'authorEmail', protoName: 'authorEmail')
    ..pPM<SubmitAppEvent_Image>(4, _omitFieldNames ? '' : 'images',
        subBuilder: SubmitAppEvent_Image.create)
    ..aI(5, _omitFieldNames ? '' : 'photoVersionToDelete')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitAppEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitAppEvent copyWith(void Function(SubmitAppEvent) updates) =>
      super.copyWith((message) => updates(message as SubmitAppEvent))
          as SubmitAppEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitAppEvent create() => SubmitAppEvent._();
  @$core.override
  SubmitAppEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubmitAppEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubmitAppEvent>(create);
  static SubmitAppEvent? _defaultInstance;

  @$pb.TagNumber(1)
  AppEvent get appEvent => $_getN(0);
  @$pb.TagNumber(1)
  set appEvent(AppEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAppEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  AppEvent ensureAppEvent() => $_ensure(0);

  @$pb.TagNumber(2)
  SubmitAppEvent_SiteEvent get siteEvent => $_getN(1);
  @$pb.TagNumber(2)
  set siteEvent(SubmitAppEvent_SiteEvent value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSiteEvent() => $_has(1);
  @$pb.TagNumber(2)
  void clearSiteEvent() => $_clearField(2);
  @$pb.TagNumber(2)
  SubmitAppEvent_SiteEvent ensureSiteEvent() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get authorEmail => $_getSZ(2);
  @$pb.TagNumber(3)
  set authorEmail($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAuthorEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthorEmail() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<SubmitAppEvent_Image> get images => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get photoVersionToDelete => $_getIZ(4);
  @$pb.TagNumber(5)
  set photoVersionToDelete($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPhotoVersionToDelete() => $_has(4);
  @$pb.TagNumber(5)
  void clearPhotoVersionToDelete() => $_clearField(5);
}

/// The AppEventRecord is a representation of the actual record stored in the
/// database This record is used just for display purposes in the client
class AppEventRecord extends $pb.GeneratedMessage {
  factory AppEventRecord({
    $core.String? isoDate,
    $core.int? version,
    AppEvent? appEvent,
  }) {
    final result = create();
    if (isoDate != null) result.isoDate = isoDate;
    if (version != null) result.version = version;
    if (appEvent != null) result.appEvent = appEvent;
    return result;
  }

  AppEventRecord._();

  factory AppEventRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppEventRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppEventRecord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'hyttahub.example.template'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'isoDate', protoName: 'isoDate')
    ..aI(2, _omitFieldNames ? '' : 'version')
    ..aOM<AppEvent>(3, _omitFieldNames ? '' : 'appEvent',
        protoName: 'appEvent', subBuilder: AppEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEventRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEventRecord copyWith(void Function(AppEventRecord) updates) =>
      super.copyWith((message) => updates(message as AppEventRecord))
          as AppEventRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEventRecord create() => AppEventRecord._();
  @$core.override
  AppEventRecord createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppEventRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppEventRecord>(create);
  static AppEventRecord? _defaultInstance;

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
  AppEvent get appEvent => $_getN(2);
  @$pb.TagNumber(3)
  set appEvent(AppEvent value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAppEvent() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppEvent() => $_clearField(3);
  @$pb.TagNumber(3)
  AppEvent ensureAppEvent() => $_ensure(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
