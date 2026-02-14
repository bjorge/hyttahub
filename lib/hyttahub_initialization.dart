// Copyright (c) 2025 bjorge


import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';

/// Initializes HyttaHub with the provided [implementation].
Future<void> initializeHyttaHub({
  required HyttaHubImplementation implementation,
  BaseSiteRoutePath? siteScreenRoute,
}) async {
  HyttaHubOptions.implementation = implementation;
  if (siteScreenRoute != null) {
    HyttaHubOptions.siteScreenRoute = siteScreenRoute;
  }
}

