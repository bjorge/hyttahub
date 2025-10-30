// Copyright (c) 2025 bjorge

import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/cloud_functions.pb.dart';

class CloudFunctionsBloc extends Cubit<CloudFunctionsState> {
  CloudFunctionsBloc()
    : super(CloudFunctionsState()..initial = CloudFunctionsInitial());

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

  Future<void> assignUserToImportedSite(String siteId, String memberId) async {
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

  Future<void> exportSite(String siteId) async {
    emit(CloudFunctionsState()..loading = CloudFunctionsLoading());
    try {
      final firestore = FirebaseFirestore.instance;

      final email = GetIt.instance<AuthBloc>().state.email;

      // The author must be an existing site user.
      // We look up their ID from the site's users collection.
      final userDoc = await FirebaseFirestore.instance
          .collection(firebaseSiteUsersPath(siteId))
          .doc(email)
          .get();

      if (userDoc.exists && userDoc.data()?.containsKey('u') == true) {
        // The 'u' field holds the author ID.
        final author = userDoc.data()!['u'];
        final docRef = firestore.doc(firebaseSiteExportPath(siteId));

        await docRef.set({
          fbTimeStamp: FieldValue.serverTimestamp(),
          fbUserId: author,
          fbAppId: HyttaHubOptions.appId,
        }, SetOptions(merge: true));
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
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'listExports',
      );
      final result = await callable.call(<String, dynamic>{
        'siteId': siteId,
        'appName': HyttaHubOptions.firebaseRootCollection,
      });
      final files = (result.data['files'] as List).map((file) {
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
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'deleteExport',
      );
      await callable.call(<String, dynamic>{
        'siteId': siteId,
        'appName': HyttaHubOptions.firebaseRootCollection,
        'fileName': fileName,
      });
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
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'exportDetails',
      );
      final result = await callable.call(<String, dynamic>{
        'siteId': siteId,
        'appName': HyttaHubOptions.firebaseRootCollection,
        'fileName': fileName,
      });
      emit(
        CloudFunctionsState()
          ..exportDetailsSuccess = ExportDetailsSuccess(
            events: result.data['events'],
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
