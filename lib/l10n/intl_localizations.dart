import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'intl_localizations_en.dart';
import 'intl_localizations_es.dart';
import 'intl_localizations_it.dart';
import 'intl_localizations_nb.dart';
import 'intl_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of HyttaHubLocalizations
/// returned by `HyttaHubLocalizations.of(context)`.
///
/// Applications need to include `HyttaHubLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/intl_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: HyttaHubLocalizations.localizationsDelegates,
///   supportedLocales: HyttaHubLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the HyttaHubLocalizations.supportedLocales
/// property.
abstract class HyttaHubLocalizations {
  HyttaHubLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static HyttaHubLocalizations? of(BuildContext context) {
    return Localizations.of<HyttaHubLocalizations>(
      context,
      HyttaHubLocalizations,
    );
  }

  static const LocalizationsDelegate<HyttaHubLocalizations> delegate =
      _HyttaHubLocalizationsDelegate();

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

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHelperText.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 16 characters long.'**
  String get loginPasswordHelperText;

  /// No description provided for @loginSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Login Success'**
  String get loginSuccessTitle;

  /// No description provided for @loginEmailEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get loginEmailEmptyError;

  /// No description provided for @loginEmailInvalidFormatError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address format.'**
  String get loginEmailInvalidFormatError;

  /// No description provided for @loginEmailReservedError.
  ///
  /// In en, this message translates to:
  /// **'Email format (matches __.*__) is not allowed.'**
  String get loginEmailReservedError;

  /// No description provided for @loginEmailTooLongError.
  ///
  /// In en, this message translates to:
  /// **'Email is too long (max 1500 bytes).'**
  String get loginEmailTooLongError;

  /// No description provided for @loginNotServiceAdminError.
  ///
  /// In en, this message translates to:
  /// **'Not a service admin'**
  String get loginNotServiceAdminError;

  /// No description provided for @loginNotBetaUserError.
  ///
  /// In en, this message translates to:
  /// **'Not an authorized email'**
  String get loginNotBetaUserError;

  /// No description provided for @loginAgreeToTermsCheckbox.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms'**
  String get loginAgreeToTermsCheckbox;

  /// No description provided for @loginAgreeToPrivacyPolicyCheckbox.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Privacy Policy'**
  String get loginAgreeToPrivacyPolicyCheckbox;

  /// No description provided for @loginAlreadyHaveAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get loginAlreadyHaveAccountButton;

  /// No description provided for @loginNeedToCreateAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Need to create an account?'**
  String get loginNeedToCreateAccountButton;

  /// No description provided for @loginForgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get loginForgotPasswordButton;

  /// No description provided for @loginGoToEmailResetPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Go to your email inbox, open the email, and click the link to create a new password. Then return here and login.'**
  String get loginGoToEmailResetPasswordMessage;

  /// No description provided for @loginGoToEmailVerifyEmailMessage.
  ///
  /// In en, this message translates to:
  /// **'Go to your email inbox, open the email, and click the link to verify your email address. Then return here and login.'**
  String get loginGoToEmailVerifyEmailMessage;

  /// No description provided for @app_versionInfo.
  ///
  /// In en, this message translates to:
  /// **'Version {appVersion} ({appBuildNumber})'**
  String app_versionInfo(String appVersion, num appBuildNumber);

  /// No description provided for @sites.
  ///
  /// In en, this message translates to:
  /// **'Sites'**
  String get sites;

  /// No description provided for @noSites.
  ///
  /// In en, this message translates to:
  /// **'no sites'**
  String get noSites;

  /// No description provided for @initializingAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Initializing Account'**
  String get initializingAccountTitle;

  /// No description provided for @serviceCreateAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Create Account'**
  String get serviceCreateAccountTitle;

  /// No description provided for @serviceLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Login'**
  String get serviceLoginTitle;

  /// No description provided for @accountSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettingsTitle;

  /// No description provided for @manageSitesTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Site'**
  String get manageSitesTitle;

  /// No description provided for @reorderSitesTitle.
  ///
  /// In en, this message translates to:
  /// **'Reorder Sites'**
  String get reorderSitesTitle;

  /// No description provided for @removeAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Account'**
  String get removeAccountTitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout?'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutDialogMessage;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @createSiteTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Site'**
  String get createSiteTitle;

