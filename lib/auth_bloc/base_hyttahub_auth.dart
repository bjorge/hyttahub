// Copyright (c) 2025 bjorge

import 'package:hyttahub/auth_bloc/hyttahub_auth_user.dart';

/// Define the common interface for authentication
abstract class BaseHyttaHubAuth {
  Future<HyttaHubAuthUser?> getCurrentUser();
  Future<HyttaHubAuthUser?> signInWithEmailAndPassword(String email, String password);
  Future<HyttaHubAuthUser?> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> deleteAccount();
  Future<void> sendEmailVerification();
}
