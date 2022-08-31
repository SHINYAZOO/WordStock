import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wordstock/model/folder/folder.dart';
import 'package:wordstock/model/report_card/report_card.dart';
import 'package:wordstock/model/word/word.dart';
import 'package:wordstock/pages/error_page/error_page.dart';

final sqliteRepositoryProvider = Provider((ref) => SqliteRepository());

class SqliteRepository {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, 'WordStock02.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE folders (id TEXT PRIMARY KEY, name TEXT, tableName TEXT)''');
    await db.execute('''
      CREATE TABLE words(
                id TEXT PRIMARY KEY,
                frontName TEXT,
                backName TEXT,
                tableName TEXT,
                folderNameId TEXT,
                yesCount INTEGER,
                noCount INTEGER,
                play INTEGER,
                time INTEGER,
                percent INTEGER,
                average INTEGER,
                ok TEXT
                )''');
  }

/*==============================================================================
【取得】
==============================================================================*/
  //Folder全件取得
  Future<List<Folder>> getFolders() async {
    final Database? db = await database;
    if (db == null) {
      throw const ErrorPage('DB:Folder取得中にエラーが発生しました');
    }
    final List<Map<String, dynamic>> maps = await db.query('folders');
    return List.generate(maps.length, (i) {
      return Folder(
        id: maps[i]['id'],
        name: maps[i]['name'],
        tableName: maps[i]['tableName'],
      );
    });
  }

  //Word全件取得
  Future<List<Word>> getWords() async {
    final Database? db = await database;
    if (db == null) {
      throw const ErrorPage('DB:Word取得中にエラーが発生しました');
    }
    final List<Map<String, dynamic>> maps = await db.query('words');
    return List.generate(maps.length, (i) {
      return Word(
        id: maps[i]['id'],
        frontName: maps[i]['frontName'],
        backName: maps[i]['backName'],
        tableName: maps[i]['tableName'],
        folderNameId: maps[i]['folderNameId'],
        yesCount: maps[i]['yesCount'],
        noCount: maps[i]['noCount'],
        play: maps[i]['play'],
        time: maps[i]['time'],
        percent: maps[i]['percent'],
        average: maps[i]['average'],
        ok: maps[i]['ok'],
      );
    });
  }

  //ID検索取得
  Future<List<Word>> getPointWords(String folderIdNum) async {
    final Database? db = await database;
    if (db == null) {
      throw const ErrorPage('DB:ID検索取得中にエラーが発生しました');
    }
    final List<Map<String, dynamic>> maps = await db
        .query('words', where: 'folderNameId = ?', whereArgs: [folderIdNum]);
    return List.generate(maps.length, (i) {
      return Word(
        id: maps[i]['id'],
        frontName: maps[i]['frontName'],
        backName: maps[i]['backName'],
        tableName: maps[i]['tableName'],
        folderNameId: maps[i]['folderNameId'],
        yesCount: maps[i]['yesCount'],
        noCount: maps[i]['noCount'],
        play: maps[i]['play'],
        time: maps[i]['time'],
        percent: maps[i]['percent'],
        average: maps[i]['average'],
        ok: maps[i]['ok'],
      );
    });
  }

  //'対象フォルダ'かつ'NG'の場合を取得
  Future<List<Word>> getPointNg(String folderId) async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('words',
        where: 'folderNameId = ? AND ok = ?', whereArgs: [folderId, 'NG']);
    return List.generate(maps.length, (i) {
      return Word(
        id: maps[i]['id'],
        frontName: maps[i]['frontName'],
        backName: maps[i]['backName'],
        tableName: maps[i]['tableName'],
        folderNameId: maps[i]['folderNameId'],
        yesCount: maps[i]['yesCount'],
        noCount: maps[i]['noCount'],
        play: maps[i]['play'],
        time: maps[i]['time'],
        percent: maps[i]['percent'],
        average: maps[i]['average'],
        ok: maps[i]['ok'],
      );
    });
  }

  Future<List<Word>> getPointGood(String folderId) async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('words',
        where: 'folderNameId = ? AND ok = ?', whereArgs: [folderId, 'OK']);
    return List.generate(maps.length, (i) {
      return Word(
          id: maps[i]['id'],
          frontName: maps[i]['frontName'],
          backName: maps[i]['backName'],
          tableName: maps[i]['tableName'],
          folderNameId: maps[i]['folderNameId'],
          yesCount: maps[i]['yesCount'],
          noCount: maps[i]['noCount'],
          play: maps[i]['play'],
          time: maps[i]['time'],
          percent: maps[i]['percent'],
          average: maps[i]['average'],
          ok: maps[i]['ok']);
    });
  }

  Future<ReportCard> getReportCard(String folderId) async {
    bool visibleCheck = false;
    int goodCount = 0;
    int badCount = 0;

    final good = await getPointGood(folderId);
    final bad = await getPointNg(folderId);
    good.isEmpty ? goodCount = 0 : goodCount = good.length;
    bad.isEmpty ? badCount = 0 : badCount = bad.length;

    var rate = (goodCount / (goodCount + badCount)) * 100;

    int accuracyRate = rate.floor();
    if (badCount != 0) visibleCheck = true;

    return ReportCard(
      goodCount: good.length,
      badCount: bad.length,
      accuracyRate: accuracyRate,
      visible: visibleCheck,
    );
  }

/*==============================================================================
【登録】
==============================================================================*/
  //Folder登録
  Future<void> registerFolder(Folder indata) async {
    final Database? db = await database;
    if (db == null) {
      throw const ErrorPage('DB:Folder登録にエラーが発生しました');
    }
    await db.insert(
      'folders',
      indata.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Word登録
  Future<void> registerWord(Word indata) async {
    final Database? db = await database;
    if (db == null) {
      throw const ErrorPage('DB:Word登録にエラーが発生しました');
    }
    await db.insert(
      'words',
      indata.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

/*==============================================================================
【削除】
==============================================================================*/
  //Folder削除
  Future<void> deleteFolder(String? id) async {
    final Database? db = await database;
    if (db == null) {
      throw const ErrorPage('DB:Folder削除中エラーが発生しました');
    }
    await db.delete('folders', where: 'id = ?', whereArgs: [id]);
  }

  //対象wFolderNameId削除
  Future<void> deleteIdSearch(String? folderNameId) async {
    final Database? db = await database;
    if (db == null) {
      throw const ErrorPage('DB:対象ID削除中にエラーが発生しました');
    }
    await db
        .delete('words', where: 'folderNameId = ?', whereArgs: [folderNameId]);
  }

  //Word削除
  Future<void> deleteWord(String id) async {
    final Database? db = await database;
    if (db == null) {
      throw const ErrorPage('DB:Word削除中にエラーが発生しました');
    }
    await db.delete('words', where: 'id = ?', whereArgs: [id]);
  }

/*==============================================================================
【編集】
==============================================================================*/
  //Folder編集
  Future<void> upFolder(Folder up) async {
    final Database? db = await database;
    if (db == null) {
      throw const ErrorPage('DB:Folder編集中にエラーが発生しました');
    }
    await db
        .update('folders', up.toJson(), where: 'id = ?', whereArgs: [up.id]);
  }

  //Word編集
  Future<void> upWord(Word word) async {
    final Database? db = await database;
    if (db == null) {
      throw const ErrorPage('DB:Word編集中にエラーが発生しました');
    }
    await db
        .update('words', word.toJson(), where: 'id = ?', whereArgs: [word.id]);
  }
}
