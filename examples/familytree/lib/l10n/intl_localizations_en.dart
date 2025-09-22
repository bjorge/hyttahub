// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'intl_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_createTreeTitle => 'Create Tree';

  @override
  String get app_treeNameLabel => 'Tree Name';

  @override
  String get app_treeNameEmptyError => 'Tree name cannot be empty';

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
  String get app_treeSettingsTitle => 'Tree Settings';

  @override
  String get app_reorderTreesTitle => 'Reorder Trees';

  @override
  String get app_renameTreeTitle => 'Rename Tree';

  @override
  String get app_photoInfoTitle => 'Photo Info';

  @override
  String get app_photoNotFound => 'Photo not found.';

  @override
  String get app_treeLabel => 'Tree';

  @override
  String get app_notAvailable => 'N/A';

  @override
  String get app_originalNameLabel => 'Original Name';

  @override
  String get app_sizeLabel => 'Size';

  @override
  String get app_noTrees => 'no trees';

  @override
  String get app_siteSettingsTitle => 'Site Settings';

  @override
  String get app_addTreeTitle => 'Add Tree';

  @override
  String get app_newTreeNameLabel => 'New Tree Name';

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
  String get app_deleteTreeTitle => 'Delete Tree';

  @override
  String get app_deleteTreeConfirmation =>
      'Delete Tree? This action cannot be undone and will delete all members and photos in the tree.';

  @override
  String get app_addTreeMemberTitle => 'Add Tree Member';

  @override
  String get app_treeMemberNameLabel => 'Member Name';

  @override
  String get app_treeMemberNameEmptyError => 'Member name cannot be empty';

  @override
  String get app_removeTreeMemberTitle => 'Remove Tree Member';

  @override
  String get app_removeTreeMemberConfirmation =>
      'Remove Member? This action cannot be undone.';

  @override
  String get app_addConnectionTitle => 'Add Connection';

  @override
  String get app_selectMember => 'Select Member';

  @override
  String get app_selectConnectionType => 'Select Connection Type';

  @override
  String get app_infoLabel => 'Info (optional)';

  @override
  String get app_removeConnectionTitle => 'Remove Connection';

  @override
  String get app_removeConnectionConfirmation =>
      'Remove Connection? This action cannot be undone.';

  @override
  String get app_updatePhotoCaptionScreenTitle => 'Update Photo Caption';

  @override
  String get app_newCaptionLabel => 'New caption';

  @override
  String get app_pleaseSelectMemberError => 'Please select a member';

  @override
  String get app_pleaseSelectConnectionType =>
      'Please select a connection type';

  @override
  String get app_treeNotFound => 'Tree not found';

  @override
  String get app_personNotFound => 'Person not found';

  @override
  String get app_noConnections => 'No connections';

  @override
  String get app_connectionTypePartner => 'Partner';

  @override
  String get app_connectionTypeExPartner => 'Ex-Partner';

  @override
  String get app_connectionTypeChild => 'Children';

  @override
  String get app_connectionTypeFriend => 'Friends';

  @override
  String get app_connectionTypeParent => 'Parents';

  @override
  String get app_connectionTypePet => 'Pets';

  @override
  String get app_connectionTypeConnections => 'Connections';

  @override
  String get app_noMembersInThisTree => 'No members in this tree';

  @override
  String get app_renameTreeMemberTitle => 'Rename Tree Member';

  @override
  String get app_newMemberNameLabel => 'New Member Name';

  @override
  String app_photoSizeInKB(String size) {
    return '$size KB';
  }

  @override
  String get app_eventsTitle => 'App Events';

  @override
  String get app_stateTitle => 'App State';

  @override
  String get app_showAppEventsState => 'Show App Events & State';

  @override
  String app_photosCount(int count) {
    return 'Photos: $count';
  }

  @override
  String app_connectionsCount(int count) {
    return 'Connections: $count';
  }

  @override
  String get app_addConnectionTooltip => 'Add Connection';

  @override
  String get app_addPhotoTooltip => 'Add Photo';

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
  String get app_appTitle => 'Hytta Hub Connections';

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
}
