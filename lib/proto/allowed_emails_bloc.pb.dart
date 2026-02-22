// This is a generated file - do not edit.
//
// Generated from allowed_emails_bloc.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'allowed_emails_bloc.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'allowed_emails_bloc.pbenum.dart';

class AllowedEmailsBlocEvent_FetchedAllowedEmails extends $pb.GeneratedMessage {
  factory AllowedEmailsBlocEvent_FetchedAllowedEmails() => create();

  AllowedEmailsBlocEvent_FetchedAllowedEmails._();

  factory AllowedEmailsBlocEvent_FetchedAllowedEmails.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AllowedEmailsBlocEvent_FetchedAllowedEmails.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AllowedEmailsBlocEvent.FetchedAllowedEmails',
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AllowedEmailsBlocEvent_FetchedAllowedEmails clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AllowedEmailsBlocEvent_FetchedAllowedEmails copyWith(
          void Function(AllowedEmailsBlocEvent_FetchedAllowedEmails) updates) =>
      super.copyWith((message) =>
              updates(message as AllowedEmailsBlocEvent_FetchedAllowedEmails))
          as AllowedEmailsBlocEvent_FetchedAllowedEmails;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AllowedEmailsBlocEvent_FetchedAllowedEmails create() =>
      AllowedEmailsBlocEvent_FetchedAllowedEmails._();
  @$core.override
  AllowedEmailsBlocEvent_FetchedAllowedEmails createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AllowedEmailsBlocEvent_FetchedAllowedEmails getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          AllowedEmailsBlocEvent_FetchedAllowedEmails>(create);
  static AllowedEmailsBlocEvent_FetchedAllowedEmails? _defaultInstance;
}

enum AllowedEmailsBlocEvent_EventType { fetchNow, updateNow, notSet }

/// Fetch the allowed emails for the service or a site
/// The emails are stored outside of the events
class AllowedEmailsBlocEvent extends $pb.GeneratedMessage {
  factory AllowedEmailsBlocEvent({
    AllowedEmailsBlocEvent_FetchedAllowedEmails? fetchNow,
    AllowedEmailsBlocState? updateNow,
  }) {
    final result = create();
    if (fetchNow != null) result.fetchNow = fetchNow;
    if (updateNow != null) result.updateNow = updateNow;
    return result;
  }

  AllowedEmailsBlocEvent._();

  factory AllowedEmailsBlocEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AllowedEmailsBlocEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, AllowedEmailsBlocEvent_EventType>
      _AllowedEmailsBlocEvent_EventTypeByTag = {
    1: AllowedEmailsBlocEvent_EventType.fetchNow,
    2: AllowedEmailsBlocEvent_EventType.updateNow,
    0: AllowedEmailsBlocEvent_EventType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AllowedEmailsBlocEvent',
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<AllowedEmailsBlocEvent_FetchedAllowedEmails>(
        1, _omitFieldNames ? '' : 'fetchNow',
        protoName: 'fetchNow',
        subBuilder: AllowedEmailsBlocEvent_FetchedAllowedEmails.create)
    ..aOM<AllowedEmailsBlocState>(2, _omitFieldNames ? '' : 'updateNow',
        protoName: 'updateNow', subBuilder: AllowedEmailsBlocState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AllowedEmailsBlocEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AllowedEmailsBlocEvent copyWith(
          void Function(AllowedEmailsBlocEvent) updates) =>
      super.copyWith((message) => updates(message as AllowedEmailsBlocEvent))
          as AllowedEmailsBlocEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AllowedEmailsBlocEvent create() => AllowedEmailsBlocEvent._();
  @$core.override
  AllowedEmailsBlocEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AllowedEmailsBlocEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AllowedEmailsBlocEvent>(create);
  static AllowedEmailsBlocEvent? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  AllowedEmailsBlocEvent_EventType whichEventType() =>
      _AllowedEmailsBlocEvent_EventTypeByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearEventType() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  AllowedEmailsBlocEvent_FetchedAllowedEmails get fetchNow => $_getN(0);
  @$pb.TagNumber(1)
  set fetchNow(AllowedEmailsBlocEvent_FetchedAllowedEmails value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFetchNow() => $_has(0);
  @$pb.TagNumber(1)
  void clearFetchNow() => $_clearField(1);
  @$pb.TagNumber(1)
  AllowedEmailsBlocEvent_FetchedAllowedEmails ensureFetchNow() => $_ensure(0);

  @$pb.TagNumber(2)
  AllowedEmailsBlocState get updateNow => $_getN(1);
  @$pb.TagNumber(2)
  set updateNow(AllowedEmailsBlocState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateNow() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateNow() => $_clearField(2);
  @$pb.TagNumber(2)
  AllowedEmailsBlocState ensureUpdateNow() => $_ensure(1);
}

class AllowedEmailsBlocState_UserInfo extends $pb.GeneratedMessage {
  factory AllowedEmailsBlocState_UserInfo({
    $core.int? userId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    return result;
  }

  AllowedEmailsBlocState_UserInfo._();

  factory AllowedEmailsBlocState_UserInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AllowedEmailsBlocState_UserInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AllowedEmailsBlocState.UserInfo',
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AllowedEmailsBlocState_UserInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AllowedEmailsBlocState_UserInfo copyWith(
          void Function(AllowedEmailsBlocState_UserInfo) updates) =>
      super.copyWith(
              (message) => updates(message as AllowedEmailsBlocState_UserInfo))
          as AllowedEmailsBlocState_UserInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AllowedEmailsBlocState_UserInfo create() =>
      AllowedEmailsBlocState_UserInfo._();
  @$core.override
  AllowedEmailsBlocState_UserInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AllowedEmailsBlocState_UserInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AllowedEmailsBlocState_UserInfo>(
          create);
  static AllowedEmailsBlocState_UserInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get userId => $_getIZ(0);
  @$pb.TagNumber(1)
  set userId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class AllowedEmailsBlocState extends $pb.GeneratedMessage {
  factory AllowedEmailsBlocState({
    AllowedEmailsBlocState_State? state,
    $core.Iterable<
            $core.MapEntry<$core.String, AllowedEmailsBlocState_UserInfo>>?
        emails,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (emails != null) result.emails.addEntries(emails);
    return result;
  }

  AllowedEmailsBlocState._();

  factory AllowedEmailsBlocState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AllowedEmailsBlocState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AllowedEmailsBlocState',
      createEmptyInstance: create)
    ..aE<AllowedEmailsBlocState_State>(1, _omitFieldNames ? '' : 'state',
        enumValues: AllowedEmailsBlocState_State.values)
    ..m<$core.String, AllowedEmailsBlocState_UserInfo>(
        2, _omitFieldNames ? '' : 'emails',
        entryClassName: 'AllowedEmailsBlocState.EmailsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: AllowedEmailsBlocState_UserInfo.create,
        valueDefaultOrMaker: AllowedEmailsBlocState_UserInfo.getDefault)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AllowedEmailsBlocState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AllowedEmailsBlocState copyWith(
          void Function(AllowedEmailsBlocState) updates) =>
      super.copyWith((message) => updates(message as AllowedEmailsBlocState))
          as AllowedEmailsBlocState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AllowedEmailsBlocState create() => AllowedEmailsBlocState._();
  @$core.override
  AllowedEmailsBlocState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AllowedEmailsBlocState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AllowedEmailsBlocState>(create);
  static AllowedEmailsBlocState? _defaultInstance;

  @$pb.TagNumber(1)
  AllowedEmailsBlocState_State get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(AllowedEmailsBlocState_State value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, AllowedEmailsBlocState_UserInfo> get emails =>
      $_getMap(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