  /// No description provided for @joinSiteTitle.
  ///
  /// In en, this message translates to:
  /// **'Join Site'**
  String get joinSiteTitle;

  /// No description provided for @unimplementedTitle.
  ///
  /// In en, this message translates to:
  /// **'Unimplemented'**
  String get unimplementedTitle;

  /// No description provided for @toBeImplemented.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon!'**
  String get toBeImplemented;

  /// No description provided for @siteNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Site Name'**
  String get siteNameLabel;

  /// No description provided for @siteNameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Site name cannot be empty'**
  String get siteNameEmptyError;

  /// No description provided for @userNameLabel.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userNameLabel;

  /// No description provided for @userNameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Site user name cannot be empty'**
  String get userNameEmptyError;

  /// No description provided for @pasteCodeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Paste Code'**
  String get pasteCodeTooltip;

  /// No description provided for @backspaceTooltip.
  ///
  /// In en, this message translates to:
  /// **'Backspace'**
  String get backspaceTooltip;

  /// No description provided for @joinSiteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter 8-character Site Code'**
  String get joinSiteCodeLabel;

  /// No description provided for @siteCodeEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Site code cannot be empty'**
  String get siteCodeEmptyError;

  /// No description provided for @siteCodeLengthError.
  ///
  /// In en, this message translates to:
  /// **'Site code must be 8 characters long'**
  String get siteCodeLengthError;

  /// No description provided for @leaveSiteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Leave Site'**
  String get leaveSiteTooltip;

  /// No description provided for @removeSiteTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Site'**
  String get removeSiteTitle;

  /// No description provided for @leaveSiteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Leave Site? Only an admin can add you back.'**
  String get leaveSiteConfirmation;

  /// No description provided for @updateTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Terms'**
  String get updateTermsTitle;

  /// No description provided for @viewTerms.
  ///
  /// In en, this message translates to:
  /// **'View Terms'**
  String get viewTerms;

  /// No description provided for @viewPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'View Privacy Policy'**
  String get viewPrivacyPolicy;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of Service'**
  String get agreeToTerms;

  /// No description provided for @agreeToPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Privacy Policy'**
  String get agreeToPrivacyPolicy;

  /// No description provided for @showAccountEventsState.
  ///
  /// In en, this message translates to:
  /// **'Show Account Events & State'**
  String get showAccountEventsState;

  /// No description provided for @serviceAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Admin'**
  String get serviceAdminTitle;

  /// No description provided for @serviceStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Status'**
  String get serviceStatusTitle;

  /// No description provided for @minRequiredVersionTitle.
  ///
  /// In en, this message translates to:
  /// **'Minimum Required Version'**
  String get minRequiredVersionTitle;

  /// No description provided for @manageBetaUsersTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Beta Users'**
  String get manageBetaUsersTitle;

  /// No description provided for @errorFetchingBetaUsers.
  ///
  /// In en, this message translates to:
  /// **'Error fetching beta users'**
  String get errorFetchingBetaUsers;

  /// No description provided for @newTermsOfServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'New Terms of Service'**
  String get newTermsOfServiceTitle;

  /// No description provided for @newPrivacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'New Privacy Policy'**
  String get newPrivacyPolicyTitle;

  /// No description provided for @manageServiceAdminsTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Service Admins'**
  String get manageServiceAdminsTitle;

  /// No description provided for @showServiceEventsStateTitle.
  ///
  /// In en, this message translates to:
  /// **'Show Service Events & State'**
  String get showServiceEventsStateTitle;

  /// No description provided for @serviceDownTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Down'**
  String get serviceDownTitle;

  /// No description provided for @serviceDownMessage.
  ///
  /// In en, this message translates to:
  /// **'The service is temporarily unavailable. Please wait while we work to restore it.'**
  String get serviceDownMessage;

  /// No description provided for @accountEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Events (database)'**
  String get accountEventsTitle;

  /// No description provided for @accountStateTitle.
  ///
  /// In en, this message translates to:
  /// **'Account State (local replay)'**
  String get accountStateTitle;

  /// No description provided for @serviceEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Events (database)'**
  String get serviceEventsTitle;

  /// No description provided for @serviceStateTitle.
  ///
  /// In en, this message translates to:
  /// **'Service State (local replay)'**
  String get serviceStateTitle;

  /// No description provided for @networkErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Network Error'**
  String get networkErrorTitle;

