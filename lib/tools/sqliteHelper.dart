import 'package:cyber_waves/models/AnimeOriginalModel.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:synchronized/synchronized.dart';

class SqliteHelper {
  String _dbDir;
  String _dbName = "cyber_wave.db";
  Database _db;
  final _lock = Lock();

  initDB() async {
    _dbDir = await getDatabasesPath();
    _db = await openDatabase(p.join(_dbDir, _dbName),
        onCreate: (database, version) {
      return database.execute('''
        create TABLE anime_original(
          animeId TEXT PRIMARIKEY,
          userId TEXT NOT NULL,
          animeName TEXT,
          animePath TEXT,
          generateTag int,
          uploadDate DATETIME NOT NULL
        );
      ''');
    }, version: 2);
  }

  addAnimeList(List modelList) async {
    return _lock.synchronized(() async {
      await initDB();
      for (var i = 0; i < modelList.length; i++) {
        await _db.insert("anime_original", modelList[i].toJson());
      }
      await _db.close();
    });
  }

  addAnime(
      String animeId, String userId, String animeName, String animePath) async {
    _lock.synchronized(() async {
      await initDB();
      AnimeOriginalModel model = AnimeOriginalModel(
          animeId: animeId,
          userId: userId,
          animeName: animeName,
          animePath: animePath,
          generateTag: 0,
          uploadDate: DateTime.now());
      await _db.insert("anime_original", model.toJson());
      await _db.close();
    });
  }

  Future<List<AnimeOriginalModel>> findAnimeList(
      String userId, String animeId) async {
    return _lock.synchronized(() async {
      await initDB();
      List<AnimeOriginalModel> modelLists = List<AnimeOriginalModel>();
      String con = "userId = ?";
      List conArgs = [userId];
      if (animeId != "") {
        con += ' and animeId = ?';
        conArgs.add(animeId);
      }
      List<Map<String, dynamic>> lists =
          await _db.query("anime_original", where: con, whereArgs: conArgs);
      for (var i = 0; i < lists.length; i++) {
        modelLists.add(AnimeOriginalModel.fromJson(lists[i]));
      }
      await _db.close();
      return modelLists;
    });
  }

  delAnime(String animeId) async {
    _lock.synchronized(() async {
      await initDB();
      await _db
          .delete("anime_original", where: 'animeId = ?', whereArgs: [animeId]);
      await _db.close();
    });
  }

  updateAnimeGenerateTag(String userId, String animeId) async {
    // List<AnimeOriginalModel> model = await findAnimeList(userId, animeId);
    _lock.synchronized(() async {
      await initDB();
      var con = "userId=? and animeId=?";
      var conArgs = [userId, animeId];
      var table = "anime_original";
      _db.update(table, {"generateTag": 1}, where: con, whereArgs: conArgs);
      // List<Map<String,dynamic >> lists =
      //     await _db.query(table, where: con, whereArgs: conArgs);
      await _db.close();
    });
    // return AnimeOriginalModel.fromJson(lists.first);
  }
}
