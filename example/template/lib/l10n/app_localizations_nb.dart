// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String app_submissionError(Object error) {
    return 'Innsendingsfeil: $error';
  }

  @override
  String get app_unexpectedError =>
      'Uventet feil, sjekk internett, gå tilbake og prøv igjen';

  @override
  String get app_appTitle => 'Hytta Hub Skjemaeksempel';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versjon $appVersion-$appBuildNumber';
  }

  @override
  String get app_enterButton => 'Enter';

  @override
  String get app_pickPhotosButton => 'Pick Photos';

  @override
  String get app_permissionDenied =>
      'Du har ikke tillatelse til å utføre denne handlingen.';

  @override
  String get app_appEventsOption => 'App Events';

  @override
  String get app_editModeTitle => 'Edit Mode';

  @override
  String get app_adminPrivileges => 'You have admin privileges for this site.';

  @override
  String get app_howToProceed => 'How would you like to proceed?';

  @override
  String get app_viewSite => 'View Site';

  @override
  String get app_editSite => 'Edit Site';

  @override
  String app_eventUpdateText(String value) {
    return 'Updated Text: $value';
  }

  @override
  String get app_eventUpdateCode => 'Updated Code';

  @override
  String app_eventUpdateCheckbox(String value) {
    return 'Updated Checkbox: $value';
  }

  @override
  String app_eventUpdateDropdown(String value) {
    return 'Updated Dropdown: $value';
  }

  @override
  String get app_eventUpdateList => 'Updated List';

  @override
  String app_eventUpdatePhoto(String name) {
    return 'Updated Photo: $name';
  }
}
