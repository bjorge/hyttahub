// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String app_submissionError(Object error) {
    return 'Errore di invio: $error';
  }

  @override
  String get app_unexpectedError =>
      'Errore imprevisto, controlla la connessione internet, torna indietro e riprova';

  @override
  String get app_appTitle => 'Hytta Hub Esempio di Modulo';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versione $appVersion-$appBuildNumber';
  }

  @override
  String get app_enterButton => 'Invio';

  @override
  String get app_pickPhotosButton => 'Pick Photos';

  @override
  String get app_permissionDenied =>
      'Non hai il permesso di eseguire questa azione.';

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
  String get app_labelText => 'Testo';

  @override
  String get app_labelCode => 'Codice';

  @override
  String get app_labelCheckbox => 'Casella';

  @override
  String get app_labelDropdown => 'Menu a Tendina';

  @override
  String get app_labelList => 'Lista';

  @override
  String get app_labelPhoto => 'Foto';

  @override
  String get app_reorderList => 'Riordina Lista';

  @override
  String app_updateLabel(String label) {
    return 'Aggiorna $label';
  }

  @override
  String get app_noPhoto => 'Nessuna foto';

  @override
  String get app_selectedPhoto => 'Foto Selezionata';

  @override
  String get app_deletePhoto => 'Elimina Foto';

  @override
  String get app_getShareableUrl => 'Ottieni URL Condivisibile';

  @override
  String get app_generatedUrlLabel => 'URL Generato (scad. 7 giorni):';

  @override
  String get app_photoDeleted => 'Foto eliminata';

  @override
  String get app_urlGenerated => 'URL Generato';

  @override
  String app_errorDeletingPhoto(String error) {
    return 'Errore nell\'eliminazione della foto: $error';
  }

  @override
  String app_errorGettingUrl(String error) {
    return 'Errore nell\'ottenere l\'URL: $error';
  }

  @override
  String get app_appSpecificEvent => 'Evento specifico dell\'applicazione';

  @override
  String get app_updateTextTitle => 'Aggiorna Testo';

  @override
  String get app_textValueLabel => 'Valore del Testo';

  @override
  String get app_updateCheckboxTitle => 'Aggiorna Casella';

  @override
  String get app_checkboxValueLabel => 'Valore della Casella';

  @override
  String get app_updateCodeTitle => 'Aggiorna Codice';

  @override
  String get app_codeValueLabel => 'Valore del Codice';

  @override
  String get app_updateDropdownTitle => 'Aggiorna Menu a Tendina';

  @override
  String get app_dropdownValueLabel => 'Valore del Menu a Tendina';

  @override
  String get app_dropdownOption1 => 'Opzione 1';

  @override
  String get app_dropdownOption2 => 'Opzione 2';

  @override
  String get app_updateListTitle => 'Aggiorna Lista';

  @override
  String get app_reorderableListLabel => 'Lista Riordinabile';

  @override
  String get app_updatePhotoTitle => 'Aggiorna Foto';

  @override
  String get app_appEventsTitle => 'Eventi dell\'Applicazione';

  @override
  String get app_appStateTitle => 'Stato dell\'Applicazione';
}
