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

class TreeConnectionInfo extends $pb.GeneratedMessage {
  factory TreeConnectionInfo({
    $core.int? id,
    $0.TreeConnection? connection,
    $core.int? toTreeMemberId,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (connection != null) {
      $result.connection = connection;
    }
    if (toTreeMemberId != null) {
      $result.toTreeMemberId = toTreeMemberId;
    }
    return $result;
  }
  TreeConnectionInfo._() : super();
  factory TreeConnectionInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TreeConnectionInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TreeConnectionInfo', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOM<$0.TreeConnection>(2, _omitFieldNames ? '' : 'connection', subBuilder: $0.TreeConnection.create)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'toTreeMemberId', $pb.PbFieldType.O3, protoName: 'toTreeMemberId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TreeConnectionInfo clone() => TreeConnectionInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TreeConnectionInfo copyWith(void Function(TreeConnectionInfo) updates) => super.copyWith((message) => updates(message as TreeConnectionInfo)) as TreeConnectionInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TreeConnectionInfo create() => TreeConnectionInfo._();
  TreeConnectionInfo createEmptyInstance() => create();
  static $pb.PbList<TreeConnectionInfo> createRepeated() => $pb.PbList<TreeConnectionInfo>();
  @$core.pragma('dart2js:noInline')
  static TreeConnectionInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TreeConnectionInfo>(create);
  static TreeConnectionInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $0.TreeConnection get connection => $_getN(1);
  @$pb.TagNumber(2)
  set connection($0.TreeConnection v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasConnection() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnection() => clearField(2);
  @$pb.TagNumber(2)
  $0.TreeConnection ensureConnection() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get toTreeMemberId => $_getIZ(2);
  @$pb.TagNumber(3)
  set toTreeMemberId($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasToTreeMemberId() => $_has(2);
  @$pb.TagNumber(3)
  void clearToTreeMemberId() => clearField(3);
}

class Photo extends $pb.GeneratedMessage {
  factory Photo({
    $core.int? id,
    $core.String? name,
    $core.int? size,
    $core.String? caption,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (size != null) {
      $result.size = size;
    }
    if (caption != null) {
      $result.caption = caption;
    }
    return $result;
  }
  Photo._() : super();
  factory Photo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Photo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Photo', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'size', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'caption')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Photo clone() => Photo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Photo copyWith(void Function(Photo) updates) => super.copyWith((message) => updates(message as Photo)) as Photo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Photo create() => Photo._();
  Photo createEmptyInstance() => create();
  static $pb.PbList<Photo> createRepeated() => $pb.PbList<Photo>();
  @$core.pragma('dart2js:noInline')
  static Photo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Photo>(create);
  static Photo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get size => $_getIZ(2);
  @$pb.TagNumber(4)
  set size($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasSize() => $_has(2);
  @$pb.TagNumber(4)
  void clearSize() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get caption => $_getSZ(3);
  @$pb.TagNumber(5)
  set caption($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasCaption() => $_has(3);
  @$pb.TagNumber(5)
  void clearCaption() => clearField(5);
}

class TreePersonInfo extends $pb.GeneratedMessage {
  factory TreePersonInfo({
    $core.int? id,
    $core.String? name,
    $core.Iterable<Photo>? photos,
    $core.Iterable<TreeConnectionInfo>? connections,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (photos != null) {
      $result.photos.addAll(photos);
    }
    if (connections != null) {
      $result.connections.addAll(connections);
    }
    return $result;
  }
  TreePersonInfo._() : super();
  factory TreePersonInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TreePersonInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TreePersonInfo', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..pc<Photo>(3, _omitFieldNames ? '' : 'photos', $pb.PbFieldType.PM, subBuilder: Photo.create)
    ..pc<TreeConnectionInfo>(4, _omitFieldNames ? '' : 'connections', $pb.PbFieldType.PM, subBuilder: TreeConnectionInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TreePersonInfo clone() => TreePersonInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TreePersonInfo copyWith(void Function(TreePersonInfo) updates) => super.copyWith((message) => updates(message as TreePersonInfo)) as TreePersonInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TreePersonInfo create() => TreePersonInfo._();
  TreePersonInfo createEmptyInstance() => create();
  static $pb.PbList<TreePersonInfo> createRepeated() => $pb.PbList<TreePersonInfo>();
  @$core.pragma('dart2js:noInline')
  static TreePersonInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TreePersonInfo>(create);
  static TreePersonInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<Photo> get photos => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<TreeConnectionInfo> get connections => $_getList(3);
}

class TreeInfo extends $pb.GeneratedMessage {
  factory TreeInfo({
    $core.int? id,
    $core.String? name,
    $core.Iterable<TreePersonInfo>? treePersons,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (treePersons != null) {
      $result.treePersons.addAll(treePersons);
    }
    return $result;
  }
  TreeInfo._() : super();
  factory TreeInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TreeInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TreeInfo', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..pc<TreePersonInfo>(3, _omitFieldNames ? '' : 'treePersons', $pb.PbFieldType.PM, protoName: 'treePersons', subBuilder: TreePersonInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TreeInfo clone() => TreeInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TreeInfo copyWith(void Function(TreeInfo) updates) => super.copyWith((message) => updates(message as TreeInfo)) as TreeInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TreeInfo create() => TreeInfo._();
  TreeInfo createEmptyInstance() => create();
  static $pb.PbList<TreeInfo> createRepeated() => $pb.PbList<TreeInfo>();
  @$core.pragma('dart2js:noInline')
  static TreeInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TreeInfo>(create);
  static TreeInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<TreePersonInfo> get treePersons => $_getList(2);
}

class AppReplayBlocState extends $pb.GeneratedMessage {
  factory AppReplayBlocState({
    $core.Iterable<TreeInfo>? trees,
  }) {
    final $result = create();
    if (trees != null) {
      $result.trees.addAll(trees);
    }
    return $result;
  }
  AppReplayBlocState._() : super();
  factory AppReplayBlocState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppReplayBlocState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppReplayBlocState', createEmptyInstance: create)
    ..pc<TreeInfo>(1, _omitFieldNames ? '' : 'trees', $pb.PbFieldType.PM, subBuilder: TreeInfo.create)
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

  /// The list of trees in the site.
  @$pb.TagNumber(1)
  $core.List<TreeInfo> get trees => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
