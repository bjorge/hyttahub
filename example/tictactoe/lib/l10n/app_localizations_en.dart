// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
  String get app_permissionDenied =>
      'You do not have permission to perform this action.';

  @override
  String get app_appEventsOption => 'App Events';

  @override
  String app_eventMove(int player, int x, int y) {
    return 'Player $player moved to ($x, $y)';
  }

  @override
  String app_eventStartGame(String vsBot) {
    return 'Started Game (vs Bot: $vsBot)';
  }

  @override
  String get app_eventPlayAgain => 'Play Again';

  @override
  String get app_draw => 'Draw!';

  @override
  String app_playerWins(String name) {
    return '$name Wins!';
  }

  @override
  String get app_startMultiplayerGame => 'Start Multiplayer Game';

  @override
  String get app_startBotGame => 'Start Bot Game';

  @override
  String app_playerYou(String name) {
    return '$name (You)';
  }

  @override
  String get app_botName => 'Bot';

  @override
  String app_unknownPlayer(int id) {
    return 'Unknown ($id)';
  }

  @override
  String app_submissionErrorSnack(String errorCode) {
    return 'Submission Error: $errorCode';
  }

  @override
  String get app_appSpecificEvent => 'App specific event';

  @override
  String get app_appEventsTitle => 'App Events';

  @override
  String get app_appStateTitle => 'App State';

  @override
  String get app_platformLabel => 'Platform';
}
