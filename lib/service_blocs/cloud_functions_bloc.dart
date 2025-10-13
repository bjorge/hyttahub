// Copyright (c) 2025 bjorge

import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:equatable/equatable.dart';
import 'package:hyttahub/hyttahub_options.dart';

part 'cloud_functions_state.dart';

class CloudFunctionsBloc extends Cubit<CloudFunctionsState> {
  CloudFunctionsBloc() : super(CloudFunctionsInitial());

  Future<Map<String, dynamic>> importSite(String base64Data) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'importSite',
      );
      final result = await callable.call(<String, dynamic>{
        'base64Data': base64Data,
        'appName': HyttaHubOptions.firebaseRootCollection,
      });
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      throw Exception('Failed to import site: $e');
    }
  }

  Future<void> assignUserToImportedSite(
      String siteId, String memberId) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'assignUserToImportedSite',
      );
      await callable.call(<String, dynamic>{
        'siteId': siteId,
        'memberId': memberId,
        'appName': HyttaHubOptions.firebaseRootCollection,
      });
    } catch (e) {
      throw Exception('Failed to assign user to imported site: $e');
    }
  }

  Future<void> exportPhotos(String siteId) async {
    emit(CloudFunctionsLoading());
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'exportSite',
      );
      final result = await callable.call(<String, dynamic>{
        'siteId': siteId,
        'appName': HyttaHubOptions.firebaseRootCollection,
      });
      emit(ExportSuccess(result.data['message']));
    } catch (e) {
      emit(CloudFunctionsFailure(e.toString()));
    }
  }

  Future<void> listExports(String siteId) async {
    emit(CloudFunctionsLoading());
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'listExports',
      );
      final result = await callable.call(<String, dynamic>{
        'siteId': siteId,
        'appName': HyttaHubOptions.firebaseRootCollection,
      });
      final files = (result.data['files'] as List)
          .map((file) => ExportFile.fromMap(file))
          .toList();
      emit(ExportListSuccess(files));
    } catch (e) {
      emit(CloudFunctionsFailure(e.toString()));
    }
  }

  Future<void> deleteExport(String siteId, String fileName) async {
    emit(CloudFunctionsLoading());
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'deleteExport',
      );
      await callable.call(<String, dynamic>{
        'siteId': siteId,
        'appName': HyttaHubOptions.firebaseRootCollection,
        'fileName': fileName,
      });
      emit(ExportDeleteSuccess());
    } catch (e) {
      emit(CloudFunctionsFailure(e.toString()));
    }
  }

  Future<void> getExportDetails(String siteId, String fileName) async {
    emit(CloudFunctionsLoading());
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'exportDetails',
      );
      final result = await callable.call(<String, dynamic>{
        'siteId': siteId,
        'appName': HyttaHubOptions.firebaseRootCollection,
        'fileName': fileName,
      });
      emit(ExportDetailsSuccess(result.data['events']));
    } catch (e) {
      emit(CloudFunctionsFailure(e.toString()));
    }
  }
}
