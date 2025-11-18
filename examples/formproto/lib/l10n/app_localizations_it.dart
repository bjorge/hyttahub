// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get app_appTitle => 'Hytta Hub Modulo Proto';

  @override
  String get app_nightMode => 'Modalità notturna';

  @override
  String get app_themeSettingsAlwaysOff => 'Sempre spento';

  @override
  String get app_themeSettingsAlwaysOn => 'Sempre acceso';

  @override
  String get app_themeSettingsAutomatic => 'Automatico';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versione $appVersion-$appBuildNumber';
  }

  @override
  String get app_selectLanguage => 'Seleziona la lingua';

  @override
  String get app_english => 'Inglese';

  @override
  String get app_italian => 'Italiano';

  @override
  String get app_spanish => 'Spagnolo';

  @override
  String get app_enterButton => 'Entra';

  @override
  String get app_otherAppsTitle => 'Altre applicazioni Hytta Hub';

  @override
  String get app_reservationsAppButton => 'Hytta Hub Prenotazioni';

  @override
  String get app_serviceLoginButton => 'Accesso al servizio';
}
