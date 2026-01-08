// Copyright (c) 2025 bjorge

import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/functions/base_hyttahub_functions.dart';
import 'package:hyttahub/functions/firebase_hyttahub_functions.dart';
import 'package:hyttahub/functions/in_memory_hyttahub_functions.dart';

class HyttaHubFunctionsFactory {
  static final Map<StorageEnum, BaseHyttaHubFunctions> _instances = {};

  static BaseHyttaHubFunctions getFunctions(StorageEnum type) {
    if (_instances.containsKey(type)) {
      return _instances[type]!;
    }

    BaseHyttaHubFunctions functions;
    switch (type) {
      case StorageEnum.firestore:
        functions = FirebaseHyttaHubFunctions();
        break;
      case StorageEnum.inMemory:
        functions = InMemoryHyttaHubFunctions(type);
        break;
      default:
        functions = FirebaseHyttaHubFunctions();
    }

    _instances[type] = functions;
    return functions;
  }

  static Future<void> clear() async {
    for (final functions in _instances.values) {
      await functions.dispose();
    }
    _instances.clear();
  }
}
