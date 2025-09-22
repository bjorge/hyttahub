//
//  Generated code. Do not modify.
//  source: allowed_emails_bloc.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'allowed_emails_bloc.pbenum.dart';

export 'allowed_emails_bloc.pbenum.dart';

class AllowedEmailsBlocEvent_FetchedAllowedEmails extends $pb.GeneratedMessage {
  factory AllowedEmailsBlocEvent_FetchedAllowedEmails() => create();
  AllowedEmailsBlocEvent_FetchedAllowedEmails._() : super();
  factory AllowedEmailsBlocEvent_FetchedAllowedEmails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AllowedEmailsBlocEvent_FetchedAllowedEmails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AllowedEmailsBlocEvent.FetchedAllowedEmails', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AllowedEmailsBlocEvent_FetchedAllowedEmails clone() => AllowedEmailsBlocEvent_FetchedAllowedEmails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AllowedEmailsBlocEvent_FetchedAllowedEmails copyWith(void Function(AllowedEmailsBlocEvent_FetchedAllowedEmails) updates) => super.copyWith((message) => updates(message as AllowedEmailsBlocEvent_FetchedAllowedEmails)) as AllowedEmailsBlocEvent_FetchedAllowedEmails;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AllowedEmailsBlocEvent_FetchedAllowedEmails create() => AllowedEmailsBlocEvent_FetchedAllowedEmails._();
  AllowedEmailsBlocEvent_FetchedAllowedEmails createEmptyInstance() => create();
  static $pb.PbList<AllowedEmailsBlocEvent_FetchedAllowedEmails> createRepeated() => $pb.PbList<AllowedEmailsBlocEvent_FetchedAllowedEmails>();
  @$core.pragma('dart2js:noInline')
  static AllowedEmailsBlocEvent_FetchedAllowedEmails getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AllowedEmailsBlocEvent_FetchedAllowedEmails>(create);
  static AllowedEmailsBlocEvent_FetchedAllowedEmails? _defaultInstance;
}

enum AllowedEmailsBlocEvent_EventType {
  fetchNow, 
  updateNow, 
  notSet
}

