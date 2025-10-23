//
//  Generated code. Do not modify.
//  source: cloud_functions.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

enum CloudFunctionsState_State {
  initial, 
  loading, 
  exportSuccess, 
  exportListSuccess, 
  exportDeleteSuccess, 
  exportDetailsSuccess, 
  failure, 
  notSet
}

class CloudFunctionsState extends $pb.GeneratedMessage {
  factory CloudFunctionsState({
    CloudFunctionsInitial? initial,
    CloudFunctionsLoading? loading,
    ExportSuccess? exportSuccess,
    ExportListSuccess? exportListSuccess,
    ExportDeleteSuccess? exportDeleteSuccess,
    ExportDetailsSuccess? exportDetailsSuccess,
    CloudFunctionsFailure? failure,
  }) {
    final $result = create();
    if (initial != null) {
      $result.initial = initial;
    }
    if (loading != null) {
      $result.loading = loading;
    }
    if (exportSuccess != null) {
      $result.exportSuccess = exportSuccess;
    }
    if (exportListSuccess != null) {
      $result.exportListSuccess = exportListSuccess;
    }
    if (exportDeleteSuccess != null) {
      $result.exportDeleteSuccess = exportDeleteSuccess;
    }
    if (exportDetailsSuccess != null) {
      $result.exportDetailsSuccess = exportDetailsSuccess;
    }
    if (failure != null) {
      $result.failure = failure;
    }
    return $result;
  }
  CloudFunctionsState._() : super();
  factory CloudFunctionsState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CloudFunctionsState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, CloudFunctionsState_State> _CloudFunctionsState_StateByTag = {
    1 : CloudFunctionsState_State.initial,
    2 : CloudFunctionsState_State.loading,
    3 : CloudFunctionsState_State.exportSuccess,
    4 : CloudFunctionsState_State.exportListSuccess,
    5 : CloudFunctionsState_State.exportDeleteSuccess,
    6 : CloudFunctionsState_State.exportDetailsSuccess,
    7 : CloudFunctionsState_State.failure,
    0 : CloudFunctionsState_State.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudFunctionsState', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7])
    ..aOM<CloudFunctionsInitial>(1, _omitFieldNames ? '' : 'initial', subBuilder: CloudFunctionsInitial.create)
    ..aOM<CloudFunctionsLoading>(2, _omitFieldNames ? '' : 'loading', subBuilder: CloudFunctionsLoading.create)
    ..aOM<ExportSuccess>(3, _omitFieldNames ? '' : 'exportSuccess', subBuilder: ExportSuccess.create)
    ..aOM<ExportListSuccess>(4, _omitFieldNames ? '' : 'exportListSuccess', subBuilder: ExportListSuccess.create)
    ..aOM<ExportDeleteSuccess>(5, _omitFieldNames ? '' : 'exportDeleteSuccess', subBuilder: ExportDeleteSuccess.create)
    ..aOM<ExportDetailsSuccess>(6, _omitFieldNames ? '' : 'exportDetailsSuccess', subBuilder: ExportDetailsSuccess.create)
    ..aOM<CloudFunctionsFailure>(7, _omitFieldNames ? '' : 'failure', subBuilder: CloudFunctionsFailure.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CloudFunctionsState clone() => CloudFunctionsState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CloudFunctionsState copyWith(void Function(CloudFunctionsState) updates) => super.copyWith((message) => updates(message as CloudFunctionsState)) as CloudFunctionsState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudFunctionsState create() => CloudFunctionsState._();
  CloudFunctionsState createEmptyInstance() => create();
  static $pb.PbList<CloudFunctionsState> createRepeated() => $pb.PbList<CloudFunctionsState>();
  @$core.pragma('dart2js:noInline')
  static CloudFunctionsState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudFunctionsState>(create);
  static CloudFunctionsState? _defaultInstance;

  CloudFunctionsState_State whichState() => _CloudFunctionsState_StateByTag[$_whichOneof(0)]!;
  void clearState() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CloudFunctionsInitial get initial => $_getN(0);
  @$pb.TagNumber(1)
  set initial(CloudFunctionsInitial v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasInitial() => $_has(0);
  @$pb.TagNumber(1)
  void clearInitial() => clearField(1);
  @$pb.TagNumber(1)
  CloudFunctionsInitial ensureInitial() => $_ensure(0);

  @$pb.TagNumber(2)
  CloudFunctionsLoading get loading => $_getN(1);
  @$pb.TagNumber(2)
  set loading(CloudFunctionsLoading v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasLoading() => $_has(1);
  @$pb.TagNumber(2)
  void clearLoading() => clearField(2);
  @$pb.TagNumber(2)
  CloudFunctionsLoading ensureLoading() => $_ensure(1);

  @$pb.TagNumber(3)
  ExportSuccess get exportSuccess => $_getN(2);
  @$pb.TagNumber(3)
  set exportSuccess(ExportSuccess v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasExportSuccess() => $_has(2);
  @$pb.TagNumber(3)
  void clearExportSuccess() => clearField(3);
  @$pb.TagNumber(3)
  ExportSuccess ensureExportSuccess() => $_ensure(2);

  @$pb.TagNumber(4)
  ExportListSuccess get exportListSuccess => $_getN(3);
  @$pb.TagNumber(4)
  set exportListSuccess(ExportListSuccess v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasExportListSuccess() => $_has(3);
  @$pb.TagNumber(4)
  void clearExportListSuccess() => clearField(4);
  @$pb.TagNumber(4)
  ExportListSuccess ensureExportListSuccess() => $_ensure(3);

  @$pb.TagNumber(5)
  ExportDeleteSuccess get exportDeleteSuccess => $_getN(4);
  @$pb.TagNumber(5)
  set exportDeleteSuccess(ExportDeleteSuccess v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasExportDeleteSuccess() => $_has(4);
  @$pb.TagNumber(5)
  void clearExportDeleteSuccess() => clearField(5);
  @$pb.TagNumber(5)
  ExportDeleteSuccess ensureExportDeleteSuccess() => $_ensure(4);

  @$pb.TagNumber(6)
  ExportDetailsSuccess get exportDetailsSuccess => $_getN(5);
  @$pb.TagNumber(6)
  set exportDetailsSuccess(ExportDetailsSuccess v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasExportDetailsSuccess() => $_has(5);
  @$pb.TagNumber(6)
  void clearExportDetailsSuccess() => clearField(6);
  @$pb.TagNumber(6)
  ExportDetailsSuccess ensureExportDetailsSuccess() => $_ensure(5);

  @$pb.TagNumber(7)
  CloudFunctionsFailure get failure => $_getN(6);
  @$pb.TagNumber(7)
  set failure(CloudFunctionsFailure v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasFailure() => $_has(6);
  @$pb.TagNumber(7)
  void clearFailure() => clearField(7);
  @$pb.TagNumber(7)
  CloudFunctionsFailure ensureFailure() => $_ensure(6);
}

class CloudFunctionsInitial extends $pb.GeneratedMessage {
  factory CloudFunctionsInitial() => create();
  CloudFunctionsInitial._() : super();
  factory CloudFunctionsInitial.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CloudFunctionsInitial.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudFunctionsInitial', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CloudFunctionsInitial clone() => CloudFunctionsInitial()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CloudFunctionsInitial copyWith(void Function(CloudFunctionsInitial) updates) => super.copyWith((message) => updates(message as CloudFunctionsInitial)) as CloudFunctionsInitial;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudFunctionsInitial create() => CloudFunctionsInitial._();
  CloudFunctionsInitial createEmptyInstance() => create();
  static $pb.PbList<CloudFunctionsInitial> createRepeated() => $pb.PbList<CloudFunctionsInitial>();
  @$core.pragma('dart2js:noInline')
  static CloudFunctionsInitial getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudFunctionsInitial>(create);
  static CloudFunctionsInitial? _defaultInstance;
}

class CloudFunctionsLoading extends $pb.GeneratedMessage {
  factory CloudFunctionsLoading() => create();
  CloudFunctionsLoading._() : super();
  factory CloudFunctionsLoading.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CloudFunctionsLoading.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudFunctionsLoading', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CloudFunctionsLoading clone() => CloudFunctionsLoading()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CloudFunctionsLoading copyWith(void Function(CloudFunctionsLoading) updates) => super.copyWith((message) => updates(message as CloudFunctionsLoading)) as CloudFunctionsLoading;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudFunctionsLoading create() => CloudFunctionsLoading._();
  CloudFunctionsLoading createEmptyInstance() => create();
  static $pb.PbList<CloudFunctionsLoading> createRepeated() => $pb.PbList<CloudFunctionsLoading>();
  @$core.pragma('dart2js:noInline')
  static CloudFunctionsLoading getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudFunctionsLoading>(create);
  static CloudFunctionsLoading? _defaultInstance;
}

class ExportSuccess extends $pb.GeneratedMessage {
  factory ExportSuccess({
    $core.String? message,
  }) {
    final $result = create();
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  ExportSuccess._() : super();
  factory ExportSuccess.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExportSuccess.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExportSuccess', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExportSuccess clone() => ExportSuccess()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExportSuccess copyWith(void Function(ExportSuccess) updates) => super.copyWith((message) => updates(message as ExportSuccess)) as ExportSuccess;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExportSuccess create() => ExportSuccess._();
  ExportSuccess createEmptyInstance() => create();
  static $pb.PbList<ExportSuccess> createRepeated() => $pb.PbList<ExportSuccess>();
  @$core.pragma('dart2js:noInline')
  static ExportSuccess getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExportSuccess>(create);
  static ExportSuccess? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);
}

class ExportFile extends $pb.GeneratedMessage {
  factory ExportFile({
    $core.String? name,
    $core.String? url,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (url != null) {
      $result.url = url;
    }
    return $result;
  }
  ExportFile._() : super();
  factory ExportFile.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExportFile.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExportFile', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExportFile clone() => ExportFile()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExportFile copyWith(void Function(ExportFile) updates) => super.copyWith((message) => updates(message as ExportFile)) as ExportFile;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExportFile create() => ExportFile._();
  ExportFile createEmptyInstance() => create();
  static $pb.PbList<ExportFile> createRepeated() => $pb.PbList<ExportFile>();
  @$core.pragma('dart2js:noInline')
  static ExportFile getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExportFile>(create);
  static ExportFile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => clearField(2);
}

class ExportListSuccess extends $pb.GeneratedMessage {
  factory ExportListSuccess({
    $core.Iterable<ExportFile>? files,
  }) {
    final $result = create();
    if (files != null) {
      $result.files.addAll(files);
    }
    return $result;
  }
  ExportListSuccess._() : super();
  factory ExportListSuccess.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExportListSuccess.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExportListSuccess', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub'), createEmptyInstance: create)
    ..pc<ExportFile>(1, _omitFieldNames ? '' : 'files', $pb.PbFieldType.PM, subBuilder: ExportFile.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExportListSuccess clone() => ExportListSuccess()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExportListSuccess copyWith(void Function(ExportListSuccess) updates) => super.copyWith((message) => updates(message as ExportListSuccess)) as ExportListSuccess;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExportListSuccess create() => ExportListSuccess._();
  ExportListSuccess createEmptyInstance() => create();
  static $pb.PbList<ExportListSuccess> createRepeated() => $pb.PbList<ExportListSuccess>();
  @$core.pragma('dart2js:noInline')
  static ExportListSuccess getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExportListSuccess>(create);
  static ExportListSuccess? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ExportFile> get files => $_getList(0);
}

class ExportDeleteSuccess extends $pb.GeneratedMessage {
  factory ExportDeleteSuccess() => create();
  ExportDeleteSuccess._() : super();
  factory ExportDeleteSuccess.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExportDeleteSuccess.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExportDeleteSuccess', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExportDeleteSuccess clone() => ExportDeleteSuccess()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExportDeleteSuccess copyWith(void Function(ExportDeleteSuccess) updates) => super.copyWith((message) => updates(message as ExportDeleteSuccess)) as ExportDeleteSuccess;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExportDeleteSuccess create() => ExportDeleteSuccess._();
  ExportDeleteSuccess createEmptyInstance() => create();
  static $pb.PbList<ExportDeleteSuccess> createRepeated() => $pb.PbList<ExportDeleteSuccess>();
  @$core.pragma('dart2js:noInline')
  static ExportDeleteSuccess getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExportDeleteSuccess>(create);
  static ExportDeleteSuccess? _defaultInstance;
}

class ExportDetailsSuccess extends $pb.GeneratedMessage {
  factory ExportDetailsSuccess({
    $core.String? events,
  }) {
    final $result = create();
    if (events != null) {
      $result.events = events;
    }
    return $result;
  }
  ExportDetailsSuccess._() : super();
  factory ExportDetailsSuccess.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExportDetailsSuccess.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExportDetailsSuccess', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'events')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExportDetailsSuccess clone() => ExportDetailsSuccess()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExportDetailsSuccess copyWith(void Function(ExportDetailsSuccess) updates) => super.copyWith((message) => updates(message as ExportDetailsSuccess)) as ExportDetailsSuccess;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExportDetailsSuccess create() => ExportDetailsSuccess._();
  ExportDetailsSuccess createEmptyInstance() => create();
  static $pb.PbList<ExportDetailsSuccess> createRepeated() => $pb.PbList<ExportDetailsSuccess>();
  @$core.pragma('dart2js:noInline')
  static ExportDetailsSuccess getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExportDetailsSuccess>(create);
  static ExportDetailsSuccess? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get events => $_getSZ(0);
  @$pb.TagNumber(1)
  set events($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEvents() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvents() => clearField(1);
}

class CloudFunctionsFailure extends $pb.GeneratedMessage {
  factory CloudFunctionsFailure({
    $core.String? error,
  }) {
    final $result = create();
    if (error != null) {
      $result.error = error;
    }
    return $result;
  }
  CloudFunctionsFailure._() : super();
  factory CloudFunctionsFailure.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CloudFunctionsFailure.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudFunctionsFailure', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CloudFunctionsFailure clone() => CloudFunctionsFailure()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CloudFunctionsFailure copyWith(void Function(CloudFunctionsFailure) updates) => super.copyWith((message) => updates(message as CloudFunctionsFailure)) as CloudFunctionsFailure;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudFunctionsFailure create() => CloudFunctionsFailure._();
  CloudFunctionsFailure createEmptyInstance() => create();
  static $pb.PbList<CloudFunctionsFailure> createRepeated() => $pb.PbList<CloudFunctionsFailure>();
  @$core.pragma('dart2js:noInline')
  static CloudFunctionsFailure getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudFunctionsFailure>(create);
  static CloudFunctionsFailure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get error => $_getSZ(0);
  @$pb.TagNumber(1)
  set error($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
