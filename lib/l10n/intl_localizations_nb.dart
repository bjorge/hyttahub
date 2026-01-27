// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'intl_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class HyttaHubLocalizationsNb extends HyttaHubLocalizations {
  HyttaHubLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get loginTitle => 'Logg inn';

  @override
  String get createAccountTitle => 'Opprett konto';

  @override
  String get loginEmailLabel => 'E-post';

  @override
  String get loginPasswordLabel => 'Passord';

  @override
  String get loginPasswordHelperText =>
      'Passordet må være minst 16 tegn langt.';

  @override
  String get loginSuccessTitle => 'Innlogging vellykket';

  @override
  String get loginEmailEmptyError => 'E-post kan ikke være tom';

  @override
  String get loginEmailInvalidFormatError =>
      'Vennligst oppgi en gyldig e-postadresse.';

  @override
  String get loginEmailReservedError =>
      'E-postformatet (matcher __.*__) er ikke tillatt.';

  @override
  String get loginEmailTooLongError => 'E-posten er for lang (maks 1500 byte).';

  @override
  String get loginNotServiceAdminError => 'Ikke en tjenesteadministrator';

  @override
  String get loginNotBetaUserError => 'Ikke en autorisert e-post';

  @override
  String get loginAgreeToTermsCheckbox => 'Jeg godtar vilkårene';

  @override
  String get loginAgreeToPrivacyPolicyCheckbox =>
      'Jeg godtar personvernreglene';

  @override
  String get loginAlreadyHaveAccountButton => 'Har du allerede en konto?';

  @override
  String get loginNeedToCreateAccountButton =>
      'Trenger du å opprette en konto?';

  @override
  String get loginForgotPasswordButton => 'Glemt passord?';

  @override
  String get loginGoToEmailResetPasswordMessage =>
      'Gå til e-postinnboksen din, åpne e-posten og klikk på lenken for å opprette et nytt passord. Gå deretter tilbake hit og logg inn.';

  @override
  String get loginGoToEmailVerifyEmailMessage =>
      'Gå til e-postinnboksen din, åpne e-posten og klikk på lenken for å bekrefte e-postadressen din. Gå deretter tilbake hit og logg inn.';

  @override
  String app_versionInfo(String appVersion, num appBuildNumber) {
    return 'Versjon $appVersion ($appBuildNumber)';
  }

  @override
  String get sites => 'Nettsteder';

  @override
  String get noSites => 'ingen nettsteder';

  @override
  String get initializingAccountTitle => 'Initialiserer konto';

  @override
  String get serviceCreateAccountTitle => 'Opprett tjenestekonto';

  @override
  String get serviceLoginTitle => 'Tjenestepålogging';

  @override
  String get accountSettingsTitle => 'Kontoinnstillinger';

  @override
  String get manageSitesTitle => 'Forlat sted';

  @override
  String get removeAccountTitle => 'Fjern konto';

  @override
  String get logout => 'Logg ut';

  @override
  String get logoutDialogTitle => 'Logg ut?';

  @override
  String get logoutDialogMessage => 'Er du sikker på at du vil logge ut?';

  @override
  String get cancelButton => 'Avbryt';

  @override
  String get createSiteTitle => 'Opprett sted';

  @override
  String get joinSiteTitle => 'Bli med i et sted';

  @override
  String get unimplementedTitle => 'Ikke implementert';

  @override
  String get toBeImplemented => 'Kommer snart!';

  @override
  String get siteNameLabel => 'Stedsnavn';

  @override
  String get siteNameEmptyError => 'Stedsnavn kan ikke være tomt';

  @override
  String get userNameLabel => 'Brukernavn';

  @override
  String get userNameEmptyError => 'Brukernavn kan ikke være tomt';

  @override
  String get pasteCodeTooltip => 'Lim inn kode';

  @override
  String get backspaceTooltip => 'Tilbake';

  @override
  String get joinSiteCodeLabel => 'Skriv inn 8-tegns stedskode';

  @override
  String get siteCodeEmptyError => 'Stedskode kan ikke være tom';

  @override
  String get siteCodeLengthError => 'Stedskode må være 8 tegn lang';

  @override
  String get leaveSiteTooltip => 'Forlat stedet';

  @override
  String get removeSiteTitle => 'Fjern sted';

  @override
  String get leaveSiteConfirmation =>
      'Forlate stedet? Kun en administrator kan legge deg til igjen.';

  @override
  String get updateTermsTitle => 'Oppdater vilkår';

  @override
  String get viewTerms => 'Vis vilkår';

  @override
  String get viewPrivacyPolicy => 'Vis personvernreglene';

  @override
  String get agreeToTerms => 'Jeg godtar tjenestevilkårene';

  @override
  String get agreeToPrivacyPolicy => 'Jeg godtar personvernreglene';

  @override
  String get showAccountEventsState => 'Vis kontohendelser og tilstand';

  @override
  String get serviceAdminTitle => 'Tjenesteadministrator';

  @override
  String get serviceStatusTitle => 'Tjenestestatus';

  @override
  String get minRequiredVersionTitle => 'Minimum påkrevd versjon';

  @override
  String get manageBetaUsersTitle => 'Administrer betabrukere';

  @override
  String get errorFetchingBetaUsers => 'Feil ved henting av betabrukere';

  @override
  String get newTermsOfServiceTitle => 'Nye tjenestevilkår';

  @override
  String get newPrivacyPolicyTitle => 'Ny personvernpolicy';

  @override
  String get manageServiceAdminsTitle => 'Administrer tjenesteadministratorer';

  @override
  String get showServiceEventsStateTitle => 'Vis tjenestehendelser og tilstand';

  @override
  String get serviceDownTitle => 'Tjenesten er nede';

  @override
  String get serviceDownMessage =>
      'Tjenesten er midlertidig utilgjengelig. Vennligst vent mens vi jobber med å gjenopprette den.';

  @override
  String get accountEventsTitle => 'Kontohendelser (database)';

  @override
  String get accountStateTitle => 'Konto‑tilstand (lokal avspilling)';

  @override
  String get serviceEventsTitle => 'Tjenestehendelser (database)';

  @override
  String get serviceStateTitle => 'Tjenestetilstand (lokal avspilling)';

  @override
  String get networkErrorTitle => 'Nettverksfeil';

  @override
  String get serviceNetworkErrorMessage =>
      'Det oppstod en feil ved kontakt med tjenesten. Sjekk internettforbindelsen og prøv igjen.';

  @override
  String get newVersionAvailableTitle => 'Ny versjon tilgjengelig';

  @override
  String get newVersionAvailableMessage =>
      'Vennligst oppdater nettleseren eller appen til siste versjon.';

  @override
  String get privacyPolicyTitle => 'Personvernregler';

  @override
  String get noPrivacyPolicyAvailable => 'Ingen personvernpolicy tilgjengelig.';

  @override
  String get termsOfServiceTitle => 'Vilkår for bruk';

  @override
  String get noTermsAvailable => 'Ingen vilkår tilgjengelig.';

  @override
  String get initializeDataStoreTitle => 'Initialize the Data Store';

  @override
  String get errorTodo => 'Feil: todo';

  @override
  String get initializeDataStoreBody =>
      'The data store is empty. Create the first service admin in order to initialize the system.';

  @override
  String get successfullySubmittedTodo =>
      'Sendt inn vellykket. TODO: grå ut feltene';

  @override
  String get errorSubmittingForm => 'Feil ved innsending av skjema';

  @override
  String get disallowedCharactersError =>
      'Tegnene \'[\' og \']\' er ikke tillatt';

  @override
  String get errorTitle => 'Feil';

  @override
  String get unexpectedError =>
      'Uventet feil, sjekk internett, gå tilbake og prøv igjen';

  @override
  String get permissionDenied =>
      'Du har ikke tillatelse til å utføre denne handlingen.';

  @override
  String get addMemberTitle => 'Legg til medlem';

  @override
  String get memberNameLabel => 'Medlemsnavn';

  @override
  String get memberNameEmptyError => 'Medlemsnavn kan ikke være tomt';

  @override
  String get memberNameExistsError => 'Medlemsnavn finnes allerede';

  @override
  String get administratorLabel => 'Administrator';

  @override
  String get emailExistsError => 'E-post finnes allerede på stedet';

  @override
  String get renameSiteTitle => 'Gi nytt navn til sted';

  @override
  String get manageSiteMembers => 'Administrer stedets medlemmer';

  @override
  String get showSiteEventsState => 'Vis stedhendelser og tilstand';

  @override
  String get showSiteAllowedEmails => 'Vis stedets tillatte e-poster';

  @override
  String get siteSettingsTitle => 'Stedsinnstillinger';

  @override
  String get newSiteNameLabel => 'Nytt stedsnavn';

  @override
  String get siteEmailsTitle => 'Stedets e-poster (database)';

  @override
  String get siteEventsTitle => 'Stedhendelser (database)';

  @override
  String get siteStateTitle => 'Stedtilstand (lokal avspilling)';

  @override
  String get membersTitle => 'Medlemmer';

  @override
  String get serviceSettingsTitle => 'Tjenesteinnstillinger';

  @override
  String get termsOfServiceContentLabel => 'Innhold i tjenestevilkårene';

  @override
  String get termsOfServiceContentEmptyError =>
      'Vennligst skriv inn innholdet i tjenestevilkårene.';

  @override
  String get contentTooShortError => 'Innholdet er for kort.';

  @override
  String get privacyPolicyContentLabel => 'Innhold i personvernpolicy';

  @override
  String get privacyPolicyContentEmptyError =>
      'Vennligst skriv inn innholdet i personvernpolicyen.';

  @override
  String get serviceUnavailableLabel => 'Tjenesten utilgjengelig';

  @override
  String get minVersionLabel => 'Min versjon';

  @override
  String get versionNumberEmptyError =>
      'Vennligst skriv inn et versjonsnummer.';

  @override
  String get versionNumberInvalidError =>
      'Vennligst skriv inn et gyldig positivt tall.';

  @override
  String get betaUserEmailsLabel =>
      'E-postadresser for betabrukere (kommadelt)';

  @override
  String get aliasLabel => 'Alias';

  @override
  String get nicknameEmptyError => 'Kallenavn kan ikke være tomt';

  @override
  String get adminAliasExistsError => 'Administratoralias finnes allerede';

  @override
  String get failedToLoadEmails => 'Kunne ikke laste inn e-poster.';

  @override
  String get permissionDeniedViewList =>
      'Du har ikke tillatelse til å se denne listen.';

  @override
  String get noEmailsFound => 'Ingen e-poster funnet.';

  @override
  String userId(int userId) {
    return 'Bruker-ID: $userId';
  }

  @override
  String get removeMemberTooltip => 'Fjern medlem';

  @override
  String get removeMemberTitle => 'Fjern medlem';

  @override
  String get removeMemberConfirmation =>
      'Fjerne medlem? Denne handlingen kan ikke angres.';

  @override
  String get updateMemberTooltip => 'Oppdater medlem';

  @override
  String get updateMemberTitle => 'Oppdater medlem';

  @override
  String get restoreMemberTooltip => 'Gjenopprett medlem';

  @override
  String get restoreMemberTitle => 'Gjenopprett medlem';

  @override
  String get removedMembersTitle => 'Slettede medlemmer';

  @override
  String get addAdminTitle => 'Legg til administrator';

  @override
  String get updateAdminTitle => 'Oppdater administrator';

  @override
  String get removeAdminTitle => 'Fjern administrator';

  @override
  String get removeAdminConfirmation =>
      'Fjerne administrator? Denne handlingen kan ikke angres.';

  @override
  String get restoreAdminTitle => 'Gjenopprett administrator';

  @override
  String get removeAccountConfirmation =>
      'Fjerne konto? Denne handlingen kan ikke angres.';

  @override
  String get cannotRemoveAccountTitle => 'Kan ikke fjerne konto';

  @override
  String get cannotRemoveAccountContent =>
      'Du må forlate alle steder før du kan fjerne kontoen din.';

  @override
  String get cannotChangeEmailWhenOnlyAdminError =>
      'Du kan ikke endre e-posten din når du er den eneste administratoren.';

  @override
  String get okButton => 'OK';

  @override
  String get copySiteIdTooltip => 'Kopier sted-ID';

  @override
  String get siteIdCopied => 'Sted-ID kopiert til utklippstavlen';

  @override
  String get and => '&';

  @override
  String get mustAgreeToTermsError => 'Du må godta vilkårene.';

  @override
  String get mustAgreeToPrivacyPolicyError => 'Du må godta personvernpolicyen.';

  @override
  String get leadingTrailingSpacesError =>
      'Innledende eller avsluttende mellomrom er ikke tillatt.';

  @override
  String get emailLowercaseError => 'E-post må være skrevet med små bokstaver.';

  @override
  String get emailLeadingTrailingSpacesError =>
      'E-post kan ikke ha innledende eller avsluttende mellomrom.';

  @override
  String get formSubmissionError =>
      'Feil ved innsending av skjemaet, sjekk internettforbindelsen, gå tilbake og prøv igjen.';

  @override
  String failedToLoadEvents(String error) {
    return 'Kunne ikke laste hendelser: $error';
  }

  @override
  String get showEventsListTooltip => 'Vis hendelsesliste';

  @override
  String get showReplayStateTooltip => 'Vis avspillingsstatus';

  @override
  String get toggleSortOrderTooltip => 'Bytt sorteringsrekkefølge';

  @override
  String get noEventsToReplay => 'Ingen hendelser å spille av.';

  @override
  String eventVersion(int version) {
    return 'Versjon: $version';
  }

  @override
  String get loadingTitle => 'Laster...';

  @override
  String authenticationErrorWithDetails(String details) {
    return 'Autentiseringsfeil: $details';
  }

  @override
  String get loadingEllipsis => '...';

  @override
  String get loginDismissSnackbar => 'Lukk';

  @override
  String get passwordEmptyError => 'Passord kan ikke være tomt.';

  @override
  String get passwordTooShortError => 'Passordet er for kort.';

  @override
  String get passwordTooLongError => 'Passordet er for langt.';

  @override
  String get exportSiteTitle => 'Eksporter sted';

  @override
  String get manageExportsTitle => 'Administrer eksport';

  @override
  String get exportDeletedSuccessfully => 'Eksport slettet';

  @override
  String get noExportsFound => 'Ingen eksport funnet.';

  @override
  String get failedToLoadExports => 'Kunne ikke laste eksportene.';

  @override
  String get noEventsFound => 'Ingen hendelser funnet.';

  @override
  String get importSiteTitle => 'Importer sted';

  @override
  String get selectFileButton => 'Velg fil';

  @override
  String get importButton => 'Importer';

  @override
  String get selectAdminTitle => 'Velg din administrator-konto';

  @override
  String get selectAdminInstruction =>
      'Velg administrator-kontoen din fra listen over administratorer for det importerte stedet.';

  @override
  String get assignUserButton => 'Tildel bruker';

  @override
  String get exportDetailsTitle => 'Eksportdetaljer';

  @override
  String largeFileWarning(int sizeInMB) {
    return 'Stor fil oppdaget (${sizeInMB}MB). Opplasting kan ta flere minutter.';
  }

  @override
  String selectedFile(String fileName) {
    return 'Valgt fil: $fileName';
  }

  @override
  String fileSizeLabel(int sizeInMB) {
    return 'Størrelse: ${sizeInMB}MB';
  }

  @override
  String uploadingProgress(String progress) {
    return 'Laster opp: $progress%';
  }

  @override
  String get processingImport =>
      'Behandler import, dette kan ta opptil 10 minutter. Vennligst vent og bli på denne skjermen...';

  @override
  String get userMustBeSignedIn =>
      'Bruker må være pålogget for å importere sted';

  @override
  String errorImportingSite(String error) {
    return 'Feil ved import av sted: $error';
  }

  @override
  String errorAssigningUser(String error) {
    return 'Feil ved tildeling av bruker: $error';
  }

  @override
  String get selectLanguage => 'Velg språk';

  @override
  String get nightMode => 'Nattmodus';

  @override
  String get platform => 'Plattform';

  @override
  String get info => 'Info';

  @override
  String get serviceLoginButton => 'Tjenestepålogging';

  @override
  String get english => 'Engelsk';

  @override
  String get italian => 'Italiensk';

  @override
  String get spanish => 'Spansk';

  @override
  String get norwegian => 'Norsk';

  @override
  String get dutch => 'Nederlandsk';

  @override
  String get themeSettingsAutomatic => 'Automatisk';

  @override
  String get themeSettingsAlwaysOff => 'Alltid av';

  @override
  String get themeSettingsAlwaysOn => 'Alltid på';

  @override
  String get openSourceLicensesButton => 'Open Source-pakker';

  @override
  String get openSourceLicensesTitle => 'Open Source-pakker';

  @override
  String get siteInfoTitle => 'Sideinformasjon';

  @override
  String get siteEventCount => 'Antall hendelser';

  @override
  String get siteTotalSize => 'Total størrelse';

  @override
  String bytesLabel(int size) {
    return '$size byte';
  }

  @override
  String get siteFileCount => 'Antall filer';

  @override
  String get siteTotalFileSize => 'Total filstørrelse';

  @override
  String get errorFetchingFiles => 'Feil ved henting av filer';
}
