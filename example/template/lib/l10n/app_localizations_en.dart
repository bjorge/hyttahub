// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String app_submissionError(Object error) {
    return 'Submission Error: $error';
  }

  @override
  String get app_unexpectedError =>
      'Unexpected error, check internet, go back and try again';

  @override
  String get app_appTitle => 'Hytta Hub Form Example';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Version $appVersion-$appBuildNumber';
  }

  @override
  String get app_enterButton => 'Enter';

  @override
  String get app_pickPhotosButton => 'Pick Photos';

  @override
  String get app_permissionDenied =>
      'You do not have permission to perform this action.';

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
  String get app_labelText => 'Text';

  @override
  String get app_labelCode => 'Code';

  @override
  String get app_labelCheckbox => 'Checkbox';

  @override
  String get app_labelDropdown => 'Dropdown';

  @override
  String get app_labelList => 'List';

  @override
  String get app_labelPhoto => 'Photo';

  @override
  String get app_reorderList => 'Reorder List';

  @override
  String app_updateLabel(String label) {
    return 'Update $label';
  }

  @override
  String get app_noPhoto => 'No photo';

  @override
  String get app_selectedPhoto => 'Selected Photo';

  @override
  String get app_deletePhoto => 'Delete Photo';

  @override
  String app_errorDeletingPhoto(String error) {
    return 'Error deleting photo: $error';
  }

  @override
  String get app_photoDeleted => 'Photo deleted';

  @override
  String get app_appSpecificEvent => 'App specific event';

  @override
  String get app_updateTextTitle => 'Update Text';

  @override
  String get app_textValueLabel => 'Text Value';

  @override
  String get app_updateCheckboxTitle => 'Update Checkbox';

  @override
  String get app_checkboxValueLabel => 'Checkbox Value';

  @override
  String get app_updateCodeTitle => 'Update Code';

  @override
  String get app_codeValueLabel => 'Code Value';

  @override
  String get app_updateDropdownTitle => 'Update Dropdown';

  @override
  String get app_dropdownValueLabel => 'Dropdown Value';

  @override
  String get app_dropdownOption1 => 'Option 1';

  @override
  String get app_dropdownOption2 => 'Option 2';

  @override
  String get app_updateListTitle => 'Update List';

  @override
  String get app_reorderableListLabel => 'Reorderable List';

  @override
  String get app_updatePhotoTitle => 'Update Photo';

  @override
  String get app_appEventsTitle => 'App Events';

  @override
  String get app_appStateTitle => 'App State';
}