/// Fetch the allowed emails for the service or a site
/// The emails are stored outside of the events
class AllowedEmailsBlocEvent extends $pb.GeneratedMessage {
  factory AllowedEmailsBlocEvent({
    AllowedEmailsBlocEvent_FetchedAllowedEmails? fetchNow,
    AllowedEmailsBlocState? updateNow,
  }) {
    final $result = create();
    if (fetchNow != null) {
      $result.fetchNow = fetchNow;
    }
    if (updateNow != null) {
      $result.updateNow = updateNow;
    }
    return $result;
  }
  AllowedEmailsBlocEvent._() : super();
  factory AllowedEmailsBlocEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AllowedEmailsBlocEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, AllowedEmailsBlocEvent_EventType> _AllowedEmailsBlocEvent_EventTypeByTag = {
    1 : AllowedEmailsBlocEvent_EventType.fetchNow,
    2 : AllowedEmailsBlocEvent_EventType.updateNow,
    0 : AllowedEmailsBlocEvent_EventType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AllowedEmailsBlocEvent', createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<AllowedEmailsBlocEvent_FetchedAllowedEmails>(1, _omitFieldNames ? '' : 'fetchNow', protoName: 'fetchNow', subBuilder: AllowedEmailsBlocEvent_FetchedAllowedEmails.create)
    ..aOM<AllowedEmailsBlocState>(2, _omitFieldNames ? '' : 'updateNow', protoName: 'updateNow', subBuilder: AllowedEmailsBlocState.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AllowedEmailsBlocEvent clone() => AllowedEmailsBlocEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AllowedEmailsBlocEvent copyWith(void Function(AllowedEmailsBlocEvent) updates) => super.copyWith((message) => updates(message as AllowedEmailsBlocEvent)) as AllowedEmailsBlocEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AllowedEmailsBlocEvent create() => AllowedEmailsBlocEvent._();
  AllowedEmailsBlocEvent createEmptyInstance() => create();
  static $pb.PbList<AllowedEmailsBlocEvent> createRepeated() => $pb.PbList<AllowedEmailsBlocEvent>();
  @$core.pragma('dart2js:noInline')
  static AllowedEmailsBlocEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AllowedEmailsBlocEvent>(create);
  static AllowedEmailsBlocEvent? _defaultInstance;

  AllowedEmailsBlocEvent_EventType whichEventType() => _AllowedEmailsBlocEvent_EventTypeByTag[$_whichOneof(0)]!;
  void clearEventType() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  AllowedEmailsBlocEvent_FetchedAllowedEmails get fetchNow => $_getN(0);
  @$pb.TagNumber(1)
  set fetchNow(AllowedEmailsBlocEvent_FetchedAllowedEmails v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasFetchNow() => $_has(0);
  @$pb.TagNumber(1)
  void clearFetchNow() => clearField(1);
  @$pb.TagNumber(1)
  AllowedEmailsBlocEvent_FetchedAllowedEmails ensureFetchNow() => $_ensure(0);

  @$pb.TagNumber(2)
  AllowedEmailsBlocState get updateNow => $_getN(1);
  @$pb.TagNumber(2)
  set updateNow(AllowedEmailsBlocState v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasUpdateNow() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateNow() => clearField(2);
  @$pb.TagNumber(2)
  AllowedEmailsBlocState ensureUpdateNow() => $_ensure(1);
}

class AllowedEmailsBlocState_UserInfo extends $pb.GeneratedMessage {
  factory AllowedEmailsBlocState_UserInfo({
    $core.int? userId,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    return $result;
  }
  AllowedEmailsBlocState_UserInfo._() : super();
  factory AllowedEmailsBlocState_UserInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AllowedEmailsBlocState_UserInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AllowedEmailsBlocState.UserInfo', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'userId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AllowedEmailsBlocState_UserInfo clone() => AllowedEmailsBlocState_UserInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AllowedEmailsBlocState_UserInfo copyWith(void Function(AllowedEmailsBlocState_UserInfo) updates) => super.copyWith((message) => updates(message as AllowedEmailsBlocState_UserInfo)) as AllowedEmailsBlocState_UserInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AllowedEmailsBlocState_UserInfo create() => AllowedEmailsBlocState_UserInfo._();
  AllowedEmailsBlocState_UserInfo createEmptyInstance() => create();
  static $pb.PbList<AllowedEmailsBlocState_UserInfo> createRepeated() => $pb.PbList<AllowedEmailsBlocState_UserInfo>();
  @$core.pragma('dart2js:noInline')
  static AllowedEmailsBlocState_UserInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AllowedEmailsBlocState_UserInfo>(create);
  static AllowedEmailsBlocState_UserInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get userId => $_getIZ(0);
  @$pb.TagNumber(1)
  set userId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);
}

class AllowedEmailsBlocState extends $pb.GeneratedMessage {
  factory AllowedEmailsBlocState({
    AllowedEmailsBlocState_State? state,
    $core.Map<$core.String, AllowedEmailsBlocState_UserInfo>? emails,
  }) {
    final $result = create();
    if (state != null) {
      $result.state = state;
    }
    if (emails != null) {
      $result.emails.addAll(emails);
    }
    return $result;
  }
  AllowedEmailsBlocState._() : super();
  factory AllowedEmailsBlocState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AllowedEmailsBlocState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AllowedEmailsBlocState', createEmptyInstance: create)
    ..e<AllowedEmailsBlocState_State>(1, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: AllowedEmailsBlocState_State.fetching, valueOf: AllowedEmailsBlocState_State.valueOf, enumValues: AllowedEmailsBlocState_State.values)
    ..m<$core.String, AllowedEmailsBlocState_UserInfo>(2, _omitFieldNames ? '' : 'emails', entryClassName: 'AllowedEmailsBlocState.EmailsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: AllowedEmailsBlocState_UserInfo.create, valueDefaultOrMaker: AllowedEmailsBlocState_UserInfo.getDefault)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AllowedEmailsBlocState clone() => AllowedEmailsBlocState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AllowedEmailsBlocState copyWith(void Function(AllowedEmailsBlocState) updates) => super.copyWith((message) => updates(message as AllowedEmailsBlocState)) as AllowedEmailsBlocState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AllowedEmailsBlocState create() => AllowedEmailsBlocState._();
  AllowedEmailsBlocState createEmptyInstance() => create();
  static $pb.PbList<AllowedEmailsBlocState> createRepeated() => $pb.PbList<AllowedEmailsBlocState>();
  @$core.pragma('dart2js:noInline')
  static AllowedEmailsBlocState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AllowedEmailsBlocState>(create);
  static AllowedEmailsBlocState? _defaultInstance;

  @$pb.TagNumber(1)
  AllowedEmailsBlocState_State get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(AllowedEmailsBlocState_State v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => clearField(1);

  @$pb.TagNumber(2)
  $core.Map<$core.String, AllowedEmailsBlocState_UserInfo> get emails => $_getMap(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
