// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_createAlbumTitle => 'Crear Álbum';

  @override
  String get app_albumNameLabel => 'Nombre del Álbum';

  @override
  String get app_addPhotosTitle => 'Añadir Fotos';

  @override
  String app_uploadingPhotosProgress(Object count, Object total) {
    return 'Subiendo $count de $total archivos...';
  }

  @override
  String app_submissionError(Object error) {
    return 'Error de Envío: $error';
  }

  @override
  String get app_pickPhotosButton => 'Seleccionar Fotos';

  @override
  String get app_selectPhotosToUpload => 'Selecciona fotos para subir:';

  @override
  String get app_hideCaptionTooltip => 'Ocultar Leyenda';

  @override
  String get app_showCaptionTooltip => 'Mostrar Leyenda';

  @override
  String get app_noPhotos => 'no hay fotos';

  @override
  String get app_noAlbums => 'no hay álbumes';

  @override
  String get app_updateCaption => 'Actualizar Leyenda';

  @override
  String get app_reorderAlbumsTitle => 'Reordenar Álbumes';

  @override
  String get app_renameAlbumTitle => 'Renombrar Álbum';

  @override
  String get app_reorderPhotos => 'Reordenar Fotos';

  @override
  String get app_photoInfoTitle => 'Información de la Foto';

  @override
  String get app_photoNotFound => 'Foto no encontrada.';

  @override
  String get app_albumLabel => 'Álbum';

  @override
  String get app_notAvailable => 'N/D';

  @override
  String get app_originalNameLabel => 'Nombre Original';

  @override
  String get app_sizeLabel => 'Tamaño';

  @override
  String get app_siteSettingsTitle => 'Configuración del Sitio';

  @override
  String get app_addAlbumTitle => 'Añadir Álbum';

  @override
  String get app_newAlbumNameLabel => 'Nombre del Nuevo Álbum';

  @override
  String get app_addPhotoCaptionTitle => 'Añadir Leyenda a la Foto';

  @override
  String get app_photoCaptionLabel => 'Leyenda de la Foto';

  @override
  String get app_deletePhotoTitle => 'Eliminar Foto';

  @override
  String get app_deletePhotoConfirmation =>
      '¿Eliminar Foto? Esta acción no se puede deshacer.';

  @override
  String get app_deleteAlbumTitle => 'Eliminar Álbum';

  @override
  String get app_deleteAlbumConfirmation =>
      '¿Eliminar Álbum? Esta acción no se puede deshacer y eliminará todos los miembros y fotos del álbum.';

  @override
  String get app_albumNotFound => 'Álbum no encontrado';

  @override
  String get app_albumNameEmptyError =>
      'El nombre del álbum no puede estar vacío.';

  @override
  String app_photoSizeInKB(String size) {
    return '$size KB';
  }

  @override
  String get app_unknownAlbum => 'Álbum Desconocido';

  @override
  String get app_eventsTitle => 'Eventos de la Aplicación';

  @override
  String get app_stateTitle => 'Estado de la Aplicación';

  @override
  String get app_showAppEventsState =>
      'Mostrar Eventos y Estado de la Aplicación';

  @override
  String get app_errorTitle => 'Error';

  @override
  String get app_unexpectedError =>
      'Error inesperado, comprueba tu conexión a internet, vuelve atrás e inténtalo de nuevo';

  @override
  String get app_accessDeniedTitle => 'Acceso Denegado';

  @override
  String get app_sitePermissionDenied =>
      'No tienes permiso para ver este sitio. Contacta al administrador del sitio si tu correo electrónico debería estar permitido.';

  @override
  String get app_networkError =>
      'Ocurrió un error de red. Por favor, comprueba tu conexión.';

  @override
  String get app_editModeTitle => 'Modo Edición';

  @override
  String get app_adminPrivileges =>
      'Tienes privilegios de administrador para este sitio.';

  @override
  String get app_howToProceed => '¿Cómo te gustaría proceder?';

  @override
  String get app_viewSite => 'Ver Sitio';

  @override
  String get app_editSite => 'Editar Sitio';

  @override
  String get app_renameSiteTitle => 'Renombrar Sitio';

  @override
  String get app_manageSiteMembers => 'Gestionar Miembros del Sitio';

  @override
  String get app_showSiteEventsState => 'Mostrar Eventos y Estado del Sitio';

  @override
  String get app_showSiteAllowedEmails =>
      'Mostrar Correos Permitidos del Sitio';

  @override
  String get app_appTitle => 'Hytta Hub Álbumes';

  @override
  String get app_nightMode => 'Modo Nocturno';

  @override
  String get app_themeSettingsAlwaysOff => 'Siempre Apagado';

  @override
  String get app_themeSettingsAlwaysOn => 'Siempre Encendido';

  @override
  String get app_themeSettingsAutomatic => 'Automático';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versión $appVersion-$appBuildNumber';
  }

  @override
  String get app_selectLanguage => 'Seleccionar Idioma';

  @override
  String get app_english => 'Inglés';

  @override
  String get app_italian => 'Italiano';

  @override
  String get app_spanish => 'Español';

  @override
  String get app_enterButton => 'Entrar';

  @override
  String get app_otherAppsTitle => 'Otras Aplicaciones de Hytta Hub';

  @override
  String get app_reservationsAppButton => 'Hytta Hub Reservas';

  @override
  String get app_serviceLoginButton => 'Inicio de Sesión de Servicio';

  @override
  String get app_exportSiteTitle => 'Exportar Sitio';

  @override
  String get app_manageExportsTitle => 'Gestionar Exportaciones';
}
