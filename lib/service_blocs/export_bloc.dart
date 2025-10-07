// Copyright (c) 2025 bjorge

import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:equatable/equatable.dart';

part 'export_state.dart';

class ExportBloc extends Cubit<ExportState> {
  ExportBloc() : super(ExportInitial());

  Future<void> exportPhotos(String siteId) async {
    emit(ExportLoading());
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('exportPhotos');
      final result = await callable.call(<String, dynamic>{
        'siteId': siteId,
      });
      emit(ExportSuccess(result.data['message']));
    } catch (e) {
      emit(ExportFailure(e.toString()));
    }
  }

  Future<void> listExports(String siteId) async {
    emit(ExportLoading());
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('listExports');
      final result = await callable.call(<String, dynamic>{
        'siteId': siteId,
      });
      final files = (result.data['files'] as List)
          .map((file) => ExportFile.fromMap(file))
          .toList();
      emit(ExportListSuccess(files));
    } catch (e) {
      emit(ExportFailure(e.toString()));
    }
  }

  Future<void> deleteExport(String siteId, String fileName) async {
    emit(ExportLoading());
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteExport');
      await callable.call(<String, dynamic>{
        'siteId': siteId,
        'fileName': fileName,
      });
      emit(ExportDeleteSuccess());
    } catch (e) {
      emit(ExportFailure(e.toString()));
    }
  }
}