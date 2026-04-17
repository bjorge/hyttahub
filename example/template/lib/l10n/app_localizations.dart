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

  /// No description provided for @app_submissionError.
  ///
  /// In en, this message translates to:
  /// **'Submission Error: {error}'**
  String app_submissionError(Object error);

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

  /// No description provided for @app_versionInfo.
  ///
  /// In en, this message translates to:
  /// **'Version {appVersion}-{appBuildNumber}'**
  String app_versionInfo(String appVersion, int appBuildNumber);

  /// No description provided for @app_enterButton.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get app_enterButton;

  /// No description provided for @app_pickPhotosButton.
  ///
  /// In en, this message translates to:
  /// **'Pick Photos'**
  String get app_pickPhotosButton;

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

  /// No description provided for @app_editModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Mode'**
  String get app_editModeTitle;

  /// No description provided for @app_adminPrivileges.
  ///
  /// In en, this message translates to:
  /// **'You have admin privileges for this hub.'**
  String get app_adminPrivileges;

  /// No description provided for @app_howToProceed.
  ///
  /// In en, this message translates to:
  /// **'How would you like to proceed?'**
  String get app_howToProceed;

  /// No description provided for @app_viewSite.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get app_viewSite;

  /// No description provided for @app_editSite.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get app_editSite;

  /// No description provided for @app_eventUpdateText.
  ///
  /// In en, this message translates to:
  /// **'Updated Text: {value}'**
  String app_eventUpdateText(String value);

  /// No description provided for @app_eventUpdateCode.
  ///
  /// In en, this message translates to:
  /// **'Updated Code'**
  String get app_eventUpdateCode;

  /// No description provided for @app_eventUpdateCheckbox.
  ///
  /// In en, this message translates to:
  /// **'Updated Checkbox: {value}'**
  String app_eventUpdateCheckbox(String value);

  /// No description provided for @app_eventUpdateDropdown.
  ///
  /// In en, this message translates to:
  /// **'Updated Dropdown: {value}'**
  String app_eventUpdateDropdown(String value);

  /// No description provided for @app_eventUpdateList.
  ///
  /// In en, this message translates to:
  /// **'Updated List'**
  String get app_eventUpdateList;

  /// No description provided for @app_eventUpdatePhoto.
  ///
  /// In en, this message translates to:
  /// **'Updated Photo: {name}'**
  String app_eventUpdatePhoto(String name);

  /// No description provided for @app_eventRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'Removed Photo'**
  String get app_eventRemovePhoto;

  /// No description provided for @app_labelText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get app_labelText;

  /// No description provided for @app_labelCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get app_labelCode;

  /// No description provided for @app_labelCheckbox.
  ///
  /// In en, this message translates to:
  /// **'Checkbox'**
  String get app_labelCheckbox;

  /// No description provided for @app_labelDropdown.
  ///
  /// In en, this message translates to:
  /// **'Dropdown'**
  String get app_labelDropdown;

  /// No description provided for @app_labelList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get app_labelList;

  /// No description provided for @app_labelPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get app_labelPhoto;

  /// No description provided for @app_reorderList.
  ///
  /// In en, this message translates to:
  /// **'Reorder List'**
  String get app_reorderList;

  /// No description provided for @app_updateLabel.
  ///
  /// In en, this message translates to:
  /// **'Update {label}'**
  String app_updateLabel(String label);

  /// No description provided for @app_noPhoto.
  ///
  /// In en, this message translates to:
  /// **'No photo'**
  String get app_noPhoto;

  /// No description provided for @app_selectedPhoto.
  ///
  /// In en, this message translates to:
  /// **'Selected Photo'**
  String get app_selectedPhoto;

  /// No description provided for @app_deletePhoto.
  ///
  /// In en, this message translates to:
  /// **'Delete Photo'**
  String get app_deletePhoto;

  /// No description provided for @app_deletePhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Photo'**
  String get app_deletePhotoTitle;

  /// No description provided for @app_deletePhotoConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion of photo'**
  String get app_deletePhotoConfirmation;

  /// No description provided for @app_appSpecificEvent.
  ///
  /// In en, this message translates to:
  /// **'App specific event'**
  String get app_appSpecificEvent;

  /// No description provided for @app_updateTextTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Text'**
  String get app_updateTextTitle;

  /// No description provided for @app_textValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Text Value'**
  String get app_textValueLabel;

  /// No description provided for @app_updateCheckboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Checkbox'**
  String get app_updateCheckboxTitle;

  /// No description provided for @app_checkboxValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Checkbox Value'**
  String get app_checkboxValueLabel;

  /// No description provided for @app_updateCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Code'**
  String get app_updateCodeTitle;

  /// No description provided for @app_codeValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Code Value'**
  String get app_codeValueLabel;

  /// No description provided for @app_updateDropdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Dropdown'**
  String get app_updateDropdownTitle;

  /// No description provided for @app_dropdownValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Dropdown Value'**
  String get app_dropdownValueLabel;

  /// No description provided for @app_dropdownOption1.
  ///
  /// In en, this message translates to:
  /// **'Option 1'**
  String get app_dropdownOption1;

  /// No description provided for @app_dropdownOption2.
  ///
  /// In en, this message translates to:
  /// **'Option 2'**
  String get app_dropdownOption2;

  /// No description provided for @app_updateListTitle.
  ///
  /// In en, this message translates to:
  /// **'Update List'**
  String get app_updateListTitle;

  /// No description provided for @app_reorderableListLabel.
  ///
  /// In en, this message translates to:
  /// **'Reorderable List'**
  String get app_reorderableListLabel;

  /// No description provided for @app_updatePhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Photo'**
  String get app_updatePhotoTitle;

  /// No description provided for @app_appEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'App Events'**
  String get app_appEventsTitle;

  /// No description provided for @app_appStateTitle.
  ///
  /// In en, this message translates to:
  /// **'App State'**
  String get app_appStateTitle;
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
