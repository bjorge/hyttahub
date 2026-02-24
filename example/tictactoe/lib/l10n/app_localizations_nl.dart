// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get app_unexpectedError =>
      'Onverwachte fout, controleer uw internetverbinding en probeer het opnieuw';

  @override
  String get app_appTitle => 'Hytta Hub Formuliervoorbeeld';

  @override
  String get app_nightMode => 'Nachtmodus';

  @override
  String get app_themeSettingsAlwaysOff => 'Altijd uit';

  @override
  String get app_themeSettingsAlwaysOn => 'Altijd aan';

  @override
  String get app_themeSettingsAutomatic => 'Automatisch';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versie $appVersion-$appBuildNumber';
  }

  @override
  String get app_selectLanguage => 'Selecteer taal';

  @override
  String get app_english => 'Engels';

  @override
  String get app_italian => 'Italiaans';

  @override
  String get app_spanish => 'Spaans';

  @override
  String get app_norwegian => 'Noors';

  @override
  String get app_dutch => 'Nederlands';

  @override
  String get app_enterButton => 'Enter';

  @override
  String get app_serviceLoginButton => 'Service Aanmelden';

  @override
  String get app_permissionDenied =>
      'U heeft geen toestemming om deze actie uit te voeren.';

  @override
  String get app_appEventsOption => 'App Gebeurtenissen';

  @override
  String app_eventMove(int player, int x, int y) {
    return 'Speler $player zette op ($x, $y)';
  }

  @override
  String app_eventStartGame(String vsBot) {
    return 'Spel Gestart (tegen Bot: $vsBot)';
  }

  @override
  String get app_eventPlayAgain => 'Opnieuw Spelen';

  @override
  String get app_draw => 'Gelijkspel!';

  @override
  String app_playerWins(String name) {
    return '$name Wint!';
  }

  @override
  String get app_startMultiplayerGame => 'Start Multiplayer Spel';

  @override
  String get app_startBotGame => 'Start Bot Spel';

  @override
  String app_playerYou(String name) {
    return '$name (Jij)';
  }

  @override
  String get app_botName => 'Bot';

  @override
  String app_unknownPlayer(int id) {
    return 'Onbekend ($id)';
  }

  @override
  String app_submissionErrorSnack(String errorCode) {
    return 'Fout bij Indienen: $errorCode';
  }

  @override
  String get app_appSpecificEvent => 'App-specifiek evenement';

  @override
  String get app_appEventsTitle => 'App Gebeurtenissen';

  @override
  String get app_appStateTitle => 'App Status';

  @override
  String get app_platformLabel => 'Platform';
}
