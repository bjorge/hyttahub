// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String app_uploadingPhotosProgress(Object count, Object total) {
    return 'Laster opp $count av $total filer...';
  }

  @override
  String app_submissionError(Object error) {
    return 'Innsendingsfeil: $error';
  }

  @override
  String app_photoSizeInKB(String size) {
    return '$size KB';
  }

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
  String get app_updateTextButton => 'Oppdater tekst';

  @override
  String app_textValueDisplay(String value) {
    return 'Tekstverdi: $value';
  }

  @override
  String get app_updateTextValueTitle => 'Oppdater tekstverdi';

  @override
  String get app_textValueLabel => 'Tekstverdi';

  @override
  String get app_pickPhotosButton => 'Pick Photos';

  @override
  String get app_permissionDenied =>
      'Du har ikke tillatelse til å utføre denne handlingen.';

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
}
