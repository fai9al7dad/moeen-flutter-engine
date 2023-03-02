import 'dart:async';

import 'package:moeen/helpers/database/words_colors/WordsColorsMap.dart';
import 'package:moeen/common/data/data_sources/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const WerdsColorsMapTable = "WerdsColorsMapTable";

class WerdsColorsMap {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), '$WerdsColorsMapTable.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'create table $WerdsColorsMapTable (id INTEGER PRIMARY KEY NOT NULL,wordID INTEGER NOT NULL ON CONFLICT REPLACE,color TEXT NOT NULL,pageNumber INTEGER NOT NULL,verseNumber INTEGER NOT NULL,chapterCode TEXT NOT NULL)',
        );
      },
      version: 1,
    );
    _db = await database;
    return await database;
  }

  Future<void> insertWord(WordColorMapModel wcm) async {
    // chaeck if exist
    // if exist delete old and add new, so no duplicate occur
    // and if color is black delete it
    var dbClient = await db;
    var payload = wcm.toMap();
    var isExist = await getColorByID(id: payload["wordID"]);
    // inspect(isExist);
    if (isExist != null) {
      dbClient!.delete(WerdsColorsMapTable,
          where: "wordID = ?", whereArgs: [payload["wordID"]]);
    }
    if (payload["wordID"] != MistakesColors.revert) {
      await dbClient!.insert(
        WerdsColorsMapTable,
        payload,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<WordColorMapModel>> getAllColors() async {
    // Get a reference to the database.
    var dbClient = await db;
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await dbClient!.query(WerdsColorsMapTable);

    List<WordColorMapModel> payload = [];
    for (var item in maps) {
      var pageColors =
          await getPageHeaderColors(pageNumber: item["pageNumber"]);
      payload.add(WordColorMapModel(
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

  Future<List<WordColorMapModel>> getPageColors({pageNumber}) async {
    // Get a reference to the database.
    var dbClient = await db;
    // Query the table for all The Dogs.
    List<Map<String, dynamic>> maps = await dbClient!.rawQuery(
        "select * from $WerdsColorsMapTable where pageNumber = $pageNumber");

    List<WordColorMapModel> payload = [];
    for (var item in maps) {
      var pageColors =
          await getPageHeaderColors(pageNumber: item["pageNumber"]);
      payload.add(WordColorMapModel(
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
    // Get a reference to the database.
    var dbClient = await db;
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await dbClient!.query(
        WerdsColorsMapTable,
        where: "pageNumber = ?",
        whereArgs: [pageNumber]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
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
    // Get a reference to the database.
    var dbClient = await db;
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await dbClient!.query(
        WerdsColorsMapTable,
        where: "chapterCode = ?",
        whereArgs: [chapterCode]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
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
    // Get a reference to the database.
    var dbClient = await db;

    // Query the table for all The Dogs.
    await dbClient!.delete(WerdsColorsMapTable);
  }

  Future<void> deleteColor({wordID}) async {
    // Get a reference to the database.
    var dbClient = await db;

    // Query the table for all The Dogs.
    await dbClient!
        .delete(WerdsColorsMapTable, where: "wordID = ?", whereArgs: [wordID]);
  }

  Future getColorByID({id}) async {
    // Get a reference to the database.
    var dbClient = await db;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await dbClient!
        .query(WerdsColorsMapTable, where: 'wordID = ?', whereArgs: [id]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    if (maps.isNotEmpty) {
      return WordColorMapModel(
        id: maps[0]['id'],
        wordID: maps[0]['wordID'],
        chapterCode: maps[0]['chapterCode'],
        verseNumber: maps[0]['verseNumber'],
        pageNumber: maps[0]['pageNumber'],
        color: maps[0]['color'],
      );
    }
  }
}
