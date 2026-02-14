// Copyright (c) 2025 bjorge

import 'dart:async';
import 'package:hyttahub/auth_bloc/base_hyttahub_auth.dart';
import 'package:hyttahub/auth_bloc/hyttahub_auth_user.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';

class HydratedHyttaHubAuth implements BaseHyttaHubAuth {
  HyttaHubAuthUser? _currentUser;
  final String _authCollection = '_auth';
  final String _currentUserDocId = 'current_user';

  Future<void> _init() async {
    try {
      final storage = HyttaHubStorageFactory.getStorage(StorageEnum.localStorage);
      final data = await storage.getDocument(_authCollection, _currentUserDocId);
      if (data != null && data.isNotEmpty) {
        _currentUser = HyttaHubAuthUser(
          uid: data['uid'] as String,
          email: data['email'] as String,
          emailVerified: data['emailVerified'] as bool,
        );
      }
    } catch (e) {
      // ignore: empty_catches
    }
  }
  
  bool _initialized = false;
  
  @override
  Future<HyttaHubAuthUser?> getCurrentUser() async {
    if (!_initialized) {
      await _init();
      _initialized = true;
    }
    return _currentUser;
  }

  @override
  Future<HyttaHubAuthUser?> signInWithEmailAndPassword(String email, String password) async {
    final user = HyttaHubAuthUser(email: email, emailVerified: true, uid: 'local-user-${email.hashCode}');
    _currentUser = user;
    await _persistUser(user);
    return _currentUser;
  }

  @override
  Future<HyttaHubAuthUser?> createUserWithEmailAndPassword(String email, String password) async {
    final user = HyttaHubAuthUser(email: email, emailVerified: true, uid: 'local-user-${email.hashCode}');
    _currentUser = user;
    await _persistUser(user);
    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    final storage = HyttaHubStorageFactory.getStorage(StorageEnum.localStorage);
    await storage.setDocument(_authCollection, _currentUserDocId, {});
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
  }

  @override
  Future<void> deleteAccount() async {
     await signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
  }
  
  Future<void> _persistUser(HyttaHubAuthUser user) async {
    final storage = HyttaHubStorageFactory.getStorage(StorageEnum.localStorage);
    await storage.setDocument(_authCollection, _currentUserDocId, {
      'uid': user.uid,
      'email': user.email,
      'emailVerified': user.emailVerified,
    });
  }
}
