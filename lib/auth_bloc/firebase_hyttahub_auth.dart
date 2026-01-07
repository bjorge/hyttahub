// Copyright (c) 2025 bjorge

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hyttahub/auth_bloc/base_hyttahub_auth.dart';
import 'package:hyttahub/auth_bloc/hyttahub_auth_user.dart';

class FirebaseHyttaHubAuth implements BaseHyttaHubAuth {
  FirebaseHyttaHubAuth({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  HyttaHubAuthUser? _mapUser(User? user) {
    if (user == null) return null;
    return HyttaHubAuthUser(
      email: user.email ?? '',
      emailVerified: user.emailVerified,
    );
  }

  @override
  Future<HyttaHubAuthUser?> getCurrentUser() async {
    return _mapUser(_auth.currentUser);
  }

  @override
  Future<HyttaHubAuthUser?> signInWithEmailAndPassword(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return _mapUser(credential.user);
  }

  @override
  Future<HyttaHubAuthUser?> createUserWithEmailAndPassword(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return _mapUser(credential.user);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }

  @override
  Future<void> sendEmailVerification() async {
    await _auth.currentUser?.sendEmailVerification();
  }
}
