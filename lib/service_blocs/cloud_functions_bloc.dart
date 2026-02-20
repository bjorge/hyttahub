// Copyright (c) 2025 bjorge

import 'package:bloc/bloc.dart';
import 'package:hyttahub/functions/hyttahub_functions_factory.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/cloud_functions.pb.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';

class CloudFunctionsBloc extends Cubit<CloudFunctionsState> {
  CloudFunctionsBloc()
    : super(CloudFunctionsState()..initial = CloudFunctionsInitial()) {
    // Warm up functions to ensure background simulations are active (especially for in-memory mode)
    HyttaHubFunctionsFactory.getFunctions(_storageType);
  }

  StorageEnum get _storageType =>
      HyttaHubOptions.implementation?.storage ?? StorageEnum.cloud;

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

  Future<Map<String, dynamic>> copySite(String siteId, {int? upToVersion}) async {
    emit(CloudFunctionsState()..loading = CloudFunctionsLoading());
    try {
      final functions = HyttaHubFunctionsFactory.getFunctions(_storageType);
      final result = await functions.copySite(
        siteId: siteId,
        appName: _appName,
        upToVersion: upToVersion,
      );
      emit(CloudFunctionsState()); // Clear loading state or emit success
      return result;
    } catch (e) {
      emit(
        CloudFunctionsState()
          ..failure = CloudFunctionsFailure(error: e.toString()),
      );
      throw Exception('Failed to copy site: $e');
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

}
