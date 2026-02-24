import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('it'),
    Locale('nb'),
    Locale('nl'),
  ];

  /// No description provided for @app_unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error, check internet, go back and try again'**
  String get app_unexpectedError;

  /// No description provided for @app_appTitle.
  ///
  /// In en, this message translates to:
  /// **'Hytta Hub Form Example'**
  String get app_appTitle;

  /// No description provided for @app_nightMode.
  ///
  /// In en, this message translates to:
  /// **'Night Mode'**
  String get app_nightMode;

  /// No description provided for @app_themeSettingsAlwaysOff.
  ///
  /// In en, this message translates to:
  /// **'Always Off'**
  String get app_themeSettingsAlwaysOff;

  /// No description provided for @app_themeSettingsAlwaysOn.
  ///
  /// In en, this message translates to:
  /// **'Always On'**
  String get app_themeSettingsAlwaysOn;

  /// No description provided for @app_themeSettingsAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get app_themeSettingsAutomatic;

  /// No description provided for @app_versionInfo.
  ///
  /// In en, this message translates to:
  /// **'Version {appVersion}-{appBuildNumber}'**
  String app_versionInfo(String appVersion, int appBuildNumber);

  /// No description provided for @app_selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get app_selectLanguage;

  /// No description provided for @app_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get app_english;

  /// No description provided for @app_italian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get app_italian;

  /// No description provided for @app_spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get app_spanish;

  /// No description provided for @app_norwegian.
  ///
  /// In en, this message translates to:
  /// **'Norwegian'**
  String get app_norwegian;

  /// No description provided for @app_dutch.
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get app_dutch;

  /// No description provided for @app_enterButton.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get app_enterButton;

  /// No description provided for @app_serviceLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Service Login'**
  String get app_serviceLoginButton;

  /// No description provided for @app_permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action.'**
  String get app_permissionDenied;

  /// No description provided for @app_appEventsOption.
  ///
  /// In en, this message translates to:
  /// **'App Events'**
  String get app_appEventsOption;

  /// No description provided for @app_eventMove.
  ///
  /// In en, this message translates to:
  /// **'Player {player} moved to ({x}, {y})'**
  String app_eventMove(int player, int x, int y);

  /// No description provided for @app_eventStartGame.
  ///
  /// In en, this message translates to:
  /// **'Started Game (vs Bot: {vsBot})'**
  String app_eventStartGame(String vsBot);

  /// No description provided for @app_eventPlayAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get app_eventPlayAgain;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'it', 'nb', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'it':
      return AppLocalizationsIt();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
