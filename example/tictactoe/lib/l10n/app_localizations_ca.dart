// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get app_unexpectedError =>
      'Error inesperat; comprova la connexió a Internet, torna enrere i prova-ho de nou';

  @override
  String get app_appTitle => 'Exemple de formulari de Hytta Hub';

  @override
  String get app_nightMode => 'Mode nocturn';

  @override
  String get app_themeSettingsAlwaysOff => 'Sempre desactivat';

  @override
  String get app_themeSettingsAlwaysOn => 'Sempre activat';

  @override
  String get app_themeSettingsAutomatic => 'Automàtic';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versió $appVersion-$appBuildNumber';
  }

  @override
  String get app_selectLanguage => 'Selecciona l\'idioma';

  @override
  String get app_english => 'Anglès';

  @override
  String get app_italian => 'Italià';

  @override
  String get app_spanish => 'Espanyol';

  @override
  String get app_norwegian => 'Noruec';

  @override
  String get app_dutch => 'Neerlandès';

  @override
  String get app_enterButton => 'Entra';

  @override
  String get app_serviceLoginButton => 'Inici de sessió del servei';

  @override
  String get app_permissionDenied => 'No tens permís per fer aquesta acció.';

  @override
  String get app_appEventsOption => 'Esdeveniments de l\'aplicació';

  @override
  String app_eventMove(int player, int x, int y) {
    return 'El jugador $player ha mogut a ($x, $y)';
  }

  @override
  String app_eventStartGame(String vsBot) {
    return 'Partida iniciada (contra el bot: $vsBot)';
  }

  @override
  String get app_eventPlayAgain => 'Torna a jugar';

  @override
  String get app_draw => 'Empat!';

  @override
  String app_playerWins(String name) {
    return 'Guanya $name!';
  }

  @override
  String get app_startMultiplayerGame => 'Inicia una partida multijugador';

  @override
  String get app_startBotGame => 'Inicia una partida contra el bot';

  @override
  String app_playerYou(String name) {
    return '$name (tu)';
  }

  @override
  String get app_botName => 'Bot';

  @override
  String app_unknownPlayer(int id) {
    return 'Desconegut ($id)';
  }

  @override
  String app_submissionErrorSnack(String errorCode) {
    return 'Error en l\'enviament: $errorCode';
  }

  @override
  String get app_appSpecificEvent => 'Esdeveniment específic de l\'aplicació';

  @override
  String get app_appEventsTitle => 'Esdeveniments de l\'aplicació';

  @override
  String get app_appStateTitle => 'Estat de l\'aplicació';

  @override
  String get app_platformLabel => 'Plataforma';
}