  /// No description provided for @serviceNetworkErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'There was an error contacting the service. Please check your internet connection and try again.'**
  String get serviceNetworkErrorMessage;

  /// No description provided for @newVersionAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'New Version Available'**
  String get newVersionAvailableTitle;

  /// No description provided for @newVersionAvailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Please update your browser or app to the latest version.'**
  String get newVersionAvailableMessage;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @noPrivacyPolicyAvailable.
  ///
  /// In en, this message translates to:
  /// **'No privacy policy available.'**
  String get noPrivacyPolicyAvailable;

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfServiceTitle;

  /// No description provided for @noTermsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No terms available.'**
  String get noTermsAvailable;

  /// No description provided for @initializeDataStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Initialize the Data Store'**
  String get initializeDataStoreTitle;

  /// No description provided for @errorTodo.
  ///
  /// In en, this message translates to:
  /// **'Error: todo'**
  String get errorTodo;

  /// No description provided for @initializeDataStoreBody.
  ///
  /// In en, this message translates to:
  /// **'The data store is empty. Create the first service admin in order to initialize the system.'**
  String get initializeDataStoreBody;

  /// No description provided for @successfullySubmittedTodo.
  ///
  /// In en, this message translates to:
  /// **'successfully submitted, todo: grey out fields'**
  String get successfullySubmittedTodo;

  /// No description provided for @errorSubmittingForm.
  ///
  /// In en, this message translates to:
  /// **'Error submitting form'**
  String get errorSubmittingForm;

  /// No description provided for @disallowedCharactersError.
  ///
  /// In en, this message translates to:
  /// **'Characters \'[\' and \']\' are not allowed'**
  String get disallowedCharactersError;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error, check internet, go back and try again'**
  String get unexpectedError;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action.'**
  String get permissionDenied;

  /// No description provided for @removedFromSite.
  ///
  /// In en, this message translates to:
  /// **'You have been removed from this site.'**
  String get removedFromSite;

  /// No description provided for @addMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get addMemberTitle;

  /// No description provided for @memberNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Member Name'**
  String get memberNameLabel;

  /// No description provided for @memberNameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Member name cannot be empty'**
  String get memberNameEmptyError;

  /// No description provided for @memberNameExistsError.
  ///
  /// In en, this message translates to:
  /// **'Member name already exists'**
  String get memberNameExistsError;

  /// No description provided for @administratorLabel.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administratorLabel;

  /// No description provided for @emailExistsError.
  ///
  /// In en, this message translates to:
  /// **'Email already exists in the site'**
  String get emailExistsError;

  /// No description provided for @renameSiteTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename Site'**
  String get renameSiteTitle;

  /// No description provided for @manageSiteMembers.
  ///
  /// In en, this message translates to:
  /// **'Manage Site Members'**
  String get manageSiteMembers;

  /// No description provided for @showSiteEventsState.
  ///
  /// In en, this message translates to:
  /// **'Show Site Events & State'**
  String get showSiteEventsState;

  /// No description provided for @showSiteAllowedEmails.
  ///
  /// In en, this message translates to:
  /// **'Show Site Allowed Emails'**
  String get showSiteAllowedEmails;

  /// No description provided for @siteSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Site Settings'**
  String get siteSettingsTitle;

  /// No description provided for @newSiteNameLabel.
  ///
  /// In en, this message translates to:
  /// **'New Site Name'**
  String get newSiteNameLabel;

  /// No description provided for @siteEmailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Site Emails (database)'**
  String get siteEmailsTitle;

  /// No description provided for @siteEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Site Events (database)'**
  String get siteEventsTitle;

  /// No description provided for @siteStateTitle.
  ///
  /// In en, this message translates to:
  /// **'Site State (local replay)'**
  String get siteStateTitle;

  /// No description provided for @membersTitle.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get membersTitle;

  /// No description provided for @serviceSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Settings'**
  String get serviceSettingsTitle;

  /// No description provided for @termsOfServiceContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service Content'**
  String get termsOfServiceContentLabel;

  /// No description provided for @termsOfServiceContentEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter terms of service content.'**
  String get termsOfServiceContentEmptyError;

  /// No description provided for @contentTooShortError.
  ///
  /// In en, this message translates to:
  /// **'Content is too short.'**
  String get contentTooShortError;

  /// No description provided for @privacyPolicyContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy Content'**
  String get privacyPolicyContentLabel;

