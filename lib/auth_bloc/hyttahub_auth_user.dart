// Copyright (c) 2025 bjorge

/// A simple user model to decouple from firebase_auth.User
class HyttaHubAuthUser {
  HyttaHubAuthUser({
    required this.email,
    required this.emailVerified,
  });

  final String email;
  final bool emailVerified;
}
