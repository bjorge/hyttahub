// Copyright (c) 2025 bjorge

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/functions/hyttahub_functions_factory.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/cloud_functions.pb.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';

class CloudFunctionsBloc extends Cubit<CloudFunctionsState> {
  CloudFunctionsBloc()
    : super(CloudFunctionsState()..initial = CloudFunctionsInitial()) {
    // Warm up functions to ensure background simulations are active (especially for in-memory mode)
    HyttaHubFunctionsFactory.getFunctions(_storageType);
  }

  StorageEnum get _storageType =>
      HyttaHubOptions.implementation?.storage ?? StorageEnum.firestore;

  String get _appName =>
      HyttaHubOptions.implementation?.firebaseRootCollection ?? '';

  Future<Map<String, dynamic>> importSite({
    String? base64Data,
    String? storagePath,
  }) async {
    try {
      final functions = HyttaHubFunctionsFactory.getFunctions(_storageType);
      return await functions.importSite(
        base64Data: base64Data,
        storagePath: storagePath,
        appName: _appName,
      );
    } catch (e) {
      throw Exception('Failed to import site: $e');
    }
  }

  Future<void> assignUserToImportedSite(String siteId, String memberId) async {
    try {
      final functions = HyttaHubFunctionsFactory.getFunctions(_storageType);
      await functions.assignUserToImportedSite(
        siteId: siteId,
        memberId: memberId,
        appName: _appName,
      );
    } catch (e) {
      throw Exception('Failed to assign user to imported site: $e');
    }
  }

  Future<void> exportSite(String siteId) async {
    emit(CloudFunctionsState()..loading = CloudFunctionsLoading());
    try {
      final storage = HyttaHubStorageFactory.getStorage(_storageType);
      final email = GetIt.instance<AuthBloc>().state.email;

      // The author must be an existing site user.
      // We look up their ID from the site's users collection.
      final userDoc = await storage.getDocument(
        firebaseSiteUsersPath(siteId),
        email,
      );

      if (userDoc != null && userDoc.containsKey(fbUserId)) {
        // The 'u' field holds the author ID.
        final author = userDoc[fbUserId];
        final docPath = firebaseSiteExportPath(siteId);
        // Extract collection path and document ID from the path.
        // firebaseSiteExportPath returns 'hyttahub/{appName}/sites/{siteId}/site_exports/export_request'
        final segments = docPath.split('/');
        final docId = segments.removeLast();
        final path = segments.join('/');

        await storage.setDocument(path, docId, {
          fbTimeStamp: storage.serverTimestamp,
          fbUserId: author,
          fbAppId: HyttaHubOptions.implementation?.appId,
        });
      } else {
        // This is an error case: an action is being performed by a non-site-user.
        throw Exception(
          "Author not found for email: $email in site $siteId. User is not a member or document is malformed.",
        );
      }
      emit(
        CloudFunctionsState()
          ..exportSuccess = ExportSuccess(message: 'Export request created'),
      );
    } catch (e) {
      emit(
        CloudFunctionsState()
          ..failure = CloudFunctionsFailure(error: e.toString()),
      );
    }
  }

  Future<void> listExports(String siteId) async {
    emit(CloudFunctionsState()..loading = CloudFunctionsLoading());
    try {
      final functions = HyttaHubFunctionsFactory.getFunctions(_storageType);
      final result = await functions.listExports(
        siteId: siteId,
        appName: _appName,
      );
      final files = (result['files'] as List).map((file) {
        final fileMap = Map<String, dynamic>.from(file);
        return ExportFile()
          ..name = fileMap['name']
          ..url = fileMap['url'];
      }).toList();
      emit(
        CloudFunctionsState()
          ..exportListSuccess = (ExportListSuccess()..files.addAll(files)),
      );
    } catch (e) {
      emit(
        CloudFunctionsState()
          ..failure = CloudFunctionsFailure(error: e.toString()),
      );
    }
  }

  Future<void> deleteExport(String siteId, String fileName) async {
    emit(CloudFunctionsState()..loading = CloudFunctionsLoading());
    try {
      final functions = HyttaHubFunctionsFactory.getFunctions(_storageType);
      await functions.deleteExport(
        siteId: siteId,
        appName: _appName,
        fileName: fileName,
      );
      emit(CloudFunctionsState()..exportDeleteSuccess = ExportDeleteSuccess());
    } catch (e) {
      emit(
        CloudFunctionsState()
          ..failure = CloudFunctionsFailure(error: e.toString()),
      );
    }
  }

  Future<void> getExportDetails(String siteId, String fileName) async {
    emit(CloudFunctionsState()..loading = CloudFunctionsLoading());
    try {
      final functions = HyttaHubFunctionsFactory.getFunctions(_storageType);
      final result = await functions.getExportDetails(
        siteId: siteId,
        appName: _appName,
        fileName: fileName,
      );
      emit(
        CloudFunctionsState()
          ..exportDetailsSuccess = ExportDetailsSuccess(
            events: result['events'],
          ),
      );
    } catch (e) {
      emit(
        CloudFunctionsState()
          ..failure = CloudFunctionsFailure(error: e.toString()),
      );
    }
  }
}