  /// No description provided for @privacyPolicyContentEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter privacy policy content.'**
  String get privacyPolicyContentEmptyError;

  /// No description provided for @serviceUnavailableLabel.
  ///
  /// In en, this message translates to:
  /// **'Service Unavailable'**
  String get serviceUnavailableLabel;

  /// No description provided for @minVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Min Version'**
  String get minVersionLabel;

  /// No description provided for @versionNumberEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a version number.'**
  String get versionNumberEmptyError;

  /// No description provided for @versionNumberInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid positive number.'**
  String get versionNumberInvalidError;

  /// No description provided for @betaUserEmailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Beta User Emails'**
  String get betaUserEmailsLabel;

  /// No description provided for @aliasLabel.
  ///
  /// In en, this message translates to:
  /// **'Alias'**
  String get aliasLabel;

  /// No description provided for @nicknameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Nickname cannot be empty'**
  String get nicknameEmptyError;

  /// No description provided for @adminAliasExistsError.
  ///
  /// In en, this message translates to:
  /// **'Admin alias already exists'**
  String get adminAliasExistsError;

  /// No description provided for @failedToLoadEmails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load emails.'**
  String get failedToLoadEmails;

  /// No description provided for @permissionDeniedViewList.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to view this list.'**
  String get permissionDeniedViewList;

  /// No description provided for @noEmailsFound.
  ///
  /// In en, this message translates to:
  /// **'No emails found.'**
  String get noEmailsFound;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID: {userId}'**
  String userId(int userId);

  /// No description provided for @removeMemberTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove Member'**
  String get removeMemberTooltip;

  /// No description provided for @removeMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Member'**
  String get removeMemberTitle;

  /// No description provided for @removeMemberConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Remove Member? This action cannot be undone.'**
  String get removeMemberConfirmation;

  /// No description provided for @updateMemberTooltip.
  ///
  /// In en, this message translates to:
  /// **'Update Member'**
  String get updateMemberTooltip;

  /// No description provided for @updateMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Member'**
  String get updateMemberTitle;

  /// No description provided for @restoreMemberTooltip.
  ///
  /// In en, this message translates to:
  /// **'Restore Member'**
  String get restoreMemberTooltip;

  /// No description provided for @restoreMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Member'**
  String get restoreMemberTitle;

  /// No description provided for @removedMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Removed Members'**
  String get removedMembersTitle;

  /// No description provided for @addAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Admin'**
  String get addAdminTitle;

  /// No description provided for @updateAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Admin'**
  String get updateAdminTitle;

  /// No description provided for @removeAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Admin'**
  String get removeAdminTitle;

  /// No description provided for @removeAdminConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Remove Admin? This action cannot be undone.'**
  String get removeAdminConfirmation;

  /// No description provided for @restoreAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Admin'**
  String get restoreAdminTitle;

  /// No description provided for @removeAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Remove Account? This action cannot be undone.'**
  String get removeAccountConfirmation;

  /// No description provided for @cannotRemoveAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Cannot Remove Account'**
  String get cannotRemoveAccountTitle;

  /// No description provided for @cannotRemoveAccountContent.
  ///
  /// In en, this message translates to:
  /// **'You must leave all sites before you can remove your account.'**
  String get cannotRemoveAccountContent;

  /// No description provided for @cannotChangeEmailWhenOnlyAdminError.
  ///
  /// In en, this message translates to:
  /// **'Cannot change your email when you are the only admin.'**
  String get cannotChangeEmailWhenOnlyAdminError;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @copySiteIdTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy Site ID'**
  String get copySiteIdTooltip;

  /// No description provided for @siteIdCopied.
  ///
  /// In en, this message translates to:
  /// **'Site ID copied to clipboard'**
  String get siteIdCopied;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'&'**
  String get and;

  /// No description provided for @mustAgreeToTermsError.
  ///
  /// In en, this message translates to:
  /// **'You must agree to the terms.'**
  String get mustAgreeToTermsError;

  /// No description provided for @mustAgreeToPrivacyPolicyError.
  ///
  /// In en, this message translates to:
  /// **'You must agree to the privacy policy.'**
  String get mustAgreeToPrivacyPolicyError;

  /// No description provided for @leadingTrailingSpacesError.
  ///
  /// In en, this message translates to:
  /// **'Leading or trailing spaces are not allowed.'**
  String get leadingTrailingSpacesError;

