import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:path_provider/path_provider.dart';

class DatabaseManager {
  // Singleton instance
  static final DatabaseManager _database = DatabaseManager._();

  // Singleton getter
  static DatabaseManager get instance => _database;

  // Private constructor.
  DatabaseManager._();

  // Database getter
  Future<Database> get database async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String databasePath = join(dir.path, 'user_afzl.db');
    return databaseFactoryIo.openDatabase(databasePath);
  }
}
