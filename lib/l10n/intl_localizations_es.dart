// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'intl_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class HyttaHubLocalizationsEs extends HyttaHubLocalizations {
  HyttaHubLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get createAccountTitle => 'Crear cuenta';

  @override
  String get loginEmailLabel => 'Correo electrónico';

  @override
  String get loginPasswordLabel => 'Contraseña';

  @override
  String get loginPasswordHelperText =>
      'La contraseña debe tener al menos 16 caracteres.';

  @override
  String get loginSuccessTitle => 'Inicio de sesión exitoso';

  @override
  String get loginEmailEmptyError =>
      'El correo electrónico no puede estar vacío';

  @override
  String get loginEmailInvalidFormatError =>
      'Introduce un formato de correo electrónico válido.';

  @override
  String get loginEmailReservedError =>
      'El formato de correo electrónico (coincide con __.*__) no está permitido.';

  @override
  String get loginEmailTooLongError =>
      'El correo electrónico es demasiado largo (máx. 1500 bytes).';

  @override
  String get loginNotServiceAdminError => 'No eres administrador del servicio';

  @override
  String get loginNotBetaUserError => 'Correo electrónico no autorizado';

  @override
  String get loginAgreeToTermsCheckbox => 'Acepto los Términos';

  @override
  String get loginAgreeToPrivacyPolicyCheckbox =>
      'Acepto la Política de Privacidad';

  @override
  String get loginAlreadyHaveAccountButton => '¿Ya tienes una cuenta?';

  @override
  String get loginNeedToCreateAccountButton => '¿Necesitas crear una cuenta?';

  @override
  String get loginForgotPasswordButton => '¿Olvidaste tu contraseña?';

  @override
  String get loginGoToEmailResetPasswordMessage =>
      'Ve a tu correo electrónico, abre el correo y haz clic en el enlace para crear una nueva contraseña. Luego vuelve aquí e inicia sesión.';

  @override
  String get loginGoToEmailVerifyEmailMessage =>
      'Ve a tu correo electrónico, abre el correo y haz clic en el enlace para verificar tu dirección de correo. Luego vuelve aquí e inicia sesión.';

  @override
  String app_versionInfo(String appVersion, num appBuildNumber) {
    return 'Versión $appVersion ($appBuildNumber)';
  }

  @override
  String get sites => 'Hubs';

  @override
  String get noSites => 'ningún hub';

  @override
  String get initializingAccountTitle => 'Inicializando cuenta';

  @override
  String get serviceCreateAccountTitle => 'Crear cuenta de servicio';

  @override
  String get serviceLoginTitle => 'Inicio de sesión de servicio';

  @override
  String get accountSettingsTitle => 'Configuración de la cuenta';

  @override
  String get manageSitesTitle => 'Abandonar';

  @override
  String get reorderSitesTitle => 'Reordenar hubs';

  @override
  String get removeAccountTitle => 'Eliminar cuenta';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logoutDialogTitle => '¿Cerrar sesión?';

  @override
  String get logoutDialogMessage =>
      '¿Estás seguro de que deseas cerrar sesión?';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get createSiteTitle => 'Crear hub';

  @override
  String get joinSiteTitle => 'Unirse a un hub';

  @override
  String get unimplementedTitle => 'No implementado';

  @override
  String get toBeImplemented => '¡Próximamente!';

  @override
  String get siteNameLabel => 'Nombre';

  @override
  String get siteNameEmptyError => 'El nombre no puede estar vacío';

  @override
  String get userNameLabel => 'Nombre de usuario';

  @override
  String get userNameEmptyError => 'El nombre de usuario no puede estar vacío';

  @override
  String get pasteCodeTooltip => 'Pegar código';

  @override
  String get backspaceTooltip => 'Borrar';

  @override
  String get joinSiteCodeLabel => 'Introduce el código de 8 caracteres';

  @override
  String get siteCodeEmptyError => 'El código no puede estar vacío';

  @override
  String get siteCodeLengthError => 'El código debe tener 8 caracteres';

  @override
  String get leaveSiteTooltip => 'Abandonar';

  @override
  String get removeSiteTitle => 'Eliminar';

  @override
  String get leaveSiteConfirmation =>
      '¿Abandonar? Solo un administrador puede agregarte de nuevo.';

  @override
  String get updateTermsTitle => 'Actualizar términos';

  @override
  String get viewTerms => 'Ver términos';

  @override
  String get viewPrivacyPolicy => 'Ver política de privacidad';

  @override
  String get agreeToTerms => 'Acepto los Términos de Servicio';

  @override
  String get agreeToPrivacyPolicy => 'Acepto la Política de Privacidad';

  @override
  String get showAccountEventsState => 'Mostrar eventos y estado de la cuenta';

  @override
  String get serviceAdminTitle => 'Administración del servicio';

  @override
  String get serviceStatusTitle => 'Estado del servicio';

  @override
  String get minRequiredVersionTitle => 'Versión mínima requerida';

  @override
  String get manageBetaUsersTitle => 'Gestionar usuarios beta';

  @override
  String get errorFetchingBetaUsers => 'Error al obtener usuarios beta';

  @override
  String get newTermsOfServiceTitle => 'Nuevos Términos de Servicio';

  @override
  String get newPrivacyPolicyTitle => 'Nueva Política de Privacidad';

  @override
  String get manageServiceAdminsTitle =>
      'Gestionar administradores del servicio';

  @override
  String get showServiceEventsStateTitle =>
      'Mostrar eventos y estado del servicio';

  @override
  String get serviceDownTitle => 'Servicio no disponible';

  @override
  String get serviceDownMessage =>
      'El servicio está temporalmente no disponible. Por favor espera mientras trabajamos para restaurarlo.';

  @override
  String get accountEventsTitle => 'Eventos de la cuenta (base de datos)';

  @override
  String get accountStateTitle => 'Estado de la cuenta (reproducción local)';

  @override
  String get serviceEventsTitle => 'Eventos del servicio (base de datos)';

  @override
  String get serviceStateTitle => 'Estado del servicio (reproducción local)';

  @override
  String get networkErrorTitle => 'Error de red';

  @override
  String get serviceNetworkErrorMessage =>
      'Se produjo un error al contactar el servicio. Verifica tu conexión a internet e inténtalo de nuevo.';

  @override
  String get newVersionAvailableTitle => 'Nueva versión disponible';

  @override
  String get newVersionAvailableMessage =>
      'Actualiza tu navegador o aplicación a la última versión.';

  @override
  String get privacyPolicyTitle => 'Política de privacidad';

  @override
  String get noPrivacyPolicyAvailable =>
      'No hay política de privacidad disponible.';

  @override
  String get termsOfServiceTitle => 'Términos de servicio';

  @override
  String get noTermsAvailable => 'No hay términos disponibles.';

  @override
  String get initializeDataStoreTitle => 'Inicializar el Almacén de Datos';

  @override
  String get errorTodo => 'Error: pendiente';

  @override
  String get initializeDataStoreBody =>
      'El almacén de datos está vacío. Crea al primer administrador del servicio para inicializar el sistema.';

  @override
  String get successfullySubmittedTodo =>
      'enviado con éxito, pendiente: deshabilitar los campos';

  @override
  String get errorSubmittingForm => 'Error al enviar el formulario';

  @override
  String get disallowedCharactersError =>
      'No se permiten los caracteres \'[\' y \']\'';

  @override
  String get errorTitle => 'Error';

  @override
  String get unexpectedError =>
      'Error inesperado, verifica la conexión a internet, regresa e inténtalo de nuevo';

  @override
  String get permissionDenied => 'No tienes permiso para realizar esta acción.';

  @override
  String get removedFromSite => 'Has sido eliminado.';

  @override
  String get addMemberTitle => 'Agregar miembro';

  @override
  String get memberNameLabel => 'Nombre del miembro';

  @override
  String get memberNameEmptyError =>
      'El nombre del miembro no puede estar vacío';

  @override
  String get memberNameExistsError => 'El nombre del miembro ya existe';

  @override
  String get administratorLabel => 'Administrador';

  @override
  String get emailExistsError => 'El correo electrónico ya existe.';

  @override
  String get renameSiteTitle => 'Renombrar';

  @override
  String get manageSiteMembers => 'Miembros';

  @override
  String get showSiteEventsState => 'Mostrar eventos y estado';

  @override
  String get showSiteAllowedEmails => 'Correos permitidos';

  @override
  String get siteSettingsTitle => 'Configuración';

  @override
  String get newSiteNameLabel => 'Nuevo nombre';

  @override
  String get siteEmailsTitle => 'Correos del hub (base de datos)';

  @override
  String get siteEventsTitle => 'Eventos del hub (base de datos)';

  @override
  String get siteStateTitle => 'Estado del hub (reproducción local)';

  @override
  String get membersTitle => 'Miembros';

  @override
  String get serviceSettingsTitle => 'Configuración del servicio';

  @override
  String get termsOfServiceContentLabel =>
      'Contenido de los Términos de Servicio';

  @override
  String get termsOfServiceContentEmptyError =>
      'Introduce el contenido de los términos de servicio.';

  @override
  String get contentTooShortError => 'El contenido es demasiado corto.';

  @override
  String get privacyPolicyContentLabel =>
      'Contenido de la Política de Privacidad';

  @override
  String get privacyPolicyContentEmptyError =>
      'Introduce el contenido de la política de privacidad.';

  @override
  String get serviceUnavailableLabel => 'Servicio no disponible';

  @override
  String get minVersionLabel => 'Versión mínima';

  @override
  String get versionNumberEmptyError => 'Introduce un número de versión.';

  @override
  String get versionNumberInvalidError =>
      'Introduce un número positivo válido.';

  @override
  String get betaUserEmailsLabel => 'Correos electrónicos de usuarios beta';

  @override
  String get aliasLabel => 'Alias';

  @override
  String get nicknameEmptyError => 'El apodo no puede estar vacío';

  @override
  String get adminAliasExistsError => 'El alias de administrador ya existe';

  @override
  String get failedToLoadEmails => 'Error al cargar los correos electrónicos.';

  @override
  String get permissionDeniedViewList =>
      'No tienes permiso para ver esta lista.';

  @override
  String get noEmailsFound => 'No se encontraron correos electrónicos.';

  @override
  String userId(int userId) {
    return 'ID de usuario: $userId';
  }

  @override
  String get removeMemberTooltip => 'Eliminar miembro';

  @override
  String get removeMemberTitle => 'Eliminar miembro';

  @override
  String get removeMemberConfirmation =>
      '¿Eliminar miembro? Esta acción no se puede deshacer.';

  @override
  String get updateMemberTooltip => 'Actualizar miembro';

  @override
  String get updateMemberTitle => 'Actualizar miembro';

  @override
  String get restoreMemberTooltip => 'Restaurar miembro';

  @override
  String get restoreMemberTitle => 'Restaurar miembro';

  @override
  String get removedMembersTitle => 'Miembros eliminados';

  @override
  String get addAdminTitle => 'Agregar administrador';

  @override
  String get updateAdminTitle => 'Actualizar administrador';

  @override
  String get removeAdminTitle => 'Eliminar administrador';

  @override
  String get removeAdminConfirmation =>
      '¿Eliminar administrador? Esta acción no se puede deshacer.';

  @override
  String get restoreAdminTitle => 'Restaurar administrador';

  @override
  String get removeAccountConfirmation =>
      '¿Eliminar cuenta? Esta acción no se puede deshacer.';

  @override
  String get cannotRemoveAccountTitle => 'No se puede eliminar la cuenta';

  @override
  String get cannotRemoveAccountContent =>
      'Debes abandonar todos los hubs antes de poder eliminar tu cuenta.';

  @override
  String get cannotChangeEmailWhenOnlyAdminError =>
      'No puedes cambiar tu correo electrónico cuando eres el único administrador.';

  @override
  String get okButton => 'Aceptar';

  @override
  String get copySiteIdTooltip => 'Copiar ID';

  @override
  String get siteIdCopied => 'ID copiado al portapapeles';

  @override
  String get and => 'y';

  @override
  String get mustAgreeToTermsError => 'Debes aceptar los términos.';

  @override
  String get mustAgreeToPrivacyPolicyError =>
      'Debes aceptar la política de privacidad.';

  @override
  String get leadingTrailingSpacesError =>
      'No se permiten espacios al principio o al final.';

  @override
  String get emailLowercaseError =>
      'El correo electrónico debe estar en minúsculas.';

  @override
  String get emailLeadingTrailingSpacesError =>
      'El correo electrónico no puede tener espacios al principio o al final.';

  @override
  String get formSubmissionError =>
      'Error al enviar el formulario, verifique la conexión a Internet, regrese e intente nuevamente.';

  @override
  String failedToLoadEvents(String error) {
    return 'Error al cargar eventos: $error';
  }

  @override
  String get showEventsListTooltip => 'Mostrar lista de eventos';

  @override
  String get showReplayStateTooltip => 'Mostrar estado de reproducción';

  @override
  String get toggleSortOrderTooltip => 'Cambiar orden';

  @override
  String get noEventsToReplay => 'No hay eventos para reproducir.';

  @override
  String eventVersion(int version) {
    return 'Versión: $version';
  }

  @override
  String get loadingTitle => 'Cargando...';

  @override
  String authenticationErrorWithDetails(String details) {
    return 'Error de autenticación: $details';
  }

  @override
  String get loadingEllipsis => '...';

  @override
  String get loginDismissSnackbar => 'Cerrar';

  @override
  String get passwordEmptyError => 'La contraseña no puede estar vacía.';

  @override
  String get passwordTooShortError => 'La contraseña es demasiado corta.';

  @override
  String get passwordTooLongError => 'La contraseña es demasiado larga.';

  @override
  String get noEventsFound => 'No se encontraron eventos.';

  @override
  String get copySiteTitle => 'Copiar';

  @override
  String get copySiteTooltip => 'Copiar';

  @override
  String get copySiteConfirmTitle => 'Confirmar copia';

  @override
  String get copySiteConfirmMessage =>
      'Copiar creará un hub privado duplicado para ti. Ten en cuenta que copiar archivos multimedia puede llevar tiempo. Podrás editar el nombre y añadir miembros una vez completada la copia.';

  @override
  String errorAssigningUser(String error) {
    return 'Error al asignar usuario: $error';
  }

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get nightMode => 'Modo nocturno';

  @override
  String get platform => 'Plataforma';

  @override
  String get info => 'Información';

  @override
  String get serviceLoginButton => 'Inicio de sesión de servicio';

  @override
  String get english => 'Inglés';

  @override
  String get italian => 'Italiano';

  @override
  String get spanish => 'Español';

  @override
  String get norwegian => 'Noruego';

  @override
  String get dutch => 'Holandés';

  @override
  String get themeSettingsAutomatic => 'Automático';

  @override
  String get themeSettingsAlwaysOff => 'Siempre desactivado';

  @override
  String get themeSettingsAlwaysOn => 'Siempre activado';

  @override
  String get openSourceLicensesButton => 'Paquetes de código abierto';

  @override
  String get clearLocalStorageButton => 'Limpiar todo el almacenamiento local';

  @override
  String get refreshBrowserButton => 'Refrescar navegador';

  @override
  String get openSourceLicensesTitle => 'Paquetes de código abierto';

  @override
  String get siteInfoTitle => 'Información';

  @override
  String get siteEventCount => 'Cantidad de eventos';

  @override
  String get siteTotalSize => 'Tamaño total';

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
  String get siteFileCount => 'Cantidad de archivos';

  @override
  String get siteTotalFileSize => 'Tamaño total de archivos';

  @override
  String get errorFetchingFiles => 'Error al obtener archivos';

  @override
  String get refresh => 'Refrescar';

  @override
  String eventSiteCreated(String siteName) {
    return 'Creado: $siteName';
  }

  @override
  String eventAddedMember(String memberName) {
    return 'Miembro añadido: $memberName';
  }

  @override
  String eventRenamedSite(String siteName) {
    return 'Bautizado: $siteName';
  }

  @override
  String eventRemovedMember(int memberId) {
    return 'Miembro eliminado: $memberId';
  }

  @override
  String eventMemberLeft(int memberId) {
    return 'Miembro abandonó: $memberId';
  }

  @override
  String eventRestoredMember(String memberName) {
    return 'Miembro restaurado: $memberName';
  }

  @override
  String eventUpdatedMember(String memberName) {
    return 'Miembro actualizado: $memberName';
  }

  @override
  String get eventSiteCopied => 'Copiado/Importado';

  @override
  String get eventAppSpecific => 'Evento específico de la aplicación';

  @override
  String get eventUnknown => 'Evento desconocido';
}
