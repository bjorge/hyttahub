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
}
