// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'intl_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get app_createTreeTitle => 'Crea Albero';

  @override
  String get app_treeNameLabel => 'Nome Albero';

  @override
  String get app_treeNameEmptyError =>
      'Il nome dell\'albero non può essere vuoto';

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
  String get app_treeSettingsTitle => 'Impostazioni Albero';

  @override
  String get app_reorderTreesTitle => 'Riordina Alberi';

  @override
  String get app_renameTreeTitle => 'Rinomina Albero';

  @override
  String get app_photoInfoTitle => 'Info Foto';

  @override
  String get app_photoNotFound => 'Foto non trovata.';

  @override
  String get app_treeLabel => 'Albero';

  @override
  String get app_notAvailable => 'N/D';

  @override
  String get app_originalNameLabel => 'Nome Originale';

  @override
  String get app_sizeLabel => 'Dimensione';

  @override
  String get app_noTrees => 'nessun albero';

  @override
  String get app_siteSettingsTitle => 'Impostazioni Sito';

  @override
  String get app_addTreeTitle => 'Aggiungi Albero';

  @override
  String get app_newTreeNameLabel => 'Nuovo Nome Albero';

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
  String get app_deleteTreeTitle => 'Elimina Albero';

  @override
  String get app_deleteTreeConfirmation =>
      'Eliminare l\'albero? Questa azione non può essere annullata ed eliminerà tutti i membri e le foto nell\'albero.';

  @override
  String get app_addTreeMemberTitle => 'Aggiungi Membro dell\'Albero';

  @override
  String get app_treeMemberNameLabel => 'Nome del Membro';

  @override
  String get app_treeMemberNameEmptyError =>
      'Il nome del membro non può essere vuoto';

  @override
  String get app_removeTreeMemberTitle => 'Rimuovi Membro dell\'Albero';

  @override
  String get app_removeTreeMemberConfirmation =>
      'Rimuovere il membro? Questa azione non può essere annullata.';

  @override
  String get app_addConnectionTitle => 'Aggiungi Connessione';

  @override
  String get app_selectMember => 'Seleziona Membro';

  @override
  String get app_selectConnectionType => 'Seleziona Tipo di Connessione';

  @override
  String get app_infoLabel => 'Info (opzionale)';

  @override
  String get app_removeConnectionTitle => 'Rimuovi Connessione';

  @override
  String get app_removeConnectionConfirmation =>
      'Rimuovere la connessione? Questa azione non può essere annullata.';

  @override
  String get app_updatePhotoCaptionScreenTitle => 'Aggiorna didascalia foto';

  @override
  String get app_newCaptionLabel => 'Nuova didascalia';

  @override
  String get app_pleaseSelectMemberError => 'Seleziona un membro';

  @override
  String get app_pleaseSelectConnectionType =>
      'Seleziona un tipo di connessione';

  @override
  String get app_treeNotFound => 'Albero non trovato';

  @override
  String get app_personNotFound => 'Persona non trovata';

  @override
  String get app_noConnections => 'Nessuna connessione';

  @override
  String get app_connectionTypePartner => 'Partner';

  @override
  String get app_connectionTypeExPartner => 'Ex-Partner';

  @override
  String get app_connectionTypeChild => 'Figli';

  @override
  String get app_connectionTypeFriend => 'Amici';

  @override
  String get app_connectionTypeParent => 'Genitori';

  @override
  String get app_connectionTypePet => 'Animali domestici';

  @override
  String get app_connectionTypeConnections => 'Connessioni';

  @override
  String get app_noMembersInThisTree => 'Nessun membro in questo albero';

  @override
  String get app_renameTreeMemberTitle => 'Rinomina membro dell\'albero';

  @override
  String get app_newMemberNameLabel => 'Nuovo nome del membro';

  @override
  String app_photoSizeInKB(String size) {
    return '$size KB';
  }

  @override
  String get app_eventsTitle => 'Eventi app';

  @override
  String get app_stateTitle => 'Stato app';

  @override
  String get app_showAppEventsState => 'Mostra eventi e stato app';

  @override
  String app_photosCount(int count) {
    return 'Fotografie: $count';
  }

  @override
  String app_connectionsCount(int count) {
    return 'Connessioni: $count';
  }

  @override
  String get app_addConnectionTooltip => 'Aggiungi connessione';

  @override
  String get app_addPhotoTooltip => 'Aggiungi foto';

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
  String get app_appTitle => 'Hytta Hub Connessioni';

  @override
  String get app_nightMode => 'Modalità Notturna';

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
  String get app_enterButton => 'Entra';

  @override
  String get app_otherAppsTitle => 'Altre applicazioni Hytta Hub';

  @override
  String get app_reservationsAppButton => 'Prenotazioni Amichevoli';

  @override
  String get app_serviceLoginButton => 'Accesso Servizio';
}
