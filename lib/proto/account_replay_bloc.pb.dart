//
//  Generated code. Do not modify.
//  source: account_replay_bloc.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common_blocs.pbenum.dart' as $0;

class AccountReplayBlocState extends $pb.GeneratedMessage {
  factory AccountReplayBlocState({
    $0.CommonReplayStateEnum? state,
    $core.int? termsVersion,
    $core.int? privacyVersion,
    $core.Map<$core.int, $core.String>? events,
    $core.Iterable<$core.String>? sitesIds,
  }) {
    final $result = create();
    if (state != null) {
      $result.state = state;
    }
    if (termsVersion != null) {
      $result.termsVersion = termsVersion;
    }
    if (privacyVersion != null) {
      $result.privacyVersion = privacyVersion;
    }
    if (events != null) {
      $result.events.addAll(events);
    }
    if (sitesIds != null) {
      $result.sitesIds.addAll(sitesIds);
    }
    return $result;
  }
  AccountReplayBlocState._() : super();
  factory AccountReplayBlocState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AccountReplayBlocState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountReplayBlocState', createEmptyInstance: create)
    ..e<$0.CommonReplayStateEnum>(1, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: $0.CommonReplayStateEnum.ok, valueOf: $0.CommonReplayStateEnum.valueOf, enumValues: $0.CommonReplayStateEnum.values)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'termsVersion', $pb.PbFieldType.O3, protoName: 'termsVersion')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'privacyVersion', $pb.PbFieldType.O3, protoName: 'privacyVersion')
    ..m<$core.int, $core.String>(4, _omitFieldNames ? '' : 'events', entryClassName: 'AccountReplayBlocState.EventsEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.OS)
    ..pPS(5, _omitFieldNames ? '' : 'sitesIds', protoName: 'sitesIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AccountReplayBlocState clone() => AccountReplayBlocState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AccountReplayBlocState copyWith(void Function(AccountReplayBlocState) updates) => super.copyWith((message) => updates(message as AccountReplayBlocState)) as AccountReplayBlocState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountReplayBlocState create() => AccountReplayBlocState._();
  AccountReplayBlocState createEmptyInstance() => create();
  static $pb.PbList<AccountReplayBlocState> createRepeated() => $pb.PbList<AccountReplayBlocState>();
  @$core.pragma('dart2js:noInline')
  static AccountReplayBlocState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountReplayBlocState>(create);
  static AccountReplayBlocState? _defaultInstance;

  @$pb.TagNumber(1)
  $0.CommonReplayStateEnum get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.CommonReplayStateEnum v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get termsVersion => $_getIZ(1);
  @$pb.TagNumber(2)
  set termsVersion($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTermsVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearTermsVersion() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get privacyVersion => $_getIZ(2);
  @$pb.TagNumber(3)
  set privacyVersion($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPrivacyVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrivacyVersion() => clearField(3);

  @$pb.TagNumber(4)
  $core.Map<$core.int, $core.String> get events => $_getMap(3);

  @$pb.TagNumber(5)
  $core.List<$core.String> get sitesIds => $_getList(4);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
