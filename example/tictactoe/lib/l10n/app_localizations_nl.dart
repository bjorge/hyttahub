// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String app_uploadingPhotosProgress(Object count, Object total) {
    return 'Bestanden uploaden: $count van $total...';
  }

  @override
  String app_submissionError(Object error) {
    return 'Fout bij indienen: $error';
  }

  @override
  String app_photoSizeInKB(String size) {
    return '$size KB';
  }

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
  String get app_updateTextButton => 'Tekst bijwerken';

  @override
  String app_textValueDisplay(String value) {
    return 'Tekstwaarde: $value';
  }

  @override
  String get app_updateTextValueTitle => 'Tekstwaarde bijwerken';

  @override
  String get app_textValueLabel => 'Tekstwaarde';

  @override
  String get app_pickPhotosButton => 'Pick Photos';

  @override
  String get app_permissionDenied =>
      'U heeft geen toestemming om deze actie uit te voeren.';

  @override
  String get app_appEventsOption => 'App Events';

  @override
  String get app_editModeTitle => 'Edit Mode';

  @override
  String get app_adminPrivileges => 'You have admin privileges for this site.';

  @override
  String get app_howToProceed => 'How would you like to proceed?';

  @override
  String get app_viewSite => 'View Site';

  @override
  String get app_editSite => 'Edit Site';

  @override
  String get app_errorTitle => 'Error';

  @override
  String get app_accessDeniedTitle => 'Access Denied';

  @override
  String get app_accessDeniedMessage =>
      'You do not have permission to access this site';

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
