// Copyright (c) 2025 bjorge

import 'package:pocketbase/pocketbase.dart';
import 'package:hyttahub/auth_bloc/base_hyttahub_auth.dart';
import 'package:hyttahub/auth_bloc/hyttahub_auth_user.dart';

/// A [BaseHyttaHubAuth] implementation backed by PocketBase.
///
/// Authenticates users against PocketBase's built-in `users` collection
/// (or a custom collection name supplied via [collectionName]).
class PocketbaseHyttaHubAuth implements BaseHyttaHubAuth {
  PocketbaseHyttaHubAuth({
    required PocketBase client,
    String collectionName = 'users',
  })  : _client = client,
        _collectionName = collectionName;

  final PocketBase _client;
  final String _collectionName;

  HyttaHubAuthUser? _mapRecord(RecordModel? record) {
    if (record == null) return null;
    return HyttaHubAuthUser(
      email: record.getStringValue('email'),
      emailVerified: record.getBoolValue('verified'),
      uid: record.id,
    );
  }

  @override
  Future<HyttaHubAuthUser?> getCurrentUser() async {
    final model = _client.authStore.record;
    if (model == null || !_client.authStore.isValid) return null;
    return _mapRecord(model);
  }

  @override
  Future<HyttaHubAuthUser?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final auth = await _client
        .collection(_collectionName)
        .authWithPassword(email, password);
    return _mapRecord(auth.record);
  }

  @override
  Future<HyttaHubAuthUser?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // Create the user record.
    await _client.collection(_collectionName).create(body: {
      'email': email,
      'password': password,
      'passwordConfirm': password,
    });
    // Sign in and return the auth result. Critically, the auth response
    // reflects the true verified state (set by the server after creation),
    // whereas the create response always returns verified=false.
    final auth = await _client
        .collection(_collectionName)
        .authWithPassword(email, password);
    return _mapRecord(auth.record);
  }

  @override
  Future<void> signOut() async {
    _client.authStore.clear();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _client.collection(_collectionName).requestPasswordReset(email);
  }

  @override
  Future<void> deleteAccount() async {
    final record = _client.authStore.record;
    if (record == null) return;
    await _client.collection(_collectionName).delete(record.id);
    _client.authStore.clear();
  }

  @override
  Future<void> sendEmailVerification() async {
    final record = _client.authStore.record;
    if (record == null) return;
    final email = record.getStringValue('email');
    if (email.isNotEmpty) {
      await _client.collection(_collectionName).requestVerification(email);
    }
  }
}
