import 'dart:async';
import 'dart:developer';

import 'package:moeen/common/services/constants.dart';
import 'package:moeen/features/highlights/highlight_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HighlightsDatabaseApi {
  final String tableName;
  static Database? _db;

  HighlightsDatabaseApi({this.tableName = "WordsColorsMap"});
  Future<Database?> get db async {
    // if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), '$tableName.db'),
      onCreate: (db, version) {
        return db.execute(
          'create table $tableName if not exists (id INTEGER PRIMARY KEY NOT NULL,wordID INTEGER NOT NULL ON CONFLICT REPLACE,color TEXT NOT NULL,pageNumber INTEGER NOT NULL,verseNumber INTEGER NOT NULL,chapterCode TEXT NOT NULL)',
        );
      },
      version: 1,
    );
    _db = await database;
    return await database;
  }

  Future<void> insertWord(HighlightModel wcm) async {
    // chaeck if exist
    // if exist delete old and add new, so no duplicate occur
    // and if color is black delete it
    var dbClient = await db;
    var payload = wcm.toMap();
    var isExist = await getColorByID(id: payload["wordID"]);
    if (isExist != null) {
      dbClient!.delete(tableName,
          where: "wordID = ?", whereArgs: [payload["wordID"]]);
    }
    if (payload["wordID"] != MistakesColors.revert) {
      await dbClient!.insert(
        tableName,
        payload,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<HighlightModel>> getAllColors({pageNumber}) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!.query(tableName);

    List<HighlightModel> payload = [];
    for (var item in maps) {
      var pageColors =
          await getPageHeaderColors(pageNumber: item["pageNumber"]);
      payload.add(HighlightModel(
        id: item['id'],
        wordID: item['wordID'],
        chapterCode: item['chapterCode'],
        verseNumber: item['verseNumber'],
        pageNumber: item['pageNumber'],
        color: item['color'],
        mistakes: pageColors["mistakes"],
        warnings: pageColors["warnings"],
      ));
    }
    return payload;
  }

  Future<List<HighlightModel>> getPageColors({pageNumber}) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!
        .rawQuery("select * from $tableName where pageNumber = $pageNumber");

    List<HighlightModel> payload = [];
    for (var item in maps) {
      var pageColors =
          await getPageHeaderColors(pageNumber: item["pageNumber"]);
      payload.add(HighlightModel(
        id: item['id'],
        wordID: item['wordID'],
        chapterCode: item['chapterCode'],
        verseNumber: item['verseNumber'],
        pageNumber: item['pageNumber'],
        color: item['color'],
        mistakes: pageColors["mistakes"],
        warnings: pageColors["warnings"],
      ));
    }
    return payload;
  }

  Future<Map<String, int>> getPageHeaderColors({pageNumber}) async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient!
        .query(tableName, where: "pageNumber = ?", whereArgs: [pageNumber]);

    int mistakes = 0;
    int warnings = 0;
    List.generate(maps.length, (i) {
      if (maps[i]['color'] == MistakesColors.mistake) {
        mistakes++;
      }
      if (maps[i]['color'] == MistakesColors.warning) {
        warnings++;
      }
    });

    return {"mistakes": mistakes, "warnings": warnings};
  }

  Future<Map<String, int>> getChapterColors({chapterCode}) async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient!
        .query(tableName, where: "chapterCode = ?", whereArgs: [chapterCode]);

    int mistakes = 0;
    int warnings = 0;
    List.generate(maps.length, (i) {
      if (maps[i]['color'] == MistakesColors.mistake) {
        mistakes++;
      }
      if (maps[i]['color'] == MistakesColors.warning) {
        warnings++;
      }
    });

    return {"mistakes": mistakes, "warnings": warnings};
  }

  Future<void> deleteAllColors() async {
    var dbClient = await db;
    await dbClient!.delete(tableName);
  }

  Future getColorByID({id}) async {
    var dbClient = await db;

    final List<Map<String, dynamic>> maps =
        await dbClient!.query(tableName, where: 'wordID = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return HighlightModel(
        id: maps[0]['id'],
        wordID: maps[0]['wordID'],
        chapterCode: maps[0]['chapterCode'],
        verseNumber: maps[0]['verseNumber'],
        pageNumber: maps[0]['pageNumber'],
        color: maps[0]['color'],
      );
    }
  }

  Future<void> deleteColor({wordID}) async {
    var dbClient = await db;
    await dbClient!.delete(tableName, where: "wordID = ?", whereArgs: [wordID]);
  }
}
