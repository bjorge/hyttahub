
import 'package:sembast/sembast.dart';
// Conditional imports for platform-specific implementations
import 'database_factory_io.dart' if (dart.library.html) 'database_factory_web.dart';

DatabaseFactory get databaseFactory => getDatabaseFactory();
