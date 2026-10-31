// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'intl_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class HyttaHubLocalizationsCa extends HyttaHubLocalizations {
  HyttaHubLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get loginTitle => 'Inici de sessió';

  @override
  String get createAccountTitle => 'Crea un compte';

  @override
  String get loginEmailLabel => 'Correu electrònic';

  @override
  String get loginPasswordLabel => 'Contrasenya';

  @override
  String get loginPasswordHelperText =>
      'La contrasenya ha de tenir com a mínim 16 caràcters.';

  @override
  String get loginSuccessTitle => 'Sessió iniciada';

  @override
  String get loginEmailEmptyError => 'El correu electrònic no pot estar buit';

  @override
  String get loginEmailInvalidFormatError =>
      'Introdueix una adreça de correu electrònic vàlida.';

  @override
  String get loginEmailReservedError =>
      'El format del correu electrònic (coincideix amb __.*__) no està permès.';

  @override
  String get loginEmailTooLongError =>
      'El correu electrònic és massa llarg (màxim 1500 bytes).';

  @override
  String get loginNotServiceAdminError => 'No és un administrador del servei';

  @override
  String get loginNotBetaUserError => 'No és un correu electrònic autoritzat';

  @override
  String get loginAgreeToTermsCheckbox => 'Accepto les condicions';

  @override
  String get loginAgreeToPrivacyPolicyCheckbox =>
      'Accepto la política de privadesa';

  @override
  String get loginAlreadyHaveAccountButton => 'Ja tens un compte?';

  @override
  String get loginNeedToCreateAccountButton => 'Necessites crear un compte?';

  @override
  String get loginForgotPasswordButton => 'Has oblidat la contrasenya?';

  @override
  String get loginGoToEmailResetPasswordMessage =>
      'Ves a la teva safata d\'entrada, obre el correu i fes clic a l\'enllaç per crear una contrasenya nova. Després torna aquí i inicia la sessió.';

  @override
  String get loginGoToEmailVerifyEmailMessage =>
      'Ves a la teva safata d\'entrada, obre el correu i fes clic a l\'enllaç per verificar la teva adreça electrònica. Després torna aquí i inicia la sessió.';

  @override
  String app_versionInfo(String appVersion, num appBuildNumber) {
    return 'Versió $appVersion ($appBuildNumber)';
  }

  @override
  String get sites => 'Hubs';

  @override
  String get noSites => 'cap hub';

  @override
  String get initializingAccountTitle => 'S\'està inicialitzant el compte';

  @override
  String get serviceCreateAccountTitle => 'Crea un compte de servei';

  @override
  String get serviceLoginTitle => 'Inici de sessió del servei';

  @override
  String get accountSettingsTitle => 'Configuració del compte';

  @override
  String get manageSitesTitle => 'Abandona';

  @override
  String get reorderSitesTitle => 'Reordena';

  @override
  String get removeAccountTitle => 'Elimina el compte';

  @override
  String get logout => 'Tanca la sessió';

  @override
  String get logoutDialogTitle => 'Vols tancar la sessió?';

  @override
  String get logoutDialogMessage => 'Segur que vols tancar la sessió?';

  @override
  String get cancelButton => 'Cancel·la';

  @override
  String get createSiteTitle => 'Crea un hub';

  @override
  String get joinSiteTitle => 'Uneix-te a un hub';

  @override
  String get unimplementedTitle => 'No implementat';

  @override
  String get toBeImplemented => 'Properament!';

  @override
  String get siteNameLabel => 'Nom';

  @override
  String get siteNameEmptyError => 'El nom no pot estar buit';

  @override
  String get userNameLabel => 'Nom d\'usuari';

  @override
  String get userNameEmptyError => 'El nom d\'usuari no pot estar buit';

  @override
  String get pasteCodeTooltip => 'Enganxa el codi';

  @override
  String get backspaceTooltip => 'Retrocés';

  @override
  String get joinSiteCodeLabel => 'Introdueix el codi de 8 caràcters';

  @override
  String get siteCodeEmptyError => 'El codi no pot estar buit';

  @override
  String get siteCodeLengthError => 'El codi ha de tenir 8 caràcters';

  @override
  String get leaveSiteTooltip => 'Abandona';

  @override
  String get removeSiteTitle => 'Elimina';

  @override
  String get leaveSiteConfirmation =>
      'Vols abandonar-lo? Només un administrador et pot tornar a afegir.';

  @override
  String get updateTermsTitle => 'Actualitza les condicions';

  @override
  String get viewTerms => 'Mostra les condicions';

  @override
  String get viewPrivacyPolicy => 'Mostra la política de privadesa';

  @override
  String get agreeToTerms => 'Accepto les condicions del servei';

  @override
  String get agreeToPrivacyPolicy => 'Accepto la política de privadesa';

  @override
  String get showAccountEventsState =>
      'Mostra els esdeveniments i l\'estat del compte';

  @override
  String get serviceAdminTitle => 'Administració del servei';

  @override
  String get serviceStatusTitle => 'Estat del servei';

  @override
  String get minRequiredVersionTitle => 'Versió mínima requerida';

  @override
  String get manageBetaUsersTitle => 'Gestiona els usuaris beta';

  @override
  String get errorFetchingBetaUsers =>
      'S\'ha produït un error en obtenir els usuaris beta';

  @override
  String get newTermsOfServiceTitle => 'Noves condicions del servei';

  @override
  String get newPrivacyPolicyTitle => 'Nova política de privadesa';

  @override
  String get manageServiceAdminsTitle =>
      'Gestiona els administradors del servei';

  @override
  String get showServiceEventsStateTitle =>
      'Mostra els esdeveniments i l\'estat del servei';

  @override
  String get serviceDownTitle => 'Servei no disponible';

  @override
  String get serviceDownMessage =>
      'El servei no està disponible temporalment. Espera mentre treballem per restablir-lo.';

  @override
  String get accountEventsTitle => 'Esdeveniments del compte (base de dades)';

  @override
  String get accountStateTitle => 'Estat del compte (reproducció local)';

  @override
  String get serviceEventsTitle => 'Esdeveniments del servei (base de dades)';

  @override
  String get serviceStateTitle => 'Estat del servei (reproducció local)';

  @override
  String get networkErrorTitle => 'Error de xarxa';

  @override
  String get serviceNetworkErrorMessage =>
      'S\'ha produït un error en contactar amb el servei. Comprova la connexió a Internet i torna-ho a provar.';

  @override
  String get newVersionAvailableTitle => 'Hi ha una versió nova disponible';

  @override
  String get newVersionAvailableMessage =>
      'Actualitza el navegador o l\'aplicació a la darrera versió.';

  @override
  String get privacyPolicyTitle => 'Política de privadesa';

  @override
  String get noPrivacyPolicyAvailable =>
      'No hi ha cap política de privadesa disponible.';

  @override
  String get termsOfServiceTitle => 'Condicions del servei';

  @override
  String get noTermsAvailable => 'No hi ha cap condició disponible.';

  @override
  String get initializeDataStoreTitle => 'Inicialitza el magatzem de dades';

  @override
  String get errorTodo => 'Error: todo';

  @override
  String get initializeDataStoreBody =>
      'El magatzem de dades és buit. Crea el primer administrador del servei per inicialitzar el sistema.';

  @override
  String get successfullySubmittedTodo =>
      's\'ha enviat correctament, todo: desactivar els camps';

  @override
  String get errorSubmittingForm =>
      'S\'ha produït un error en enviar el formulari';

  @override
  String get disallowedCharactersError =>
      'Els caràcters \'[\' i \']\' no estan permesos';

  @override
  String get errorTitle => 'Error';

  @override
  String get unexpectedError =>
      'Error inesperat; comprova la connexió a Internet, torna enrere i prova-ho de nou';

  @override
  String get permissionDenied => 'No tens permís per fer aquesta acció.';

  @override
  String get removedFromSite => 'Se t\'ha eliminat.';

  @override
  String get addMemberTitle => 'Afegeix un membre';

  @override
  String get memberNameLabel => 'Nom del membre';

  @override
  String get memberNameEmptyError => 'El nom del membre no pot estar buit';

  @override
  String get memberNameExistsError => 'El nom del membre ja existeix';

  @override
  String get administratorLabel => 'Administrador';

  @override
  String get emailExistsError => 'El correu electrònic ja existeix.';

  @override
  String get renameSiteTitle => 'Canvia el nom';

  @override
  String get manageSiteMembers => 'Membres';

  @override
  String get showSiteEventsState => 'Mostra els esdeveniments i l\'estat';

  @override
  String get showSiteAllowedEmails => 'Correus permesos';

  @override
  String get siteSettingsTitle => 'Configuració';

  @override
  String get newSiteNameLabel => 'Nom nou';

  @override
  String get siteEmailsTitle => 'Correus del hub (base de dades)';

  @override
  String get siteEventsTitle => 'Esdeveniments del hub (base de dades)';

  @override
  String get siteStateTitle => 'Estat del hub (reproducció local)';

  @override
  String get membersTitle => 'Membres';

  @override
  String get serviceSettingsTitle => 'Configuració del servei';

  @override
  String get termsOfServiceContentLabel =>
      'Contingut de les condicions del servei';

  @override
  String get termsOfServiceContentEmptyError =>
      'Introdueix el contingut de les condicions del servei.';

  @override
  String get contentTooShortError => 'El contingut és massa curt.';

  @override
  String get privacyPolicyContentLabel =>
      'Contingut de la política de privadesa';

  @override
  String get privacyPolicyContentEmptyError =>
      'Introdueix el contingut de la política de privadesa.';

  @override
  String get serviceUnavailableLabel => 'Servei no disponible';

  @override
  String get minVersionLabel => 'Versió mínima';

  @override
  String get versionNumberEmptyError => 'Introdueix un número de versió.';

  @override
  String get versionNumberInvalidError => 'Introdueix un número positiu vàlid.';

  @override
  String get betaUserEmailsLabel => 'Correus dels usuaris beta';

  @override
  String get aliasLabel => 'Àlies';

  @override
  String get nicknameEmptyError => 'El sobrenom no pot estar buit';

  @override
  String get adminAliasExistsError => 'L\'àlies d\'administrador ja existeix';

  @override
  String get failedToLoadEmails => 'No s\'han pogut carregar els correus.';

  @override
  String get permissionDeniedViewList =>
      'No tens permís per veure aquesta llista.';

  @override
  String get noEmailsFound => 'No s\'ha trobat cap correu.';

  @override
  String userId(int userId) {
    return 'ID d\'usuari: $userId';
  }

  @override
  String get removeMemberTooltip => 'Elimina el membre';

  @override
  String get removeMemberTitle => 'Elimina el membre';

  @override
  String get removeMemberConfirmation =>
      'Vols eliminar el membre? Aquesta acció no es pot desfer.';

  @override
  String get updateMemberTooltip => 'Actualitza el membre';

  @override
  String get updateMemberTitle => 'Actualitza el membre';

  @override
  String get restoreMemberTooltip => 'Restaura el membre';

  @override
  String get restoreMemberTitle => 'Restaura el membre';

  @override
  String get removedMembersTitle => 'Membres eliminats';

  @override
  String get addAdminTitle => 'Afegeix un administrador';

  @override
  String get updateAdminTitle => 'Actualitza l\'administrador';

  @override
  String get removeAdminTitle => 'Elimina l\'administrador';

  @override
  String get removeAdminConfirmation =>
      'Vols eliminar l\'administrador? Aquesta acció no es pot desfer.';

  @override
  String get restoreAdminTitle => 'Restaura l\'administrador';

  @override
  String get removeAccountConfirmation =>
      'Vols eliminar el compte? Aquesta acció no es pot desfer.';

  @override
  String get cannotRemoveAccountTitle => 'No es pot eliminar el compte';

  @override
  String get cannotRemoveAccountContent =>
      'Has d\'abandonar tots els hubs abans de poder eliminar el teu compte.';

  @override
  String get cannotChangeEmailWhenOnlyAdminError =>
      'No pots canviar el teu correu electrònic quan ets l\'únic administrador.';

  @override
  String get okButton => 'D\'acord';

  @override
  String get copySiteIdTooltip => 'Copia l\'ID';

  @override
  String get siteIdCopied => 'S\'ha copiat l\'ID al porta-retalls';

  @override
  String get and => 'i';

  @override
  String get mustAgreeToTermsError => 'Has d\'acceptar les condicions.';

  @override
  String get mustAgreeToPrivacyPolicyError =>
      'Has d\'acceptar la política de privadesa.';

  @override
  String get leadingTrailingSpacesError =>
      'No es permeten espais al principi ni al final.';

  @override
  String get emailLowercaseError =>
      'El correu electrònic ha d\'estar en minúscules.';

  @override
  String get emailLeadingTrailingSpacesError =>
      'El correu electrònic no pot tenir espais al principi ni al final.';

  @override
  String get formSubmissionError =>
      'S\'ha produït un error en enviar el formulari; comprova la connexió a Internet, torna enrere i prova-ho de nou.';

  @override
  String failedToLoadEvents(String error) {
    return 'No s\'han pogut carregar els esdeveniments: $error';
  }

  @override
  String get showEventsListTooltip => 'Mostra la llista d\'esdeveniments';

  @override
  String get showReplayStateTooltip => 'Mostra l\'estat de la reproducció';

  @override
  String get toggleSortOrderTooltip => 'Canvia el criteri d\'ordenació';

  @override
  String get noEventsToReplay => 'No hi ha esdeveniments per reproduir.';

  @override
  String eventVersion(int version) {
    return 'Versió: $version';
  }

  @override
  String get loadingTitle => 'S\'està carregant...';

  @override
  String authenticationErrorWithDetails(String details) {
    return 'Error d\'autenticació: $details';
  }

  @override
  String get loadingEllipsis => '...';

  @override
  String get loginDismissSnackbar => 'Descarta';

  @override
  String get passwordEmptyError => 'La contrasenya no pot estar buida.';

  @override
  String get passwordTooShortError => 'La contrasenya és massa curta.';

  @override
  String get passwordTooLongError => 'La contrasenya és massa llarga.';

  @override
  String get noEventsFound => 'No s\'ha trobat cap esdeveniment.';

  @override
  String get copySiteTitle => 'Copia';

  @override
  String get copySiteTooltip => 'Copia';

  @override
  String get copySiteConfirmTitle => 'Confirmació de la còpia';

  @override
  String get copySiteConfirmMessage =>
      'En copiar-lo es crearà un hub privat duplicat per a tu. Tingues en compte que copiar els fitxers multimèdia pot trigar una estona. Podràs editar el nom nou i afegir membres un cop s\'hagi completat la còpia.';

  @override
  String errorAssigningUser(String error) {
    return 'S\'ha produït un error en assignar l\'usuari: $error';
  }

  @override
  String get selectLanguage => 'Selecciona l\'idioma';

  @override
  String get nightMode => 'Mode nocturn';

  @override
  String get platform => 'Plataforma';

  @override
  String get info => 'Informació';

  @override
  String get serviceLoginButton => 'Inici de sessió del servei';

  @override
  String get english => 'Anglès';

  @override
  String get italian => 'Italià';

  @override
  String get spanish => 'Espanyol';

  @override
  String get catalan => 'Català';

  @override
  String get portuguese => 'Portuguès';

  @override
  String get norwegian => 'Noruec';

  @override
  String get dutch => 'Neerlandès';

  @override
  String get themeSettingsAutomatic => 'Automàtic';

  @override
  String get themeSettingsAlwaysOff => 'Sempre desactivat';

  @override
  String get themeSettingsAlwaysOn => 'Sempre activat';

  @override
  String get openSourceLicensesButton => 'Paquets de codi obert';

  @override
  String get clearLocalStorageButton => 'Esborra tot l\'emmagatzematge local';

  @override
  String get refreshBrowserButton => 'Actualitza el navegador';

  @override
  String get openSourceLicensesTitle => 'Paquets de codi obert';

  @override
  String get siteInfoTitle => 'Informació';

  @override
  String get siteEventCount => 'Nombre d\'esdeveniments';

  @override
  String get siteTotalSize => 'Mida total';

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
  String get siteFileCount => 'Nombre de fitxers';

  @override
  String get siteTotalFileSize => 'Mida total dels fitxers';

  @override
  String get errorFetchingFiles =>
      'S\'ha produït un error en obtenir els fitxers';

  @override
  String get refresh => 'Actualitza';

  @override
  String eventSiteCreated(String siteName) {
    return 'Creat: $siteName';
  }

  @override
  String eventAddedMember(String memberName) {
    return 'Membre afegit: $memberName';
  }

  @override
  String eventRenamedSite(String siteName) {
    return 'Nom canviat: $siteName';
  }

  @override
  String eventRemovedMember(int memberId) {
    return 'Membre eliminat: $memberId';
  }

  @override
  String eventMemberLeft(int memberId) {
    return 'El membre ha marxat: $memberId';
  }

  @override
  String eventRestoredMember(String memberName) {
    return 'Membre restaurat: $memberName';
  }

  @override
  String eventUpdatedMember(String memberName) {
    return 'Membre actualitzat: $memberName';
  }

  @override
  String get eventSiteCopied => 'Copiat/Importat';

  @override
  String get eventAppSpecific => 'Esdeveniment específic de l\'aplicació';

  @override
  String get eventUnknown => 'Esdeveniment desconegut';
}
