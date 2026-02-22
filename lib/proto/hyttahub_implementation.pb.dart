// This is a generated file - do not edit.
//
// Generated from hyttahub_implementation.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'hyttahub_implementation.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'hyttahub_implementation.pbenum.dart';

class HyttaHubImplementation extends $pb.GeneratedMessage {
  factory HyttaHubImplementation({
    StorageEnum? storage,
    $core.int? appBuildNumber,
    $core.String? appId,
    $core.String? firebaseRootCollection,
    $core.bool? disableFirestoreCache,
    $core.String? implementationId,
  }) {
    final result = create();
    if (storage != null) result.storage = storage;
    if (appBuildNumber != null) result.appBuildNumber = appBuildNumber;
    if (appId != null) result.appId = appId;
    if (firebaseRootCollection != null)
      result.firebaseRootCollection = firebaseRootCollection;
    if (disableFirestoreCache != null)
      result.disableFirestoreCache = disableFirestoreCache;
    if (implementationId != null) result.implementationId = implementationId;
    return result;
  }

  HyttaHubImplementation._();

  factory HyttaHubImplementation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HyttaHubImplementation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HyttaHubImplementation',
      createEmptyInstance: create)
    ..aE<StorageEnum>(1, _omitFieldNames ? '' : 'storage',
        enumValues: StorageEnum.values)
    ..aI(2, _omitFieldNames ? '' : 'appBuildNumber',
        protoName: 'appBuildNumber')
    ..aOS(3, _omitFieldNames ? '' : 'appId', protoName: 'appId')
    ..aOS(4, _omitFieldNames ? '' : 'firebaseRootCollection',
        protoName: 'firebaseRootCollection')
    ..aOB(5, _omitFieldNames ? '' : 'disableFirestoreCache')
    ..aOS(6, _omitFieldNames ? '' : 'implementationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HyttaHubImplementation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HyttaHubImplementation copyWith(
          void Function(HyttaHubImplementation) updates) =>
      super.copyWith((message) => updates(message as HyttaHubImplementation))
          as HyttaHubImplementation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HyttaHubImplementation create() => HyttaHubImplementation._();
  @$core.override
  HyttaHubImplementation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HyttaHubImplementation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HyttaHubImplementation>(create);
  static HyttaHubImplementation? _defaultInstance;

  @$pb.TagNumber(1)
  StorageEnum get storage => $_getN(0);
  @$pb.TagNumber(1)
  set storage(StorageEnum value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStorage() => $_has(0);
  @$pb.TagNumber(1)
  void clearStorage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get appBuildNumber => $_getIZ(1);
  @$pb.TagNumber(2)
  set appBuildNumber($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAppBuildNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearAppBuildNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get appId => $_getSZ(2);
  @$pb.TagNumber(3)
  set appId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAppId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get firebaseRootCollection => $_getSZ(3);
  @$pb.TagNumber(4)
  set firebaseRootCollection($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFirebaseRootCollection() => $_has(3);
  @$pb.TagNumber(4)
  void clearFirebaseRootCollection() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get disableFirestoreCache => $_getBF(4);
  @$pb.TagNumber(5)
  set disableFirestoreCache($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDisableFirestoreCache() => $_has(4);
  @$pb.TagNumber(5)
  void clearDisableFirestoreCache() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get implementationId => $_getSZ(5);
  @$pb.TagNumber(6)
  set implementationId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasImplementationId() => $_has(5);
  @$pb.TagNumber(6)
  void clearImplementationId() => $_clearField(6);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
