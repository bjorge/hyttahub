// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get app_createAlbumTitle => 'Crea Album';

  @override
  String get app_albumNameLabel => 'Nome Album';

  @override
  String get app_addPhotosTitle => 'Aggiungi Foto';

  @override
  String app_uploadingPhotosProgress(Object count, Object total) {
    return 'Caricamento di $count di $total file...';
  }

  @override
  String app_submissionError(Object error) {
    return 'Errore di invio: $error';
  }

  @override
  String get app_pickPhotosButton => 'Scegli Foto';

  @override
  String get app_selectPhotosToUpload => 'Seleziona le foto da caricare:';

  @override
  String get app_hideCaptionTooltip => 'Nascondi Didascalia';

  @override
  String get app_showCaptionTooltip => 'Mostra Didascalia';

  @override
  String get app_noPhotos => 'nessuna foto';

  @override
  String get app_updateCaption => 'Aggiorna Didascalia';

  @override
  String get app_reorderAlbumsTitle => 'Riordina Album';

  @override
  String get app_renameAlbumTitle => 'Rinomina Album';

  @override
  String get app_reorderPhotos => 'Riordina Foto';

  @override
  String get app_photoInfoTitle => 'Info Foto';

  @override
  String get app_photoNotFound => 'Foto non trovata.';

  @override
  String get app_albumLabel => 'Album';

  @override
  String get app_notAvailable => 'N/A';

  @override
  String get app_originalNameLabel => 'Nome Originale';

  @override
  String get app_sizeLabel => 'Dimensione';

  @override
  String get app_siteSettingsTitle => 'Impostazioni Sito';

  @override
  String get app_addAlbumTitle => 'Aggiungi Album';

  @override
  String get app_newAlbumNameLabel => 'Nuovo Nome Album';

  @override
  String get app_addPhotoCaptionTitle => 'Aggiungi Didascalia Foto';

  @override
  String get app_photoCaptionLabel => 'Didascalia Foto';

  @override
  String get app_deletePhotoTitle => 'Elimina Foto';

  @override
  String get app_deletePhotoConfirmation =>
      'Eliminare la foto? Questa azione non può essere annullata.';

  @override
  String get app_deleteAlbumTitle => 'Elimina Album';

  @override
  String get app_deleteAlbumConfirmation =>
      'Eliminare l\'album? Questa azione non può essere annullata ed eliminerà tutti i membri e le foto nell\'album.';

  @override
  String get app_albumNotFound => 'Album non trovato';

  @override
  String get app_albumNameEmptyError =>
      'Il nome dell\'album non può essere vuoto';

  @override
  String app_photoSizeInKB(String size) {
    return '$size KB';
  }

  @override
  String get app_unknownAlbum => 'Album sconosciuto';

  @override
  String get app_eventsTitle => 'Eventi app';

  @override
  String get app_stateTitle => 'Stato app';

  @override
  String get app_showAppEventsState => 'Mostra eventi e stato app';

  @override
  String get app_errorTitle => 'Errore';

  @override
  String get app_unexpectedError =>
      'Errore imprevisto, controlla la connessione internet, torna indietro e riprova';

  @override
  String get app_accessDeniedTitle => 'Accesso Negato';

  @override
  String get app_sitePermissionDenied =>
      'Non hai il permesso di visualizzare questo sito. Contatta l\'amministratore del sito se la tua email dovrebbe essere autorizzata.';

  @override
  String get app_networkError =>
      'Si è verificato un errore di rete. Controlla la tua connessione.';

  @override
  String get app_editModeTitle => 'Modalità Modifica';

  @override
  String get app_adminPrivileges =>
      'Hai i privilegi di amministratore per questo sito.';

  @override
  String get app_howToProceed => 'Come vuoi procedere?';

  @override
  String get app_viewSite => 'Visualizza Sito';

  @override
  String get app_editSite => 'Modifica Sito';

  @override
  String get app_renameSiteTitle => 'Rinomina Sito';

  @override
  String get app_manageSiteMembers => 'Gestisci Membri del Sito';

  @override
  String get app_showSiteEventsState => 'Mostra Eventi e Stato del Sito';

  @override
  String get app_showSiteAllowedEmails => 'Mostra Email Autorizzate del Sito';

  @override
  String get app_appTitle => 'Hytta Hub Album';

  @override
  String get app_nightMode => 'Modalità Notte';

  @override
  String get app_themeSettingsAlwaysOff => 'Sempre Spento';

  @override
  String get app_themeSettingsAlwaysOn => 'Sempre Acceso';

  @override
  String get app_themeSettingsAutomatic => 'Automatico';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versione $appVersion-$appBuildNumber';
  }

  @override
  String get app_selectLanguage => 'Seleziona Lingua';

  @override
  String get app_english => 'Inglese';

  @override
  String get app_italian => 'Italiano';

  @override
  String get app_spanish => 'Spagnolo';

  @override
  String get app_enterButton => 'Invio';

  @override
  String get app_otherAppsTitle => 'Altre Applicazioni Hytta Hub';

  @override
  String get app_reservationsAppButton => 'Hytta Hub Prenotazioni';

  @override
  String get app_serviceLoginButton => 'Accesso Servizio';

  @override
  String get app_exportSiteTitle => 'Esporta Sito';

  @override
  String get app_manageExportsTitle => 'Gestisci Esportazioni';
}
