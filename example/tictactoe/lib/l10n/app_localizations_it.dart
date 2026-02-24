// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get app_unexpectedError =>
      'Errore imprevisto, controlla la connessione internet, torna indietro e riprova';

  @override
  String get app_appTitle => 'Hytta Hub Esempio di Modulo';

  @override
  String get app_nightMode => 'Modalità Notte';

  @override
  String get app_themeSettingsAlwaysOff => 'Sempre Spento';

  @override
  String get app_themeSettingsAlwaysOn => 'Sempre Acceso';

  @override
  String get app_themeSettingsAutomatic => 'Automatico';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versione $appVersion-$appBuildNumber';
  }

  @override
  String get app_selectLanguage => 'Seleziona Lingua';

  @override
  String get app_english => 'Inglese';

  @override
  String get app_italian => 'Italiano';

  @override
  String get app_spanish => 'Spagnolo';

  @override
  String get app_norwegian => 'Norvegese';

  @override
  String get app_dutch => 'Olandese';

  @override
  String get app_enterButton => 'Invio';

  @override
  String get app_serviceLoginButton => 'Accesso Servizio';

  @override
  String get app_permissionDenied =>
      'Non hai il permesso di eseguire questa azione.';

  @override
  String get app_appEventsOption => 'Eventi dell\'App';

  @override
  String app_eventMove(int player, int x, int y) {
    return 'Giocatore $player ha mosso in ($x, $y)';
  }

  @override
  String app_eventStartGame(String vsBot) {
    return 'Partita Iniziata (vs Bot: $vsBot)';
  }

  @override
  String get app_eventPlayAgain => 'Gioca Ancora';
}
