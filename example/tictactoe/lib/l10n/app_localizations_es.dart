// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_unexpectedError =>
      'Error inesperado, comprueba tu conexión a internet, vuelve atrás e inténtalo de nuevo';

  @override
  String get app_appTitle => 'Hytta Hub Ejemplo de Formulario';

  @override
  String get app_nightMode => 'Modo Nocturno';

  @override
  String get app_themeSettingsAlwaysOff => 'Siempre Apagado';

  @override
  String get app_themeSettingsAlwaysOn => 'Siempre Encendido';

  @override
  String get app_themeSettingsAutomatic => 'Automático';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versión $appVersion-$appBuildNumber';
  }

  @override
  String get app_selectLanguage => 'Seleccionar Idioma';

  @override
  String get app_english => 'Inglés';

  @override
  String get app_italian => 'Italiano';

  @override
  String get app_spanish => 'Español';

  @override
  String get app_norwegian => 'Noruego';

  @override
  String get app_dutch => 'Neerlandés';

  @override
  String get app_enterButton => 'Entrar';

  @override
  String get app_serviceLoginButton => 'Inicio de Sesión de Servicio';

  @override
  String get app_permissionDenied =>
      'No tienes permiso para realizar esta acción.';

  @override
  String get app_appEventsOption => 'Eventos de la App';

  @override
  String app_eventMove(int player, int x, int y) {
    return 'Jugador $player movió a ($x, $y)';
  }

  @override
  String app_eventStartGame(String vsBot) {
    return 'Juego Iniciado (vs Bot: $vsBot)';
  }

  @override
  String get app_eventPlayAgain => 'Jugar de Nuevo';
}
