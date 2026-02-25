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

  @override
  String get app_labelText => 'Texto';

  @override
  String get app_labelCode => 'Código';

  @override
  String get app_labelCheckbox => 'Casilla';

  @override
  String get app_labelDropdown => 'Desplegable';

  @override
  String get app_labelList => 'Lista';

  @override
  String get app_labelPhoto => 'Foto';

  @override
  String get app_reorderList => 'Reordenar Lista';

  @override
  String app_updateLabel(String label) {
    return 'Actualizar $label';
  }

  @override
  String get app_noPhoto => 'Sin foto';

  @override
  String get app_selectedPhoto => 'Foto Seleccionada';

  @override
  String get app_deletePhoto => 'Eliminar Foto';

  @override
  String get app_getShareableUrl => 'Obtener URL Compartible';

  @override
  String get app_generatedUrlLabel => 'URL Generada (exp. 7 días):';

  @override
  String get app_photoDeleted => 'Foto eliminada';

  @override
  String get app_urlGenerated => 'URL Generada';

  @override
  String app_errorDeletingPhoto(String error) {
    return 'Error al eliminar foto: $error';
  }

  @override
  String app_errorGettingUrl(String error) {
    return 'Error al obtener URL: $error';
  }

  @override
  String get app_appSpecificEvent => 'Evento específico de la aplicación';

  @override
  String get app_updateTextTitle => 'Actualizar Texto';

  @override
  String get app_textValueLabel => 'Valor del Texto';

  @override
  String get app_updateCheckboxTitle => 'Actualizar Casilla';

  @override
  String get app_checkboxValueLabel => 'Valor de la Casilla';

  @override
  String get app_updateCodeTitle => 'Actualizar Código';

  @override
  String get app_codeValueLabel => 'Valor del Código';

  @override
  String get app_updateDropdownTitle => 'Actualizar Desplegable';

  @override
  String get app_dropdownValueLabel => 'Valor del Desplegable';

  @override
  String get app_dropdownOption1 => 'Opción 1';

  @override
  String get app_dropdownOption2 => 'Opción 2';

  @override
  String get app_updateListTitle => 'Actualizar Lista';

  @override
  String get app_reorderableListLabel => 'Lista Reordenable';

  @override
  String get app_updatePhotoTitle => 'Actualizar Foto';

  @override
  String get app_appEventsTitle => 'Eventos de la Aplicación';

  @override
  String get app_appStateTitle => 'Estado de la Aplicación';
}
