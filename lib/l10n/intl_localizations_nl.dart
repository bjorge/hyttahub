// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'intl_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class HyttaHubLocalizationsNl extends HyttaHubLocalizations {
  HyttaHubLocalizationsNl([String locale = 'nl']) : super(locale);

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
  String get loginNotBetaUserError => 'Geen geautoriseerde e-mail';

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
    return 'Versie $appVersion ($appBuildNumber)';
  }

  @override
  String get sites => 'Hubs';

  @override
  String get noSites => 'geen hubs';

  @override
  String get initializingAccountTitle => 'Initializing Account';

  @override
  String get serviceCreateAccountTitle => 'Service Create Account';

  @override
  String get serviceLoginTitle => 'Service Login';

  @override
  String get accountSettingsTitle => 'Account Settings';

  @override
  String get manageSitesTitle => 'Verlaten';

  @override
  String get reorderSitesTitle => 'Hubs herschikken';

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
  String get createSiteTitle => 'Hub maken';

  @override
  String get joinSiteTitle => 'Deelnemen aan hub';

  @override
  String get unimplementedTitle => 'Unimplemented';

  @override
  String get toBeImplemented => 'Coming Soon!';

  @override
  String get siteNameLabel => 'Naam';

  @override
  String get siteNameEmptyError => 'Naam mag niet leeg zijn';

  @override
  String get userNameLabel => 'User Name';

  @override
  String get userNameEmptyError => 'Gebruikersnaam mag niet leeg zijn';

  @override
  String get pasteCodeTooltip => 'Paste Code';

  @override
  String get backspaceTooltip => 'Backspace';

  @override
  String get joinSiteCodeLabel => 'Voer 8-cijferige code in';

  @override
  String get siteCodeEmptyError => 'Code mag niet leeg zijn';

  @override
  String get siteCodeLengthError => 'Code moet 8 tekens lang zijn';

  @override
  String get leaveSiteTooltip => 'Verlaten';

  @override
  String get removeSiteTitle => 'Verwijderen';

  @override
  String get leaveSiteConfirmation =>
      'Verlaten? Alleen een beheerder kan je opnieuw toevoegen.';

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
  String get initializeDataStoreTitle => 'Initialiseer de Gegevensopslag';

  @override
  String get errorTodo => 'Fout: todo';

  @override
  String get initializeDataStoreBody =>
      'De gegevensopslag is leeg. Maak de eerste servicebeheerder aan om het systeem te initialiseren.';

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
      'Onverwachte fout, controleer internet, ga terug en probeer opnieuw';

  @override
  String get permissionDenied =>
      'Je hebt geen toestemming om deze actie uit te voeren.';

  @override
  String get removedFromSite => 'Je bent verwijderd.';

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
  String get emailExistsError => 'E-mail bestaat al.';

  @override
  String get renameSiteTitle => 'Naam wijzigen';

  @override
  String get manageSiteMembers => 'Leden';

  @override
  String get showSiteEventsState => 'Show Events & State';

  @override
  String get showSiteAllowedEmails => 'Allowed Emails';

  @override
  String get siteSettingsTitle => 'Instellingen';

  @override
  String get newSiteNameLabel => 'Nieuwe naam';

  @override
  String get siteEmailsTitle => 'Hub e-mails (database)';

  @override
  String get siteEventsTitle => 'Hub gebeurtenissen (database)';

  @override
  String get siteStateTitle => 'Hub status (lokal replay)';

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
  String get betaUserEmailsLabel => 'E-mailadressen van bètagebruikers';

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
      'Je moet alle hubs verlaten voordat je je account kunt verwijderen.';

  @override
  String get cannotChangeEmailWhenOnlyAdminError =>
      'Cannot change your email when you are the only admin.';

  @override
  String get okButton => 'OK';

  @override
  String get copySiteIdTooltip => 'ID kopiëren';

  @override
  String get siteIdCopied => 'ID naar klembord gekopieerd';

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
  String get loginDismissSnackbar => 'Sluiten';

  @override
  String get passwordEmptyError => 'Wachtwoord mag niet leeg zijn.';

  @override
  String get passwordTooShortError => 'Wachtwoord is te kort.';

  @override
  String get passwordTooLongError => 'Wachtwoord is te lang.';

  @override
  String get noEventsFound => 'Geen gebeurtenissen gevonden.';

  @override
  String get copySiteTitle => 'Kopiëren';

  @override
  String get copySiteTooltip => 'Kopiëren';

  @override
  String get copySiteConfirmTitle => 'Bevestiging kopiëren';

  @override
  String get copySiteConfirmMessage =>
      'Door te kopiëren wordt er een privé-hubduplicaat voor je gemaakt. Houd er rekening mee dat het kopiëren van mediabestanden even kan duren. Je kunt de naam aanpassen en leden toevoegen zodra de kopie voltooid is.';

  @override
  String errorAssigningUser(String error) {
    return 'Fout bij het toewijzen van gebruiker: $error';
  }

  @override
  String get selectLanguage => 'Selecteer taal';

  @override
  String get nightMode => 'Nachtmodus';

  @override
  String get platform => 'Platform';

  @override
  String get info => 'Info';

  @override
  String get serviceLoginButton => 'Service Login';

  @override
  String get english => 'Engels';

  @override
  String get italian => 'Italiaans';

  @override
  String get spanish => 'Spaans';

  @override
  String get norwegian => 'Noors';

  @override
  String get dutch => 'Nederlands';

  @override
  String get themeSettingsAutomatic => 'Automatisch';

  @override
  String get themeSettingsAlwaysOff => 'Altijd uit';

  @override
  String get themeSettingsAlwaysOn => 'Altijd aan';

  @override
  String get openSourceLicensesButton => 'Open-source pakketten';

  @override
  String get clearLocalStorageButton => 'Wis alle lokale opslag';

  @override
  String get refreshBrowserButton => 'Vernieuw browser';

  @override
  String get openSourceLicensesTitle => 'Open-source pakketten';

  @override
  String get siteInfoTitle => 'Informatie';

  @override
  String get siteEventCount => 'Aantal gebeurtenissen';

  @override
  String get siteTotalSize => 'Totale grootte';

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
  String get siteFileCount => 'Aantal bestanden';

  @override
  String get siteTotalFileSize => 'Totale bestandsgrootte';

  @override
  String get errorFetchingFiles => 'Fout bij het ophalen van bestanden';

  @override
  String get refresh => 'Vernieuwen';

  @override
  String eventSiteCreated(String siteName) {
    return 'Aangemaakt: $siteName';
  }

  @override
  String eventAddedMember(String memberName) {
    return 'Lid toegevoegd: $memberName';
  }

  @override
  String eventRenamedSite(String siteName) {
    return 'Naam gewijzigd: $siteName';
  }

  @override
  String eventRemovedMember(int memberId) {
    return 'Lid verwijderd: $memberId';
  }

  @override
  String eventMemberLeft(int memberId) {
    return 'Lid heeft de groep verlaten: $memberId';
  }

  @override
  String eventRestoredMember(String memberName) {
    return 'Lid hersteld: $memberName';
  }

  @override
  String eventUpdatedMember(String memberName) {
    return 'Lid bijgewerkt: $memberName';
  }

  @override
  String get eventSiteCopied => 'Gekopieerd/Geïmporteerd';

  @override
  String get eventAppSpecific => 'App-specifieke gebeurtenis';

  @override
  String get eventUnknown => 'Onbekende gebeurtenis';
}