  /// No description provided for @emailLowercaseError.
  ///
  /// In en, this message translates to:
  /// **'Email must be in lowercase.'**
  String get emailLowercaseError;

  /// No description provided for @emailLeadingTrailingSpacesError.
  ///
  /// In en, this message translates to:
  /// **'Email cannot have leading or trailing spaces.'**
  String get emailLeadingTrailingSpacesError;

  /// No description provided for @formSubmissionError.
  ///
  /// In en, this message translates to:
  /// **'Error submitting the form, check internet connection, go back and try again.'**
  String get formSubmissionError;

  /// No description provided for @failedToLoadEvents.
  ///
  /// In en, this message translates to:
  /// **'Failed to load events: {error}'**
  String failedToLoadEvents(String error);

  /// No description provided for @showEventsListTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show Events List'**
  String get showEventsListTooltip;

  /// No description provided for @showReplayStateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show Replay State'**
  String get showReplayStateTooltip;

  /// No description provided for @toggleSortOrderTooltip.
  ///
  /// In en, this message translates to:
  /// **'Toggle Sort Order'**
  String get toggleSortOrderTooltip;

  /// No description provided for @noEventsToReplay.
  ///
  /// In en, this message translates to:
  /// **'No events to replay.'**
  String get noEventsToReplay;

  /// No description provided for @eventVersion.
  ///
  /// In en, this message translates to:
  /// **'Version: {version}'**
  String eventVersion(int version);

  /// No description provided for @loadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingTitle;

  /// No description provided for @authenticationErrorWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Authentication error: {details}'**
  String authenticationErrorWithDetails(String details);

  /// No description provided for @loadingEllipsis.
  ///
  /// In en, this message translates to:
  /// **'...'**
  String get loadingEllipsis;

  /// No description provided for @loginDismissSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get loginDismissSnackbar;

  /// No description provided for @passwordEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty.'**
  String get passwordEmptyError;

  /// No description provided for @passwordTooShortError.
  ///
  /// In en, this message translates to:
  /// **'Password is too short.'**
  String get passwordTooShortError;

  /// No description provided for @passwordTooLongError.
  ///
  /// In en, this message translates to:
  /// **'Password is too long.'**
  String get passwordTooLongError;

  /// No description provided for @noEventsFound.
  ///
  /// In en, this message translates to:
  /// **'No events found.'**
  String get noEventsFound;

  /// Title for the Copy Site dialog option.
  ///
  /// In en, this message translates to:
  /// **'Copy Site'**
  String get copySiteTitle;

  /// Tooltip for the copy site button.
  ///
  /// In en, this message translates to:
  /// **'Copy Site'**
  String get copySiteTooltip;

  /// Title for the copy site confirmation screen.
  ///
  /// In en, this message translates to:
  /// **'Copy Site Confirmation'**
  String get copySiteConfirmTitle;

  /// Message for the copy site confirmation.
  ///
  /// In en, this message translates to:
  /// **'Copying the site will create a private duplicate site for you. Note that copying over the media files might take some time. You can edit the new site name and add members once the copy is complete.'**
  String get copySiteConfirmMessage;

  /// No description provided for @errorAssigningUser.
  ///
  /// In en, this message translates to:
  /// **'Error assigning user: {error}'**
  String errorAssigningUser(String error);

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @nightMode.
  ///
  /// In en, this message translates to:
  /// **'Night Mode'**
  String get nightMode;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @serviceLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Service Login'**
  String get serviceLoginButton;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @italian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get italian;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @norwegian.
  ///
  /// In en, this message translates to:
  /// **'Norwegian'**
  String get norwegian;

  /// No description provided for @dutch.
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get dutch;

  /// No description provided for @themeSettingsAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get themeSettingsAutomatic;

  /// No description provided for @themeSettingsAlwaysOff.
  ///
  /// In en, this message translates to:
  /// **'Always Off'**
  String get themeSettingsAlwaysOff;

  /// No description provided for @themeSettingsAlwaysOn.
  ///
  /// In en, this message translates to:
  /// **'Always On'**
  String get themeSettingsAlwaysOn;

  /// No description provided for @openSourceLicensesButton.
  ///
  /// In en, this message translates to:
  /// **'Open Source Packages'**
  String get openSourceLicensesButton;

