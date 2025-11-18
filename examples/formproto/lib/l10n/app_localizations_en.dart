// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_createAlbumTitle => 'Create Album';

  @override
  String get app_albumNameLabel => 'Album Name';

  @override
  String get app_addPhotosTitle => 'Add Photos';

  @override
  String app_uploadingPhotosProgress(Object count, Object total) {
    return 'Uploading $count of $total files...';
  }

  @override
  String app_submissionError(Object error) {
    return 'Submission Error: $error';
  }

  @override
  String get app_pickPhotosButton => 'Pick Photos';

  @override
  String get app_selectPhotosToUpload => 'Select photos to upload:';

  @override
  String get app_hideCaptionTooltip => 'Hide Caption';

  @override
  String get app_showCaptionTooltip => 'Show Caption';

  @override
  String get app_noPhotos => 'no photos';

  @override
  String get app_noAlbums => 'no albums';

  @override
  String get app_updateCaption => 'Update Caption';

  @override
  String get app_reorderAlbumsTitle => 'Reorder Albums';

  @override
  String get app_renameAlbumTitle => 'Rename Album';

  @override
  String get app_reorderPhotos => 'Reorder Photos';

  @override
  String get app_photoInfoTitle => 'Photo Info';

  @override
  String get app_photoNotFound => 'Photo not found.';

  @override
  String get app_albumLabel => 'Album';

  @override
  String get app_notAvailable => 'N/A';

  @override
  String get app_originalNameLabel => 'Original Name';

  @override
  String get app_sizeLabel => 'Size';

  @override
  String get app_siteSettingsTitle => 'Site Settings';

  @override
  String get app_addAlbumTitle => 'Add Album';

  @override
  String get app_newAlbumNameLabel => 'New Album Name';

  @override
  String get app_addPhotoCaptionTitle => 'Add Photo Caption';

  @override
  String get app_photoCaptionLabel => 'Photo Caption';

  @override
  String get app_deletePhotoTitle => 'Delete Photo';

  @override
  String get app_deletePhotoConfirmation =>
      'Delete Photo? This action cannot be undone.';

  @override
  String get app_deleteAlbumTitle => 'Delete Album';

  @override
  String get app_deleteAlbumConfirmation =>
      'Delete Album? This action cannot be undone and will delete all members and photos in the album.';

  @override
  String get app_albumNotFound => 'Album not found';

  @override
  String get app_albumNameEmptyError => 'Album name cannot be empty.';

  @override
  String app_photoSizeInKB(String size) {
    return '$size KB';
  }

  @override
  String get app_unknownAlbum => 'Unknown Album';

  @override
  String get app_eventsTitle => 'App Events';

  @override
  String get app_stateTitle => 'App State';

  @override
  String get app_showAppEventsState => 'Show App Events & State';

  @override
  String get app_errorTitle => 'Error';

  @override
  String get app_unexpectedError =>
      'Unexpected error, check internet, go back and try again';

  @override
  String get app_accessDeniedTitle => 'Access Denied';

  @override
  String get app_sitePermissionDenied =>
      'You do not have permission to view this site. Contact the site administrator if your email should be allowed.';

  @override
  String get app_networkError =>
      'A network error occurred. Please check your connection.';

  @override
  String get app_editModeTitle => 'Edit Mode';

  @override
  String get app_adminPrivileges => 'You have admin privileges for this site.';

  @override
  String get app_howToProceed => 'How would you like to proceed?';

  @override
  String get app_viewSite => 'View Site';

  @override
  String get app_editSite => 'Edit Site';

  @override
  String get app_renameSiteTitle => 'Rename Site';

  @override
  String get app_manageSiteMembers => 'Manage Site Members';

  @override
  String get app_showSiteEventsState => 'Show Site Events & State';

  @override
  String get app_showSiteAllowedEmails => 'Show Site Allowed Emails';

  @override
  String get app_appTitle => 'Hytta Hub Albums';

  @override
  String get app_nightMode => 'Night Mode';

  @override
  String get app_themeSettingsAlwaysOff => 'Always Off';

  @override
  String get app_themeSettingsAlwaysOn => 'Always On';

  @override
  String get app_themeSettingsAutomatic => 'Automatic';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Version $appVersion-$appBuildNumber';
  }

  @override
  String get app_selectLanguage => 'Select Language';

  @override
  String get app_english => 'English';

  @override
  String get app_italian => 'Italian';

  @override
  String get app_spanish => 'Spanish';

  @override
  String get app_enterButton => 'Enter';

  @override
  String get app_otherAppsTitle => 'Other Hytta Hub Applications';

  @override
  String get app_reservationsAppButton => 'Hytta Hub Reservations';

  @override
  String get app_serviceLoginButton => 'Service Login';

  @override
  String get app_exportSiteTitle => 'Export Site';

  @override
  String get app_manageExportsTitle => 'Manage Exports';
}
