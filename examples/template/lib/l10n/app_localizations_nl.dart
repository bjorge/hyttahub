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
}