  /// Button label to clear all local hydrated bloc storage.
  ///
  /// In en, this message translates to:
  /// **'Clear all local storage'**
  String get clearLocalStorageButton;

  /// Button label to refresh the browser page.
  ///
  /// In en, this message translates to:
  /// **'Refresh browser'**
  String get refreshBrowserButton;

  /// No description provided for @openSourceLicensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Open Source Packages'**
  String get openSourceLicensesTitle;

  /// No description provided for @siteInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Site Info'**
  String get siteInfoTitle;

  /// No description provided for @siteEventCount.
  ///
  /// In en, this message translates to:
  /// **'Event Count'**
  String get siteEventCount;

  /// No description provided for @siteTotalSize.
  ///
  /// In en, this message translates to:
  /// **'Total Size'**
  String get siteTotalSize;

  /// No description provided for @bytesLabel.
  ///
  /// In en, this message translates to:
  /// **'{size} bytes'**
  String bytesLabel(int size);

  /// No description provided for @kilobytesLabel.
  ///
  /// In en, this message translates to:
  /// **'{size} KB'**
  String kilobytesLabel(double size);

  /// No description provided for @megabytesLabel.
  ///
  /// In en, this message translates to:
  /// **'{size} MB'**
  String megabytesLabel(double size);

  /// No description provided for @gigabytesLabel.
  ///
  /// In en, this message translates to:
  /// **'{size} GB'**
  String gigabytesLabel(double size);

  /// No description provided for @siteFileCount.
  ///
  /// In en, this message translates to:
  /// **'File Count'**
  String get siteFileCount;

  /// No description provided for @siteTotalFileSize.
  ///
  /// In en, this message translates to:
  /// **'Total File Size'**
  String get siteTotalFileSize;

  /// No description provided for @errorFetchingFiles.
  ///
  /// In en, this message translates to:
  /// **'Error fetching files'**
  String get errorFetchingFiles;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @eventSiteCreated.
  ///
  /// In en, this message translates to:
  /// **'Site Created: {siteName}'**
  String eventSiteCreated(String siteName);

  /// No description provided for @eventAddedMember.
  ///
  /// In en, this message translates to:
  /// **'Added Member: {memberName}'**
  String eventAddedMember(String memberName);

  /// No description provided for @eventRenamedSite.
  ///
  /// In en, this message translates to:
  /// **'Renamed Site: {siteName}'**
  String eventRenamedSite(String siteName);

  /// No description provided for @eventRemovedMember.
  ///
  /// In en, this message translates to:
  /// **'Removed Member: {memberId}'**
  String eventRemovedMember(int memberId);

  /// No description provided for @eventMemberLeft.
  ///
  /// In en, this message translates to:
  /// **'Member Left: {memberId}'**
  String eventMemberLeft(int memberId);

  /// No description provided for @eventRestoredMember.
  ///
  /// In en, this message translates to:
  /// **'Restored Member: {memberName}'**
  String eventRestoredMember(String memberName);

  /// No description provided for @eventUpdatedMember.
  ///
  /// In en, this message translates to:
  /// **'Updated Member: {memberName}'**
  String eventUpdatedMember(String memberName);

  /// No description provided for @eventSiteCopied.
  ///
  /// In en, this message translates to:
  /// **'Site Copied/Imported'**
  String get eventSiteCopied;

  /// No description provided for @eventAppSpecific.
  ///
  /// In en, this message translates to:
  /// **'App specific event'**
  String get eventAppSpecific;

  /// No description provided for @eventUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown Event'**
  String get eventUnknown;
}

class _HyttaHubLocalizationsDelegate
    extends LocalizationsDelegate<HyttaHubLocalizations> {
  const _HyttaHubLocalizationsDelegate();

  @override
  Future<HyttaHubLocalizations> load(Locale locale) {
    return SynchronousFuture<HyttaHubLocalizations>(
      lookupHyttaHubLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'it', 'nb', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_HyttaHubLocalizationsDelegate old) => false;
}

HyttaHubLocalizations lookupHyttaHubLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return HyttaHubLocalizationsEn();
    case 'es':
      return HyttaHubLocalizationsEs();
    case 'it':
      return HyttaHubLocalizationsIt();
    case 'nb':
      return HyttaHubLocalizationsNb();
    case 'nl':
      return HyttaHubLocalizationsNl();
  }

  throw FlutterError(
    'HyttaHubLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
