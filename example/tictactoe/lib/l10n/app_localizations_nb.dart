// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get app_unexpectedError =>
      'Uventet feil, sjekk internett, gå tilbake og prøv igjen';

  @override
  String get app_appTitle => 'Hytta Hub Skjemaeksempel';

  @override
  String get app_nightMode => 'Nattmodus';

  @override
  String get app_themeSettingsAlwaysOff => 'Alltid av';

  @override
  String get app_themeSettingsAlwaysOn => 'Alltid på';

  @override
  String get app_themeSettingsAutomatic => 'Automatisk';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versjon $appVersion-$appBuildNumber';
  }

  @override
  String get app_selectLanguage => 'Velg språk';

  @override
  String get app_english => 'Engelsk';

  @override
  String get app_italian => 'Italiensk';

  @override
  String get app_spanish => 'Spansk';

  @override
  String get app_norwegian => 'Norsk';

  @override
  String get app_dutch => 'Nederlandsk';

  @override
  String get app_enterButton => 'Enter';

  @override
  String get app_serviceLoginButton => 'Tjenestepålogging';

  @override
  String get app_permissionDenied =>
      'Du har ikke tillatelse til å utføre denne handlingen.';

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
