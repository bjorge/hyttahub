// This is a generated file - do not edit.
//
// Generated from app_wrapper.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// The SiteEvent is persisted in immutable firestore collection
/// do not store email addresses or any other PII in this message
class AppEventWrapper extends $pb.GeneratedMessage {
  factory AppEventWrapper({
    $core.List<$core.int>? payload,
  }) {
    final result = create();
    if (payload != null) result.payload = payload;
    return result;
  }

  AppEventWrapper._();

  factory AppEventWrapper.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppEventWrapper.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppEventWrapper',
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'payload', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEventWrapper clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppEventWrapper copyWith(void Function(AppEventWrapper) updates) =>
      super.copyWith((message) => updates(message as AppEventWrapper))
          as AppEventWrapper;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEventWrapper create() => AppEventWrapper._();
  @$core.override
  AppEventWrapper createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppEventWrapper getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppEventWrapper>(create);
  static AppEventWrapper? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get payload => $_getN(0);
  @$pb.TagNumber(1)
  set payload($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPayload() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayload() => $_clearField(1);
}

class AppReplayWrapper extends $pb.GeneratedMessage {
  factory AppReplayWrapper({
    $core.List<$core.int>? payload,
  }) {
    final result = create();
    if (payload != null) result.payload = payload;
    return result;
  }

  AppReplayWrapper._();

  factory AppReplayWrapper.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppReplayWrapper.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppReplayWrapper',
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'payload', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppReplayWrapper clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppReplayWrapper copyWith(void Function(AppReplayWrapper) updates) =>
      super.copyWith((message) => updates(message as AppReplayWrapper))
          as AppReplayWrapper;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppReplayWrapper create() => AppReplayWrapper._();
  @$core.override
  AppReplayWrapper createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppReplayWrapper getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppReplayWrapper>(create);
  static AppReplayWrapper? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get payload => $_getN(0);
  @$pb.TagNumber(1)
  set payload($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPayload() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayload() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
