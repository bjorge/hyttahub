// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String app_uploadingPhotosProgress(Object count, Object total) {
    return 'Caricamento di $count di $total file...';
  }

  @override
  String app_submissionError(Object error) {
    return 'Errore di invio: $error';
  }

  @override
  String app_photoSizeInKB(String size) {
    return '$size KB';
  }

  @override
  String get app_unexpectedError =>
      'Errore imprevisto, controlla la connessione internet, torna indietro e riprova';

  @override
  String get app_appTitle => 'Hytta Hub Esempio di Modulo';

  @override
  String get app_nightMode => 'Modalità Notte';

  @override
  String get app_themeSettingsAlwaysOff => 'Sempre Spento';

  @override
  String get app_themeSettingsAlwaysOn => 'Sempre Acceso';

  @override
  String get app_themeSettingsAutomatic => 'Automatico';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versione $appVersion-$appBuildNumber';
  }

  @override
  String get app_selectLanguage => 'Seleziona Lingua';

  @override
  String get app_english => 'Inglese';

  @override
  String get app_italian => 'Italiano';

  @override
  String get app_spanish => 'Spagnolo';

  @override
  String get app_norwegian => 'Norvegese';

  @override
  String get app_dutch => 'Olandese';

  @override
  String get app_enterButton => 'Invio';

  @override
  String get app_serviceLoginButton => 'Accesso Servizio';

  @override
  String get app_updateTextButton => 'Aggiorna Testo';

  @override
  String app_textValueDisplay(String value) {
    return 'Valore del Testo: $value';
  }

  @override
  String get app_updateTextValueTitle => 'Aggiorna Valore del Testo';

  @override
  String get app_textValueLabel => 'Valore del Testo';

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
  String get app_errorTitle => 'Error';

  @override
  String get app_accessDeniedTitle => 'Access Denied';

  @override
  String get app_accessDeniedMessage =>
      'You do not have permission to access this site';

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
