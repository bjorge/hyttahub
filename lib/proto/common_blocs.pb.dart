// This is a generated file - do not edit.
//
// Generated from common_blocs.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common_blocs.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'common_blocs.pbenum.dart';

class CommonReplayBlocEvent_NewEvents extends $pb.GeneratedMessage {
  factory CommonReplayBlocEvent_NewEvents({
    $core.Iterable<$core.MapEntry<$core.int, $core.String>>? events,
  }) {
    final result = create();
    if (events != null) result.events.addEntries(events);
    return result;
  }

  CommonReplayBlocEvent_NewEvents._();

  factory CommonReplayBlocEvent_NewEvents.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommonReplayBlocEvent_NewEvents.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommonReplayBlocEvent.NewEvents',
      createEmptyInstance: create)
    ..m<$core.int, $core.String>(1, _omitFieldNames ? '' : 'events',
        entryClassName: 'CommonReplayBlocEvent.NewEvents.EventsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OS)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommonReplayBlocEvent_NewEvents clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommonReplayBlocEvent_NewEvents copyWith(
          void Function(CommonReplayBlocEvent_NewEvents) updates) =>
      super.copyWith(
              (message) => updates(message as CommonReplayBlocEvent_NewEvents))
          as CommonReplayBlocEvent_NewEvents;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommonReplayBlocEvent_NewEvents create() =>
      CommonReplayBlocEvent_NewEvents._();
  @$core.override
  CommonReplayBlocEvent_NewEvents createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CommonReplayBlocEvent_NewEvents getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommonReplayBlocEvent_NewEvents>(
          create);
  static CommonReplayBlocEvent_NewEvents? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.int, $core.String> get events => $_getMap(0);
}

enum CommonReplayBlocEvent_EventType { listen, newEvents, notSet }

class CommonReplayBlocEvent extends $pb.GeneratedMessage {
  factory CommonReplayBlocEvent({
    $core.bool? listen,
    CommonReplayBlocEvent_NewEvents? newEvents,
  }) {
    final result = create();
    if (listen != null) result.listen = listen;
    if (newEvents != null) result.newEvents = newEvents;
    return result;
  }

  CommonReplayBlocEvent._();

