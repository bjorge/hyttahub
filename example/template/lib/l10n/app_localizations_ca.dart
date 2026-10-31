// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String app_submissionError(Object error) {
    return 'Error en l\'enviament: $error';
  }

  @override
  String get app_unexpectedError =>
      'Error inesperat; comprova la connexió a Internet, torna enrere i prova-ho de nou';

  @override
  String get app_appTitle => 'Exemple de formulari de Hytta Hub';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versió $appVersion-$appBuildNumber';
  }

  @override
  String get app_enterButton => 'Entra';

  @override
  String get app_pickPhotosButton => 'Tria fotos';

  @override
  String get app_permissionDenied => 'No tens permís per fer aquesta acció.';

  @override
  String get app_appEventsOption => 'Esdeveniments de l\'aplicació';

  @override
  String get app_editModeTitle => 'Mode d\'edició';

  @override
  String get app_adminPrivileges =>
      'Tens privilegis d\'administrador en aquest hub.';

  @override
  String get app_howToProceed => 'Com vols continuar?';

  @override
  String get app_viewSite => 'Mostra';

  @override
  String get app_editSite => 'Edita';

  @override
  String app_eventUpdateText(String value) {
    return 'Text actualitzat: $value';
  }

  @override
  String get app_eventUpdateCode => 'Codi actualitzat';

  @override
  String app_eventUpdateCheckbox(String value) {
    return 'Casella actualitzada: $value';
  }

  @override
  String app_eventUpdateDropdown(String value) {
    return 'Desplegable actualitzat: $value';
  }

  @override
  String get app_eventUpdateList => 'Llista actualitzada';

  @override
  String app_eventUpdatePhoto(String name) {
    return 'Foto actualitzada: $name';
  }

  @override
  String get app_eventRemovePhoto => 'Foto eliminada';

  @override
  String get app_labelText => 'Text';

  @override
  String get app_labelCode => 'Codi';

  @override
  String get app_labelCheckbox => 'Casella';

  @override
  String get app_labelDropdown => 'Desplegable';

  @override
  String get app_labelList => 'Llista';

  @override
  String get app_labelPhoto => 'Foto';

  @override
  String get app_reorderList => 'Reordena la llista';

  @override
  String app_updateLabel(String label) {
    return 'Actualitza $label';
  }

  @override
  String get app_noPhoto => 'Cap foto';

  @override
  String get app_selectedPhoto => 'Foto seleccionada';

  @override
  String get app_deletePhoto => 'Suprimeix la foto';

  @override
  String get app_deletePhotoTitle => 'Suprimeix la foto';

  @override
  String get app_deletePhotoConfirmation => 'Confirma la supressió de la foto';

  @override
  String get app_appSpecificEvent => 'Esdeveniment específic de l\'aplicació';

  @override
  String get app_updateTextTitle => 'Actualitza el text';

  @override
  String get app_textValueLabel => 'Valor del text';

  @override
  String get app_updateCheckboxTitle => 'Actualitza la casella';

  @override
  String get app_checkboxValueLabel => 'Valor de la casella';

  @override
  String get app_updateCodeTitle => 'Actualitza el codi';

  @override
  String get app_codeValueLabel => 'Valor del codi';

  @override
  String get app_updateDropdownTitle => 'Actualitza el desplegable';

  @override
  String get app_dropdownValueLabel => 'Valor del desplegable';

  @override
  String get app_dropdownOption1 => 'Opció 1';

  @override
  String get app_dropdownOption2 => 'Opció 2';

  @override
  String get app_updateListTitle => 'Actualitza la llista';

  @override
  String get app_reorderableListLabel => 'Llista reordenable';

  @override
  String get app_updatePhotoTitle => 'Actualitza la foto';

  @override
  String get app_appEventsTitle => 'Esdeveniments de l\'aplicació';

  @override
  String get app_appStateTitle => 'Estat de l\'aplicació';
}
