//
//  Generated code. Do not modify.
//  source: site_email.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'site_email.pbenum.dart';

export 'site_email.pbenum.dart';

/// The SiteEmail is persisted in the email collection for each site
class MarkForDeletion extends $pb.GeneratedMessage {
  factory MarkForDeletion({
    MarkForDeletion_DeleteReason? deleteReason,
  }) {
    final $result = create();
    if (deleteReason != null) {
      $result.deleteReason = deleteReason;
    }
    return $result;
  }
  MarkForDeletion._() : super();
  factory MarkForDeletion.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MarkForDeletion.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MarkForDeletion', createEmptyInstance: create)
    ..e<MarkForDeletion_DeleteReason>(1, _omitFieldNames ? '' : 'deleteReason', $pb.PbFieldType.OE, protoName: 'deleteReason', defaultOrMaker: MarkForDeletion_DeleteReason.memberLeftSite, valueOf: MarkForDeletion_DeleteReason.valueOf, enumValues: MarkForDeletion_DeleteReason.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MarkForDeletion clone() => MarkForDeletion()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MarkForDeletion copyWith(void Function(MarkForDeletion) updates) => super.copyWith((message) => updates(message as MarkForDeletion)) as MarkForDeletion;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarkForDeletion create() => MarkForDeletion._();
  MarkForDeletion createEmptyInstance() => create();
  static $pb.PbList<MarkForDeletion> createRepeated() => $pb.PbList<MarkForDeletion>();
  @$core.pragma('dart2js:noInline')
  static MarkForDeletion getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MarkForDeletion>(create);
  static MarkForDeletion? _defaultInstance;

  @$pb.TagNumber(1)
  MarkForDeletion_DeleteReason get deleteReason => $_getN(0);
  @$pb.TagNumber(1)
  set deleteReason(MarkForDeletion_DeleteReason v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeleteReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeleteReason() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
