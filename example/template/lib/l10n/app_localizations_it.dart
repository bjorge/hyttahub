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
  String get app_pickPhotosButton => 'Scegli Foto';

  @override
  String get app_permissionDenied =>
      'Non hai il permesso di eseguire questa azione.';

  @override
  String get app_appEventsOption => 'Eventi dell\'Applicazione';

  @override
  String get app_editModeTitle => 'Modalità di Modifica';

  @override
  String get app_adminPrivileges =>
      'Hai privilegi di amministratore per questo hub.';

  @override
  String get app_howToProceed => 'Come vuoi procedere?';

  @override
  String get app_viewSite => 'Visualizza';

  @override
  String get app_editSite => 'Modifica';

  @override
  String app_eventUpdateText(String value) {
    return 'Testo Aggiornato: $value';
  }

  @override
  String get app_eventUpdateCode => 'Codice Aggiornato';

  @override
  String app_eventUpdateCheckbox(String value) {
    return 'Casella Aggiornata: $value';
  }

  @override
  String app_eventUpdateDropdown(String value) {
    return 'Menu a Tendina Aggiornato: $value';
  }

  @override
  String get app_eventUpdateList => 'Lista Aggiornata';

  @override
  String app_eventUpdatePhoto(String name) {
    return 'Foto Aggiornata: $name';
  }

  @override
  String get app_eventRemovePhoto => 'Foto Rimossa';

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
  String get app_deletePhotoTitle => 'Elimina Foto';

  @override
  String get app_deletePhotoConfirmation => 'Conferma eliminazione della foto';

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
