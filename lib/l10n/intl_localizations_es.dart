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
  String get loginNotBetaUserError => 'No eres usuario beta';

  @override
  String get loginPasswordTooShortError => 'La contraseña es demasiado corta.';

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
      'Ve a tu correo electrónico, abre el correo de Reservas Amigables y haz clic en el enlace para crear una nueva contraseña. Luego vuelve aquí e inicia sesión.';

  @override
  String get loginGoToEmailVerifyEmailMessage =>
      'Ve a tu correo electrónico, abre el correo de Reservas Amigables y haz clic en el enlace para verificar tu dirección de correo. Luego vuelve aquí e inicia sesión.';

  @override
  String get sites => 'Sitios';

  @override
  String get noSites => 'ningún sitio';

  @override
  String get initializingAccountTitle => 'Inicializando cuenta';

  @override
  String get serviceCreateAccountTitle => 'Crear cuenta de servicio';

  @override
  String get serviceLoginTitle => 'Inicio de sesión de servicio';

  @override
  String get accountSettingsTitle => 'Configuración de la cuenta';

  @override
  String get manageSitesTitle => 'Abandonar sitio';

  @override
  String get removeAccountTitle => 'Eliminar cuenta';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get createSiteTitle => 'Crear sitio';

  @override
  String get joinSiteTitle => 'Unirse a un sitio';

  @override
  String get unimplementedTitle => 'No implementado';

  @override
  String get toBeImplemented => '¡Próximamente!';

  @override
  String get siteNameLabel => 'Nombre del sitio';

  @override
  String get siteNameEmptyError => 'El nombre del sitio no puede estar vacío';

  @override
  String get userNameLabel => 'Nombre de usuario';

  @override
  String get userNameEmptyError =>
      'El nombre de usuario del sitio no puede estar vacío';

  @override
  String get pasteCodeTooltip => 'Pegar código';

  @override
  String get backspaceTooltip => 'Borrar';

  @override
  String get joinSiteCodeLabel =>
      'Introduce el código de sitio de 8 caracteres';

  @override
  String get siteCodeEmptyError => 'El código del sitio no puede estar vacío';

  @override
  String get siteCodeLengthError =>
      'El código del sitio debe tener 8 caracteres';

  @override
  String get leaveSiteTooltip => 'Abandonar sitio';

  @override
  String get removeSiteTitle => 'Eliminar sitio';

  @override
  String get leaveSiteConfirmation =>
      '¿Abandonar el sitio? Solo un administrador puede agregarte de nuevo.';

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
  String get uninitializedErrorTitle => 'Error de inicialización';

  @override
  String get errorTodo => 'Error: pendiente';

  @override
  String get initializeFirebaseEmulator => 'Inicializar emulador de Firebase.';

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
  String get emailExistsError => 'El correo electrónico ya existe en el sitio';

  @override
  String get renameSiteTitle => 'Renombrar sitio';

  @override
  String get newSiteNameLabel => 'Nuevo nombre del sitio';

  @override
  String get siteEmailsTitle =>
      'Correos electrónicos del sitio (base de datos)';

  @override
  String get siteEventsTitle => 'Eventos del sitio (base de datos)';

  @override
  String get siteStateTitle => 'Estado del sitio (reproducción local)';

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
  String get betaUserEmailsLabel =>
      'Correos electrónicos de usuarios beta (separados por coma)';

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
      'Debes abandonar todos los sitios antes de poder eliminar tu cuenta.';

  @override
  String get cannotChangeEmailWhenOnlyAdminError =>
      'No puedes cambiar tu correo electrónico cuando eres el único administrador.';

  @override
  String get okButton => 'Aceptar';

  @override
  String get copySiteIdTooltip => 'Copiar ID del sitio';

  @override
  String get siteIdCopied => 'ID del sitio copiado al portapapeles';

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
  String get loginDismissSnackbar => 'Descartar';

  @override
  String get passwordEmptyError => 'La contraseña no puede estar vacía.';

  @override
  String get passwordTooShortError => 'La contraseña es demasiado corta.';

  @override
  String get passwordTooLongError => 'La contraseña es demasiado larga.';

  @override
  String get exportSiteTitle => 'Exportar sitio';

  @override
  String get manageExportsTitle => 'Gestionar exportaciones';

  @override
  String get exportDeletedSuccessfully => 'Exportación eliminada con éxito';

  @override
  String get noExportsFound => 'No se encontraron exportaciones.';

  @override
  String get failedToLoadExports => 'Error al cargar las exportaciones.';

  @override
  String get importSiteTitle => 'Importar sitio';

  @override
  String get selectFileButton => 'Seleccionar archivo';

  @override
  String get importButton => 'Importar';

  @override
  String get selectAdminTitle => 'Seleccione su cuenta de administrador';

  @override
  String get selectAdminInstruction =>
      'Seleccione su cuenta de administrador de la lista de administradores del sitio importado.';

  @override
  String get assignUserButton => 'Asignar usuario';
}
