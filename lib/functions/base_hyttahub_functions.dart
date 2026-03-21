// Copyright (c) 2025 bjorge

import 'dart:async';

abstract class BaseHyttaHubFunctions {

  Future<Map<String, dynamic>> listSiteFiles({
    required String siteId,
    required String appName,
  });

  Future<void> dispose();
}
