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

class AppEvent_AddAlbum extends $pb.GeneratedMessage {
  factory AppEvent_AddAlbum({
    $core.String? name,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  AppEvent_AddAlbum._() : super();
  factory AppEvent_AddAlbum.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_AddAlbum.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.AddAlbum', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_AddAlbum clone() => AppEvent_AddAlbum()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_AddAlbum copyWith(void Function(AppEvent_AddAlbum) updates) => super.copyWith((message) => updates(message as AppEvent_AddAlbum)) as AppEvent_AddAlbum;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_AddAlbum create() => AppEvent_AddAlbum._();
  AppEvent_AddAlbum createEmptyInstance() => create();
  static $pb.PbList<AppEvent_AddAlbum> createRepeated() => $pb.PbList<AppEvent_AddAlbum>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_AddAlbum getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_AddAlbum>(create);
  static AppEvent_AddAlbum? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);
}

class AppEvent_AddPhoto extends $pb.GeneratedMessage {
  factory AppEvent_AddPhoto({
    $core.int? albumId,
    $core.String? name,
    $core.int? size,
  }) {
    final $result = create();
    if (albumId != null) {
      $result.albumId = albumId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (size != null) {
      $result.size = size;
    }
    return $result;
  }
  AppEvent_AddPhoto._() : super();
  factory AppEvent_AddPhoto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_AddPhoto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.AddPhoto', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'albumId', $pb.PbFieldType.O3, protoName: 'albumId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'size', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_AddPhoto clone() => AppEvent_AddPhoto()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_AddPhoto copyWith(void Function(AppEvent_AddPhoto) updates) => super.copyWith((message) => updates(message as AppEvent_AddPhoto)) as AppEvent_AddPhoto;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_AddPhoto create() => AppEvent_AddPhoto._();
  AppEvent_AddPhoto createEmptyInstance() => create();
  static $pb.PbList<AppEvent_AddPhoto> createRepeated() => $pb.PbList<AppEvent_AddPhoto>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_AddPhoto getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_AddPhoto>(create);
  static AppEvent_AddPhoto? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get albumId => $_getIZ(0);
  @$pb.TagNumber(1)
  set albumId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAlbumId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlbumId() => clearField(1);

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

class AppEvent_ReorderAlbums extends $pb.GeneratedMessage {
  factory AppEvent_ReorderAlbums({
    $core.Iterable<$core.int>? albumIds,
  }) {
    final $result = create();
    if (albumIds != null) {
      $result.albumIds.addAll(albumIds);
    }
    return $result;
  }
  AppEvent_ReorderAlbums._() : super();
  factory AppEvent_ReorderAlbums.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_ReorderAlbums.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.ReorderAlbums', createEmptyInstance: create)
    ..p<$core.int>(1, _omitFieldNames ? '' : 'albumIds', $pb.PbFieldType.K3, protoName: 'albumIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_ReorderAlbums clone() => AppEvent_ReorderAlbums()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_ReorderAlbums copyWith(void Function(AppEvent_ReorderAlbums) updates) => super.copyWith((message) => updates(message as AppEvent_ReorderAlbums)) as AppEvent_ReorderAlbums;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_ReorderAlbums create() => AppEvent_ReorderAlbums._();
  AppEvent_ReorderAlbums createEmptyInstance() => create();
  static $pb.PbList<AppEvent_ReorderAlbums> createRepeated() => $pb.PbList<AppEvent_ReorderAlbums>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_ReorderAlbums getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_ReorderAlbums>(create);
  static AppEvent_ReorderAlbums? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get albumIds => $_getList(0);
}

class AppEvent_UpdateAlbum extends $pb.GeneratedMessage {
  factory AppEvent_UpdateAlbum({
    $core.int? albumId,
    $core.String? name,
  }) {
    final $result = create();
    if (albumId != null) {
      $result.albumId = albumId;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  AppEvent_UpdateAlbum._() : super();
  factory AppEvent_UpdateAlbum.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_UpdateAlbum.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.UpdateAlbum', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'albumId', $pb.PbFieldType.O3, protoName: 'albumId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_UpdateAlbum clone() => AppEvent_UpdateAlbum()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_UpdateAlbum copyWith(void Function(AppEvent_UpdateAlbum) updates) => super.copyWith((message) => updates(message as AppEvent_UpdateAlbum)) as AppEvent_UpdateAlbum;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateAlbum create() => AppEvent_UpdateAlbum._();
  AppEvent_UpdateAlbum createEmptyInstance() => create();
  static $pb.PbList<AppEvent_UpdateAlbum> createRepeated() => $pb.PbList<AppEvent_UpdateAlbum>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateAlbum getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_UpdateAlbum>(create);
  static AppEvent_UpdateAlbum? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get albumId => $_getIZ(0);
  @$pb.TagNumber(1)
  set albumId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAlbumId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlbumId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

class AppEvent_DeleteAlbum extends $pb.GeneratedMessage {
  factory AppEvent_DeleteAlbum({
    $core.int? albumId,
  }) {
    final $result = create();
    if (albumId != null) {
      $result.albumId = albumId;
    }
    return $result;
  }
  AppEvent_DeleteAlbum._() : super();
  factory AppEvent_DeleteAlbum.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_DeleteAlbum.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.DeleteAlbum', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'albumId', $pb.PbFieldType.O3, protoName: 'albumId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_DeleteAlbum clone() => AppEvent_DeleteAlbum()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_DeleteAlbum copyWith(void Function(AppEvent_DeleteAlbum) updates) => super.copyWith((message) => updates(message as AppEvent_DeleteAlbum)) as AppEvent_DeleteAlbum;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_DeleteAlbum create() => AppEvent_DeleteAlbum._();
  AppEvent_DeleteAlbum createEmptyInstance() => create();
  static $pb.PbList<AppEvent_DeleteAlbum> createRepeated() => $pb.PbList<AppEvent_DeleteAlbum>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_DeleteAlbum getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_DeleteAlbum>(create);
  static AppEvent_DeleteAlbum? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get albumId => $_getIZ(0);
  @$pb.TagNumber(1)
  set albumId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAlbumId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlbumId() => clearField(1);
}

class AppEvent_UpdateCaption extends $pb.GeneratedMessage {
  factory AppEvent_UpdateCaption({
    $core.int? photoId,
    $core.String? caption,
  }) {
    final $result = create();
    if (photoId != null) {
      $result.photoId = photoId;
    }
    if (caption != null) {
      $result.caption = caption;
    }
    return $result;
  }
  AppEvent_UpdateCaption._() : super();
  factory AppEvent_UpdateCaption.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_UpdateCaption.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.UpdateCaption', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'photoId', $pb.PbFieldType.O3, protoName: 'photoId')
    ..aOS(2, _omitFieldNames ? '' : 'caption')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_UpdateCaption clone() => AppEvent_UpdateCaption()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_UpdateCaption copyWith(void Function(AppEvent_UpdateCaption) updates) => super.copyWith((message) => updates(message as AppEvent_UpdateCaption)) as AppEvent_UpdateCaption;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateCaption create() => AppEvent_UpdateCaption._();
  AppEvent_UpdateCaption createEmptyInstance() => create();
  static $pb.PbList<AppEvent_UpdateCaption> createRepeated() => $pb.PbList<AppEvent_UpdateCaption>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateCaption getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_UpdateCaption>(create);
  static AppEvent_UpdateCaption? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get photoId => $_getIZ(0);
  @$pb.TagNumber(1)
  set photoId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPhotoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhotoId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get caption => $_getSZ(1);
  @$pb.TagNumber(2)
  set caption($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCaption() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaption() => clearField(2);
}

class AppEvent_DeletePhoto extends $pb.GeneratedMessage {
  factory AppEvent_DeletePhoto({
    $core.int? photoId,
  }) {
    final $result = create();
    if (photoId != null) {
      $result.photoId = photoId;
    }
    return $result;
  }
  AppEvent_DeletePhoto._() : super();
  factory AppEvent_DeletePhoto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_DeletePhoto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.DeletePhoto', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'photoId', $pb.PbFieldType.O3, protoName: 'photoId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_DeletePhoto clone() => AppEvent_DeletePhoto()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_DeletePhoto copyWith(void Function(AppEvent_DeletePhoto) updates) => super.copyWith((message) => updates(message as AppEvent_DeletePhoto)) as AppEvent_DeletePhoto;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_DeletePhoto create() => AppEvent_DeletePhoto._();
  AppEvent_DeletePhoto createEmptyInstance() => create();
  static $pb.PbList<AppEvent_DeletePhoto> createRepeated() => $pb.PbList<AppEvent_DeletePhoto>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_DeletePhoto getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_DeletePhoto>(create);
  static AppEvent_DeletePhoto? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get photoId => $_getIZ(0);
  @$pb.TagNumber(1)
  set photoId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPhotoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhotoId() => clearField(1);
}

class AppEvent_ReorderPhotos extends $pb.GeneratedMessage {
  factory AppEvent_ReorderPhotos({
    $core.int? albumId,
    $core.Iterable<$core.int>? photoIds,
  }) {
    final $result = create();
    if (albumId != null) {
      $result.albumId = albumId;
    }
    if (photoIds != null) {
      $result.photoIds.addAll(photoIds);
    }
    return $result;
  }
  AppEvent_ReorderPhotos._() : super();
  factory AppEvent_ReorderPhotos.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_ReorderPhotos.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.ReorderPhotos', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'albumId', $pb.PbFieldType.O3, protoName: 'albumId')
    ..p<$core.int>(2, _omitFieldNames ? '' : 'photoIds', $pb.PbFieldType.K3, protoName: 'photoIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_ReorderPhotos clone() => AppEvent_ReorderPhotos()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_ReorderPhotos copyWith(void Function(AppEvent_ReorderPhotos) updates) => super.copyWith((message) => updates(message as AppEvent_ReorderPhotos)) as AppEvent_ReorderPhotos;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_ReorderPhotos create() => AppEvent_ReorderPhotos._();
  AppEvent_ReorderPhotos createEmptyInstance() => create();
  static $pb.PbList<AppEvent_ReorderPhotos> createRepeated() => $pb.PbList<AppEvent_ReorderPhotos>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_ReorderPhotos getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_ReorderPhotos>(create);
  static AppEvent_ReorderPhotos? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get albumId => $_getIZ(0);
  @$pb.TagNumber(1)
  set albumId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAlbumId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlbumId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get photoIds => $_getList(1);
}

enum AppEvent_EventType {
  addAlbum, 
  addPhoto, 
  reorderAlbums, 
  updateAlbum, 
  deleteAlbum, 
  updateCaption, 
  deletePhoto, 
  reorderPhotos, 
  notSet
}

class AppEvent extends $pb.GeneratedMessage {
  factory AppEvent({
    AppEvent_AddAlbum? addAlbum,
    AppEvent_AddPhoto? addPhoto,
    AppEvent_ReorderAlbums? reorderAlbums,
    AppEvent_UpdateAlbum? updateAlbum,
    AppEvent_DeleteAlbum? deleteAlbum,
    AppEvent_UpdateCaption? updateCaption,
    AppEvent_DeletePhoto? deletePhoto,
    AppEvent_ReorderPhotos? reorderPhotos,
  }) {
    final $result = create();
    if (addAlbum != null) {
      $result.addAlbum = addAlbum;
    }
    if (addPhoto != null) {
      $result.addPhoto = addPhoto;
    }
    if (reorderAlbums != null) {
      $result.reorderAlbums = reorderAlbums;
    }
    if (updateAlbum != null) {
      $result.updateAlbum = updateAlbum;
    }
    if (deleteAlbum != null) {
      $result.deleteAlbum = deleteAlbum;
    }
    if (updateCaption != null) {
      $result.updateCaption = updateCaption;
    }
    if (deletePhoto != null) {
      $result.deletePhoto = deletePhoto;
    }
    if (reorderPhotos != null) {
      $result.reorderPhotos = reorderPhotos;
    }
    return $result;
  }
  AppEvent._() : super();
  factory AppEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, AppEvent_EventType> _AppEvent_EventTypeByTag = {
    1 : AppEvent_EventType.addAlbum,
    2 : AppEvent_EventType.addPhoto,
    3 : AppEvent_EventType.reorderAlbums,
    4 : AppEvent_EventType.updateAlbum,
    5 : AppEvent_EventType.deleteAlbum,
    6 : AppEvent_EventType.updateCaption,
    7 : AppEvent_EventType.deletePhoto,
    8 : AppEvent_EventType.reorderPhotos,
    0 : AppEvent_EventType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent', createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8])
    ..aOM<AppEvent_AddAlbum>(1, _omitFieldNames ? '' : 'addAlbum', protoName: 'addAlbum', subBuilder: AppEvent_AddAlbum.create)
    ..aOM<AppEvent_AddPhoto>(2, _omitFieldNames ? '' : 'addPhoto', protoName: 'addPhoto', subBuilder: AppEvent_AddPhoto.create)
    ..aOM<AppEvent_ReorderAlbums>(3, _omitFieldNames ? '' : 'reorderAlbums', protoName: 'reorderAlbums', subBuilder: AppEvent_ReorderAlbums.create)
    ..aOM<AppEvent_UpdateAlbum>(4, _omitFieldNames ? '' : 'updateAlbum', protoName: 'updateAlbum', subBuilder: AppEvent_UpdateAlbum.create)
    ..aOM<AppEvent_DeleteAlbum>(5, _omitFieldNames ? '' : 'deleteAlbum', protoName: 'deleteAlbum', subBuilder: AppEvent_DeleteAlbum.create)
    ..aOM<AppEvent_UpdateCaption>(6, _omitFieldNames ? '' : 'updateCaption', protoName: 'updateCaption', subBuilder: AppEvent_UpdateCaption.create)
    ..aOM<AppEvent_DeletePhoto>(7, _omitFieldNames ? '' : 'deletePhoto', protoName: 'deletePhoto', subBuilder: AppEvent_DeletePhoto.create)
    ..aOM<AppEvent_ReorderPhotos>(8, _omitFieldNames ? '' : 'reorderPhotos', protoName: 'reorderPhotos', subBuilder: AppEvent_ReorderPhotos.create)
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

  AppEvent_EventType whichEventType() => _AppEvent_EventTypeByTag[$_whichOneof(0)]!;
  void clearEventType() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  AppEvent_AddAlbum get addAlbum => $_getN(0);
  @$pb.TagNumber(1)
  set addAlbum(AppEvent_AddAlbum v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddAlbum() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddAlbum() => clearField(1);
  @$pb.TagNumber(1)
  AppEvent_AddAlbum ensureAddAlbum() => $_ensure(0);

  @$pb.TagNumber(2)
  AppEvent_AddPhoto get addPhoto => $_getN(1);
  @$pb.TagNumber(2)
  set addPhoto(AppEvent_AddPhoto v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAddPhoto() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddPhoto() => clearField(2);
  @$pb.TagNumber(2)
  AppEvent_AddPhoto ensureAddPhoto() => $_ensure(1);

  @$pb.TagNumber(3)
  AppEvent_ReorderAlbums get reorderAlbums => $_getN(2);
  @$pb.TagNumber(3)
  set reorderAlbums(AppEvent_ReorderAlbums v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasReorderAlbums() => $_has(2);
  @$pb.TagNumber(3)
  void clearReorderAlbums() => clearField(3);
  @$pb.TagNumber(3)
  AppEvent_ReorderAlbums ensureReorderAlbums() => $_ensure(2);

  @$pb.TagNumber(4)
  AppEvent_UpdateAlbum get updateAlbum => $_getN(3);
  @$pb.TagNumber(4)
  set updateAlbum(AppEvent_UpdateAlbum v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasUpdateAlbum() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdateAlbum() => clearField(4);
  @$pb.TagNumber(4)
  AppEvent_UpdateAlbum ensureUpdateAlbum() => $_ensure(3);

  @$pb.TagNumber(5)
  AppEvent_DeleteAlbum get deleteAlbum => $_getN(4);
  @$pb.TagNumber(5)
  set deleteAlbum(AppEvent_DeleteAlbum v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasDeleteAlbum() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeleteAlbum() => clearField(5);
  @$pb.TagNumber(5)
  AppEvent_DeleteAlbum ensureDeleteAlbum() => $_ensure(4);

  @$pb.TagNumber(6)
  AppEvent_UpdateCaption get updateCaption => $_getN(5);
  @$pb.TagNumber(6)
  set updateCaption(AppEvent_UpdateCaption v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasUpdateCaption() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpdateCaption() => clearField(6);
  @$pb.TagNumber(6)
  AppEvent_UpdateCaption ensureUpdateCaption() => $_ensure(5);

  @$pb.TagNumber(7)
  AppEvent_DeletePhoto get deletePhoto => $_getN(6);
  @$pb.TagNumber(7)
  set deletePhoto(AppEvent_DeletePhoto v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasDeletePhoto() => $_has(6);
  @$pb.TagNumber(7)
  void clearDeletePhoto() => clearField(7);
  @$pb.TagNumber(7)
  AppEvent_DeletePhoto ensureDeletePhoto() => $_ensure(6);

  @$pb.TagNumber(8)
  AppEvent_ReorderPhotos get reorderPhotos => $_getN(7);
  @$pb.TagNumber(8)
  set reorderPhotos(AppEvent_ReorderPhotos v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasReorderPhotos() => $_has(7);
  @$pb.TagNumber(8)
  void clearReorderPhotos() => clearField(8);
  @$pb.TagNumber(8)
  AppEvent_ReorderPhotos ensureReorderPhotos() => $_ensure(7);
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

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitAppEvent.SiteEvent', createEmptyInstance: create)
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

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitAppEvent.Image', createEmptyInstance: create)
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
    $core.Iterable<$core.int>? photoIdsToDelete,
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
    if (photoIdsToDelete != null) {
      $result.photoIdsToDelete.addAll(photoIdsToDelete);
    }
    return $result;
  }
  SubmitAppEvent._() : super();
  factory SubmitAppEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitAppEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitAppEvent', createEmptyInstance: create)
    ..aOM<AppEvent>(1, _omitFieldNames ? '' : 'appEvent', protoName: 'appEvent', subBuilder: AppEvent.create)
    ..aOM<SubmitAppEvent_SiteEvent>(2, _omitFieldNames ? '' : 'siteEvent', protoName: 'siteEvent', subBuilder: SubmitAppEvent_SiteEvent.create)
    ..aOS(3, _omitFieldNames ? '' : 'authorEmail', protoName: 'authorEmail')
    ..pc<SubmitAppEvent_Image>(10, _omitFieldNames ? '' : 'images', $pb.PbFieldType.PM, subBuilder: SubmitAppEvent_Image.create)
    ..p<$core.int>(11, _omitFieldNames ? '' : 'photoIdsToDelete', $pb.PbFieldType.K3)
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

  @$pb.TagNumber(10)
  $core.List<SubmitAppEvent_Image> get images => $_getList(3);

  @$pb.TagNumber(11)
  $core.List<$core.int> get photoIdsToDelete => $_getList(4);
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

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEventRecord', createEmptyInstance: create)
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
