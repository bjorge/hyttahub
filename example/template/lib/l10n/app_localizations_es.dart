// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String app_submissionError(Object error) {
    return 'Error de Envío: $error';
  }

  @override
  String get app_unexpectedError =>
      'Error inesperado, comprueba tu conexión a internet, vuelve atrás e inténtalo de nuevo';

  @override
  String get app_appTitle => 'Hytta Hub Ejemplo de Formulario';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versión $appVersion-$appBuildNumber';
  }

  @override
  String get app_enterButton => 'Entrar';

  @override
  String get app_pickPhotosButton => 'Pick Photos';

  @override
  String get app_permissionDenied =>
      'No tienes permiso para realizar esta acción.';

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
