// This is a generated file - do not edit.
//
// Generated from account_replay_bloc.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common_blocs.pbenum.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class AccountReplayBlocState extends $pb.GeneratedMessage {
  factory AccountReplayBlocState({
    $0.CommonReplayStateEnum? state,
    $core.int? termsVersion,
    $core.int? privacyVersion,
    $core.Iterable<$core.MapEntry<$core.int, $core.String>>? events,
    $core.Iterable<$core.String>? sitesIds,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (termsVersion != null) result.termsVersion = termsVersion;
    if (privacyVersion != null) result.privacyVersion = privacyVersion;
    if (events != null) result.events.addEntries(events);
    if (sitesIds != null) result.sitesIds.addAll(sitesIds);
    return result;
  }

  AccountReplayBlocState._();

  factory AccountReplayBlocState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountReplayBlocState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccountReplayBlocState',
      createEmptyInstance: create)
    ..aE<$0.CommonReplayStateEnum>(1, _omitFieldNames ? '' : 'state',
        enumValues: $0.CommonReplayStateEnum.values)
    ..aI(2, _omitFieldNames ? '' : 'termsVersion', protoName: 'termsVersion')
    ..aI(3, _omitFieldNames ? '' : 'privacyVersion',
        protoName: 'privacyVersion')
    ..m<$core.int, $core.String>(4, _omitFieldNames ? '' : 'events',
        entryClassName: 'AccountReplayBlocState.EventsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OS)
    ..pPS(5, _omitFieldNames ? '' : 'sitesIds', protoName: 'sitesIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountReplayBlocState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountReplayBlocState copyWith(
          void Function(AccountReplayBlocState) updates) =>
      super.copyWith((message) => updates(message as AccountReplayBlocState))
          as AccountReplayBlocState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountReplayBlocState create() => AccountReplayBlocState._();
  @$core.override
  AccountReplayBlocState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountReplayBlocState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AccountReplayBlocState>(create);
  static AccountReplayBlocState? _defaultInstance;

  @$pb.TagNumber(1)
  $0.CommonReplayStateEnum get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.CommonReplayStateEnum value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get termsVersion => $_getIZ(1);
  @$pb.TagNumber(2)
  set termsVersion($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTermsVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearTermsVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get privacyVersion => $_getIZ(2);
  @$pb.TagNumber(3)
  set privacyVersion($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrivacyVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrivacyVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.int, $core.String> get events => $_getMap(3);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get sitesIds => $_getList(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
