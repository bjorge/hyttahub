import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

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
    Locale('it'),
  ];

  /// No description provided for @app_createAlbumTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Album'**
  String get app_createAlbumTitle;

  /// No description provided for @app_albumNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Album Name'**
  String get app_albumNameLabel;

  /// No description provided for @app_addPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get app_addPhotosTitle;

  /// No description provided for @app_uploadingPhotosProgress.
  ///
  /// In en, this message translates to:
  /// **'Uploading {count} of {total} files...'**
  String app_uploadingPhotosProgress(Object count, Object total);

  /// No description provided for @app_submissionError.
  ///
  /// In en, this message translates to:
  /// **'Submission Error: {error}'**
  String app_submissionError(Object error);

  /// No description provided for @app_pickPhotosButton.
  ///
  /// In en, this message translates to:
  /// **'Pick Photos'**
  String get app_pickPhotosButton;

  /// No description provided for @app_selectPhotosToUpload.
  ///
  /// In en, this message translates to:
  /// **'Select photos to upload:'**
  String get app_selectPhotosToUpload;

  /// No description provided for @app_hideCaptionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Hide Caption'**
  String get app_hideCaptionTooltip;

  /// No description provided for @app_showCaptionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show Caption'**
  String get app_showCaptionTooltip;

  /// No description provided for @app_noPhotos.
  ///
  /// In en, this message translates to:
  /// **'no photos'**
  String get app_noPhotos;

  /// No description provided for @app_noAlbums.
  ///
  /// In en, this message translates to:
  /// **'no albums'**
  String get app_noAlbums;

  /// No description provided for @app_updateCaption.
  ///
  /// In en, this message translates to:
  /// **'Update Caption'**
  String get app_updateCaption;

  /// No description provided for @app_reorderAlbumsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reorder Albums'**
  String get app_reorderAlbumsTitle;

  /// No description provided for @app_renameAlbumTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename Album'**
  String get app_renameAlbumTitle;

  /// No description provided for @app_reorderPhotos.
  ///
  /// In en, this message translates to:
  /// **'Reorder Photos'**
  String get app_reorderPhotos;

  /// No description provided for @app_photoInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo Info'**
  String get app_photoInfoTitle;

  /// No description provided for @app_photoNotFound.
  ///
  /// In en, this message translates to:
  /// **'Photo not found.'**
  String get app_photoNotFound;

  /// No description provided for @app_albumLabel.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get app_albumLabel;

  /// No description provided for @app_notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get app_notAvailable;

  /// No description provided for @app_originalNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Original Name'**
  String get app_originalNameLabel;

  /// No description provided for @app_sizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get app_sizeLabel;

  /// No description provided for @app_siteSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Site Settings'**
  String get app_siteSettingsTitle;

  /// No description provided for @app_addAlbumTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Album'**
  String get app_addAlbumTitle;

  /// No description provided for @app_newAlbumNameLabel.
  ///
  /// In en, this message translates to:
  /// **'New Album Name'**
  String get app_newAlbumNameLabel;

  /// No description provided for @app_addPhotoCaptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Photo Caption'**
  String get app_addPhotoCaptionTitle;

  /// No description provided for @app_photoCaptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Photo Caption'**
  String get app_photoCaptionLabel;

  /// No description provided for @app_deletePhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Photo'**
  String get app_deletePhotoTitle;

  /// No description provided for @app_deletePhotoConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete Photo? This action cannot be undone.'**
  String get app_deletePhotoConfirmation;

  /// No description provided for @app_deleteAlbumTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Album'**
  String get app_deleteAlbumTitle;

  /// No description provided for @app_deleteAlbumConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete Album? This action cannot be undone and will delete all members and photos in the album.'**
  String get app_deleteAlbumConfirmation;

  /// No description provided for @app_albumNotFound.
  ///
  /// In en, this message translates to:
  /// **'Album not found'**
  String get app_albumNotFound;

  /// No description provided for @app_albumNameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Album name cannot be empty.'**
  String get app_albumNameEmptyError;

  /// No description provided for @app_photoSizeInKB.
  ///
  /// In en, this message translates to:
  /// **'{size} KB'**
  String app_photoSizeInKB(String size);

  /// No description provided for @app_unknownAlbum.
  ///
  /// In en, this message translates to:
  /// **'Unknown Album'**
  String get app_unknownAlbum;

  /// No description provided for @app_eventsTitle.
  ///
  /// In en, this message translates to:
  /// **'App Events'**
  String get app_eventsTitle;

  /// No description provided for @app_stateTitle.
  ///
  /// In en, this message translates to:
  /// **'App State'**
  String get app_stateTitle;

  /// No description provided for @app_showAppEventsState.
  ///
  /// In en, this message translates to:
  /// **'Show App Events & State'**
  String get app_showAppEventsState;

  /// No description provided for @app_errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get app_errorTitle;

  /// No description provided for @app_unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error, check internet, go back and try again'**
  String get app_unexpectedError;

  /// No description provided for @app_accessDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get app_accessDeniedTitle;

  /// No description provided for @app_sitePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to view this site. Contact the site administrator if your email should be allowed.'**
  String get app_sitePermissionDenied;

  /// No description provided for @app_networkError.
  ///
  /// In en, this message translates to:
  /// **'A network error occurred. Please check your connection.'**
  String get app_networkError;

  /// No description provided for @app_editModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Mode'**
  String get app_editModeTitle;

  /// No description provided for @app_adminPrivileges.
  ///
  /// In en, this message translates to:
  /// **'You have admin privileges for this site.'**
  String get app_adminPrivileges;

  /// No description provided for @app_howToProceed.
  ///
  /// In en, this message translates to:
  /// **'How would you like to proceed?'**
  String get app_howToProceed;

  /// No description provided for @app_viewSite.
  ///
  /// In en, this message translates to:
  /// **'View Site'**
  String get app_viewSite;

  /// No description provided for @app_editSite.
  ///
  /// In en, this message translates to:
  /// **'Edit Site'**
  String get app_editSite;

  /// No description provided for @app_renameSiteTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename Site'**
  String get app_renameSiteTitle;

  /// No description provided for @app_manageSiteMembers.
  ///
  /// In en, this message translates to:
  /// **'Manage Site Members'**
  String get app_manageSiteMembers;

  /// No description provided for @app_showSiteEventsState.
  ///
  /// In en, this message translates to:
  /// **'Show Site Events & State'**
  String get app_showSiteEventsState;

  /// No description provided for @app_showSiteAllowedEmails.
  ///
  /// In en, this message translates to:
  /// **'Show Site Allowed Emails'**
  String get app_showSiteAllowedEmails;

  /// No description provided for @app_appTitle.
  ///
  /// In en, this message translates to:
  /// **'Hytta Hub Albums'**
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

  /// No description provided for @app_enterButton.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get app_enterButton;

  /// No description provided for @app_otherAppsTitle.
  ///
  /// In en, this message translates to:
  /// **'Other Hytta Hub Applications'**
  String get app_otherAppsTitle;

  /// No description provided for @app_reservationsAppButton.
  ///
  /// In en, this message translates to:
  /// **'Hytta Hub Reservations'**
  String get app_reservationsAppButton;

  /// No description provided for @app_serviceLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Service Login'**
  String get app_serviceLoginButton;

  /// No description provided for @app_exportSiteTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Site'**
  String get app_exportSiteTitle;

  /// No description provided for @app_manageExportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Exports'**
  String get app_manageExportsTitle;
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
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
