// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'intl_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class HyttaHubLocalizationsPt extends HyttaHubLocalizations {
  HyttaHubLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get loginTitle => 'Login';

  @override
  String get createAccountTitle => 'Criar conta';

  @override
  String get loginEmailLabel => 'E-mail';

  @override
  String get loginPasswordLabel => 'Senha';

  @override
  String get loginPasswordHelperText =>
      'A senha deve ter no mínimo 16 caracteres.';

  @override
  String get loginSuccessTitle => 'Login realizado';

  @override
  String get loginEmailEmptyError => 'O e-mail não pode ficar vazio';

  @override
  String get loginEmailInvalidFormatError =>
      'Digite um endereço de e-mail válido.';

  @override
  String get loginEmailReservedError =>
      'O formato de e-mail (que corresponde a __.*__) não é permitido.';

  @override
  String get loginEmailTooLongError =>
      'O e-mail é muito longo (máximo de 1500 bytes).';

  @override
  String get loginNotServiceAdminError => 'Não é um administrador do serviço';

  @override
  String get loginNotBetaUserError => 'Não é um e-mail autorizado';

  @override
  String get loginAgreeToTermsCheckbox => 'Concordo com os Termos';

  @override
  String get loginAgreeToPrivacyPolicyCheckbox =>
      'Concordo com a Política de Privacidade';

  @override
  String get loginAlreadyHaveAccountButton => 'Já tem uma conta?';

  @override
  String get loginNeedToCreateAccountButton => 'Precisa criar uma conta?';

  @override
  String get loginForgotPasswordButton => 'Esqueceu a senha?';

  @override
  String get loginGoToEmailResetPasswordMessage =>
      'Acesse sua caixa de entrada, abra o e-mail e clique no link para criar uma nova senha. Depois volte aqui e faça login.';

  @override
  String get loginGoToEmailVerifyEmailMessage =>
      'Acesse sua caixa de entrada, abra o e-mail e clique no link para verificar seu endereço de e-mail. Depois volte aqui e faça login.';

  @override
  String app_versionInfo(String appVersion, num appBuildNumber) {
    return 'Versão $appVersion ($appBuildNumber)';
  }

  @override
  String get sites => 'Hubs';

  @override
  String get noSites => 'nenhum hub';

  @override
  String get initializingAccountTitle => 'Inicializando a conta';

  @override
  String get serviceCreateAccountTitle => 'Criar conta de serviço';

  @override
  String get serviceLoginTitle => 'Login do serviço';

  @override
  String get accountSettingsTitle => 'Configurações da conta';

  @override
  String get manageSitesTitle => 'Abandonar';

  @override
  String get reorderSitesTitle => 'Reordenar';

  @override
  String get removeAccountTitle => 'Remover conta';

  @override
  String get logout => 'Sair';

  @override
  String get logoutDialogTitle => 'Sair?';

  @override
  String get logoutDialogMessage => 'Tem certeza de que deseja sair?';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get createSiteTitle => 'Criar hub';

  @override
  String get joinSiteTitle => 'Entrar em um hub';

  @override
  String get unimplementedTitle => 'Não implementado';

  @override
  String get toBeImplemented => 'Em breve!';

  @override
  String get siteNameLabel => 'Nome';

  @override
  String get siteNameEmptyError => 'O nome não pode ficar vazio';

  @override
  String get userNameLabel => 'Nome de usuário';

  @override
  String get userNameEmptyError => 'O nome de usuário não pode ficar vazio';

  @override
  String get pasteCodeTooltip => 'Colar código';

  @override
  String get backspaceTooltip => 'Apagar';

  @override
  String get joinSiteCodeLabel => 'Digite o código de 8 caracteres';

  @override
  String get siteCodeEmptyError => 'O código não pode ficar vazio';

  @override
  String get siteCodeLengthError => 'O código deve ter 8 caracteres';

  @override
  String get leaveSiteTooltip => 'Abandonar';

  @override
  String get removeSiteTitle => 'Remover';

  @override
  String get leaveSiteConfirmation =>
      'Abandonar? Somente um administrador pode adicionar você novamente.';

  @override
  String get updateTermsTitle => 'Atualizar termos';

  @override
  String get viewTerms => 'Ver termos';

  @override
  String get viewPrivacyPolicy => 'Ver política de privacidade';

  @override
  String get agreeToTerms => 'Concordo com os Termos de Serviço';

  @override
  String get agreeToPrivacyPolicy => 'Concordo com a Política de Privacidade';

  @override
  String get showAccountEventsState => 'Mostrar eventos e estado da conta';

  @override
  String get serviceAdminTitle => 'Administração do serviço';

  @override
  String get serviceStatusTitle => 'Status do serviço';

  @override
  String get minRequiredVersionTitle => 'Versão mínima exigida';

  @override
  String get manageBetaUsersTitle => 'Gerenciar usuários beta';

  @override
  String get errorFetchingBetaUsers => 'Erro ao buscar os usuários beta';

  @override
  String get newTermsOfServiceTitle => 'Novos Termos de Serviço';

  @override
  String get newPrivacyPolicyTitle => 'Nova Política de Privacidade';

  @override
  String get manageServiceAdminsTitle => 'Gerenciar administradores do serviço';

  @override
  String get showServiceEventsStateTitle =>
      'Mostrar eventos e estado do serviço';

  @override
  String get serviceDownTitle => 'Serviço indisponível';

  @override
  String get serviceDownMessage =>
      'O serviço está temporariamente indisponível. Aguarde enquanto trabalhamos para restaurá-lo.';

  @override
  String get accountEventsTitle => 'Eventos da conta (banco de dados)';

  @override
  String get accountStateTitle => 'Estado da conta (replay local)';

  @override
  String get serviceEventsTitle => 'Eventos do serviço (banco de dados)';

  @override
  String get serviceStateTitle => 'Estado do serviço (replay local)';

  @override
  String get networkErrorTitle => 'Erro de rede';

  @override
  String get serviceNetworkErrorMessage =>
      'Ocorreu um erro ao contatar o serviço. Verifique sua conexão com a internet e tente novamente.';

  @override
  String get newVersionAvailableTitle => 'Nova versão disponível';

  @override
  String get newVersionAvailableMessage =>
      'Atualize seu navegador ou aplicativo para a versão mais recente.';

  @override
  String get privacyPolicyTitle => 'Política de Privacidade';

  @override
  String get noPrivacyPolicyAvailable =>
      'Nenhuma política de privacidade disponível.';

  @override
  String get termsOfServiceTitle => 'Termos de Serviço';

  @override
  String get noTermsAvailable => 'Nenhum termo disponível.';

  @override
  String get initializeDataStoreTitle => 'Inicializar o armazenamento de dados';

  @override
  String get errorTodo => 'Erro: todo';

  @override
  String get initializeDataStoreBody =>
      'O armazenamento de dados está vazio. Crie o primeiro administrador do serviço para inicializar o sistema.';

  @override
  String get successfullySubmittedTodo =>
      'enviado com sucesso, todo: desabilitar os campos';

  @override
  String get errorSubmittingForm => 'Erro ao enviar o formulário';

  @override
  String get disallowedCharactersError =>
      'Os caracteres \'[\' e \']\' não são permitidos';

  @override
  String get errorTitle => 'Erro';

  @override
  String get unexpectedError =>
      'Erro inesperado; verifique a internet, volte e tente novamente';

  @override
  String get permissionDenied =>
      'Você não tem permissão para realizar esta ação.';

  @override
  String get removedFromSite => 'Você foi removido.';

  @override
  String get addMemberTitle => 'Adicionar membro';

  @override
  String get memberNameLabel => 'Nome do membro';

  @override
  String get memberNameEmptyError => 'O nome do membro não pode ficar vazio';

  @override
  String get memberNameExistsError => 'O nome do membro já existe';

  @override
  String get administratorLabel => 'Administrador';

  @override
  String get emailExistsError => 'O e-mail já existe.';

  @override
  String get renameSiteTitle => 'Renomear';

  @override
  String get manageSiteMembers => 'Membros';

  @override
  String get showSiteEventsState => 'Mostrar eventos e estado';

  @override
  String get showSiteAllowedEmails => 'E-mails permitidos';

  @override
  String get siteSettingsTitle => 'Configurações';

  @override
  String get newSiteNameLabel => 'Novo nome';

  @override
  String get siteEmailsTitle => 'E-mails do hub (banco de dados)';

  @override
  String get siteEventsTitle => 'Eventos do hub (banco de dados)';

  @override
  String get siteStateTitle => 'Estado do hub (replay local)';

  @override
  String get membersTitle => 'Membros';

  @override
  String get serviceSettingsTitle => 'Configurações do serviço';

  @override
  String get termsOfServiceContentLabel => 'Conteúdo dos Termos de Serviço';

  @override
  String get termsOfServiceContentEmptyError =>
      'Digite o conteúdo dos termos de serviço.';

  @override
  String get contentTooShortError => 'O conteúdo é muito curto.';

  @override
  String get privacyPolicyContentLabel => 'Conteúdo da Política de Privacidade';

  @override
  String get privacyPolicyContentEmptyError =>
      'Digite o conteúdo da política de privacidade.';

  @override
  String get serviceUnavailableLabel => 'Serviço indisponível';

  @override
  String get minVersionLabel => 'Versão mínima';

  @override
  String get versionNumberEmptyError => 'Digite um número de versão.';

  @override
  String get versionNumberInvalidError => 'Digite um número positivo válido.';

  @override
  String get betaUserEmailsLabel => 'E-mails dos usuários beta';

  @override
  String get aliasLabel => 'Alias';

  @override
  String get nicknameEmptyError => 'O alias não pode ficar vazio';

  @override
  String get adminAliasExistsError => 'O alias de administrador já existe';

  @override
  String get failedToLoadEmails => 'Falha ao carregar os e-mails.';

  @override
  String get permissionDeniedViewList =>
      'Você não tem permissão para ver esta lista.';

  @override
  String get noEmailsFound => 'Nenhum e-mail encontrado.';

  @override
  String userId(int userId) {
    return 'ID do usuário: $userId';
  }

  @override
  String get removeMemberTooltip => 'Remover membro';

  @override
  String get removeMemberTitle => 'Remover membro';

  @override
  String get removeMemberConfirmation =>
      'Remover membro? Esta ação não pode ser desfeita.';

  @override
  String get updateMemberTooltip => 'Atualizar membro';

  @override
  String get updateMemberTitle => 'Atualizar membro';

  @override
  String get restoreMemberTooltip => 'Restaurar membro';

  @override
  String get restoreMemberTitle => 'Restaurar membro';

  @override
  String get removedMembersTitle => 'Membros removidos';

  @override
  String get addAdminTitle => 'Adicionar administrador';

  @override
  String get updateAdminTitle => 'Atualizar administrador';

  @override
  String get removeAdminTitle => 'Remover administrador';

  @override
  String get removeAdminConfirmation =>
      'Remover administrador? Esta ação não pode ser desfeita.';

  @override
  String get restoreAdminTitle => 'Restaurar administrador';

  @override
  String get removeAccountConfirmation =>
      'Remover conta? Esta ação não pode ser desfeita.';

  @override
  String get cannotRemoveAccountTitle => 'Não é possível remover a conta';

  @override
  String get cannotRemoveAccountContent =>
      'Você precisa abandonar todos os hubs antes de remover sua conta.';

  @override
  String get cannotChangeEmailWhenOnlyAdminError =>
      'Não é possível alterar seu e-mail enquanto você for o único administrador.';

  @override
  String get okButton => 'OK';

  @override
  String get copySiteIdTooltip => 'Copiar ID';

  @override
  String get siteIdCopied => 'ID copiado para a área de transferência';

  @override
  String get and => 'e';

  @override
  String get mustAgreeToTermsError => 'Você precisa concordar com os termos.';

  @override
  String get mustAgreeToPrivacyPolicyError =>
      'Você precisa concordar com a política de privacidade.';

  @override
  String get leadingTrailingSpacesError =>
      'Não são permitidos espaços no início nem no fim.';

  @override
  String get emailLowercaseError => 'O e-mail deve estar em minúsculas.';

  @override
  String get emailLeadingTrailingSpacesError =>
      'O e-mail não pode ter espaços no início nem no fim.';

  @override
  String get formSubmissionError =>
      'Erro ao enviar o formulário; verifique a conexão com a internet, volte e tente novamente.';

  @override
  String failedToLoadEvents(String error) {
    return 'Falha ao carregar os eventos: $error';
  }

  @override
  String get showEventsListTooltip => 'Mostrar lista de eventos';

  @override
  String get showReplayStateTooltip => 'Mostrar estado do replay';

  @override
  String get toggleSortOrderTooltip => 'Alternar ordem de classificação';

  @override
  String get noEventsToReplay => 'Nenhum evento para reproduzir.';

  @override
  String eventVersion(int version) {
    return 'Versão: $version';
  }

  @override
  String get loadingTitle => 'Carregando...';

  @override
  String authenticationErrorWithDetails(String details) {
    return 'Erro de autenticação: $details';
  }

  @override
  String get loadingEllipsis => '...';

  @override
  String get loginDismissSnackbar => 'Dispensar';

  @override
  String get passwordEmptyError => 'A senha não pode ficar vazia.';

  @override
  String get passwordTooShortError => 'A senha é muito curta.';

  @override
  String get passwordTooLongError => 'A senha é muito longa.';

  @override
  String get noEventsFound => 'Nenhum evento encontrado.';

  @override
  String get copySiteTitle => 'Copiar';

  @override
  String get copySiteTooltip => 'Copiar';

  @override
  String get copySiteConfirmTitle => 'Confirmação da cópia';

  @override
  String get copySiteConfirmMessage =>
      'A cópia criará um hub privado duplicado para você. Observe que copiar os arquivos de mídia pode levar algum tempo. Você poderá editar o novo nome e adicionar membros assim que a cópia for concluída.';

  @override
  String errorAssigningUser(String error) {
    return 'Erro ao atribuir o usuário: $error';
  }

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get nightMode => 'Modo noturno';

  @override
  String get platform => 'Plataforma';

  @override
  String get info => 'Informações';

  @override
  String get serviceLoginButton => 'Login do serviço';

  @override
  String get english => 'Inglês';

  @override
  String get italian => 'Italiano';

  @override
  String get spanish => 'Espanhol';

  @override
  String get catalan => 'Catalão';

  @override
  String get portuguese => 'Português';

  @override
  String get norwegian => 'Norueguês';

  @override
  String get dutch => 'Holandês';

  @override
  String get themeSettingsAutomatic => 'Automático';

  @override
  String get themeSettingsAlwaysOff => 'Sempre desativado';

  @override
  String get themeSettingsAlwaysOn => 'Sempre ativado';

  @override
  String get openSourceLicensesButton => 'Pacotes de código aberto';

  @override
  String get clearLocalStorageButton => 'Limpar todo o armazenamento local';

  @override
  String get refreshBrowserButton => 'Atualizar o navegador';

  @override
  String get openSourceLicensesTitle => 'Pacotes de código aberto';

  @override
  String get siteInfoTitle => 'Informações';

  @override
  String get siteEventCount => 'Número de eventos';

  @override
  String get siteTotalSize => 'Tamanho total';

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
  String get siteFileCount => 'Número de arquivos';

  @override
  String get siteTotalFileSize => 'Tamanho total dos arquivos';

  @override
  String get errorFetchingFiles => 'Erro ao buscar os arquivos';

  @override
  String get refresh => 'Atualizar';

  @override
  String eventSiteCreated(String siteName) {
    return 'Criado: $siteName';
  }

  @override
  String eventAddedMember(String memberName) {
    return 'Membro adicionado: $memberName';
  }

  @override
  String eventRenamedSite(String siteName) {
    return 'Renomeado: $siteName';
  }

  @override
  String eventRemovedMember(int memberId) {
    return 'Membro removido: $memberId';
  }

  @override
  String eventMemberLeft(int memberId) {
    return 'Membro saiu: $memberId';
  }

  @override
  String eventRestoredMember(String memberName) {
    return 'Membro restaurado: $memberName';
  }

  @override
  String eventUpdatedMember(String memberName) {
    return 'Membro atualizado: $memberName';
  }

  @override
  String get eventSiteCopied => 'Copiado/Importado';

  @override
  String get eventAppSpecific => 'Evento específico do aplicativo';

  @override
  String get eventUnknown => 'Evento desconhecido';
}
