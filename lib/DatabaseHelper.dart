import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper {
  static String configTable = 'configuration';
  static String columnId = '_id';
  static String columnKey = 'key';
  static String columnValue = 'value';

  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      'config.db',
      version: 1,
      onCreate: _createDatabase,
    );
    return _database!;
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $configTable (
        $columnId INTEGER PRIMARY KEY,
        $columnKey TEXT NOT NULL,
        $columnValue TEXT NOT NULL
      )
    ''');
    saveConfiguration();

  }

  Future<void> saveConfig(String key, String value) async {
    Database db = await instance.database;
    await db.insert(
      DatabaseHelper.configTable,
      {DatabaseHelper.columnKey: key, DatabaseHelper.columnValue: value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getConfig(String key) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(
      DatabaseHelper.configTable,
      where: '${DatabaseHelper.columnKey} = ?',
      whereArgs: [key],
    );
    if (results.isNotEmpty) {
      return results.first[DatabaseHelper.columnValue];
    }
    return null;
  }
}

// To save the configuration in your code
Future<void> saveConfiguration() async {
  var configData = '''
    {
      "applications": [
        {
          "app_name": "PRATISOFT",
          "path": "http://192.111.2.12/",
          "api": [
            {"key": "auth", "path": "api/auth/"},
            {"key": "appointment", "path": "mobile/appointment/"},
            {"key": "appointment_reason", "path": "api/reason/"}
          ]
        },
        {
          "app_name": "FireRis",
          "path": "http://192.111.1.11/",
          "api": []
        }
      ]
    }
  ''';

  try {
    await DatabaseHelper.instance.saveConfig('config', configData);
    print('Configuration saved successfully!');

  } catch (e) {
    print('Error saving configuration: $e');
  }

}

Future<String?> loadConfiguration() async {
  return await DatabaseHelper.instance.getConfig('config');

}

