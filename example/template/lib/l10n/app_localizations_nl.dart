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
  String get app_pickPhotosButton => 'Foto\'s Kiezen';

  @override
  String get app_permissionDenied =>
      'U heeft geen toestemming om deze actie uit te voeren.';

  @override
  String get app_appEventsOption => 'App Gebeurtenissen';

  @override
  String get app_editModeTitle => 'Bewerkingsmodus';

  @override
  String get app_adminPrivileges => 'Je hebt beheerdersrechten voor deze hub.';

  @override
  String get app_howToProceed => 'Hoe wil je verdergaan?';

  @override
  String get app_viewSite => 'Bekijken';

  @override
  String get app_editSite => 'Bewerken';

  @override
  String app_eventUpdateText(String value) {
    return 'Tekst Bijgewerkt: $value';
  }

  @override
  String get app_eventUpdateCode => 'Code Bijgewerkt';

  @override
  String app_eventUpdateCheckbox(String value) {
    return 'Selectievakje Bijgewerkt: $value';
  }

  @override
  String app_eventUpdateDropdown(String value) {
    return 'Keuzelijst Bijgewerkt: $value';
  }

  @override
  String get app_eventUpdateList => 'Lijst Bijgewerkt';

  @override
  String app_eventUpdatePhoto(String name) {
    return 'Foto Bijgewerkt: $name';
  }

  @override
  String get app_eventRemovePhoto => 'Foto Verwijderd';

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
  String get app_deletePhotoTitle => 'Foto Verwijderen';

  @override
  String get app_deletePhotoConfirmation => 'Bevestig verwijdering van foto';

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