  factory CommonReplayBlocEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommonReplayBlocEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, CommonReplayBlocEvent_EventType>
      _CommonReplayBlocEvent_EventTypeByTag = {
    1: CommonReplayBlocEvent_EventType.listen,
    2: CommonReplayBlocEvent_EventType.newEvents,
    0: CommonReplayBlocEvent_EventType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommonReplayBlocEvent',
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOB(1, _omitFieldNames ? '' : 'listen')
    ..aOM<CommonReplayBlocEvent_NewEvents>(
        2, _omitFieldNames ? '' : 'newEvents',
        protoName: 'newEvents',
        subBuilder: CommonReplayBlocEvent_NewEvents.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommonReplayBlocEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommonReplayBlocEvent copyWith(
          void Function(CommonReplayBlocEvent) updates) =>
      super.copyWith((message) => updates(message as CommonReplayBlocEvent))
          as CommonReplayBlocEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommonReplayBlocEvent create() => CommonReplayBlocEvent._();
  @$core.override
  CommonReplayBlocEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CommonReplayBlocEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommonReplayBlocEvent>(create);
  static CommonReplayBlocEvent? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  CommonReplayBlocEvent_EventType whichEventType() =>
      _CommonReplayBlocEvent_EventTypeByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearEventType() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.bool get listen => $_getBF(0);
  @$pb.TagNumber(1)
  set listen($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListen() => $_has(0);
  @$pb.TagNumber(1)
  void clearListen() => $_clearField(1);

  @$pb.TagNumber(2)
  CommonReplayBlocEvent_NewEvents get newEvents => $_getN(1);
  @$pb.TagNumber(2)
  set newEvents(CommonReplayBlocEvent_NewEvents value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasNewEvents() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewEvents() => $_clearField(2);
  @$pb.TagNumber(2)
  CommonReplayBlocEvent_NewEvents ensureNewEvents() => $_ensure(1);
}

class EventMapProto extends $pb.GeneratedMessage {
  factory EventMapProto({
    $core.Iterable<$core.MapEntry<$core.int, $core.String>>? events,
  }) {
    final result = create();
    if (events != null) result.events.addEntries(events);
    return result;
  }

  EventMapProto._();

  factory EventMapProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EventMapProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EventMapProto',
      createEmptyInstance: create)
    ..m<$core.int, $core.String>(1, _omitFieldNames ? '' : 'events',
        entryClassName: 'EventMapProto.EventsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OS)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EventMapProto clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EventMapProto copyWith(void Function(EventMapProto) updates) =>
      super.copyWith((message) => updates(message as EventMapProto))
          as EventMapProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EventMapProto create() => EventMapProto._();
  @$core.override
  EventMapProto createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EventMapProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EventMapProto>(create);
  static EventMapProto? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.int, $core.String> get events => $_getMap(0);
}

class CommonSubmitBlocEvent_SubmitNow extends $pb.GeneratedMessage {
  factory CommonSubmitBlocEvent_SubmitNow() => create();

  CommonSubmitBlocEvent_SubmitNow._();

  factory CommonSubmitBlocEvent_SubmitNow.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommonSubmitBlocEvent_SubmitNow.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommonSubmitBlocEvent.SubmitNow',
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommonSubmitBlocEvent_SubmitNow clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommonSubmitBlocEvent_SubmitNow copyWith(
          void Function(CommonSubmitBlocEvent_SubmitNow) updates) =>
      super.copyWith(
              (message) => updates(message as CommonSubmitBlocEvent_SubmitNow))
          as CommonSubmitBlocEvent_SubmitNow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommonSubmitBlocEvent_SubmitNow create() =>
      CommonSubmitBlocEvent_SubmitNow._();
  @$core.override
  CommonSubmitBlocEvent_SubmitNow createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CommonSubmitBlocEvent_SubmitNow getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommonSubmitBlocEvent_SubmitNow>(
          create);
  static CommonSubmitBlocEvent_SubmitNow? _defaultInstance;
}

enum CommonSubmitBlocEvent_EventType {
  updatedPayload,
  isFormValid,
  submit,
  notSet
}

class CommonSubmitBlocEvent extends $pb.GeneratedMessage {
  factory CommonSubmitBlocEvent({
    $core.String? updatedPayload,
    $core.bool? isFormValid,
    CommonSubmitBlocEvent_SubmitNow? submit,
  }) {
    final result = create();
    if (updatedPayload != null) result.updatedPayload = updatedPayload;
    if (isFormValid != null) result.isFormValid = isFormValid;
    if (submit != null) result.submit = submit;
    return result;
  }

  CommonSubmitBlocEvent._();

  factory CommonSubmitBlocEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommonSubmitBlocEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, CommonSubmitBlocEvent_EventType>
      _CommonSubmitBlocEvent_EventTypeByTag = {
    2: CommonSubmitBlocEvent_EventType.updatedPayload,
    3: CommonSubmitBlocEvent_EventType.isFormValid,
    4: CommonSubmitBlocEvent_EventType.submit,
    0: CommonSubmitBlocEvent_EventType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommonSubmitBlocEvent',
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aOS(2, _omitFieldNames ? '' : 'updatedPayload',
        protoName: 'updatedPayload')
    ..aOB(3, _omitFieldNames ? '' : 'isFormValid', protoName: 'isFormValid')
    ..aOM<CommonSubmitBlocEvent_SubmitNow>(4, _omitFieldNames ? '' : 'submit',
        subBuilder: CommonSubmitBlocEvent_SubmitNow.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommonSubmitBlocEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommonSubmitBlocEvent copyWith(
          void Function(CommonSubmitBlocEvent) updates) =>
      super.copyWith((message) => updates(message as CommonSubmitBlocEvent))
          as CommonSubmitBlocEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommonSubmitBlocEvent create() => CommonSubmitBlocEvent._();
  @$core.override
  CommonSubmitBlocEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CommonSubmitBlocEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommonSubmitBlocEvent>(create);
  static CommonSubmitBlocEvent? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  CommonSubmitBlocEvent_EventType whichEventType() =>
      _CommonSubmitBlocEvent_EventTypeByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearEventType() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(2)
  $core.String get updatedPayload => $_getSZ(0);
  @$pb.TagNumber(2)
  set updatedPayload($core.String value) => $_setString(0, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdatedPayload() => $_has(0);
  @$pb.TagNumber(2)
  void clearUpdatedPayload() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isFormValid => $_getBF(1);
  @$pb.TagNumber(3)
  set isFormValid($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(3)
  $core.bool hasIsFormValid() => $_has(1);
  @$pb.TagNumber(3)
  void clearIsFormValid() => $_clearField(3);

  @$pb.TagNumber(4)
  CommonSubmitBlocEvent_SubmitNow get submit => $_getN(2);
  @$pb.TagNumber(4)
  set submit(CommonSubmitBlocEvent_SubmitNow value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSubmit() => $_has(2);
  @$pb.TagNumber(4)
  void clearSubmit() => $_clearField(4);
  @$pb.TagNumber(4)
  CommonSubmitBlocEvent_SubmitNow ensureSubmit() => $_ensure(2);
}

class CommonSubmitBlocState_SubmitProgress extends $pb.GeneratedMessage {
  factory CommonSubmitBlocState_SubmitProgress({
    $core.int? count,
    $core.int? total,
  }) {
    final result = create();
    if (count != null) result.count = count;
    if (total != null) result.total = total;
    return result;
  }

  CommonSubmitBlocState_SubmitProgress._();

  factory CommonSubmitBlocState_SubmitProgress.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommonSubmitBlocState_SubmitProgress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommonSubmitBlocState.SubmitProgress',
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'count')
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommonSubmitBlocState_SubmitProgress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommonSubmitBlocState_SubmitProgress copyWith(
          void Function(CommonSubmitBlocState_SubmitProgress) updates) =>
      super.copyWith((message) =>
              updates(message as CommonSubmitBlocState_SubmitProgress))
          as CommonSubmitBlocState_SubmitProgress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommonSubmitBlocState_SubmitProgress create() =>
      CommonSubmitBlocState_SubmitProgress._();
  @$core.override
  CommonSubmitBlocState_SubmitProgress createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CommonSubmitBlocState_SubmitProgress getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          CommonSubmitBlocState_SubmitProgress>(create);
  static CommonSubmitBlocState_SubmitProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get count => $_getIZ(0);
  @$pb.TagNumber(1)
  set count($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class CommonSubmitBlocState extends $pb.GeneratedMessage {
  factory CommonSubmitBlocState({
    CommonSubmitBlocState_State? state,
    CommonSubmitBlocState_ErrorCode? errorCode,
    CommonSubmitBlocState_SubmitProgress? progress,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (errorCode != null) result.errorCode = errorCode;
    if (progress != null) result.progress = progress;
    return result;
  }

  CommonSubmitBlocState._();

  factory CommonSubmitBlocState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommonSubmitBlocState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommonSubmitBlocState',
      createEmptyInstance: create)
    ..aE<CommonSubmitBlocState_State>(1, _omitFieldNames ? '' : 'state',
        enumValues: CommonSubmitBlocState_State.values)
    ..aE<CommonSubmitBlocState_ErrorCode>(8, _omitFieldNames ? '' : 'errorCode',
        protoName: 'errorCode',
        enumValues: CommonSubmitBlocState_ErrorCode.values)
    ..aOM<CommonSubmitBlocState_SubmitProgress>(
        9, _omitFieldNames ? '' : 'progress',
        subBuilder: CommonSubmitBlocState_SubmitProgress.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommonSubmitBlocState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommonSubmitBlocState copyWith(
          void Function(CommonSubmitBlocState) updates) =>
      super.copyWith((message) => updates(message as CommonSubmitBlocState))
          as CommonSubmitBlocState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommonSubmitBlocState create() => CommonSubmitBlocState._();
  @$core.override
  CommonSubmitBlocState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CommonSubmitBlocState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommonSubmitBlocState>(create);
  static CommonSubmitBlocState? _defaultInstance;

  @$pb.TagNumber(1)
  CommonSubmitBlocState_State get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(CommonSubmitBlocState_State value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(8)
  CommonSubmitBlocState_ErrorCode get errorCode => $_getN(1);
  @$pb.TagNumber(8)
  set errorCode(CommonSubmitBlocState_ErrorCode value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasErrorCode() => $_has(1);
  @$pb.TagNumber(8)
  void clearErrorCode() => $_clearField(8);

  @$pb.TagNumber(9)
  CommonSubmitBlocState_SubmitProgress get progress => $_getN(2);
  @$pb.TagNumber(9)
  set progress(CommonSubmitBlocState_SubmitProgress value) =>
      $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasProgress() => $_has(2);
  @$pb.TagNumber(9)
  void clearProgress() => $_clearField(9);
  @$pb.TagNumber(9)
  CommonSubmitBlocState_SubmitProgress ensureProgress() => $_ensure(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
