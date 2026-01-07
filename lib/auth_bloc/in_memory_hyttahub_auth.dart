// Copyright (c) 2025 bjorge

import 'package:hyttahub/auth_bloc/base_hyttahub_auth.dart';
import 'package:hyttahub/auth_bloc/hyttahub_auth_user.dart';

class InMemoryHyttaHubAuth implements BaseHyttaHubAuth {
  HyttaHubAuthUser? _currentUser;

  @override
  Future<HyttaHubAuthUser?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<HyttaHubAuthUser?> signInWithEmailAndPassword(String email, String password) async {
    // For in-memory, we assume any password is correct
    _currentUser = HyttaHubAuthUser(email: email, emailVerified: true);
    return _currentUser;
  }

  @override
  Future<HyttaHubAuthUser?> createUserWithEmailAndPassword(String email, String password) async {
    _currentUser = HyttaHubAuthUser(email: email, emailVerified: true);
    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    // No-op for in-memory
  }

  @override
  Future<void> deleteAccount() async {
    _currentUser = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (_currentUser != null) {
      _currentUser = HyttaHubAuthUser(
        email: _currentUser!.email,
        emailVerified: true,
      );
    }
  }
}
