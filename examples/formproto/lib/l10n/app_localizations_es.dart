// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_appTitle => 'Hytta Hub Formulario Proto';

  @override
  String get app_nightMode => 'Modo nocturno';

  @override
  String get app_themeSettingsAlwaysOff => 'Siempre apagado';

  @override
  String get app_themeSettingsAlwaysOn => 'Siempre encendido';

  @override
  String get app_themeSettingsAutomatic => 'Automático';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versión $appVersion-$appBuildNumber';
  }

  @override
  String get app_selectLanguage => 'Seleccionar idioma';

  @override
  String get app_english => 'Inglés';

  @override
  String get app_italian => 'Italiano';

  @override
  String get app_spanish => 'Español';

  @override
  String get app_enterButton => 'Entrar';

  @override
  String get app_otherAppsTitle => 'Otras aplicaciones de Hytta Hub';

  @override
  String get app_reservationsAppButton => 'Reservas de Hytta Hub';

  @override
  String get app_serviceLoginButton => 'Inicio de sesión de servicio';
}
