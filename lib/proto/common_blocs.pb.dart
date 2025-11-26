//
//  Generated code. Do not modify.
//  source: common_blocs.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common_blocs.pbenum.dart';

export 'common_blocs.pbenum.dart';

class CommonReplayBlocEvent_NewEvents extends $pb.GeneratedMessage {
  factory CommonReplayBlocEvent_NewEvents({
    $core.Map<$core.int, $core.String>? events,
  }) {
    final $result = create();
    if (events != null) {
      $result.events.addAll(events);
    }
    return $result;
  }
  CommonReplayBlocEvent_NewEvents._() : super();
  factory CommonReplayBlocEvent_NewEvents.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CommonReplayBlocEvent_NewEvents.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CommonReplayBlocEvent.NewEvents', createEmptyInstance: create)
    ..m<$core.int, $core.String>(1, _omitFieldNames ? '' : 'events', entryClassName: 'CommonReplayBlocEvent.NewEvents.EventsEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.OS)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CommonReplayBlocEvent_NewEvents clone() => CommonReplayBlocEvent_NewEvents()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CommonReplayBlocEvent_NewEvents copyWith(void Function(CommonReplayBlocEvent_NewEvents) updates) => super.copyWith((message) => updates(message as CommonReplayBlocEvent_NewEvents)) as CommonReplayBlocEvent_NewEvents;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommonReplayBlocEvent_NewEvents create() => CommonReplayBlocEvent_NewEvents._();
  CommonReplayBlocEvent_NewEvents createEmptyInstance() => create();
  static $pb.PbList<CommonReplayBlocEvent_NewEvents> createRepeated() => $pb.PbList<CommonReplayBlocEvent_NewEvents>();
  @$core.pragma('dart2js:noInline')
  static CommonReplayBlocEvent_NewEvents getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommonReplayBlocEvent_NewEvents>(create);
  static CommonReplayBlocEvent_NewEvents? _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.int, $core.String> get events => $_getMap(0);
}

enum CommonReplayBlocEvent_EventType {
  listen, 
  newEvents, 
  errorOccurred, 
  notSet
}

class CommonReplayBlocEvent extends $pb.GeneratedMessage {
  factory CommonReplayBlocEvent({
    $core.bool? listen,
    CommonReplayBlocEvent_NewEvents? newEvents,
    $core.String? errorOccurred,
  }) {
    final $result = create();
    if (listen != null) {
      $result.listen = listen;
    }
    if (newEvents != null) {
      $result.newEvents = newEvents;
    }
    if (errorOccurred != null) {
      $result.errorOccurred = errorOccurred;
    }
    return $result;
  }
  CommonReplayBlocEvent._() : super();
  factory CommonReplayBlocEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CommonReplayBlocEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, CommonReplayBlocEvent_EventType> _CommonReplayBlocEvent_EventTypeByTag = {
    1 : CommonReplayBlocEvent_EventType.listen,
    2 : CommonReplayBlocEvent_EventType.newEvents,
    3 : CommonReplayBlocEvent_EventType.errorOccurred,
    0 : CommonReplayBlocEvent_EventType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CommonReplayBlocEvent', createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOB(1, _omitFieldNames ? '' : 'listen')
    ..aOM<CommonReplayBlocEvent_NewEvents>(2, _omitFieldNames ? '' : 'newEvents', protoName: 'newEvents', subBuilder: CommonReplayBlocEvent_NewEvents.create)
    ..aOS(3, _omitFieldNames ? '' : 'errorOccurred', protoName: 'errorOccurred')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CommonReplayBlocEvent clone() => CommonReplayBlocEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CommonReplayBlocEvent copyWith(void Function(CommonReplayBlocEvent) updates) => super.copyWith((message) => updates(message as CommonReplayBlocEvent)) as CommonReplayBlocEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommonReplayBlocEvent create() => CommonReplayBlocEvent._();
  CommonReplayBlocEvent createEmptyInstance() => create();
  static $pb.PbList<CommonReplayBlocEvent> createRepeated() => $pb.PbList<CommonReplayBlocEvent>();
  @$core.pragma('dart2js:noInline')
  static CommonReplayBlocEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommonReplayBlocEvent>(create);
  static CommonReplayBlocEvent? _defaultInstance;

  CommonReplayBlocEvent_EventType whichEventType() => _CommonReplayBlocEvent_EventTypeByTag[$_whichOneof(0)]!;
  void clearEventType() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.bool get listen => $_getBF(0);
  @$pb.TagNumber(1)
  set listen($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasListen() => $_has(0);
  @$pb.TagNumber(1)
  void clearListen() => clearField(1);

  @$pb.TagNumber(2)
  CommonReplayBlocEvent_NewEvents get newEvents => $_getN(1);
  @$pb.TagNumber(2)
  set newEvents(CommonReplayBlocEvent_NewEvents v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasNewEvents() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewEvents() => clearField(2);
  @$pb.TagNumber(2)
  CommonReplayBlocEvent_NewEvents ensureNewEvents() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get errorOccurred => $_getSZ(2);
  @$pb.TagNumber(3)
  set errorOccurred($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasErrorOccurred() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorOccurred() => clearField(3);
}

class EventMapProto extends $pb.GeneratedMessage {
  factory EventMapProto({
    $core.Map<$core.int, $core.String>? events,
  }) {
    final $result = create();
    if (events != null) {
      $result.events.addAll(events);
    }
    return $result;
  }
  EventMapProto._() : super();
  factory EventMapProto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventMapProto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EventMapProto', createEmptyInstance: create)
    ..m<$core.int, $core.String>(1, _omitFieldNames ? '' : 'events', entryClassName: 'EventMapProto.EventsEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.OS)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventMapProto clone() => EventMapProto()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventMapProto copyWith(void Function(EventMapProto) updates) => super.copyWith((message) => updates(message as EventMapProto)) as EventMapProto;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EventMapProto create() => EventMapProto._();
  EventMapProto createEmptyInstance() => create();
  static $pb.PbList<EventMapProto> createRepeated() => $pb.PbList<EventMapProto>();
  @$core.pragma('dart2js:noInline')
  static EventMapProto getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventMapProto>(create);
  static EventMapProto? _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.int, $core.String> get events => $_getMap(0);
}

class CommonSubmitBlocEvent_SubmitNow extends $pb.GeneratedMessage {
  factory CommonSubmitBlocEvent_SubmitNow() => create();
  CommonSubmitBlocEvent_SubmitNow._() : super();
  factory CommonSubmitBlocEvent_SubmitNow.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CommonSubmitBlocEvent_SubmitNow.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CommonSubmitBlocEvent.SubmitNow', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CommonSubmitBlocEvent_SubmitNow clone() => CommonSubmitBlocEvent_SubmitNow()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CommonSubmitBlocEvent_SubmitNow copyWith(void Function(CommonSubmitBlocEvent_SubmitNow) updates) => super.copyWith((message) => updates(message as CommonSubmitBlocEvent_SubmitNow)) as CommonSubmitBlocEvent_SubmitNow;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommonSubmitBlocEvent_SubmitNow create() => CommonSubmitBlocEvent_SubmitNow._();
  CommonSubmitBlocEvent_SubmitNow createEmptyInstance() => create();
  static $pb.PbList<CommonSubmitBlocEvent_SubmitNow> createRepeated() => $pb.PbList<CommonSubmitBlocEvent_SubmitNow>();
  @$core.pragma('dart2js:noInline')
  static CommonSubmitBlocEvent_SubmitNow getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommonSubmitBlocEvent_SubmitNow>(create);
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
    final $result = create();
    if (updatedPayload != null) {
      $result.updatedPayload = updatedPayload;
    }
    if (isFormValid != null) {
      $result.isFormValid = isFormValid;
    }
    if (submit != null) {
      $result.submit = submit;
    }
    return $result;
  }
  CommonSubmitBlocEvent._() : super();
  factory CommonSubmitBlocEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CommonSubmitBlocEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, CommonSubmitBlocEvent_EventType> _CommonSubmitBlocEvent_EventTypeByTag = {
    2 : CommonSubmitBlocEvent_EventType.updatedPayload,
    3 : CommonSubmitBlocEvent_EventType.isFormValid,
    4 : CommonSubmitBlocEvent_EventType.submit,
    0 : CommonSubmitBlocEvent_EventType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CommonSubmitBlocEvent', createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aOS(2, _omitFieldNames ? '' : 'updatedPayload', protoName: 'updatedPayload')
    ..aOB(3, _omitFieldNames ? '' : 'isFormValid', protoName: 'isFormValid')
    ..aOM<CommonSubmitBlocEvent_SubmitNow>(4, _omitFieldNames ? '' : 'submit', subBuilder: CommonSubmitBlocEvent_SubmitNow.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CommonSubmitBlocEvent clone() => CommonSubmitBlocEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CommonSubmitBlocEvent copyWith(void Function(CommonSubmitBlocEvent) updates) => super.copyWith((message) => updates(message as CommonSubmitBlocEvent)) as CommonSubmitBlocEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommonSubmitBlocEvent create() => CommonSubmitBlocEvent._();
  CommonSubmitBlocEvent createEmptyInstance() => create();
  static $pb.PbList<CommonSubmitBlocEvent> createRepeated() => $pb.PbList<CommonSubmitBlocEvent>();
  @$core.pragma('dart2js:noInline')
  static CommonSubmitBlocEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommonSubmitBlocEvent>(create);
  static CommonSubmitBlocEvent? _defaultInstance;

  CommonSubmitBlocEvent_EventType whichEventType() => _CommonSubmitBlocEvent_EventTypeByTag[$_whichOneof(0)]!;
  void clearEventType() => clearField($_whichOneof(0));

  @$pb.TagNumber(2)
  $core.String get updatedPayload => $_getSZ(0);
  @$pb.TagNumber(2)
  set updatedPayload($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasUpdatedPayload() => $_has(0);
  @$pb.TagNumber(2)
  void clearUpdatedPayload() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isFormValid => $_getBF(1);
  @$pb.TagNumber(3)
  set isFormValid($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsFormValid() => $_has(1);
  @$pb.TagNumber(3)
  void clearIsFormValid() => clearField(3);

  @$pb.TagNumber(4)
  CommonSubmitBlocEvent_SubmitNow get submit => $_getN(2);
  @$pb.TagNumber(4)
  set submit(CommonSubmitBlocEvent_SubmitNow v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSubmit() => $_has(2);
  @$pb.TagNumber(4)
  void clearSubmit() => clearField(4);
  @$pb.TagNumber(4)
  CommonSubmitBlocEvent_SubmitNow ensureSubmit() => $_ensure(2);
}

class CommonSubmitBlocState_SubmitProgress extends $pb.GeneratedMessage {
  factory CommonSubmitBlocState_SubmitProgress({
    $core.int? count,
    $core.int? total,
  }) {
    final $result = create();
    if (count != null) {
      $result.count = count;
    }
    if (total != null) {
      $result.total = total;
    }
    return $result;
  }
  CommonSubmitBlocState_SubmitProgress._() : super();
  factory CommonSubmitBlocState_SubmitProgress.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CommonSubmitBlocState_SubmitProgress.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CommonSubmitBlocState.SubmitProgress', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'count', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'total', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CommonSubmitBlocState_SubmitProgress clone() => CommonSubmitBlocState_SubmitProgress()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CommonSubmitBlocState_SubmitProgress copyWith(void Function(CommonSubmitBlocState_SubmitProgress) updates) => super.copyWith((message) => updates(message as CommonSubmitBlocState_SubmitProgress)) as CommonSubmitBlocState_SubmitProgress;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommonSubmitBlocState_SubmitProgress create() => CommonSubmitBlocState_SubmitProgress._();
  CommonSubmitBlocState_SubmitProgress createEmptyInstance() => create();
  static $pb.PbList<CommonSubmitBlocState_SubmitProgress> createRepeated() => $pb.PbList<CommonSubmitBlocState_SubmitProgress>();
  @$core.pragma('dart2js:noInline')
  static CommonSubmitBlocState_SubmitProgress getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommonSubmitBlocState_SubmitProgress>(create);
  static CommonSubmitBlocState_SubmitProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get count => $_getIZ(0);
  @$pb.TagNumber(1)
  set count($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => clearField(2);
}

class CommonSubmitBlocState extends $pb.GeneratedMessage {
  factory CommonSubmitBlocState({
    CommonSubmitBlocState_State? state,
    CommonSubmitBlocState_ErrorCode? errorCode,
    CommonSubmitBlocState_SubmitProgress? progress,
  }) {
    final $result = create();
    if (state != null) {
      $result.state = state;
    }
    if (errorCode != null) {
      $result.errorCode = errorCode;
    }
    if (progress != null) {
      $result.progress = progress;
    }
    return $result;
  }
  CommonSubmitBlocState._() : super();
  factory CommonSubmitBlocState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CommonSubmitBlocState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CommonSubmitBlocState', createEmptyInstance: create)
    ..e<CommonSubmitBlocState_State>(1, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: CommonSubmitBlocState_State.ready, valueOf: CommonSubmitBlocState_State.valueOf, enumValues: CommonSubmitBlocState_State.values)
    ..e<CommonSubmitBlocState_ErrorCode>(8, _omitFieldNames ? '' : 'errorCode', $pb.PbFieldType.OE, protoName: 'errorCode', defaultOrMaker: CommonSubmitBlocState_ErrorCode.none, valueOf: CommonSubmitBlocState_ErrorCode.valueOf, enumValues: CommonSubmitBlocState_ErrorCode.values)
    ..aOM<CommonSubmitBlocState_SubmitProgress>(9, _omitFieldNames ? '' : 'progress', subBuilder: CommonSubmitBlocState_SubmitProgress.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CommonSubmitBlocState clone() => CommonSubmitBlocState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CommonSubmitBlocState copyWith(void Function(CommonSubmitBlocState) updates) => super.copyWith((message) => updates(message as CommonSubmitBlocState)) as CommonSubmitBlocState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommonSubmitBlocState create() => CommonSubmitBlocState._();
  CommonSubmitBlocState createEmptyInstance() => create();
  static $pb.PbList<CommonSubmitBlocState> createRepeated() => $pb.PbList<CommonSubmitBlocState>();
  @$core.pragma('dart2js:noInline')
  static CommonSubmitBlocState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommonSubmitBlocState>(create);
  static CommonSubmitBlocState? _defaultInstance;

  @$pb.TagNumber(1)
  CommonSubmitBlocState_State get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(CommonSubmitBlocState_State v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => clearField(1);

  @$pb.TagNumber(8)
  CommonSubmitBlocState_ErrorCode get errorCode => $_getN(1);
  @$pb.TagNumber(8)
  set errorCode(CommonSubmitBlocState_ErrorCode v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasErrorCode() => $_has(1);
  @$pb.TagNumber(8)
  void clearErrorCode() => clearField(8);

  @$pb.TagNumber(9)
  CommonSubmitBlocState_SubmitProgress get progress => $_getN(2);
  @$pb.TagNumber(9)
  set progress(CommonSubmitBlocState_SubmitProgress v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasProgress() => $_has(2);
  @$pb.TagNumber(9)
  void clearProgress() => clearField(9);
  @$pb.TagNumber(9)
  CommonSubmitBlocState_SubmitProgress ensureProgress() => $_ensure(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
