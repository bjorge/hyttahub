// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String app_uploadingPhotosProgress(Object count, Object total) {
    return 'Uploading $count of $total files...';
  }

  @override
  String app_submissionError(Object error) {
    return 'Submission Error: $error';
  }

  @override
  String app_photoSizeInKB(String size) {
    return '$size KB';
  }

  @override
  String get app_unexpectedError =>
      'Unexpected error, check internet, go back and try again';

  @override
  String get app_appTitle => 'Hytta Hub Form Example';

  @override
  String get app_nightMode => 'Night Mode';

  @override
  String get app_themeSettingsAlwaysOff => 'Always Off';

  @override
  String get app_themeSettingsAlwaysOn => 'Always On';

  @override
  String get app_themeSettingsAutomatic => 'Automatic';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Version $appVersion-$appBuildNumber';
  }

  @override
  String get app_selectLanguage => 'Select Language';

  @override
  String get app_english => 'English';

  @override
  String get app_italian => 'Italian';

  @override
  String get app_spanish => 'Spanish';

  @override
  String get app_norwegian => 'Norwegian';

  @override
  String get app_dutch => 'Dutch';

  @override
  String get app_enterButton => 'Enter';

  @override
  String get app_serviceLoginButton => 'Service Login';

  @override
  String get app_updateTextButton => 'Update Text';

  @override
  String app_textValueDisplay(String value) {
    return 'Text Value: $value';
  }

  @override
  String get app_updateTextValueTitle => 'Update Text Value';

  @override
  String get app_textValueLabel => 'Text Value';

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
  String get app_errorTitle => 'Error';

  @override
  String get app_accessDeniedTitle => 'Access Denied';

  @override
  String get app_accessDeniedMessage =>
      'You do not have permission to access this site';
}
