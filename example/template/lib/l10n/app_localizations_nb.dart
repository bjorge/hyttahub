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

  @override
  String get app_eventRemovePhoto => 'Bilde Fjernet';

  @override
  String get app_labelText => 'Tekst';

  @override
  String get app_labelCode => 'Kode';

  @override
  String get app_labelCheckbox => 'Avkrysning';

  @override
  String get app_labelDropdown => 'Nedtrekksmeny';

  @override
  String get app_labelList => 'Liste';

  @override
  String get app_labelPhoto => 'Bilde';

  @override
  String get app_reorderList => 'Omordne Liste';

  @override
  String app_updateLabel(String label) {
    return 'Oppdater $label';
  }

  @override
  String get app_noPhoto => 'Ingen bilde';

  @override
  String get app_selectedPhoto => 'Valgt Bilde';

  @override
  String get app_deletePhoto => 'Slett Bilde';

  @override
  String get app_deletePhotoTitle => 'Slett Bilde';

  @override
  String get app_deletePhotoConfirmation => 'Bekreft sletting av bilde';

  @override
  String get app_appSpecificEvent => 'Appspesifikk hendelse';

  @override
  String get app_updateTextTitle => 'Oppdater Tekst';

  @override
  String get app_textValueLabel => 'Tekstverdi';

  @override
  String get app_updateCheckboxTitle => 'Oppdater Avkrysning';

  @override
  String get app_checkboxValueLabel => 'Avkrysningsverdi';

  @override
  String get app_updateCodeTitle => 'Oppdater Kode';

  @override
  String get app_codeValueLabel => 'Kodeverdi';

  @override
  String get app_updateDropdownTitle => 'Oppdater Nedtrekksmeny';

  @override
  String get app_dropdownValueLabel => 'Nedtrekksverdi';

  @override
  String get app_dropdownOption1 => 'Alternativ 1';

  @override
  String get app_dropdownOption2 => 'Alternativ 2';

  @override
  String get app_updateListTitle => 'Oppdater Liste';

  @override
  String get app_reorderableListLabel => 'Omordnbar Liste';

  @override
  String get app_updatePhotoTitle => 'Oppdater Bilde';

  @override
  String get app_appEventsTitle => 'Apphendelser';

  @override
  String get app_appStateTitle => 'Appstatus';
}
