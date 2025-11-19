import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_events.freezed.dart';
part 'app_events.g.dart';

@freezed
class AppEvent with _$AppEvent {
  const factory AppEvent.updateText({
    String? text,
  }) = AppEvent_UpdateText;

  factory AppEvent.fromJson(Map<String, dynamic> json) =>
      _$AppEventFromJson(json);
}

@freezed
class SubmitAppEventSiteEvent with _$SubmitAppEventSiteEvent {
  const factory SubmitAppEventSiteEvent({
    int? version,
    int? author,
  }) = _SubmitAppEventSiteEvent;

  factory SubmitAppEventSiteEvent.fromJson(Map<String, dynamic> json) =>
      _$SubmitAppEventSiteEventFromJson(json);
}


@freezed
class SubmitAppEvent with _$SubmitAppEvent {
  const factory SubmitAppEvent({
    AppEvent? appEvent,
    SubmitAppEventSiteEvent? siteEvent,
    String? authorEmail,
  }) = _SubmitAppEvent;

  factory SubmitAppEvent.fromJson(Map<String, dynamic> json) =>
      _$SubmitAppEventFromJson(json);
}

@freezed
class AppEventRecord with _$AppEventRecord {
  const factory AppEventRecord({
    String? isoDate,
    int? version,
    AppEvent? appEvent,
  }) = _AppEventRecord;

  factory AppEventRecord.fromJson(Map<String, dynamic> json) =>
      _$AppEventRecordFromJson(json);
}
