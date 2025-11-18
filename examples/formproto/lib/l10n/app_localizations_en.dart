// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_appTitle => 'Hytta Hub Form Proto';

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
  String get app_enterButton => 'Enter';

  @override
  String get app_otherAppsTitle => 'Other Hytta Hub Applications';

  @override
  String get app_reservationsAppButton => 'Hytta Hub Reservations';

  @override
  String get app_serviceLoginButton => 'Service Login';
}
