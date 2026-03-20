// This is a generated file - do not edit.
//
// Generated from site_util.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'site_util.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'site_util.pbenum.dart';

/// The SiteEmail is persisted in the email collection for each site
class MarkForDeletion extends $pb.GeneratedMessage {
  factory MarkForDeletion({
    MarkForDeletion_DeleteReason? deleteReason,
    $core.int? author,
  }) {
    final result = create();
    if (deleteReason != null) result.deleteReason = deleteReason;
    if (author != null) result.author = author;
    return result;
  }

  MarkForDeletion._();

  factory MarkForDeletion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MarkForDeletion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkForDeletion',
      createEmptyInstance: create)
    ..aE<MarkForDeletion_DeleteReason>(1, _omitFieldNames ? '' : 'deleteReason',
        protoName: 'deleteReason',
        enumValues: MarkForDeletion_DeleteReason.values)
    ..aI(2, _omitFieldNames ? '' : 'author')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkForDeletion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkForDeletion copyWith(void Function(MarkForDeletion) updates) =>
      super.copyWith((message) => updates(message as MarkForDeletion))
          as MarkForDeletion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarkForDeletion create() => MarkForDeletion._();
  @$core.override
  MarkForDeletion createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MarkForDeletion getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkForDeletion>(create);
  static MarkForDeletion? _defaultInstance;

  @$pb.TagNumber(1)
  MarkForDeletion_DeleteReason get deleteReason => $_getN(0);
  @$pb.TagNumber(1)
  set deleteReason(MarkForDeletion_DeleteReason value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDeleteReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeleteReason() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get author => $_getIZ(1);
  @$pb.TagNumber(2)
  set author($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAuthor() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthor() => $_clearField(2);
}

class MarkForCopy extends $pb.GeneratedMessage {
  factory MarkForCopy({
    $core.int? author,
    $core.int? upToVersion,
  }) {
    final result = create();
    if (author != null) result.author = author;
    if (upToVersion != null) result.upToVersion = upToVersion;
    return result;
  }

  MarkForCopy._();

  factory MarkForCopy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MarkForCopy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkForCopy',
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'author')
    ..aI(2, _omitFieldNames ? '' : 'upToVersion', protoName: 'upToVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkForCopy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkForCopy copyWith(void Function(MarkForCopy) updates) =>
      super.copyWith((message) => updates(message as MarkForCopy))
          as MarkForCopy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarkForCopy create() => MarkForCopy._();
  @$core.override
  MarkForCopy createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MarkForCopy getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkForCopy>(create);
  static MarkForCopy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get author => $_getIZ(0);
  @$pb.TagNumber(1)
  set author($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAuthor() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get upToVersion => $_getIZ(1);
  @$pb.TagNumber(2)
  set upToVersion($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUpToVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpToVersion() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
