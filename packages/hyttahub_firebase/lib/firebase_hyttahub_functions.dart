// Copyright (c) 2025 bjorge

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:hyttahub/functions/base_hyttahub_functions.dart';
import 'package:hyttahub/proto/site_util.pb.dart';

class FirebaseHyttaHubFunctions implements BaseHyttaHubFunctions {
  @override
  Future<Map<String, dynamic>> copySite({
    required String siteId,
    required String appName,
    int? upToVersion,
    String? mockUserEmail,
  }) async {
    final path = 'hyttahub/$appName/sites/$siteId/site_users';
    final docRef = FirebaseFirestore.instance.collection(path).doc(mockUserEmail);
    
    final doc = await docRef.get();
    if (!doc.exists) {
      throw Exception('Site user record not found: $mockUserEmail');
    }
    
    final authorId = doc.data()?['u'] as int? ?? 0;
    final mark = MarkForCopy(
      author: authorId,
      upToVersion: upToVersion ?? 0,
    );
    
    final mValue = base64Encode(mark.writeToBuffer());
    await docRef.update({'MarkForCopy': mValue});
    
    return {'message': 'Site copy requested via data trigger'};
  }

  @override
  Future<Map<String, dynamic>> listSiteFiles({
    required String siteId,
    required String appName,
  }) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'listSiteFiles',
    );
    final result = await callable.call(<String, dynamic>{
      'siteId': siteId,
      'appName': appName,
    });
    return Map<String, dynamic>.from(result.data);
  }

  @override
  Future<void> dispose() async {}
}
