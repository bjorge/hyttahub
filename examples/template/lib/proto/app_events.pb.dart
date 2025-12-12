//
//  Generated code. Do not modify.
//  source: app_events.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AppEvent_ReorderableItem extends $pb.GeneratedMessage {
  factory AppEvent_ReorderableItem({
    $core.int? id,
    $core.String? title,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (title != null) {
      $result.title = title;
    }
    return $result;
  }
  AppEvent_ReorderableItem._() : super();
  factory AppEvent_ReorderableItem.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_ReorderableItem.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.ReorderableItem', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub.example.template'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_ReorderableItem clone() => AppEvent_ReorderableItem()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_ReorderableItem copyWith(void Function(AppEvent_ReorderableItem) updates) => super.copyWith((message) => updates(message as AppEvent_ReorderableItem)) as AppEvent_ReorderableItem;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_ReorderableItem create() => AppEvent_ReorderableItem._();
  AppEvent_ReorderableItem createEmptyInstance() => create();
  static $pb.PbList<AppEvent_ReorderableItem> createRepeated() => $pb.PbList<AppEvent_ReorderableItem>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_ReorderableItem getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_ReorderableItem>(create);
  static AppEvent_ReorderableItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);
}

class AppEvent_TemplateForm extends $pb.GeneratedMessage {
  factory AppEvent_TemplateForm({
    $core.String? textValue,
    $core.String? codeValue,
    $core.bool? checkboxValue,
    $core.String? dropdownValue,
    $core.Iterable<AppEvent_ReorderableItem>? listItems,
  }) {
    final $result = create();
    if (textValue != null) {
      $result.textValue = textValue;
    }
    if (codeValue != null) {
      $result.codeValue = codeValue;
    }
    if (checkboxValue != null) {
      $result.checkboxValue = checkboxValue;
    }
    if (dropdownValue != null) {
      $result.dropdownValue = dropdownValue;
    }
    if (listItems != null) {
      $result.listItems.addAll(listItems);
    }
    return $result;
  }
  AppEvent_TemplateForm._() : super();
  factory AppEvent_TemplateForm.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent_TemplateForm.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent.TemplateForm', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub.example.template'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'textValue', protoName: 'textValue')
    ..aOS(2, _omitFieldNames ? '' : 'codeValue', protoName: 'codeValue')
    ..aOB(3, _omitFieldNames ? '' : 'checkboxValue', protoName: 'checkboxValue')
    ..aOS(4, _omitFieldNames ? '' : 'dropdownValue', protoName: 'dropdownValue')
    ..pc<AppEvent_ReorderableItem>(5, _omitFieldNames ? '' : 'listItems', $pb.PbFieldType.PM, protoName: 'listItems', subBuilder: AppEvent_ReorderableItem.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent_TemplateForm clone() => AppEvent_TemplateForm()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent_TemplateForm copyWith(void Function(AppEvent_TemplateForm) updates) => super.copyWith((message) => updates(message as AppEvent_TemplateForm)) as AppEvent_TemplateForm;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent_TemplateForm create() => AppEvent_TemplateForm._();
  AppEvent_TemplateForm createEmptyInstance() => create();
  static $pb.PbList<AppEvent_TemplateForm> createRepeated() => $pb.PbList<AppEvent_TemplateForm>();
  @$core.pragma('dart2js:noInline')
  static AppEvent_TemplateForm getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent_TemplateForm>(create);
  static AppEvent_TemplateForm? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get textValue => $_getSZ(0);
  @$pb.TagNumber(1)
  set textValue($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTextValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearTextValue() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get codeValue => $_getSZ(1);
  @$pb.TagNumber(2)
  set codeValue($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCodeValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearCodeValue() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get checkboxValue => $_getBF(2);
  @$pb.TagNumber(3)
  set checkboxValue($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCheckboxValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearCheckboxValue() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get dropdownValue => $_getSZ(3);
  @$pb.TagNumber(4)
  set dropdownValue($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDropdownValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearDropdownValue() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<AppEvent_ReorderableItem> get listItems => $_getList(4);
}

enum AppEvent_Event {
  templateForm, 
  notSet
}

class AppEvent extends $pb.GeneratedMessage {
  factory AppEvent({
    AppEvent_TemplateForm? templateForm,
  }) {
    final $result = create();
    if (templateForm != null) {
      $result.templateForm = templateForm;
    }
    return $result;
  }
  AppEvent._() : super();
  factory AppEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, AppEvent_Event> _AppEvent_EventByTag = {
    2 : AppEvent_Event.templateForm,
    0 : AppEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub.example.template'), createEmptyInstance: create)
    ..oo(0, [2])
    ..aOM<AppEvent_TemplateForm>(2, _omitFieldNames ? '' : 'templateForm', protoName: 'templateForm', subBuilder: AppEvent_TemplateForm.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEvent clone() => AppEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEvent copyWith(void Function(AppEvent) updates) => super.copyWith((message) => updates(message as AppEvent)) as AppEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEvent create() => AppEvent._();
  AppEvent createEmptyInstance() => create();
  static $pb.PbList<AppEvent> createRepeated() => $pb.PbList<AppEvent>();
  @$core.pragma('dart2js:noInline')
  static AppEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEvent>(create);
  static AppEvent? _defaultInstance;

  AppEvent_Event whichEvent() => _AppEvent_EventByTag[$_whichOneof(0)]!;
  void clearEvent() => clearField($_whichOneof(0));

  @$pb.TagNumber(2)
  AppEvent_TemplateForm get templateForm => $_getN(0);
  @$pb.TagNumber(2)
  set templateForm(AppEvent_TemplateForm v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTemplateForm() => $_has(0);
  @$pb.TagNumber(2)
  void clearTemplateForm() => clearField(2);
  @$pb.TagNumber(2)
  AppEvent_TemplateForm ensureTemplateForm() => $_ensure(0);
}

/// the final site event will contain this app event
class SubmitAppEvent_SiteEvent extends $pb.GeneratedMessage {
  factory SubmitAppEvent_SiteEvent({
    $core.int? version,
    $core.int? author,
  }) {
    final $result = create();
    if (version != null) {
      $result.version = version;
    }
    if (author != null) {
      $result.author = author;
    }
    return $result;
  }
  SubmitAppEvent_SiteEvent._() : super();
  factory SubmitAppEvent_SiteEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitAppEvent_SiteEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitAppEvent.SiteEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub.example.template'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'version', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'author', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitAppEvent_SiteEvent clone() => SubmitAppEvent_SiteEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitAppEvent_SiteEvent copyWith(void Function(SubmitAppEvent_SiteEvent) updates) => super.copyWith((message) => updates(message as SubmitAppEvent_SiteEvent)) as SubmitAppEvent_SiteEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitAppEvent_SiteEvent create() => SubmitAppEvent_SiteEvent._();
  SubmitAppEvent_SiteEvent createEmptyInstance() => create();
  static $pb.PbList<SubmitAppEvent_SiteEvent> createRepeated() => $pb.PbList<SubmitAppEvent_SiteEvent>();
  @$core.pragma('dart2js:noInline')
  static SubmitAppEvent_SiteEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitAppEvent_SiteEvent>(create);
  static SubmitAppEvent_SiteEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get author => $_getIZ(1);
  @$pb.TagNumber(2)
  set author($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAuthor() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthor() => clearField(2);
}

/// The SubmitAppEvent is passed to the submit bloc handler
/// PII (ex. email) is allowed in this message since not stored to immutable
/// records
class SubmitAppEvent extends $pb.GeneratedMessage {
  factory SubmitAppEvent({
    AppEvent? appEvent,
    SubmitAppEvent_SiteEvent? siteEvent,
    $core.String? authorEmail,
  }) {
    final $result = create();
    if (appEvent != null) {
      $result.appEvent = appEvent;
    }
    if (siteEvent != null) {
      $result.siteEvent = siteEvent;
    }
    if (authorEmail != null) {
      $result.authorEmail = authorEmail;
    }
    return $result;
  }
  SubmitAppEvent._() : super();
  factory SubmitAppEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitAppEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitAppEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub.example.template'), createEmptyInstance: create)
    ..aOM<AppEvent>(1, _omitFieldNames ? '' : 'appEvent', protoName: 'appEvent', subBuilder: AppEvent.create)
    ..aOM<SubmitAppEvent_SiteEvent>(2, _omitFieldNames ? '' : 'siteEvent', protoName: 'siteEvent', subBuilder: SubmitAppEvent_SiteEvent.create)
    ..aOS(3, _omitFieldNames ? '' : 'authorEmail', protoName: 'authorEmail')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitAppEvent clone() => SubmitAppEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitAppEvent copyWith(void Function(SubmitAppEvent) updates) => super.copyWith((message) => updates(message as SubmitAppEvent)) as SubmitAppEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitAppEvent create() => SubmitAppEvent._();
  SubmitAppEvent createEmptyInstance() => create();
  static $pb.PbList<SubmitAppEvent> createRepeated() => $pb.PbList<SubmitAppEvent>();
  @$core.pragma('dart2js:noInline')
  static SubmitAppEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitAppEvent>(create);
  static SubmitAppEvent? _defaultInstance;

  @$pb.TagNumber(1)
  AppEvent get appEvent => $_getN(0);
  @$pb.TagNumber(1)
  set appEvent(AppEvent v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAppEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppEvent() => clearField(1);
  @$pb.TagNumber(1)
  AppEvent ensureAppEvent() => $_ensure(0);

  @$pb.TagNumber(2)
  SubmitAppEvent_SiteEvent get siteEvent => $_getN(1);
  @$pb.TagNumber(2)
  set siteEvent(SubmitAppEvent_SiteEvent v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSiteEvent() => $_has(1);
  @$pb.TagNumber(2)
  void clearSiteEvent() => clearField(2);
  @$pb.TagNumber(2)
  SubmitAppEvent_SiteEvent ensureSiteEvent() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get authorEmail => $_getSZ(2);
  @$pb.TagNumber(3)
  set authorEmail($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAuthorEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthorEmail() => clearField(3);
}

/// The AppEventRecord is a representation of the actual record stored in the
/// database This record is used just for display purposes in the client
class AppEventRecord extends $pb.GeneratedMessage {
  factory AppEventRecord({
    $core.String? isoDate,
    $core.int? version,
    AppEvent? appEvent,
  }) {
    final $result = create();
    if (isoDate != null) {
      $result.isoDate = isoDate;
    }
    if (version != null) {
      $result.version = version;
    }
    if (appEvent != null) {
      $result.appEvent = appEvent;
    }
    return $result;
  }
  AppEventRecord._() : super();
  factory AppEventRecord.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppEventRecord.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppEventRecord', package: const $pb.PackageName(_omitMessageNames ? '' : 'hyttahub.example.template'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'isoDate', protoName: 'isoDate')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'version', $pb.PbFieldType.O3)
    ..aOM<AppEvent>(3, _omitFieldNames ? '' : 'appEvent', protoName: 'appEvent', subBuilder: AppEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppEventRecord clone() => AppEventRecord()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppEventRecord copyWith(void Function(AppEventRecord) updates) => super.copyWith((message) => updates(message as AppEventRecord)) as AppEventRecord;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppEventRecord create() => AppEventRecord._();
  AppEventRecord createEmptyInstance() => create();
  static $pb.PbList<AppEventRecord> createRepeated() => $pb.PbList<AppEventRecord>();
  @$core.pragma('dart2js:noInline')
  static AppEventRecord getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppEventRecord>(create);
  static AppEventRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get isoDate => $_getSZ(0);
  @$pb.TagNumber(1)
  set isoDate($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIsoDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsoDate() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get version => $_getIZ(1);
  @$pb.TagNumber(2)
  set version($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => clearField(2);

  @$pb.TagNumber(3)
  AppEvent get appEvent => $_getN(2);
  @$pb.TagNumber(3)
  set appEvent(AppEvent v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAppEvent() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppEvent() => clearField(3);
  @$pb.TagNumber(3)
  AppEvent ensureAppEvent() => $_ensure(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
