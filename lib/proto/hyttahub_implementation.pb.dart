//
//  Generated code. Do not modify.
//  source: hyttahub_implementation.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'hyttahub_implementation.pbenum.dart';

export 'hyttahub_implementation.pbenum.dart';

class HyttaHubImplementation extends $pb.GeneratedMessage {
  factory HyttaHubImplementation({
    StorageEnum? storage,
    $core.int? appBuildNumber,
    $core.String? appId,
    $core.String? firebaseRootCollection,
  }) {
    final $result = create();
    if (storage != null) {
      $result.storage = storage;
    }
    if (appBuildNumber != null) {
      $result.appBuildNumber = appBuildNumber;
    }
    if (appId != null) {
      $result.appId = appId;
    }
    if (firebaseRootCollection != null) {
      $result.firebaseRootCollection = firebaseRootCollection;
    }
    return $result;
  }
  HyttaHubImplementation._() : super();
  factory HyttaHubImplementation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HyttaHubImplementation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HyttaHubImplementation', createEmptyInstance: create)
    ..e<StorageEnum>(1, _omitFieldNames ? '' : 'storage', $pb.PbFieldType.OE, defaultOrMaker: StorageEnum.firestore, valueOf: StorageEnum.valueOf, enumValues: StorageEnum.values)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'appBuildNumber', $pb.PbFieldType.O3, protoName: 'appBuildNumber')
    ..aOS(3, _omitFieldNames ? '' : 'appId', protoName: 'appId')
    ..aOS(4, _omitFieldNames ? '' : 'firebaseRootCollection', protoName: 'firebaseRootCollection')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HyttaHubImplementation clone() => HyttaHubImplementation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HyttaHubImplementation copyWith(void Function(HyttaHubImplementation) updates) => super.copyWith((message) => updates(message as HyttaHubImplementation)) as HyttaHubImplementation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HyttaHubImplementation create() => HyttaHubImplementation._();
  HyttaHubImplementation createEmptyInstance() => create();
  static $pb.PbList<HyttaHubImplementation> createRepeated() => $pb.PbList<HyttaHubImplementation>();
  @$core.pragma('dart2js:noInline')
  static HyttaHubImplementation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HyttaHubImplementation>(create);
  static HyttaHubImplementation? _defaultInstance;

  @$pb.TagNumber(1)
  StorageEnum get storage => $_getN(0);
  @$pb.TagNumber(1)
  set storage(StorageEnum v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStorage() => $_has(0);
  @$pb.TagNumber(1)
  void clearStorage() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get appBuildNumber => $_getIZ(1);
  @$pb.TagNumber(2)
  set appBuildNumber($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAppBuildNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearAppBuildNumber() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get appId => $_getSZ(2);
  @$pb.TagNumber(3)
  set appId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAppId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get firebaseRootCollection => $_getSZ(3);
  @$pb.TagNumber(4)
  set firebaseRootCollection($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFirebaseRootCollection() => $_has(3);
  @$pb.TagNumber(4)
  void clearFirebaseRootCollection() => clearField(4);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
