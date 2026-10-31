// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'intl_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class HyttaHubLocalizationsNl extends HyttaHubLocalizations {
  HyttaHubLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get loginTitle => 'Inloggen';

  @override
  String get createAccountTitle => 'Account aanmaken';

  @override
  String get loginEmailLabel => 'E-mail';

  @override
  String get loginPasswordLabel => 'Wachtwoord';

  @override
  String get loginPasswordHelperText =>
      'Het wachtwoord moet minstens 16 tekens lang zijn.';

  @override
  String get loginSuccessTitle => 'Succesvol ingelogd';

  @override
  String get loginEmailEmptyError => 'E-mail mag niet leeg zijn';

  @override
  String get loginEmailInvalidFormatError => 'Voer een geldig e-mailadres in.';

  @override
  String get loginEmailReservedError =>
      'E-mailformaat (komt overeen met __.*__) is niet toegestaan.';

  @override
  String get loginEmailTooLongError => 'E-mail is te lang (max. 1500 bytes).';

  @override
  String get loginNotServiceAdminError => 'Geen servicebeheerder';

  @override
  String get loginNotBetaUserError => 'Geen geautoriseerde e-mail';

  @override
  String get loginAgreeToTermsCheckbox => 'Ik ga akkoord met de voorwaarden';

  @override
  String get loginAgreeToPrivacyPolicyCheckbox =>
      'Ik ga akkoord met het privacybeleid';

  @override
  String get loginAlreadyHaveAccountButton => 'Heb je al een account?';

  @override
  String get loginNeedToCreateAccountButton => 'Moet je een account aanmaken?';

  @override
  String get loginForgotPasswordButton => 'Wachtwoord vergeten?';

  @override
  String get loginGoToEmailResetPasswordMessage =>
      'Ga naar je inbox, open de e-mail en klik op de link om een nieuw wachtwoord aan te maken. Kom daarna terug en log in.';

  @override
  String get loginGoToEmailVerifyEmailMessage =>
      'Ga naar je inbox, open de e-mail en klik op de link om je e-mailadres te verifiëren. Kom daarna terug en log in.';

  @override
  String app_versionInfo(String appVersion, num appBuildNumber) {
    return 'Versie $appVersion ($appBuildNumber)';
  }

  @override
  String get sites => 'Hubs';

  @override
  String get noSites => 'geen hubs';

  @override
  String get initializingAccountTitle => 'Account initialiseren';

  @override
  String get serviceCreateAccountTitle => 'Serviceaccount aanmaken';

  @override
  String get serviceLoginTitle => 'Service-inlog';

  @override
  String get accountSettingsTitle => 'Accountinstellingen';

  @override
  String get manageSitesTitle => 'Verlaten';

  @override
  String get reorderSitesTitle => 'Hubs herschikken';

  @override
  String get removeAccountTitle => 'Account verwijderen';

  @override
  String get logout => 'Uitloggen';

  @override
  String get logoutDialogTitle => 'Uitloggen?';

  @override
  String get logoutDialogMessage => 'Weet je zeker dat je wilt uitloggen?';

  @override
  String get cancelButton => 'Annuleren';

  @override
  String get createSiteTitle => 'Hub maken';

  @override
  String get joinSiteTitle => 'Deelnemen aan hub';

  @override
  String get unimplementedTitle => 'Niet geïmplementeerd';

  @override
  String get toBeImplemented => 'Binnenkort beschikbaar!';

  @override
  String get siteNameLabel => 'Naam';

  @override
  String get siteNameEmptyError => 'Naam mag niet leeg zijn';

  @override
  String get userNameLabel => 'Gebruikersnaam';

  @override
  String get userNameEmptyError => 'Gebruikersnaam mag niet leeg zijn';

  @override
  String get pasteCodeTooltip => 'Code plakken';

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
  String get updateTermsTitle => 'Voorwaarden bijwerken';

  @override
  String get viewTerms => 'Voorwaarden bekijken';

  @override
  String get viewPrivacyPolicy => 'Privacybeleid bekijken';

  @override
  String get agreeToTerms => 'Ik ga akkoord met de servicevoorwaarden';

  @override
  String get agreeToPrivacyPolicy => 'Ik ga akkoord met het privacybeleid';

  @override
  String get showAccountEventsState => 'Accountgebeurtenissen en -status tonen';

  @override
  String get serviceAdminTitle => 'Servicebeheer';

  @override
  String get serviceStatusTitle => 'Servicestatus';

  @override
  String get minRequiredVersionTitle => 'Minimaal vereiste versie';

  @override
  String get manageBetaUsersTitle => 'Bètagebruikers beheren';

  @override
  String get errorFetchingBetaUsers => 'Fout bij ophalen van bètagebruikers';

  @override
  String get newTermsOfServiceTitle => 'Nieuwe servicevoorwaarden';

  @override
  String get newPrivacyPolicyTitle => 'Nieuw privacybeleid';

  @override
  String get manageServiceAdminsTitle => 'Servicebeheerders beheren';

  @override
  String get showServiceEventsStateTitle =>
      'Servicegebeurtenissen en -status tonen';

  @override
  String get serviceDownTitle => 'Service niet beschikbaar';

  @override
  String get serviceDownMessage =>
      'De service is tijdelijk niet beschikbaar. Wacht even terwijl we werken aan het herstel.';

  @override
  String get accountEventsTitle => 'Accountgebeurtenissen (database)';

  @override
  String get accountStateTitle => 'Accountstatus (lokale replay)';

  @override
  String get serviceEventsTitle => 'Servicegebeurtenissen (database)';

  @override
  String get serviceStateTitle => 'Servicestatus (lokale replay)';

  @override
  String get networkErrorTitle => 'Netwerkfout';

  @override
  String get serviceNetworkErrorMessage =>
      'Er is een fout opgetreden bij het contact met de service. Controleer je internetverbinding en probeer het opnieuw.';

  @override
  String get newVersionAvailableTitle => 'Nieuwe versie beschikbaar';

  @override
  String get newVersionAvailableMessage =>
      'Werk je browser of app bij naar de nieuwste versie.';

  @override
  String get privacyPolicyTitle => 'Privacybeleid';

  @override
  String get noPrivacyPolicyAvailable => 'Geen privacybeleid beschikbaar.';

  @override
  String get termsOfServiceTitle => 'Servicevoorwaarden';

  @override
  String get noTermsAvailable => 'Geen voorwaarden beschikbaar.';

  @override
  String get initializeDataStoreTitle => 'Initialiseer de Gegevensopslag';

  @override
  String get errorTodo => 'Fout: todo';

  @override
  String get initializeDataStoreBody =>
      'De gegevensopslag is leeg. Maak de eerste servicebeheerder aan om het systeem te initialiseren.';

  @override
  String get successfullySubmittedTodo =>
      'succesvol verzonden, todo: velden grijs maken';

  @override
  String get errorSubmittingForm => 'Fout bij verzenden van formulier';

  @override
  String get disallowedCharactersError =>
      'De tekens \'[\' en \']\' zijn niet toegestaan';

  @override
  String get errorTitle => 'Fout';

  @override
  String get unexpectedError =>
      'Onverwachte fout, controleer internet, ga terug en probeer opnieuw';

  @override
  String get permissionDenied =>
      'Je hebt geen toestemming om deze actie uit te voeren.';

  @override
  String get removedFromSite => 'Je bent verwijderd.';

  @override
  String get addMemberTitle => 'Lid toevoegen';

  @override
  String get memberNameLabel => 'Naam van lid';

  @override
  String get memberNameEmptyError => 'Naam van lid mag niet leeg zijn';

  @override
  String get memberNameExistsError => 'Naam van lid bestaat al';

  @override
  String get administratorLabel => 'Beheerder';

  @override
  String get emailExistsError => 'E-mail bestaat al.';

  @override
  String get renameSiteTitle => 'Naam wijzigen';

  @override
  String get manageSiteMembers => 'Leden';

  @override
  String get showSiteEventsState => 'Gebeurtenissen en status tonen';

  @override
  String get showSiteAllowedEmails => 'Toegestane e-mailadressen';

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
  String get membersTitle => 'Leden';

  @override
  String get serviceSettingsTitle => 'Service-instellingen';

  @override
  String get termsOfServiceContentLabel => 'Inhoud van de servicevoorwaarden';

  @override
  String get termsOfServiceContentEmptyError =>
      'Voer de inhoud van de servicevoorwaarden in.';

  @override
  String get contentTooShortError => 'De inhoud is te kort.';

  @override
  String get privacyPolicyContentLabel => 'Inhoud van het privacybeleid';

  @override
  String get privacyPolicyContentEmptyError =>
      'Voer de inhoud van het privacybeleid in.';

  @override
  String get serviceUnavailableLabel => 'Service niet beschikbaar';

  @override
  String get minVersionLabel => 'Min. versie';

  @override
  String get versionNumberEmptyError => 'Voer een versienummer in.';

  @override
  String get versionNumberInvalidError => 'Voer een geldig positief getal in.';

  @override
  String get betaUserEmailsLabel => 'E-mailadressen van bètagebruikers';

  @override
  String get aliasLabel => 'Alias';

  @override
  String get nicknameEmptyError => 'Bijnaam mag niet leeg zijn';

  @override
  String get adminAliasExistsError => 'Beheerdersalias bestaat al';

  @override
  String get failedToLoadEmails => 'Kan e-mailadressen niet laden.';

  @override
  String get permissionDeniedViewList =>
      'Je hebt geen toestemming om deze lijst te bekijken.';

  @override
  String get noEmailsFound => 'Geen e-mailadressen gevonden.';

  @override
  String userId(int userId) {
    return 'Gebruikers-ID: $userId';
  }

  @override
  String get removeMemberTooltip => 'Lid verwijderen';

  @override
  String get removeMemberTitle => 'Lid verwijderen';

  @override
  String get removeMemberConfirmation =>
      'Lid verwijderen? Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get updateMemberTooltip => 'Lid bijwerken';

  @override
  String get updateMemberTitle => 'Lid bijwerken';

  @override
  String get restoreMemberTooltip => 'Lid herstellen';

  @override
  String get restoreMemberTitle => 'Lid herstellen';

  @override
  String get removedMembersTitle => 'Verwijderde leden';

  @override
  String get addAdminTitle => 'Beheerder toevoegen';

  @override
  String get updateAdminTitle => 'Beheerder bijwerken';

  @override
  String get removeAdminTitle => 'Beheerder verwijderen';

  @override
  String get removeAdminConfirmation =>
      'Beheerder verwijderen? Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get restoreAdminTitle => 'Beheerder herstellen';

  @override
  String get removeAccountConfirmation =>
      'Account verwijderen? Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get cannotRemoveAccountTitle => 'Kan account niet verwijderen';

  @override
  String get cannotRemoveAccountContent =>
      'Je moet alle hubs verlaten voordat je je account kunt verwijderen.';

  @override
  String get cannotChangeEmailWhenOnlyAdminError =>
      'Je kunt je e-mailadres niet wijzigen als je de enige beheerder bent.';

  @override
  String get okButton => 'OK';

  @override
  String get copySiteIdTooltip => 'ID kopiëren';

  @override
  String get siteIdCopied => 'ID naar klembord gekopieerd';

  @override
  String get and => 'en';

  @override
  String get mustAgreeToTermsError =>
      'Je moet akkoord gaan met de voorwaarden.';

  @override
  String get mustAgreeToPrivacyPolicyError =>
      'Je moet akkoord gaan met het privacybeleid.';

  @override
  String get leadingTrailingSpacesError =>
      'Spaties aan het begin of einde zijn niet toegestaan.';

  @override
  String get emailLowercaseError => 'E-mail moet in kleine letters zijn.';

  @override
  String get emailLeadingTrailingSpacesError =>
      'E-mail mag geen spaties aan het begin of einde hebben.';

  @override
  String get formSubmissionError =>
      'Fout bij het verzenden van het formulier, controleer je internetverbinding, ga terug en probeer het opnieuw.';

  @override
  String failedToLoadEvents(String error) {
    return 'Kan gebeurtenissen niet laden: $error';
  }

  @override
  String get showEventsListTooltip => 'Gebeurtenissenlijst tonen';

  @override
  String get showReplayStateTooltip => 'Replaystatus tonen';

  @override
  String get toggleSortOrderTooltip => 'Sorteervolgorde wisselen';

  @override
  String get noEventsToReplay => 'Geen gebeurtenissen om af te spelen.';

  @override
  String eventVersion(int version) {
    return 'Versie: $version';
  }

  @override
  String get loadingTitle => 'Laden...';

  @override
  String authenticationErrorWithDetails(String details) {
    return 'Authenticatiefout: $details';
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
  String get serviceLoginButton => 'Service-inlog';

  @override
  String get english => 'Engels';

  @override
  String get italian => 'Italiaans';

  @override
  String get spanish => 'Spaans';

  @override
  String get catalan => 'Catalaans';

  @override
  String get portuguese => 'Portugees';

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
