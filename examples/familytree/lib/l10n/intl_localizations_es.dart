// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'intl_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_createTreeTitle => 'Crear árbol';

  @override
  String get app_treeNameLabel => 'Nombre del árbol';

  @override
  String get app_treeNameEmptyError =>
      'El nombre del árbol no puede estar vacío';

  @override
  String get app_addPhotosTitle => 'Agregar fotos';

  @override
  String app_uploadingPhotosProgress(Object count, Object total) {
    return 'Subiendo $count de $total archivos...';
  }

  @override
  String app_submissionError(Object error) {
    return 'Error de envío: $error';
  }

  @override
  String get app_pickPhotosButton => 'Seleccionar fotos';

  @override
  String get app_selectPhotosToUpload => 'Selecciona las fotos para subir:';

  @override
  String get app_treeSettingsTitle => 'Configuración del árbol';

  @override
  String get app_reorderTreesTitle => 'Reordenar árboles';

  @override
  String get app_renameTreeTitle => 'Renombrar árbol';

  @override
  String get app_photoInfoTitle => 'Información de la foto';

  @override
  String get app_photoNotFound => 'Foto no encontrada.';

  @override
  String get app_treeLabel => 'Árbol';

  @override
  String get app_notAvailable => 'N/D';

  @override
  String get app_originalNameLabel => 'Nombre original';

  @override
  String get app_sizeLabel => 'Tamaño';

  @override
  String get app_noTrees => 'ningún árbol';

  @override
  String get app_siteSettingsTitle => 'Configuración del sitio';

  @override
  String get app_addTreeTitle => 'Agregar árbol';

  @override
  String get app_newTreeNameLabel => 'Nuevo nombre del árbol';

  @override
  String get app_addPhotoCaptionTitle => 'Agregar leyenda a la foto';

  @override
  String get app_photoCaptionLabel => 'Leyenda de la foto';

  @override
  String get app_deletePhotoTitle => 'Eliminar Foto';

  @override
  String get app_deletePhotoConfirmation =>
      '¿Eliminar Foto? Esta acción no se puede deshacer.';

  @override
  String get app_deleteTreeTitle => 'Eliminar árbol';

  @override
  String get app_deleteTreeConfirmation =>
      '¿Eliminar árbol? Esta acción no se puede deshacer y eliminará todos los miembros y fotos del árbol.';

  @override
  String get app_addTreeMemberTitle => 'Agregar miembro del árbol';

  @override
  String get app_treeMemberNameLabel => 'Nombre del miembro';

  @override
  String get app_treeMemberNameEmptyError =>
      'El nombre del miembro no puede estar vacío';

  @override
  String get app_removeTreeMemberTitle => 'Eliminar miembro del árbol';

  @override
  String get app_removeTreeMemberConfirmation =>
      '¿Eliminar miembro? Esta acción no se puede deshacer.';

  @override
  String get app_addConnectionTitle => 'Agregar conexión';

  @override
  String get app_selectMember => 'Seleccionar miembro';

  @override
  String get app_selectConnectionType => 'Seleccionar tipo de conexión';

  @override
  String get app_infoLabel => 'Información (opcional)';

  @override
  String get app_removeConnectionTitle => 'Eliminar conexión';

  @override
  String get app_removeConnectionConfirmation =>
      '¿Eliminar conexión? Esta acción no se puede deshacer.';

  @override
  String get app_updatePhotoCaptionScreenTitle => 'Actualizar pie de foto';

  @override
  String get app_newCaptionLabel => 'Nuevo pie de foto';

  @override
  String get app_pleaseSelectMemberError => 'Por favor seleccione un miembro';

  @override
  String get app_pleaseSelectConnectionType =>
      'Por favor seleccione un tipo de conexión';

  @override
  String get app_treeNotFound => 'Árbol no encontrado';

  @override
  String get app_personNotFound => 'Persona no encontrada';

  @override
  String get app_noConnections => 'No hay conexiones';

  @override
  String get app_connectionTypePartner => 'Compañero';

  @override
  String get app_connectionTypeExPartner => 'Ex-pareja';

  @override
  String get app_connectionTypeChild => 'Niños';

  @override
  String get app_connectionTypeFriend => 'Amigos';

  @override
  String get app_connectionTypeParent => 'Padres';

  @override
  String get app_connectionTypePet => 'Mascotas';

  @override
  String get app_connectionTypeConnections => 'Conexiones';

  @override
  String get app_noMembersInThisTree => 'No hay miembros en este árbol';

  @override
  String get app_renameTreeMemberTitle => 'Renombrar miembro del árbol';

  @override
  String get app_newMemberNameLabel => 'Nuevo nombre de miembro';

  @override
  String app_photoSizeInKB(String size) {
    return '$size KB';
  }

  @override
  String get app_eventsTitle => 'Eventos de la aplicación';

  @override
  String get app_stateTitle => 'Estado de la aplicación';

  @override
  String get app_showAppEventsState =>
      'Mostrar eventos y estado de la aplicación';

  @override
  String app_photosCount(int count) {
    return 'Fotos: $count';
  }

  @override
  String app_connectionsCount(int count) {
    return 'Conexiones: $count';
  }

  @override
  String get app_addConnectionTooltip => 'Añadir conección';

  @override
  String get app_addPhotoTooltip => 'Añadir foto';

  @override
  String get app_errorTitle => 'Error';

  @override
  String get app_unexpectedError =>
      'Error inesperado, verifica la conexión a internet, regresa e inténtalo de nuevo';

  @override
  String get app_accessDeniedTitle => 'Acceso denegado';

  @override
  String get app_sitePermissionDenied =>
      'No tienes permiso para ver este sitio. Contacta al administrador si tu correo electrónico debería estar autorizado.';

  @override
  String get app_networkError =>
      'Se produjo un error de red. Verifica tu conexión.';

  @override
  String get app_editModeTitle => 'Modo edición';

  @override
  String get app_adminPrivileges =>
      'Tienes privilegios de administrador para este sitio.';

  @override
  String get app_howToProceed => '¿Cómo deseas proceder?';

  @override
  String get app_viewSite => 'Ver sitio';

  @override
  String get app_editSite => 'Editar sitio';

  @override
  String get app_renameSiteTitle => 'Renombrar sitio';

  @override
  String get app_manageSiteMembers => 'Gestionar miembros del sitio';

  @override
  String get app_showSiteEventsState => 'Mostrar eventos y estado del sitio';

  @override
  String get app_showSiteAllowedEmails =>
      'Mostrar correos electrónicos autorizados del sitio';

  @override
  String get app_appTitle => 'Conexiones de Hytta Hub';

  @override
  String get app_nightMode => 'Modo noche';

  @override
  String get app_themeSettingsAlwaysOff => 'Siempre apagado';

  @override
  String get app_themeSettingsAlwaysOn => 'Siempre encendido';

  @override
  String get app_themeSettingsAutomatic => 'Automático';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versión $appVersion-$appBuildNumber';
  }

  @override
  String get app_selectLanguage => 'Seleccionar idioma';

  @override
  String get app_english => 'Inglés';

  @override
  String get app_italian => 'Italiano';

  @override
  String get app_spanish => 'Español';

  @override
  String get app_enterButton => 'Entrar';

  @override
  String get app_otherAppsTitle => 'Otras aplicaciones de Hytta Hub';

  @override
  String get app_reservationsAppButton => 'Reservas de Hytta Hub';

  @override
  String get app_serviceLoginButton => 'Inicio de sesión del servicio';
}
