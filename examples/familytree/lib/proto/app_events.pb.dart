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

import 'app_events.pbenum.dart';

export 'app_events.pbenum.dart';

class TreeConnection extends $pb.GeneratedMessage {
  factory TreeConnection({
    TreeConnectionType? type,
    $core.String? info,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (info != null) {
      $result.info = info;
    }
    return $result;
  }
  TreeConnection._() : super();
  factory TreeConnection.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TreeConnection.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TreeConnection', createEmptyInstance: create)
    ..e<TreeConnectionType>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: TreeConnectionType.parent, valueOf: TreeConnectionType.valueOf, enumValues: TreeConnectionType.values)
    ..aOS(2, _omitFieldNames ? '' : 'info')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TreeConnection clone() => TreeConnection()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TreeConnection copyWith(void Function(TreeConnection) updates) => super.copyWith((message) => updates(message as TreeConnection)) as TreeConnection;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TreeConnection create() => TreeConnection._();
  TreeConnection createEmptyInstance() => create();
  static $pb.PbList<TreeConnection> createRepeated() => $pb.PbList<TreeConnection>();
  @$core.pragma('dart2js:noInline')
  static TreeConnection getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TreeConnection>(create);
  static TreeConnection? _defaultInstance;

  @$pb.TagNumber(1)
  TreeConnectionType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(TreeConnectionType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get info => $_getSZ(1);
  @$pb.TagNumber(2)
  set info($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearInfo() => clearField(2);
}

class AppEvent_AddTree extends $pb.GeneratedMessage {
  factory AppEvent_AddTree({
    $core.String? name,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  AppEvent_AddTree._() : super();
  factory AppEvent_AddTree.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_AddTree.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.AddTree', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_AddTree clone() => AppEvent_AddTree()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_AddTree copyWith(void Function(AppEvent_AddTree) updates) => super.copyWith((message) => updates(message as AppEvent_AddTree)) as AppEvent_AddTree;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_AddTree create() => AppEvent_AddTree._();
  AppEvent_AddTree createEmptyInstance() => create();
  static $pb.PbList<AppEvent_AddTree> createRepeated() => $pb.PbList<AppEvent_AddTree>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_AddTree getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_AddTree>(create);
  static AppEvent_AddTree? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);
}

class AppEvent_UpdateTree extends $pb.GeneratedMessage {
  factory AppEvent_UpdateTree({
    $core.int? treeId,
    $core.String? name,
  }) {
    final $result = create();
    if (treeId != null) {
      $result.treeId = treeId;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  AppEvent_UpdateTree._() : super();
  factory AppEvent_UpdateTree.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_UpdateTree.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.UpdateTree', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'treeId', $pb.PbFieldType.O3, protoName: 'treeId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_UpdateTree clone() => AppEvent_UpdateTree()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_UpdateTree copyWith(void Function(AppEvent_UpdateTree) updates) => super.copyWith((message) => updates(message as AppEvent_UpdateTree)) as AppEvent_UpdateTree;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateTree create() => AppEvent_UpdateTree._();
  AppEvent_UpdateTree createEmptyInstance() => create();
  static $pb.PbList<AppEvent_UpdateTree> createRepeated() => $pb.PbList<AppEvent_UpdateTree>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateTree getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_UpdateTree>(create);
  static AppEvent_UpdateTree? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get treeId => $_getIZ(0);
  @$pb.TagNumber(1)
  set treeId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTreeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTreeId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

class AppEvent_DeleteTree extends $pb.GeneratedMessage {
  factory AppEvent_DeleteTree({
    $core.int? treeId,
  }) {
    final $result = create();
    if (treeId != null) {
      $result.treeId = treeId;
    }
    return $result;
  }
  AppEvent_DeleteTree._() : super();
  factory AppEvent_DeleteTree.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_DeleteTree.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.DeleteTree', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'treeId', $pb.PbFieldType.O3, protoName: 'treeId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_DeleteTree clone() => AppEvent_DeleteTree()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_DeleteTree copyWith(void Function(AppEvent_DeleteTree) updates) => super.copyWith((message) => updates(message as AppEvent_DeleteTree)) as AppEvent_DeleteTree;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_DeleteTree create() => AppEvent_DeleteTree._();
  AppEvent_DeleteTree createEmptyInstance() => create();
  static $pb.PbList<AppEvent_DeleteTree> createRepeated() => $pb.PbList<AppEvent_DeleteTree>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_DeleteTree getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_DeleteTree>(create);
  static AppEvent_DeleteTree? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get treeId => $_getIZ(0);
  @$pb.TagNumber(1)
  set treeId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTreeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTreeId() => clearField(1);
}

class AppEvent_ReorderTrees extends $pb.GeneratedMessage {
  factory AppEvent_ReorderTrees({
    $core.Iterable<$core.int>? treeIds,
  }) {
    final $result = create();
    if (treeIds != null) {
      $result.treeIds.addAll(treeIds);
    }
    return $result;
  }
  AppEvent_ReorderTrees._() : super();
  factory AppEvent_ReorderTrees.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_ReorderTrees.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.ReorderTrees', createEmptyInstance: create)
    ..p<$core.int>(1, _omitFieldNames ? '' : 'treeIds', $pb.PbFieldType.K3, protoName: 'treeIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_ReorderTrees clone() => AppEvent_ReorderTrees()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_ReorderTrees copyWith(void Function(AppEvent_ReorderTrees) updates) => super.copyWith((message) => updates(message as AppEvent_ReorderTrees)) as AppEvent_ReorderTrees;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_ReorderTrees create() => AppEvent_ReorderTrees._();
  AppEvent_ReorderTrees createEmptyInstance() => create();
  static $pb.PbList<AppEvent_ReorderTrees> createRepeated() => $pb.PbList<AppEvent_ReorderTrees>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_ReorderTrees getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_ReorderTrees>(create);
  static AppEvent_ReorderTrees? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get treeIds => $_getList(0);
}

class AppEvent_AddTreeMember extends $pb.GeneratedMessage {
  factory AppEvent_AddTreeMember({
    $core.int? treeId,
    $core.String? name,
  }) {
    final $result = create();
    if (treeId != null) {
      $result.treeId = treeId;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  AppEvent_AddTreeMember._() : super();
  factory AppEvent_AddTreeMember.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_AddTreeMember.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.AddTreeMember', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'treeId', $pb.PbFieldType.O3, protoName: 'treeId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_AddTreeMember clone() => AppEvent_AddTreeMember()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_AddTreeMember copyWith(void Function(AppEvent_AddTreeMember) updates) => super.copyWith((message) => updates(message as AppEvent_AddTreeMember)) as AppEvent_AddTreeMember;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_AddTreeMember create() => AppEvent_AddTreeMember._();
  AppEvent_AddTreeMember createEmptyInstance() => create();
  static $pb.PbList<AppEvent_AddTreeMember> createRepeated() => $pb.PbList<AppEvent_AddTreeMember>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_AddTreeMember getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_AddTreeMember>(create);
  static AppEvent_AddTreeMember? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get treeId => $_getIZ(0);
  @$pb.TagNumber(1)
  set treeId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTreeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTreeId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

class AppEvent_UpdateTreeMember extends $pb.GeneratedMessage {
  factory AppEvent_UpdateTreeMember({
    $core.int? treeMemberId,
    $core.String? name,
  }) {
    final $result = create();
    if (treeMemberId != null) {
      $result.treeMemberId = treeMemberId;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  AppEvent_UpdateTreeMember._() : super();
  factory AppEvent_UpdateTreeMember.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_UpdateTreeMember.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.UpdateTreeMember', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'treeMemberId', $pb.PbFieldType.O3, protoName: 'treeMemberId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_UpdateTreeMember clone() => AppEvent_UpdateTreeMember()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_UpdateTreeMember copyWith(void Function(AppEvent_UpdateTreeMember) updates) => super.copyWith((message) => updates(message as AppEvent_UpdateTreeMember)) as AppEvent_UpdateTreeMember;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateTreeMember create() => AppEvent_UpdateTreeMember._();
  AppEvent_UpdateTreeMember createEmptyInstance() => create();
  static $pb.PbList<AppEvent_UpdateTreeMember> createRepeated() => $pb.PbList<AppEvent_UpdateTreeMember>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateTreeMember getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_UpdateTreeMember>(create);
  static AppEvent_UpdateTreeMember? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get treeMemberId => $_getIZ(0);
  @$pb.TagNumber(1)
  set treeMemberId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTreeMemberId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTreeMemberId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

class AppEvent_RemoveTreeMember extends $pb.GeneratedMessage {
  factory AppEvent_RemoveTreeMember({
    $core.int? treeMemberId,
  }) {
    final $result = create();
    if (treeMemberId != null) {
      $result.treeMemberId = treeMemberId;
    }
    return $result;
  }
  AppEvent_RemoveTreeMember._() : super();
  factory AppEvent_RemoveTreeMember.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_RemoveTreeMember.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.RemoveTreeMember', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'treeMemberId', $pb.PbFieldType.O3, protoName: 'treeMemberId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_RemoveTreeMember clone() => AppEvent_RemoveTreeMember()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_RemoveTreeMember copyWith(void Function(AppEvent_RemoveTreeMember) updates) => super.copyWith((message) => updates(message as AppEvent_RemoveTreeMember)) as AppEvent_RemoveTreeMember;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_RemoveTreeMember create() => AppEvent_RemoveTreeMember._();
  AppEvent_RemoveTreeMember createEmptyInstance() => create();
  static $pb.PbList<AppEvent_RemoveTreeMember> createRepeated() => $pb.PbList<AppEvent_RemoveTreeMember>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_RemoveTreeMember getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_RemoveTreeMember>(create);
  static AppEvent_RemoveTreeMember? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get treeMemberId => $_getIZ(0);
  @$pb.TagNumber(1)
  set treeMemberId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTreeMemberId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTreeMemberId() => clearField(1);
}

class AppEvent_ReorderTreeMembers extends $pb.GeneratedMessage {
  factory AppEvent_ReorderTreeMembers({
    $core.int? treeId,
    $core.Iterable<$core.int>? treeMemberIds,
  }) {
    final $result = create();
    if (treeId != null) {
      $result.treeId = treeId;
    }
    if (treeMemberIds != null) {
      $result.treeMemberIds.addAll(treeMemberIds);
    }
    return $result;
  }
  AppEvent_ReorderTreeMembers._() : super();
  factory AppEvent_ReorderTreeMembers.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_ReorderTreeMembers.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.ReorderTreeMembers', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'treeId', $pb.PbFieldType.O3, protoName: 'treeId')
    ..p<$core.int>(2, _omitFieldNames ? '' : 'treeMemberIds', $pb.PbFieldType.K3, protoName: 'treeMemberIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_ReorderTreeMembers clone() => AppEvent_ReorderTreeMembers()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_ReorderTreeMembers copyWith(void Function(AppEvent_ReorderTreeMembers) updates) => super.copyWith((message) => updates(message as AppEvent_ReorderTreeMembers)) as AppEvent_ReorderTreeMembers;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_ReorderTreeMembers create() => AppEvent_ReorderTreeMembers._();
  AppEvent_ReorderTreeMembers createEmptyInstance() => create();
  static $pb.PbList<AppEvent_ReorderTreeMembers> createRepeated() => $pb.PbList<AppEvent_ReorderTreeMembers>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_ReorderTreeMembers getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_ReorderTreeMembers>(create);
  static AppEvent_ReorderTreeMembers? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get treeId => $_getIZ(0);
  @$pb.TagNumber(1)
  set treeId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTreeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTreeId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get treeMemberIds => $_getList(1);
}

class AppEvent_AddConnection extends $pb.GeneratedMessage {
  factory AppEvent_AddConnection({
    TreeConnection? connection,
    $core.int? fromTreeMemberId,
    $core.int? toTreeMemberId,
  }) {
    final $result = create();
    if (connection != null) {
      $result.connection = connection;
    }
    if (fromTreeMemberId != null) {
      $result.fromTreeMemberId = fromTreeMemberId;
    }
    if (toTreeMemberId != null) {
      $result.toTreeMemberId = toTreeMemberId;
    }
    return $result;
  }
  AppEvent_AddConnection._() : super();
  factory AppEvent_AddConnection.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_AddConnection.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.AddConnection', createEmptyInstance: create)
    ..aOM<TreeConnection>(1, _omitFieldNames ? '' : 'connection', subBuilder: TreeConnection.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'fromTreeMemberId', $pb.PbFieldType.O3, protoName: 'fromTreeMemberId')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'toTreeMemberId', $pb.PbFieldType.O3, protoName: 'toTreeMemberId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_AddConnection clone() => AppEvent_AddConnection()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_AddConnection copyWith(void Function(AppEvent_AddConnection) updates) => super.copyWith((message) => updates(message as AppEvent_AddConnection)) as AppEvent_AddConnection;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_AddConnection create() => AppEvent_AddConnection._();
  AppEvent_AddConnection createEmptyInstance() => create();
  static $pb.PbList<AppEvent_AddConnection> createRepeated() => $pb.PbList<AppEvent_AddConnection>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_AddConnection getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_AddConnection>(create);
  static AppEvent_AddConnection? _defaultInstance;

  @$pb.TagNumber(1)
  TreeConnection get connection => $_getN(0);
  @$pb.TagNumber(1)
  set connection(TreeConnection v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasConnection() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnection() => clearField(1);
  @$pb.TagNumber(1)
  TreeConnection ensureConnection() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get fromTreeMemberId => $_getIZ(1);
  @$pb.TagNumber(2)
  set fromTreeMemberId($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFromTreeMemberId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromTreeMemberId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get toTreeMemberId => $_getIZ(2);
  @$pb.TagNumber(3)
  set toTreeMemberId($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasToTreeMemberId() => $_has(2);
  @$pb.TagNumber(3)
  void clearToTreeMemberId() => clearField(3);
}

class AppEvent_UpdateConnection extends $pb.GeneratedMessage {
  factory AppEvent_UpdateConnection({
    $core.int? connectionId,
    TreeConnection? connection,
  }) {
    final $result = create();
    if (connectionId != null) {
      $result.connectionId = connectionId;
    }
    if (connection != null) {
      $result.connection = connection;
    }
    return $result;
  }
  AppEvent_UpdateConnection._() : super();
  factory AppEvent_UpdateConnection.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_UpdateConnection.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.UpdateConnection', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'connectionId', $pb.PbFieldType.O3, protoName: 'connectionId')
    ..aOM<TreeConnection>(2, _omitFieldNames ? '' : 'connection', subBuilder: TreeConnection.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_UpdateConnection clone() => AppEvent_UpdateConnection()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_UpdateConnection copyWith(void Function(AppEvent_UpdateConnection) updates) => super.copyWith((message) => updates(message as AppEvent_UpdateConnection)) as AppEvent_UpdateConnection;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateConnection create() => AppEvent_UpdateConnection._();
  AppEvent_UpdateConnection createEmptyInstance() => create();
  static $pb.PbList<AppEvent_UpdateConnection> createRepeated() => $pb.PbList<AppEvent_UpdateConnection>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_UpdateConnection getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_UpdateConnection>(create);
  static AppEvent_UpdateConnection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get connectionId => $_getIZ(0);
  @$pb.TagNumber(1)
  set connectionId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasConnectionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnectionId() => clearField(1);

  @$pb.TagNumber(2)
  TreeConnection get connection => $_getN(1);
  @$pb.TagNumber(2)
  set connection(TreeConnection v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasConnection() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnection() => clearField(2);
  @$pb.TagNumber(2)
  TreeConnection ensureConnection() => $_ensure(1);
}

class AppEvent_RemoveConnection extends $pb.GeneratedMessage {
  factory AppEvent_RemoveConnection({
    $core.int? treeConnectionId,
  }) {
    final $result = create();
    if (treeConnectionId != null) {
      $result.treeConnectionId = treeConnectionId;
    }
    return $result;
  }
  AppEvent_RemoveConnection._() : super();
  factory AppEvent_RemoveConnection.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_RemoveConnection.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.RemoveConnection', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'treeConnectionId', $pb.PbFieldType.O3, protoName: 'treeConnectionId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_RemoveConnection clone() => AppEvent_RemoveConnection()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_RemoveConnection copyWith(void Function(AppEvent_RemoveConnection) updates) => super.copyWith((message) => updates(message as AppEvent_RemoveConnection)) as AppEvent_RemoveConnection;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_RemoveConnection create() => AppEvent_RemoveConnection._();
  AppEvent_RemoveConnection createEmptyInstance() => create();
  static $pb.PbList<AppEvent_RemoveConnection> createRepeated() => $pb.PbList<AppEvent_RemoveConnection>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_RemoveConnection getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_RemoveConnection>(create);
  static AppEvent_RemoveConnection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get treeConnectionId => $_getIZ(0);
  @$pb.TagNumber(1)
  set treeConnectionId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTreeConnectionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTreeConnectionId() => clearField(1);
}

class AppEvent_AddPhoto extends $pb.GeneratedMessage {
  factory AppEvent_AddPhoto({
    $core.int? treeMemberId,
    $core.String? name,
    $core.int? size,
  }) {
    final $result = create();
    if (treeMemberId != null) {
      $result.treeMemberId = treeMemberId;
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
    ..a<$core.int>(1, _omitFieldNames ? '' : 'treeMemberId', $pb.PbFieldType.O3, protoName: 'treeMemberId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'size', $pb.PbFieldType.O3)
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
  $core.int get treeMemberId => $_getIZ(0);
  @$pb.TagNumber(1)
  set treeMemberId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTreeMemberId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTreeMemberId() => clearField(1);

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

class AppEvent_UpdateCaption extends $pb.GeneratedMessage {
  factory AppEvent_UpdateCaption({
    $core.String? caption,
    $core.int? photoId,
  }) {
    final $result = create();
    if (caption != null) {
      $result.caption = caption;
    }
    if (photoId != null) {
      $result.photoId = photoId;
    }
    return $result;
  }
  AppEvent_UpdateCaption._() : super();
  factory AppEvent_UpdateCaption.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_UpdateCaption.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.UpdateCaption', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caption')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'photoId', $pb.PbFieldType.O3, protoName: 'photoId')
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
  $core.String get caption => $_getSZ(0);
  @$pb.TagNumber(1)
  set caption($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCaption() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaption() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get photoId => $_getIZ(1);
  @$pb.TagNumber(2)
  set photoId($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPhotoId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhotoId() => clearField(2);
}

enum AppEvent_EventType {
  addTree, 
  updateTree, 
  deleteTree, 
  reorderTrees, 
  addTreeMember, 
  updateTreeMember, 
  removeTreeMember, 
  reorderTreeMembers, 
  addConnection, 
  updateConnection, 
  removeConnection, 
  addPhoto, 
  deletePhoto, 
  updateCaption, 
  notSet
}

class AppEvent extends $pb.GeneratedMessage {
  factory AppEvent({
    AppEvent_AddTree? addTree,
    AppEvent_UpdateTree? updateTree,
    AppEvent_DeleteTree? deleteTree,
    AppEvent_ReorderTrees? reorderTrees,
    AppEvent_AddTreeMember? addTreeMember,
    AppEvent_UpdateTreeMember? updateTreeMember,
    AppEvent_RemoveTreeMember? removeTreeMember,
    AppEvent_ReorderTreeMembers? reorderTreeMembers,
    AppEvent_AddConnection? addConnection,
    AppEvent_UpdateConnection? updateConnection,
    AppEvent_RemoveConnection? removeConnection,
    AppEvent_AddPhoto? addPhoto,
    AppEvent_DeletePhoto? deletePhoto,
    AppEvent_UpdateCaption? updateCaption,
  }) {
    final $result = create();
    if (addTree != null) {
      $result.addTree = addTree;
    }
    if (updateTree != null) {
      $result.updateTree = updateTree;
    }
    if (deleteTree != null) {
      $result.deleteTree = deleteTree;
    }
    if (reorderTrees != null) {
      $result.reorderTrees = reorderTrees;
    }
    if (addTreeMember != null) {
      $result.addTreeMember = addTreeMember;
    }
    if (updateTreeMember != null) {
      $result.updateTreeMember = updateTreeMember;
    }
    if (removeTreeMember != null) {
      $result.removeTreeMember = removeTreeMember;
    }
    if (reorderTreeMembers != null) {
      $result.reorderTreeMembers = reorderTreeMembers;
    }
    if (addConnection != null) {
      $result.addConnection = addConnection;
    }
    if (updateConnection != null) {
      $result.updateConnection = updateConnection;
    }
    if (removeConnection != null) {
      $result.removeConnection = removeConnection;
    }
    if (addPhoto != null) {
      $result.addPhoto = addPhoto;
    }
    if (deletePhoto != null) {
      $result.deletePhoto = deletePhoto;
    }
    if (updateCaption != null) {
      $result.updateCaption = updateCaption;
    }
    return $result;
  }
  AppEvent._() : super();
  factory AppEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, AppEvent_EventType> _AppEvent_EventTypeByTag = {
    1 : AppEvent_EventType.addTree,
    2 : AppEvent_EventType.updateTree,
    3 : AppEvent_EventType.deleteTree,
    4 : AppEvent_EventType.reorderTrees,
    5 : AppEvent_EventType.addTreeMember,
    6 : AppEvent_EventType.updateTreeMember,
    7 : AppEvent_EventType.removeTreeMember,
    8 : AppEvent_EventType.reorderTreeMembers,
    9 : AppEvent_EventType.addConnection,
    10 : AppEvent_EventType.updateConnection,
    11 : AppEvent_EventType.removeConnection,
    12 : AppEvent_EventType.addPhoto,
    13 : AppEvent_EventType.deletePhoto,
    14 : AppEvent_EventType.updateCaption,
    0 : AppEvent_EventType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent', createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14])
    ..aOM<AppEvent_AddTree>(1, _omitFieldNames ? '' : 'addTree', protoName: 'addTree', subBuilder: AppEvent_AddTree.create)
    ..aOM<AppEvent_UpdateTree>(2, _omitFieldNames ? '' : 'updateTree', protoName: 'updateTree', subBuilder: AppEvent_UpdateTree.create)
    ..aOM<AppEvent_DeleteTree>(3, _omitFieldNames ? '' : 'deleteTree', protoName: 'deleteTree', subBuilder: AppEvent_DeleteTree.create)
    ..aOM<AppEvent_ReorderTrees>(4, _omitFieldNames ? '' : 'reorderTrees', protoName: 'reorderTrees', subBuilder: AppEvent_ReorderTrees.create)
    ..aOM<AppEvent_AddTreeMember>(5, _omitFieldNames ? '' : 'addTreeMember', protoName: 'addTreeMember', subBuilder: AppEvent_AddTreeMember.create)
    ..aOM<AppEvent_UpdateTreeMember>(6, _omitFieldNames ? '' : 'updateTreeMember', protoName: 'updateTreeMember', subBuilder: AppEvent_UpdateTreeMember.create)
    ..aOM<AppEvent_RemoveTreeMember>(7, _omitFieldNames ? '' : 'removeTreeMember', protoName: 'removeTreeMember', subBuilder: AppEvent_RemoveTreeMember.create)
    ..aOM<AppEvent_ReorderTreeMembers>(8, _omitFieldNames ? '' : 'reorderTreeMembers', protoName: 'reorderTreeMembers', subBuilder: AppEvent_ReorderTreeMembers.create)
    ..aOM<AppEvent_AddConnection>(9, _omitFieldNames ? '' : 'addConnection', protoName: 'addConnection', subBuilder: AppEvent_AddConnection.create)
    ..aOM<AppEvent_UpdateConnection>(10, _omitFieldNames ? '' : 'updateConnection', protoName: 'updateConnection', subBuilder: AppEvent_UpdateConnection.create)
    ..aOM<AppEvent_RemoveConnection>(11, _omitFieldNames ? '' : 'removeConnection', protoName: 'removeConnection', subBuilder: AppEvent_RemoveConnection.create)
    ..aOM<AppEvent_AddPhoto>(12, _omitFieldNames ? '' : 'addPhoto', protoName: 'addPhoto', subBuilder: AppEvent_AddPhoto.create)
    ..aOM<AppEvent_DeletePhoto>(13, _omitFieldNames ? '' : 'deletePhoto', protoName: 'deletePhoto', subBuilder: AppEvent_DeletePhoto.create)
    ..aOM<AppEvent_UpdateCaption>(14, _omitFieldNames ? '' : 'updateCaption', protoName: 'updateCaption', subBuilder: AppEvent_UpdateCaption.create)
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
  AppEvent_AddTree get addTree => $_getN(0);
  @$pb.TagNumber(1)
  set addTree(AppEvent_AddTree v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddTree() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddTree() => clearField(1);
  @$pb.TagNumber(1)
  AppEvent_AddTree ensureAddTree() => $_ensure(0);

  @$pb.TagNumber(2)
  AppEvent_UpdateTree get updateTree => $_getN(1);
  @$pb.TagNumber(2)
  set updateTree(AppEvent_UpdateTree v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasUpdateTree() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateTree() => clearField(2);
  @$pb.TagNumber(2)
  AppEvent_UpdateTree ensureUpdateTree() => $_ensure(1);

  @$pb.TagNumber(3)
  AppEvent_DeleteTree get deleteTree => $_getN(2);
  @$pb.TagNumber(3)
  set deleteTree(AppEvent_DeleteTree v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasDeleteTree() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeleteTree() => clearField(3);
  @$pb.TagNumber(3)
  AppEvent_DeleteTree ensureDeleteTree() => $_ensure(2);

  @$pb.TagNumber(4)
  AppEvent_ReorderTrees get reorderTrees => $_getN(3);
  @$pb.TagNumber(4)
  set reorderTrees(AppEvent_ReorderTrees v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasReorderTrees() => $_has(3);
  @$pb.TagNumber(4)
  void clearReorderTrees() => clearField(4);
  @$pb.TagNumber(4)
  AppEvent_ReorderTrees ensureReorderTrees() => $_ensure(3);

  @$pb.TagNumber(5)
  AppEvent_AddTreeMember get addTreeMember => $_getN(4);
  @$pb.TagNumber(5)
  set addTreeMember(AppEvent_AddTreeMember v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasAddTreeMember() => $_has(4);
  @$pb.TagNumber(5)
  void clearAddTreeMember() => clearField(5);
  @$pb.TagNumber(5)
  AppEvent_AddTreeMember ensureAddTreeMember() => $_ensure(4);

  @$pb.TagNumber(6)
  AppEvent_UpdateTreeMember get updateTreeMember => $_getN(5);
  @$pb.TagNumber(6)
  set updateTreeMember(AppEvent_UpdateTreeMember v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasUpdateTreeMember() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpdateTreeMember() => clearField(6);
  @$pb.TagNumber(6)
  AppEvent_UpdateTreeMember ensureUpdateTreeMember() => $_ensure(5);

  @$pb.TagNumber(7)
  AppEvent_RemoveTreeMember get removeTreeMember => $_getN(6);
  @$pb.TagNumber(7)
  set removeTreeMember(AppEvent_RemoveTreeMember v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasRemoveTreeMember() => $_has(6);
  @$pb.TagNumber(7)
  void clearRemoveTreeMember() => clearField(7);
  @$pb.TagNumber(7)
  AppEvent_RemoveTreeMember ensureRemoveTreeMember() => $_ensure(6);

  @$pb.TagNumber(8)
  AppEvent_ReorderTreeMembers get reorderTreeMembers => $_getN(7);
  @$pb.TagNumber(8)
  set reorderTreeMembers(AppEvent_ReorderTreeMembers v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasReorderTreeMembers() => $_has(7);
  @$pb.TagNumber(8)
  void clearReorderTreeMembers() => clearField(8);
  @$pb.TagNumber(8)
  AppEvent_ReorderTreeMembers ensureReorderTreeMembers() => $_ensure(7);

  @$pb.TagNumber(9)
  AppEvent_AddConnection get addConnection => $_getN(8);
  @$pb.TagNumber(9)
  set addConnection(AppEvent_AddConnection v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasAddConnection() => $_has(8);
  @$pb.TagNumber(9)
  void clearAddConnection() => clearField(9);
  @$pb.TagNumber(9)
  AppEvent_AddConnection ensureAddConnection() => $_ensure(8);

  @$pb.TagNumber(10)
  AppEvent_UpdateConnection get updateConnection => $_getN(9);
  @$pb.TagNumber(10)
  set updateConnection(AppEvent_UpdateConnection v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasUpdateConnection() => $_has(9);
  @$pb.TagNumber(10)
  void clearUpdateConnection() => clearField(10);
  @$pb.TagNumber(10)
  AppEvent_UpdateConnection ensureUpdateConnection() => $_ensure(9);

  @$pb.TagNumber(11)
  AppEvent_RemoveConnection get removeConnection => $_getN(10);
  @$pb.TagNumber(11)
  set removeConnection(AppEvent_RemoveConnection v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasRemoveConnection() => $_has(10);
  @$pb.TagNumber(11)
  void clearRemoveConnection() => clearField(11);
  @$pb.TagNumber(11)
  AppEvent_RemoveConnection ensureRemoveConnection() => $_ensure(10);

  @$pb.TagNumber(12)
  AppEvent_AddPhoto get addPhoto => $_getN(11);
  @$pb.TagNumber(12)
  set addPhoto(AppEvent_AddPhoto v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasAddPhoto() => $_has(11);
  @$pb.TagNumber(12)
  void clearAddPhoto() => clearField(12);
  @$pb.TagNumber(12)
  AppEvent_AddPhoto ensureAddPhoto() => $_ensure(11);

  @$pb.TagNumber(13)
  AppEvent_DeletePhoto get deletePhoto => $_getN(12);
  @$pb.TagNumber(13)
  set deletePhoto(AppEvent_DeletePhoto v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasDeletePhoto() => $_has(12);
  @$pb.TagNumber(13)
  void clearDeletePhoto() => clearField(13);
  @$pb.TagNumber(13)
  AppEvent_DeletePhoto ensureDeletePhoto() => $_ensure(12);

  @$pb.TagNumber(14)
  AppEvent_UpdateCaption get updateCaption => $_getN(13);
  @$pb.TagNumber(14)
  set updateCaption(AppEvent_UpdateCaption v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasUpdateCaption() => $_has(13);
  @$pb.TagNumber(14)
  void clearUpdateCaption() => clearField(14);
  @$pb.TagNumber(14)
  AppEvent_UpdateCaption ensureUpdateCaption() => $_ensure(13);
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
    ..a<$core.int>(4, _omitFieldNames ? '' : 'size', $pb.PbFieldType.O3)
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

  @$pb.TagNumber(4)
  $core.int get size => $_getIZ(2);
  @$pb.TagNumber(4)
  set size($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasSize() => $_has(2);
  @$pb.TagNumber(4)
  void clearSize() => clearField(4);
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
    $core.String? deletePhotoUrl,
    $core.Map<$core.int, $core.String>? photoUrls,
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
    if (deletePhotoUrl != null) {
      $result.deletePhotoUrl = deletePhotoUrl;
    }
    if (photoUrls != null) {
      $result.photoUrls.addAll(photoUrls);
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
    ..pc<SubmitAppEvent_Image>(20, _omitFieldNames ? '' : 'images', $pb.PbFieldType.PM, subBuilder: SubmitAppEvent_Image.create)
    ..aOS(21, _omitFieldNames ? '' : 'deletePhotoUrl', protoName: 'deletePhotoUrl')
    ..m<$core.int, $core.String>(22, _omitFieldNames ? '' : 'photoUrls', entryClassName: 'SubmitAppEvent.PhotoUrlsEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.OS)
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

  @$pb.TagNumber(20)
  $core.List<SubmitAppEvent_Image> get images => $_getList(3);

  @$pb.TagNumber(21)
  $core.String get deletePhotoUrl => $_getSZ(4);
  @$pb.TagNumber(21)
  set deletePhotoUrl($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(21)
  $core.bool hasDeletePhotoUrl() => $_has(4);
  @$pb.TagNumber(21)
  void clearDeletePhotoUrl() => clearField(21);

  @$pb.TagNumber(22)
  $core.Map<$core.int, $core.String> get photoUrls => $_getMap(5);
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
