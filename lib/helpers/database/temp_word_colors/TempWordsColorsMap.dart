import 'dart:async';

import 'package:moeen/helpers/general/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const TempWordsColorsMapTable = "TempWordsColorsMap";

class TempWordColorMapModel {
  final int? id;
  final int? wordID;
  final int? pageNumber;
  final int? verseNumber;
  final String? chapterCode;
  final String? color;
  final int? mistakes;
  final int? warnings;

  const TempWordColorMapModel(
      {this.id,
      this.wordID,
      this.chapterCode,
      this.color,
      this.pageNumber,
      this.verseNumber,
      this.mistakes,
      this.warnings});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'wordID': wordID,
      'pageNumber': pageNumber,
      'color': color,
      'verseNumber': verseNumber,
      'chapterCode': chapterCode,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return '$TempWordsColorsMapTable{id: $id, wordID: $wordID, pageNumber: $pageNumber, color: $color,verseNumber: $verseNumber,chapterCode: $chapterCode,}';
  }
}

class TempWordColorMap {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), '$TempWordsColorsMapTable.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'create table $TempWordsColorsMapTable (id INTEGER PRIMARY KEY NOT NULL,wordID INTEGER NOT NULL ON CONFLICT REPLACE,color TEXT NOT NULL,pageNumber INTEGER NOT NULL,verseNumber INTEGER NOT NULL,chapterCode TEXT NOT NULL)',
        );
      },
      version: 1,
    );
    _db = await database;
    return await database;
  }

  Future<void> insertWord(TempWordColorMapModel wcm) async {
    // chaeck if exist
    // if exist delete old and add new, so no duplicate occur
    // and if color is black delete it
    var dbClient = await db;
    var payload = wcm.toMap();
    var isExist = await getColorByID(id: payload["wordID"]);
    // inspect(isExist);
    if (isExist != null) {
      dbClient!.delete(TempWordsColorsMapTable,
          where: "wordID = ?", whereArgs: [payload["wordID"]]);
    }
    if (payload["wordID"] != MistakesColors.revert) {
      await dbClient!.insert(
        TempWordsColorsMapTable,
        payload,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<TempWordColorMapModel>> getAllColors() async {
    // Get a reference to the database.
    var dbClient = await db;
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await dbClient!.query(TempWordsColorsMapTable);

    List<TempWordColorMapModel> payload = [];
    for (var item in maps) {
      var pageColors = await getPageColors(pageNumber: item["pageNumber"]);
      payload.add(TempWordColorMapModel(
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

  Future<Map<String, int>> getPageColors({pageNumber}) async {
    // Get a reference to the database.
    var dbClient = await db;
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await dbClient!.query(
        TempWordsColorsMapTable,
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
        TempWordsColorsMapTable,
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
    await dbClient!.delete(TempWordsColorsMapTable);
  }

  Future getColorByID({id}) async {
    // Get a reference to the database.
    var dbClient = await db;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await dbClient!
        .query(TempWordsColorsMapTable, where: 'wordID = ?', whereArgs: [id]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    if (maps.isNotEmpty) {
      return TempWordColorMapModel(
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
