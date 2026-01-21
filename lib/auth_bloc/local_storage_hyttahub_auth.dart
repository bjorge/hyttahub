// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:hyttahub/auth_bloc/base_hyttahub_auth.dart';
import 'package:hyttahub/auth_bloc/hyttahub_auth_user.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';
import 'package:hyttahub/storage/sembast_hyttahub_storage.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';

class LocalStorageHyttaHubAuth implements BaseHyttaHubAuth {
  HyttaHubAuthUser? _currentUser;
  final String _authCollection = '_auth';
  final String _currentUserDocId = 'current_user';

  // Helper to access the Sembast storage instance directly (knowing it is initialized)
  Future<SembastHyttaHubStorage> get _storage async {
     // We assume the storage factory is initialized for localStorage
     final storage = HyttaHubStorageFactory.getStorage(StorageEnum.localStorage);
     if (storage is! SembastHyttaHubStorage) {
       throw Exception('Storage is not SembastHyttaHubStorage');
     }
     return storage;
  }

  Future<void> _init() async {
    try {
      final storage = await _storage;
      final data = await storage.getDocument(_authCollection, _currentUserDocId);
      if (data != null) {
        _currentUser = HyttaHubAuthUser(
          uid: data['uid'] as String,
          email: data['email'] as String,
          emailVerified: data['emailVerified'] as bool,
        );
      }
    } catch (e) {
      // Ignore errors during init (e.g. db not ready), user just won't be logged in
      // print('Auth init error: $e');
    }
  }
  
  // We need to ensure init is called. 
  // BaseHyttaHubAuth doesn't have an init. 
  // We will call it lazily on getCurrentUser or just once on construction if async constructor pattern was possible.
  // We'll trust getCurrentUser checks it.
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
    // Permissive login like inMemory
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
    final storage = await _storage;
    // We can't delete document in BaseHyttaHubStorage interface easily? 
    // Wait, BaseHyttaHubStorage doesn't have deleteDocument?
    // Correct. It only has set/update.
    // But SembastStorage is our concrete type here.
    // Accessing internal DB/store? 
    // Or just set to empty/null marker?
    // Let's implement 'deleteDocument' in SembastHyttaHubStorage or just set content to empty and handle it.
    
    // Better: use internal access since we are in the same package/context potentially?
    // Or just set a flag 'loggedOut'.
    // Or just overwrite with empty map and check for empty map in _init.
    await storage.setDocument(_authCollection, _currentUserDocId, {});
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    // No-op
  }

  @override
  Future<void> deleteAccount() async {
     await signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    // No-op
  }
  
  Future<void> _persistUser(HyttaHubAuthUser user) async {
    final storage = await _storage;
    await storage.setDocument(_authCollection, _currentUserDocId, {
      'uid': user.uid,
      'email': user.email,
      'emailVerified': user.emailVerified,
    });
  }
}
