import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class SqliteHelper {
  String _dbDir;
  String _dbName = "cyber_wave.db";
  Database _db;

  initDB() async {
    _dbDir = await getDatabasesPath();
    _db = await openDatabase(p.join(_dbDir, _dbName),
        onCreate: (database, version) {
      return database.execute('''
        create table generate_anime(
          userId TEXT PRIMARIKEY,
          genDate ,
        )
      ''');
    },version: 1);
  }
}
