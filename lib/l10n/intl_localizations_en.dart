// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'intl_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class HyttaHubLocalizationsEn extends HyttaHubLocalizations {
  HyttaHubLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Login';

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHelperText =>
      'Password must be at least 16 characters long.';

  @override
  String get loginSuccessTitle => 'Login Success';

  @override
  String get loginEmailEmptyError => 'Email cannot be empty';

  @override
  String get loginEmailInvalidFormatError =>
      'Please enter a valid email address format.';

  @override
  String get loginEmailReservedError =>
      'Email format (matches __.*__) is not allowed.';

  @override
  String get loginEmailTooLongError => 'Email is too long (max 1500 bytes).';

  @override
  String get loginNotServiceAdminError => 'Not a service admin';

  @override
  String get loginNotBetaUserError => 'Not an authorized email';

  @override
  String get loginAgreeToTermsCheckbox => 'I agree to the Terms';

  @override
  String get loginAgreeToPrivacyPolicyCheckbox =>
      'I agree to the Privacy Policy';

  @override
  String get loginAlreadyHaveAccountButton => 'Already have an account?';

  @override
  String get loginNeedToCreateAccountButton => 'Need to create an account?';

  @override
  String get loginForgotPasswordButton => 'Forgot Password?';

  @override
  String get loginGoToEmailResetPasswordMessage =>
      'Go to your email inbox, open the email, and click the link to create a new password. Then return here and login.';

  @override
  String get loginGoToEmailVerifyEmailMessage =>
      'Go to your email inbox, open the email, and click the link to verify your email address. Then return here and login.';

  @override
  String app_versionInfo(String appVersion, num appBuildNumber) {
    return 'Version $appVersion ($appBuildNumber)';
  }

  @override
  String get sites => 'Hubs';

  @override
  String get noSites => 'no hubs';

  @override
  String get initializingAccountTitle => 'Initializing Account';

  @override
  String get serviceCreateAccountTitle => 'Service Create Account';

  @override
  String get serviceLoginTitle => 'Service Login';

  @override
  String get accountSettingsTitle => 'Account Settings';

  @override
  String get manageSitesTitle => 'Leave';

  @override
  String get reorderSitesTitle => 'Reorder';

  @override
  String get removeAccountTitle => 'Remove Account';

  @override
  String get logout => 'Logout';

  @override
  String get logoutDialogTitle => 'Logout?';

  @override
  String get logoutDialogMessage => 'Are you sure you want to log out?';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get createSiteTitle => 'Create Hub';

  @override
  String get joinSiteTitle => 'Join Hub';

  @override
  String get unimplementedTitle => 'Unimplemented';

  @override
  String get toBeImplemented => 'Coming Soon!';

  @override
  String get siteNameLabel => 'Name';

  @override
  String get siteNameEmptyError => 'Name cannot be empty';

  @override
  String get userNameLabel => 'User Name';

  @override
  String get userNameEmptyError => 'User name cannot be empty';

  @override
  String get pasteCodeTooltip => 'Paste Code';

  @override
  String get backspaceTooltip => 'Backspace';

  @override
  String get joinSiteCodeLabel => 'Enter 8-character Code';

  @override
  String get siteCodeEmptyError => 'Code cannot be empty';

  @override
  String get siteCodeLengthError => 'Code must be 8 characters long';

  @override
  String get leaveSiteTooltip => 'Leave';

  @override
  String get removeSiteTitle => 'Remove';

  @override
  String get leaveSiteConfirmation => 'Leave? Only an admin can add you back.';

  @override
  String get updateTermsTitle => 'Update Terms';

  @override
  String get viewTerms => 'View Terms';

  @override
  String get viewPrivacyPolicy => 'View Privacy Policy';

  @override
  String get agreeToTerms => 'I agree to the Terms of Service';

  @override
  String get agreeToPrivacyPolicy => 'I agree to the Privacy Policy';

  @override
  String get showAccountEventsState => 'Show Account Events & State';

  @override
  String get serviceAdminTitle => 'Service Admin';

  @override
  String get serviceStatusTitle => 'Service Status';

  @override
  String get minRequiredVersionTitle => 'Minimum Required Version';

  @override
  String get manageBetaUsersTitle => 'Manage Beta Users';

  @override
  String get errorFetchingBetaUsers => 'Error fetching beta users';

  @override
  String get newTermsOfServiceTitle => 'New Terms of Service';

  @override
  String get newPrivacyPolicyTitle => 'New Privacy Policy';

  @override
  String get manageServiceAdminsTitle => 'Manage Service Admins';

  @override
  String get showServiceEventsStateTitle => 'Show Service Events & State';

  @override
  String get serviceDownTitle => 'Service Down';

  @override
  String get serviceDownMessage =>
      'The service is temporarily unavailable. Please wait while we work to restore it.';

  @override
  String get accountEventsTitle => 'Account Events (database)';

  @override
  String get accountStateTitle => 'Account State (local replay)';

  @override
  String get serviceEventsTitle => 'Service Events (database)';

  @override
  String get serviceStateTitle => 'Service State (local replay)';

  @override
  String get networkErrorTitle => 'Network Error';

  @override
  String get serviceNetworkErrorMessage =>
      'There was an error contacting the service. Please check your internet connection and try again.';

  @override
  String get newVersionAvailableTitle => 'New Version Available';

  @override
  String get newVersionAvailableMessage =>
      'Please update your browser or app to the latest version.';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get noPrivacyPolicyAvailable => 'No privacy policy available.';

  @override
  String get termsOfServiceTitle => 'Terms of Service';

  @override
  String get noTermsAvailable => 'No terms available.';

  @override
  String get initializeDataStoreTitle => 'Initialize the Data Store';

  @override
  String get errorTodo => 'Error: todo';

  @override
  String get initializeDataStoreBody =>
      'The data store is empty. Create the first service admin in order to initialize the system.';

  @override
  String get successfullySubmittedTodo =>
      'successfully submitted, todo: grey out fields';

  @override
  String get errorSubmittingForm => 'Error submitting form';

  @override
  String get disallowedCharactersError =>
      'Characters \'[\' and \']\' are not allowed';

  @override
  String get errorTitle => 'Error';

  @override
  String get unexpectedError =>
      'Unexpected error, check internet, go back and try again';

  @override
  String get permissionDenied =>
      'You do not have permission to perform this action.';

  @override
  String get removedFromSite => 'You have been removed.';

  @override
  String get addMemberTitle => 'Add Member';

  @override
  String get memberNameLabel => 'Member Name';

  @override
  String get memberNameEmptyError => 'Member name cannot be empty';

  @override
  String get memberNameExistsError => 'Member name already exists';

  @override
  String get administratorLabel => 'Administrator';

  @override
  String get emailExistsError => 'Email already exists.';

  @override
  String get renameSiteTitle => 'Rename';

  @override
  String get manageSiteMembers => 'Members';

  @override
  String get showSiteEventsState => 'Show Events & State';

  @override
  String get showSiteAllowedEmails => 'Allowed Emails';

  @override
  String get siteSettingsTitle => 'Settings';

  @override
  String get newSiteNameLabel => 'New Name';

  @override
  String get siteEmailsTitle => 'Hub Emails (database)';

  @override
  String get siteEventsTitle => 'Hub Events (database)';

  @override
  String get siteStateTitle => 'Hub State (local replay)';

  @override
  String get membersTitle => 'Members';

  @override
  String get serviceSettingsTitle => 'Service Settings';

  @override
  String get termsOfServiceContentLabel => 'Terms of Service Content';

  @override
  String get termsOfServiceContentEmptyError =>
      'Please enter terms of service content.';

  @override
  String get contentTooShortError => 'Content is too short.';

  @override
  String get privacyPolicyContentLabel => 'Privacy Policy Content';

  @override
  String get privacyPolicyContentEmptyError =>
      'Please enter privacy policy content.';

  @override
  String get serviceUnavailableLabel => 'Service Unavailable';

  @override
  String get minVersionLabel => 'Min Version';

  @override
  String get versionNumberEmptyError => 'Please enter a version number.';

  @override
  String get versionNumberInvalidError =>
      'Please enter a valid positive number.';

  @override
  String get betaUserEmailsLabel => 'Beta User Emails';

  @override
  String get aliasLabel => 'Alias';

  @override
  String get nicknameEmptyError => 'Nickname cannot be empty';

  @override
  String get adminAliasExistsError => 'Admin alias already exists';

  @override
  String get failedToLoadEmails => 'Failed to load emails.';

  @override
  String get permissionDeniedViewList =>
      'You do not have permission to view this list.';

  @override
  String get noEmailsFound => 'No emails found.';

  @override
  String userId(int userId) {
    return 'User ID: $userId';
  }

  @override
  String get removeMemberTooltip => 'Remove Member';

  @override
  String get removeMemberTitle => 'Remove Member';

  @override
  String get removeMemberConfirmation =>
      'Remove Member? This action cannot be undone.';

  @override
  String get updateMemberTooltip => 'Update Member';

  @override
  String get updateMemberTitle => 'Update Member';

  @override
  String get restoreMemberTooltip => 'Restore Member';

  @override
  String get restoreMemberTitle => 'Restore Member';

  @override
  String get removedMembersTitle => 'Removed Members';

  @override
  String get addAdminTitle => 'Add Admin';

  @override
  String get updateAdminTitle => 'Update Admin';

  @override
  String get removeAdminTitle => 'Remove Admin';

  @override
  String get removeAdminConfirmation =>
      'Remove Admin? This action cannot be undone.';

  @override
  String get restoreAdminTitle => 'Restore Admin';

  @override
  String get removeAccountConfirmation =>
      'Remove Account? This action cannot be undone.';

  @override
  String get cannotRemoveAccountTitle => 'Cannot Remove Account';

  @override
  String get cannotRemoveAccountContent =>
      'You must leave all hubs before you can remove your account.';

  @override
  String get cannotChangeEmailWhenOnlyAdminError =>
      'Cannot change your email when you are the only admin.';

  @override
  String get okButton => 'OK';

  @override
  String get copySiteIdTooltip => 'Copy ID';

  @override
  String get siteIdCopied => 'ID copied to clipboard';

  @override
  String get and => '&';

  @override
  String get mustAgreeToTermsError => 'You must agree to the terms.';

  @override
  String get mustAgreeToPrivacyPolicyError =>
      'You must agree to the privacy policy.';

  @override
  String get leadingTrailingSpacesError =>
      'Leading or trailing spaces are not allowed.';

  @override
  String get emailLowercaseError => 'Email must be in lowercase.';

  @override
  String get emailLeadingTrailingSpacesError =>
      'Email cannot have leading or trailing spaces.';

  @override
  String get formSubmissionError =>
      'Error submitting the form, check internet connection, go back and try again.';

  @override
  String failedToLoadEvents(String error) {
    return 'Failed to load events: $error';
  }

  @override
  String get showEventsListTooltip => 'Show Events List';

  @override
  String get showReplayStateTooltip => 'Show Replay State';

  @override
  String get toggleSortOrderTooltip => 'Toggle Sort Order';

  @override
  String get noEventsToReplay => 'No events to replay.';

  @override
  String eventVersion(int version) {
    return 'Version: $version';
  }

  @override
  String get loadingTitle => 'Loading...';

  @override
  String authenticationErrorWithDetails(String details) {
    return 'Authentication error: $details';
  }

  @override
  String get loadingEllipsis => '...';

  @override
  String get loginDismissSnackbar => 'Dismiss';

  @override
  String get passwordEmptyError => 'Password cannot be empty.';

  @override
  String get passwordTooShortError => 'Password is too short.';

  @override
  String get passwordTooLongError => 'Password is too long.';

  @override
  String get noEventsFound => 'No events found.';

  @override
  String get copySiteTitle => 'Copy';

  @override
  String get copySiteTooltip => 'Copy';

  @override
  String get copySiteConfirmTitle => 'Copy Confirmation';

  @override
  String get copySiteConfirmMessage =>
      'Copying will create a private duplicate hub for you. Note that copying over the media files might take some time. You can edit the new name and add members once the copy is complete.';

  @override
  String errorAssigningUser(String error) {
    return 'Error assigning user: $error';
  }

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get nightMode => 'Night Mode';

  @override
  String get platform => 'Platform';

  @override
  String get info => 'Info';

  @override
  String get serviceLoginButton => 'Service Login';

  @override
  String get english => 'English';

  @override
  String get italian => 'Italian';

  @override
  String get spanish => 'Spanish';

  @override
  String get norwegian => 'Norwegian';

  @override
  String get dutch => 'Dutch';

  @override
  String get themeSettingsAutomatic => 'Automatic';

  @override
  String get themeSettingsAlwaysOff => 'Always Off';

  @override
  String get themeSettingsAlwaysOn => 'Always On';

  @override
  String get openSourceLicensesButton => 'Open Source Packages';

  @override
  String get clearLocalStorageButton => 'Clear all local storage';

  @override
  String get refreshBrowserButton => 'Refresh browser';

  @override
  String get openSourceLicensesTitle => 'Open Source Packages';

  @override
  String get siteInfoTitle => 'Info';

  @override
  String get siteEventCount => 'Event Count';

  @override
  String get siteTotalSize => 'Total Size';

  @override
  String bytesLabel(int size) {
    return '$size bytes';
  }

  @override
  String kilobytesLabel(double size) {
    final intl.NumberFormat sizeNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String sizeString = sizeNumberFormat.format(size);

    return '$sizeString KB';
  }

  @override
  String megabytesLabel(double size) {
    final intl.NumberFormat sizeNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String sizeString = sizeNumberFormat.format(size);

    return '$sizeString MB';
  }

  @override
  String gigabytesLabel(double size) {
    final intl.NumberFormat sizeNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String sizeString = sizeNumberFormat.format(size);

    return '$sizeString GB';
  }

  @override
  String get siteFileCount => 'File Count';

  @override
  String get siteTotalFileSize => 'Total File Size';

  @override
  String get errorFetchingFiles => 'Error fetching files';

  @override
  String get refresh => 'Refresh';

  @override
  String eventSiteCreated(String siteName) {
    return 'Created: $siteName';
  }

  @override
  String eventAddedMember(String memberName) {
    return 'Added Member: $memberName';
  }

  @override
  String eventRenamedSite(String siteName) {
    return 'Renamed: $siteName';
  }

  @override
  String eventRemovedMember(int memberId) {
    return 'Removed Member: $memberId';
  }

  @override
  String eventMemberLeft(int memberId) {
    return 'Member Left: $memberId';
  }

  @override
  String eventRestoredMember(String memberName) {
    return 'Restored Member: $memberName';
  }

  @override
  String eventUpdatedMember(String memberName) {
    return 'Updated Member: $memberName';
  }

  @override
  String get eventSiteCopied => 'Copied/Imported';

  @override
  String get eventAppSpecific => 'App specific event';

  @override
  String get eventUnknown => 'Unknown Event';
}
