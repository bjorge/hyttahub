// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'intl_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class HyttaHubLocalizationsIt extends HyttaHubLocalizations {
  HyttaHubLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get loginTitle => 'Accesso';

  @override
  String get createAccountTitle => 'Crea Account';

  @override
  String get loginWelcomeMessage => 'Benvenuto in Hytta Hub Connections!';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHelperText =>
      'La password deve contenere almeno 16 caratteri.';

  @override
  String get loginSuccessTitle => 'Accesso Riuscito';

  @override
  String get loginEmailEmptyError => 'L\'email non può essere vuota';

  @override
  String get loginEmailInvalidFormatError =>
      'Inserisci un formato email valido.';

  @override
  String get loginEmailReservedError =>
      'Il formato dell\'email (corrisponde a __.*__) non è consentito.';

  @override
  String get loginEmailTooLongError =>
      'L\'email è troppo lunga (max 1500 byte).';

  @override
  String get loginNotServiceAdminError =>
      'Non sei un amministratore del servizio';

  @override
  String get loginNotBetaUserError => 'Non sei un utente beta';

  @override
  String get loginPasswordTooShortError => 'La password è troppo corta.';

  @override
  String get loginAgreeToTermsCheckbox => 'Accetto i Termini';

  @override
  String get loginAgreeToPrivacyPolicyCheckbox =>
      'Accetto l\'Informativa sulla Privacy';

  @override
  String get loginAlreadyHaveAccountButton => 'Hai già un account?';

  @override
  String get loginNeedToCreateAccountButton => 'Devi creare un account?';

  @override
  String get loginForgotPasswordButton => 'Password dimenticata?';

  @override
  String get loginGoToEmailResetPasswordMessage =>
      'Vai alla tua casella di posta elettronica, apri l\'email da Prenotazioni Amichevoli e clicca sul link per creare una nuova password. Quindi torna qui e accedi.';

  @override
  String get loginGoToEmailVerifyEmailMessage =>
      'Vai alla tua casella di posta elettronica, apri l\'email da Prenotazioni Amichevoli e clicca sul link per verificare il tuo indirizzo email. Quindi torna qui e accedi.';

  @override
  String get sites => 'Siti';

  @override
  String get noSites => 'nessun sito';

  @override
  String get initializingAccountTitle => 'Inizializzazione Account';

  @override
  String get serviceCreateAccountTitle => 'Crea Account Servizio';

  @override
  String get serviceLoginTitle => 'Accesso Servizio';

  @override
  String get accountSettingsTitle => 'Impostazioni Account';

  @override
  String get manageSitesTitle => 'Lascia il Sito';

  @override
  String get removeAccountTitle => 'Rimuovi Account';

  @override
  String get logout => 'Logout';

  @override
  String get createSiteTitle => 'Crea Sito';

  @override
  String get joinSiteTitle => 'Unisciti a un Sito';

  @override
  String get unimplementedTitle => 'Non implementato';

  @override
  String get toBeImplemented => 'Prossimamente!';

  @override
  String get siteNameLabel => 'Nome del Sito';

  @override
  String get siteNameEmptyError => 'Il nome del sito non può essere vuoto';

  @override
  String get userNameLabel => 'Nome Utente';

  @override
  String get userNameEmptyError =>
      'Il nome utente del sito non può essere vuoto';

  @override
  String get pasteCodeTooltip => 'Incolla Codice';

  @override
  String get backspaceTooltip => 'Cancella';

  @override
  String get joinSiteCodeLabel => 'Inserisci il codice del sito di 8 caratteri';

  @override
  String get siteCodeEmptyError => 'Il codice del sito non può essere vuoto';

  @override
  String get siteCodeLengthError =>
      'Il codice del sito deve essere di 8 caratteri';

  @override
  String get leaveSiteTooltip => 'Lascia il Sito';

  @override
  String get removeSiteTitle => 'Rimuovi Sito';

  @override
  String get leaveSiteConfirmation =>
      'Lasciare il sito? Solo un amministratore può aggiungerti di nuovo.';

  @override
  String get updateTermsTitle => 'Aggiorna Termini';

  @override
  String get viewTerms => 'Visualizza i Termini';

  @override
  String get viewPrivacyPolicy => 'Visualizza l\'Informativa sulla Privacy';

  @override
  String get agreeToTerms => 'Accetto i Termini di Servizio';

  @override
  String get agreeToPrivacyPolicy => 'Accetto l\'Informativa sulla Privacy';

  @override
  String get showAccountEventsState => 'Mostra Eventi e Stato Account';

  @override
  String get serviceAdminTitle => 'Amministrazione Servizio';

  @override
  String get serviceStatusTitle => 'Stato del Servizio';

  @override
  String get minRequiredVersionTitle => 'Versione Minima Richiesta';

  @override
  String get manageBetaUsersTitle => 'Gestisci Utenti Beta';

  @override
  String get errorFetchingBetaUsers => 'Errore nel recupero degli utenti beta';

  @override
  String get newTermsOfServiceTitle => 'Nuovi Termini di Servizio';

  @override
  String get newPrivacyPolicyTitle => 'Nuova Informativa sulla Privacy';

  @override
  String get manageServiceAdminsTitle => 'Gestisci Amministratori del Servizio';

  @override
  String get showServiceEventsStateTitle =>
      'Mostra Eventi e Stato del Servizio';

  @override
  String get serviceDownTitle => 'Servizio Non Disponibile';

  @override
  String get serviceDownMessage =>
      'Il servizio è temporaneamente non disponibile. Attendere mentre lavoriamo per ripristinarlo.';

  @override
  String get accountEventsTitle => 'Eventi Account (database)';

  @override
  String get accountStateTitle => 'Stato Account (replay locale)';

  @override
  String get serviceEventsTitle => 'Eventi di Servizio (database)';

  @override
  String get serviceStateTitle => 'Stato del Servizio (replay locale)';

  @override
  String get networkErrorTitle => 'Errore di Rete';

  @override
  String get serviceNetworkErrorMessage =>
      'Si è verificato un errore nel contattare il servizio. Controlla la tua connessione internet e riprova.';

  @override
  String get newVersionAvailableTitle => 'Nuova Versione Disponibile';

  @override
  String get newVersionAvailableMessage =>
      'Aggiorna il tuo browser o la tua app all\'ultima versione.';

  @override
  String get privacyPolicyTitle => 'Informativa sulla Privacy';

  @override
  String get noPrivacyPolicyAvailable =>
      'Nessuna informativa sulla privacy disponibile.';

  @override
  String get termsOfServiceTitle => 'Termini di Servizio';

  @override
  String get noTermsAvailable => 'Nessun termine disponibile.';

  @override
  String get uninitializedErrorTitle => 'Errore di Inizializzazione';

  @override
  String get errorTodo => 'Errore: da fare';

  @override
  String get initializeFirebaseEmulator =>
      'Inizializza l\'emulatore di Firebase.';

  @override
  String get successfullySubmittedTodo =>
      'inviato con successo, todo: disabilita i campi';

  @override
  String get errorSubmittingForm => 'Errore durante l\'invio del modulo';

  @override
  String get disallowedCharactersError =>
      'I caratteri \'[\' e \']\' non sono ammessi';

  @override
  String get errorTitle => 'Errore';

  @override
  String get unexpectedError =>
      'Errore imprevisto, controlla la connessione internet, torna indietro e riprova';

  @override
  String get permissionDenied =>
      'Non hai il permesso di eseguire questa azione.';

  @override
  String get addMemberTitle => 'Aggiungi Membro';

  @override
  String get memberNameLabel => 'Nome Membro';

  @override
  String get memberNameEmptyError => 'Il nome del membro non può essere vuoto';

  @override
  String get memberNameExistsError => 'Il nome del membro esiste già';

  @override
  String get administratorLabel => 'Amministratore';

  @override
  String get emailExistsError => 'L\'email esiste già nel sito';

  @override
  String get renameSiteTitle => 'Rinomina Sito';

  @override
  String get newSiteNameLabel => 'Nuovo Nome Sito';

  @override
  String get siteEmailsTitle => 'Email del Sito (database)';

  @override
  String get siteEventsTitle => 'Eventi del Sito (database)';

  @override
  String get siteStateTitle => 'Stato del Sito (replay locale)';

  @override
  String get membersTitle => 'Membri';

  @override
  String get serviceSettingsTitle => 'Impostazioni Servizio';

  @override
  String get termsOfServiceContentLabel => 'Contenuto dei Termini di Servizio';

  @override
  String get termsOfServiceContentEmptyError =>
      'Inserisci il contenuto dei termini di servizio.';

  @override
  String get contentTooShortError => 'Il contenuto è troppo corto.';

  @override
  String get privacyPolicyContentLabel =>
      'Contenuto dell\'Informativa sulla Privacy';

  @override
  String get privacyPolicyContentEmptyError =>
      'Inserisci il contenuto dell\'informativa sulla privacy.';

  @override
  String get serviceUnavailableLabel => 'Servizio Non Disponibile';

  @override
  String get minVersionLabel => 'Versione Minima';

  @override
  String get versionNumberEmptyError => 'Inserisci un numero di versione.';

  @override
  String get versionNumberInvalidError =>
      'Inserisci un numero positivo valido.';

  @override
  String get betaUserEmailsLabel => 'Email Utenti Beta (separate da virgola)';

  @override
  String get aliasLabel => 'Alias';

  @override
  String get nicknameEmptyError => 'Il soprannome non può essere vuoto';

  @override
  String get adminAliasExistsError =>
      'L\'alias dell\'amministratore esiste già';

  @override
  String get failedToLoadEmails => 'Impossibile caricare le email.';

  @override
  String get permissionDeniedViewList =>
      'Non hai il permesso di visualizzare questo elenco.';

  @override
  String get noEmailsFound => 'Nessuna email trovata.';

  @override
  String userId(int userId) {
    return 'ID utente: $userId';
  }

  @override
  String get removeMemberTooltip => 'Rimuovi Membro';

  @override
  String get removeMemberTitle => 'Rimuovi Membro';

  @override
  String get removeMemberConfirmation =>
      'Rimuovere il membro? Questa azione non può essere annullata.';

  @override
  String get updateMemberTooltip => 'Aggiorna membro';

  @override
  String get updateMemberTitle => 'Aggiorna membro';

  @override
  String get restoreMemberTooltip => 'Ripristina membro';

  @override
  String get restoreMemberTitle => 'Ripristina membro';

  @override
  String get removedMembersTitle => 'Membri rimossi';

  @override
  String get addAdminTitle => 'Aggiungi amministratore';

  @override
  String get updateAdminTitle => 'Aggiorna amministratore';

  @override
  String get removeAdminTitle => 'Rimuovi amministratore';

  @override
  String get removeAdminConfirmation =>
      'Rimuovere l\'amministratore? Questa azione non può essere annullata.';

  @override
  String get restoreAdminTitle => 'Ripristina amministratore';

  @override
  String get removeAccountConfirmation =>
      'Rimuovere l\'account? Questa azione non può essere annullata.';

  @override
  String get cannotRemoveAccountTitle => 'Impossibile Rimuovere l\'Account';

  @override
  String get cannotRemoveAccountContent =>
      'Devi lasciare tutti i siti prima di poter rimuovere il tuo account.';

  @override
  String get cannotChangeEmailWhenOnlyAdminError =>
      'Non puoi cambiare la tua email quando sei l\'unico amministratore.';

  @override
  String get okButton => 'OK';

  @override
  String get copySiteIdTooltip => 'Copia ID sito';

  @override
  String get siteIdCopied => 'ID del sito copiato negli appunti';

  @override
  String get and => 'e';

  @override
  String get mustAgreeToTermsError => 'Devi accettare i termini.';

  @override
  String get mustAgreeToPrivacyPolicyError =>
      'Devi accettare l\'informativa sulla privacy.';

  @override
  String get leadingTrailingSpacesError =>
      'Non sono consentiti spazi iniziali o finali.';

  @override
  String get emailLowercaseError => 'L\'email deve essere in minuscolo.';

  @override
  String get emailLeadingTrailingSpacesError =>
      'L\'email non può avere spazi iniziali o finali.';

  @override
  String get formSubmissionError =>
      'Errore durante l\'invio del modulo, controlla la connessione internet, torna indietro e riprova.';

  @override
  String failedToLoadEvents(String error) {
    return 'Impossibile caricare gli eventi: $error';
  }

  @override
  String get showEventsListTooltip => 'Mostra elenco eventi';

  @override
  String get showReplayStateTooltip => 'Mostra stato di riproduzione';

  @override
  String get toggleSortOrderTooltip => 'Cambia ordine';

  @override
  String get noEventsToReplay => 'Nessun evento da riprodurre.';

  @override
  String eventVersion(int version) {
    return 'Versione: $version';
  }

  @override
  String get loadingTitle => 'Caricamento in corso...';

  @override
  String authenticationErrorWithDetails(String details) {
    return 'Errore di autenticazione: $details';
  }

  @override
  String get loadingEllipsis => '...';

  @override
  String get loginDismissSnackbar => 'Ignora';

  @override
  String get passwordEmptyError => 'La password non può essere vuota.';

  @override
  String get passwordTooShortError => 'La password è troppo corta.';

  @override
  String get passwordTooLongError => 'La password è troppo lunga.';

  @override
  String get exportSiteTitle => 'Esporta Sito';

  @override
  String get manageExportsTitle => 'Gestisci Esportazioni';

  @override
  String get exportDeletedSuccessfully => 'Esportazione eliminata con successo';

  @override
  String get noExportsFound => 'Nessuna esportazione trovata.';

  @override
  String get failedToLoadExports => 'Impossibile caricare le esportazioni.';

  @override
  String get importSiteTitle => 'Importa Sito';

  @override
  String get selectFileButton => 'Seleziona File';

  @override
  String get importButton => 'Importa';

  @override
  String get selectAdminTitle => 'Seleziona il tuo Account Amministratore';

  @override
  String get selectAdminInstruction =>
      'Seleziona il tuo account amministratore dall\'elenco degli amministratori del sito importato.';

  @override
  String get assignUserButton => 'Assegna Utente';
}
