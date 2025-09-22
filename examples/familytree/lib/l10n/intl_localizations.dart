import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'intl_localizations_en.dart';
import 'intl_localizations_es.dart';
import 'intl_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/intl_localizations.dart';
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
  ];

  /// No description provided for @app_createTreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Tree'**
  String get app_createTreeTitle;

  /// No description provided for @app_treeNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Tree Name'**
  String get app_treeNameLabel;

  /// No description provided for @app_treeNameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Tree name cannot be empty'**
  String get app_treeNameEmptyError;

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

  /// No description provided for @app_treeSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tree Settings'**
  String get app_treeSettingsTitle;

  /// No description provided for @app_reorderTreesTitle.
  ///
  /// In en, this message translates to:
  /// **'Reorder Trees'**
  String get app_reorderTreesTitle;

  /// No description provided for @app_renameTreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename Tree'**
  String get app_renameTreeTitle;

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

  /// No description provided for @app_treeLabel.
  ///
  /// In en, this message translates to:
  /// **'Tree'**
  String get app_treeLabel;

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

  /// No description provided for @app_noTrees.
  ///
  /// In en, this message translates to:
  /// **'no trees'**
  String get app_noTrees;

  /// No description provided for @app_siteSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Site Settings'**
  String get app_siteSettingsTitle;

  /// No description provided for @app_addTreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Tree'**
  String get app_addTreeTitle;

  /// No description provided for @app_newTreeNameLabel.
  ///
  /// In en, this message translates to:
  /// **'New Tree Name'**
  String get app_newTreeNameLabel;

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

  /// No description provided for @app_deleteTreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Tree'**
  String get app_deleteTreeTitle;

  /// No description provided for @app_deleteTreeConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete Tree? This action cannot be undone and will delete all members and photos in the tree.'**
  String get app_deleteTreeConfirmation;

  /// No description provided for @app_addTreeMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Tree Member'**
  String get app_addTreeMemberTitle;

  /// No description provided for @app_treeMemberNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Member Name'**
  String get app_treeMemberNameLabel;

  /// No description provided for @app_treeMemberNameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Member name cannot be empty'**
  String get app_treeMemberNameEmptyError;

  /// No description provided for @app_removeTreeMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Tree Member'**
  String get app_removeTreeMemberTitle;

  /// No description provided for @app_removeTreeMemberConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Remove Member? This action cannot be undone.'**
  String get app_removeTreeMemberConfirmation;

  /// No description provided for @app_addConnectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Connection'**
  String get app_addConnectionTitle;

  /// No description provided for @app_selectMember.
  ///
  /// In en, this message translates to:
  /// **'Select Member'**
  String get app_selectMember;

  /// No description provided for @app_selectConnectionType.
  ///
  /// In en, this message translates to:
  /// **'Select Connection Type'**
  String get app_selectConnectionType;

  /// No description provided for @app_infoLabel.
  ///
  /// In en, this message translates to:
  /// **'Info (optional)'**
  String get app_infoLabel;

  /// No description provided for @app_removeConnectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Connection'**
  String get app_removeConnectionTitle;

  /// No description provided for @app_removeConnectionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Remove Connection? This action cannot be undone.'**
  String get app_removeConnectionConfirmation;

  /// No description provided for @app_updatePhotoCaptionScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Photo Caption'**
  String get app_updatePhotoCaptionScreenTitle;

  /// No description provided for @app_newCaptionLabel.
  ///
  /// In en, this message translates to:
  /// **'New caption'**
  String get app_newCaptionLabel;

  /// No description provided for @app_pleaseSelectMemberError.
  ///
  /// In en, this message translates to:
  /// **'Please select a member'**
  String get app_pleaseSelectMemberError;

  /// No description provided for @app_pleaseSelectConnectionType.
  ///
  /// In en, this message translates to:
  /// **'Please select a connection type'**
  String get app_pleaseSelectConnectionType;

  /// No description provided for @app_treeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Tree not found'**
  String get app_treeNotFound;

  /// No description provided for @app_personNotFound.
  ///
  /// In en, this message translates to:
  /// **'Person not found'**
  String get app_personNotFound;

  /// No description provided for @app_noConnections.
  ///
  /// In en, this message translates to:
  /// **'No connections'**
  String get app_noConnections;

  /// No description provided for @app_connectionTypePartner.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get app_connectionTypePartner;

  /// No description provided for @app_connectionTypeExPartner.
  ///
  /// In en, this message translates to:
  /// **'Ex-Partner'**
  String get app_connectionTypeExPartner;

  /// No description provided for @app_connectionTypeChild.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get app_connectionTypeChild;

  /// No description provided for @app_connectionTypeFriend.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get app_connectionTypeFriend;

  /// No description provided for @app_connectionTypeParent.
  ///
  /// In en, this message translates to:
  /// **'Parents'**
  String get app_connectionTypeParent;

  /// No description provided for @app_connectionTypePet.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get app_connectionTypePet;

  /// No description provided for @app_connectionTypeConnections.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get app_connectionTypeConnections;

  /// No description provided for @app_noMembersInThisTree.
  ///
  /// In en, this message translates to:
  /// **'No members in this tree'**
  String get app_noMembersInThisTree;

  /// No description provided for @app_renameTreeMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename Tree Member'**
  String get app_renameTreeMemberTitle;

  /// No description provided for @app_newMemberNameLabel.
  ///
  /// In en, this message translates to:
  /// **'New Member Name'**
  String get app_newMemberNameLabel;

  /// No description provided for @app_photoSizeInKB.
  ///
  /// In en, this message translates to:
  /// **'{size} KB'**
  String app_photoSizeInKB(String size);

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

  /// No description provided for @app_photosCount.
  ///
  /// In en, this message translates to:
  /// **'Photos: {count}'**
  String app_photosCount(int count);

  /// No description provided for @app_connectionsCount.
  ///
  /// In en, this message translates to:
  /// **'Connections: {count}'**
  String app_connectionsCount(int count);

  /// No description provided for @app_addConnectionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add Connection'**
  String get app_addConnectionTooltip;

  /// No description provided for @app_addPhotoTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get app_addPhotoTooltip;

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
  /// **'Hytta Hub Connections'**
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
      <String>['en', 'es', 'it'].contains(locale.languageCode);

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
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
