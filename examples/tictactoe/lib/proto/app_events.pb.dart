//
//  Generated code. Do not modify.
//  source: app_events.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AppEvent_Move extends $pb.GeneratedMessage {
  factory AppEvent_Move({
    $core.int? x,
    $core.int? y,
    $core.int? player,
  }) {
    final $result = create();
    if (x != null) {
      $result.x = x;
    }
    if (y != null) {
      $result.y = y;
    }
    if (player != null) {
      $result.player = player;
    }
    return $result;
  }
  AppEvent_Move._() : super();
  factory AppEvent_Move.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_Move.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.Move', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub.example.tictactoe'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'x', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'y', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'player', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_Move clone() => AppEvent_Move()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_Move copyWith(void Function(AppEvent_Move) updates) => super.copyWith((message) => updates(message as AppEvent_Move)) as AppEvent_Move;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_Move create() => AppEvent_Move._();
  AppEvent_Move createEmptyInstance() => create();
  static $pb.PbList<AppEvent_Move> createRepeated() => $pb.PbList<AppEvent_Move>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_Move getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_Move>(create);
  static AppEvent_Move? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get x => $_getIZ(0);
  @$pb.TagNumber(1)
  set x($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get y => $_getIZ(1);
  @$pb.TagNumber(2)
  set y($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get player => $_getIZ(2);
  @$pb.TagNumber(3)
  set player($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPlayer() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlayer() => clearField(3);
}

enum AppEvent_Event {
  move, 
  notSet
}

class AppEvent extends $pb.GeneratedMessage {
  factory AppEvent({
    AppEvent_Move? move,
  }) {
    final $result = create();
    if (move != null) {
      $result.move = move;
    }
    return $result;
  }
  AppEvent._() : super();
  factory AppEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, AppEvent_Event> _AppEvent_EventByTag = {
    1 : AppEvent_Event.move,
    0 : AppEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub.example.tictactoe'), createEmptyInstance: create)
    ..oo(0, [1])
    ..aOM<AppEvent_Move>(1, _omitFieldNames ? '' : 'move', subBuilder: AppEvent_Move.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent clone() => AppEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent copyWith(void Function(AppEvent) updates) => super.copyWith((message) => updates(message as AppEvent)) as AppEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent create() => AppEvent._();
  AppEvent createEmptyInstance() => create();
  static $pb.PbList<AppEvent> createRepeated() => $pb.PbList<AppEvent>();
  @$core.pragma('dart2js:noInline')
  static AppEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent>(create);
  static AppEvent? _defaultInstance;

  AppEvent_Event whichEvent() => _AppEvent_EventByTag[$_whichOneof(0)]!;
  void clearEvent() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  AppEvent_Move get move => $_getN(0);
  @$pb.TagNumber(1)
  set move(AppEvent_Move v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasMove() => $_has(0);
  @$pb.TagNumber(1)
  void clearMove() => clearField(1);
  @$pb.TagNumber(1)
  AppEvent_Move ensureMove() => $_ensure(0);
}

/// the final site event will contain this app event
class SubmitAppEvent_SiteEvent extends $pb.GeneratedMessage {
  factory SubmitAppEvent_SiteEvent({
    $core.int? version,
    $core.int? author,
  }) {
    final $result = create();
    if (version != null) {
      $result.version = version;
    }
    if (author != null) {
      $result.author = author;
    }
    return $result;
  }
  SubmitAppEvent_SiteEvent._() : super();
  factory SubmitAppEvent_SiteEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitAppEvent_SiteEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitAppEvent.SiteEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub.example.tictactoe'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'version', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'author', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitAppEvent_SiteEvent clone() => SubmitAppEvent_SiteEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitAppEvent_SiteEvent copyWith(void Function(SubmitAppEvent_SiteEvent) updates) => super.copyWith((message) => updates(message as SubmitAppEvent_SiteEvent)) as SubmitAppEvent_SiteEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitAppEvent_SiteEvent create() => SubmitAppEvent_SiteEvent._();
  SubmitAppEvent_SiteEvent createEmptyInstance() => create();
  static $pb.PbList<SubmitAppEvent_SiteEvent> createRepeated() => $pb.PbList<SubmitAppEvent_SiteEvent>();
  @$core.pragma('dart2js:noInline')
  static SubmitAppEvent_SiteEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitAppEvent_SiteEvent>(create);
  static SubmitAppEvent_SiteEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get author => $_getIZ(1);
  @$pb.TagNumber(2)
  set author($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAuthor() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthor() => clearField(2);
}

class SubmitAppEvent_Image extends $pb.GeneratedMessage {
  factory SubmitAppEvent_Image({
    $core.String? base64Data,
    $core.String? name,
    $core.int? size,
  }) {
    final $result = create();
    if (base64Data != null) {
      $result.base64Data = base64Data;
    }
    if (name != null) {
      $result.name = name;
    }
    if (size != null) {
      $result.size = size;
    }
    return $result;
  }
  SubmitAppEvent_Image._() : super();
  factory SubmitAppEvent_Image.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitAppEvent_Image.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitAppEvent.Image', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub.example.tictactoe'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'base64Data', protoName: 'base64Data')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'size', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitAppEvent_Image clone() => SubmitAppEvent_Image()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitAppEvent_Image copyWith(void Function(SubmitAppEvent_Image) updates) => super.copyWith((message) => updates(message as SubmitAppEvent_Image)) as SubmitAppEvent_Image;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitAppEvent_Image create() => SubmitAppEvent_Image._();
  SubmitAppEvent_Image createEmptyInstance() => create();
  static $pb.PbList<SubmitAppEvent_Image> createRepeated() => $pb.PbList<SubmitAppEvent_Image>();
  @$core.pragma('dart2js:noInline')
  static SubmitAppEvent_Image getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitAppEvent_Image>(create);
  static SubmitAppEvent_Image? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get base64Data => $_getSZ(0);
  @$pb.TagNumber(1)
  set base64Data($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBase64Data() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase64Data() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get size => $_getIZ(2);
  @$pb.TagNumber(3)
  set size($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearSize() => clearField(3);
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
  }) {
    final $result = create();
    if (appEvent != null) {
      $result.appEvent = appEvent;
    }
    if (siteEvent != null) {
      $result.siteEvent = siteEvent;
    }
    if (authorEmail != null) {
      $result.authorEmail = authorEmail;
    }
    if (images != null) {
      $result.images.addAll(images);
    }
    return $result;
  }
  SubmitAppEvent._() : super();
  factory SubmitAppEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitAppEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitAppEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub.example.tictactoe'), createEmptyInstance: create)
    ..aOM<AppEvent>(1, _omitFieldNames ? '' : 'appEvent', protoName: 'appEvent', subBuilder: AppEvent.create)
    ..aOM<SubmitAppEvent_SiteEvent>(2, _omitFieldNames ? '' : 'siteEvent', protoName: 'siteEvent', subBuilder: SubmitAppEvent_SiteEvent.create)
    ..aOS(3, _omitFieldNames ? '' : 'authorEmail', protoName: 'authorEmail')
    ..pc<SubmitAppEvent_Image>(4, _omitFieldNames ? '' : 'images', $pb.PbFieldType.PM, subBuilder: SubmitAppEvent_Image.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitAppEvent clone() => SubmitAppEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitAppEvent copyWith(void Function(SubmitAppEvent) updates) => super.copyWith((message) => updates(message as SubmitAppEvent)) as SubmitAppEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitAppEvent create() => SubmitAppEvent._();
  SubmitAppEvent createEmptyInstance() => create();
  static $pb.PbList<SubmitAppEvent> createRepeated() => $pb.PbList<SubmitAppEvent>();
  @$core.pragma('dart2js:noInline')
  static SubmitAppEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitAppEvent>(create);
  static SubmitAppEvent? _defaultInstance;

  @$pb.TagNumber(1)
  AppEvent get appEvent => $_getN(0);
  @$pb.TagNumber(1)
  set appEvent(AppEvent v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAppEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppEvent() => clearField(1);
  @$pb.TagNumber(1)
  AppEvent ensureAppEvent() => $_ensure(0);

  @$pb.TagNumber(2)
  SubmitAppEvent_SiteEvent get siteEvent => $_getN(1);
  @$pb.TagNumber(2)
  set siteEvent(SubmitAppEvent_SiteEvent v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSiteEvent() => $_has(1);
  @$pb.TagNumber(2)
  void clearSiteEvent() => clearField(2);
  @$pb.TagNumber(2)
  SubmitAppEvent_SiteEvent ensureSiteEvent() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get authorEmail => $_getSZ(2);
  @$pb.TagNumber(3)
  set authorEmail($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAuthorEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthorEmail() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<SubmitAppEvent_Image> get images => $_getList(3);
}

/// The AppEventRecord is a representation of the actual record stored in the
/// database This record is used just for display purposes in the client
class AppEventRecord extends $pb.GeneratedMessage {
  factory AppEventRecord({
    $core.String? isoDate,
    $core.int? version,
    AppEvent? appEvent,
  }) {
    final $result = create();
    if (isoDate != null) {
      $result.isoDate = isoDate;
    }
    if (version != null) {
      $result.version = version;
    }
    if (appEvent != null) {
      $result.appEvent = appEvent;
    }
    return $result;
  }
  AppEventRecord._() : super();
  factory AppEventRecord.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEventRecord.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEventRecord', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub.example.tictactoe'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'isoDate', protoName: 'isoDate')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'version', $pb.PbFieldType.O3)
    ..aOM<AppEvent>(3, _omitFieldNames ? '' : 'appEvent', protoName: 'appEvent', subBuilder: AppEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEventRecord clone() => AppEventRecord()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEventRecord copyWith(void Function(AppEventRecord) updates) => super.copyWith((message) => updates(message as AppEventRecord)) as AppEventRecord;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEventRecord create() => AppEventRecord._();
  AppEventRecord createEmptyInstance() => create();
  static $pb.PbList<AppEventRecord> createRepeated() => $pb.PbList<AppEventRecord>();
  @$core.pragma('dart2js:noInline')
  static AppEventRecord getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEventRecord>(create);
  static AppEventRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get isoDate => $_getSZ(0);
  @$pb.TagNumber(1)
  set isoDate($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIsoDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsoDate() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get version => $_getIZ(1);
  @$pb.TagNumber(2)
  set version($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => clearField(2);

  @$pb.TagNumber(3)
  AppEvent get appEvent => $_getN(2);
  @$pb.TagNumber(3)
  set appEvent(AppEvent v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAppEvent() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppEvent() => clearField(3);
  @$pb.TagNumber(3)
  AppEvent ensureAppEvent() => $_ensure(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
