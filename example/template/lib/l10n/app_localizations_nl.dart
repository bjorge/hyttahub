// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String app_submissionError(Object error) {
    return 'Fout bij indienen: $error';
  }

  @override
  String get app_unexpectedError =>
      'Onverwachte fout, controleer uw internetverbinding en probeer het opnieuw';

  @override
  String get app_appTitle => 'Hytta Hub Formuliervoorbeeld';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versie $appVersion-$appBuildNumber';
  }

  @override
  String get app_enterButton => 'Enter';

  @override
  String get app_pickPhotosButton => 'Pick Photos';

  @override
  String get app_permissionDenied =>
      'U heeft geen toestemming om deze actie uit te voeren.';

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

  @override
  String get app_labelText => 'Tekst';

  @override
  String get app_labelCode => 'Code';

  @override
  String get app_labelCheckbox => 'Selectievakje';

  @override
  String get app_labelDropdown => 'Keuzelijst';

  @override
  String get app_labelList => 'Lijst';

  @override
  String get app_labelPhoto => 'Foto';

  @override
  String get app_reorderList => 'Lijst Herschikken';

  @override
  String app_updateLabel(String label) {
    return '$label Bijwerken';
  }

  @override
  String get app_noPhoto => 'Geen foto';

  @override
  String get app_selectedPhoto => 'Geselecteerde Foto';

  @override
  String get app_deletePhoto => 'Foto Verwijderen';

  @override
  String app_errorDeletingPhoto(String error) {
    return 'Fout bij verwijderen van foto: $error';
  }

  @override
  String get app_photoDeleted => 'Foto verwijderd';

  @override
  String get app_appSpecificEvent => 'App-specifieke gebeurtenis';

  @override
  String get app_updateTextTitle => 'Tekst Bijwerken';

  @override
  String get app_textValueLabel => 'Tekstwaarde';

  @override
  String get app_updateCheckboxTitle => 'Selectievakje Bijwerken';

  @override
  String get app_checkboxValueLabel => 'Selectievakwaarde';

  @override
  String get app_updateCodeTitle => 'Code Bijwerken';

  @override
  String get app_codeValueLabel => 'Codewaarde';

  @override
  String get app_updateDropdownTitle => 'Keuzelijst Bijwerken';

  @override
  String get app_dropdownValueLabel => 'Keuzelijstwaarde';

  @override
  String get app_dropdownOption1 => 'Optie 1';

  @override
  String get app_dropdownOption2 => 'Optie 2';

  @override
  String get app_updateListTitle => 'Lijst Bijwerken';

  @override
  String get app_reorderableListLabel => 'Herschikbare Lijst';

  @override
  String get app_updatePhotoTitle => 'Foto Bijwerken';

  @override
  String get app_appEventsTitle => 'App Gebeurtenissen';

  @override
  String get app_appStateTitle => 'App Status';
}
