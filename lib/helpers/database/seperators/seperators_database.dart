import 'dart:developer';

import 'package:moeen/helpers/general/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const seperatorsDB = "seperators";

class SeperatorModel {
  final int? id;
  final int? pageNumber;
  final int? verseNumber;
  final String? color;
  final String? name;
  final String? surah;

  const SeperatorModel(
      {this.id,
      this.color,
      this.pageNumber,
      this.verseNumber,
      this.name,
      this.surah});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pageNumber': pageNumber,
      'color': color,
      'verseNumber': verseNumber,
      'name': name,
      'surah': surah,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return '$seperatorsDB{id: $id, pageNumber: $pageNumber, color: $color,verseNumber: $verseNumber,name: $name,}';
  }
}

class SeperatorsDB {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), '$seperatorsDB.db'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'create table $seperatorsDB (id INTEGER PRIMARY KEY NOT NULL,verseNumber INTEGER ,color TEXT NOT NULL,pageNumber INTEGER ,name TEXT NOT NULL,surah TEXT)',
        );
      },
      version: 1,
    );

    _db = await database;
    return await database;
  }

  Future<void> fillTable() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient!.query(seperatorsDB);
    if (maps.isEmpty) {
      print("ran");
      await insertSeperator(const SeperatorModel(
          id: 1, color: "0xff047857", name: "الفاصل الأخضر"));
      await insertSeperator(const SeperatorModel(
          id: 2, color: "0xFF0097A7", name: "الفاصل الأزرق"));
      await insertSeperator(const SeperatorModel(
          id: 3, color: "0xFF7B1FA2", name: "الفاصل البنفسجي"));
      await insertSeperator(const SeperatorModel(
          id: 4, color: "0xFF5D4037", name: "الفاصل البني"));
    }
    return;
  }

  Future<List<SeperatorModel>> getAllSeperators() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient!.query(seperatorsDB);
    List<SeperatorModel> val = [];
    for (var item in maps) {
      val.add(SeperatorModel(
        id: item['id'],
        color: item['color'],
        pageNumber: item['pageNumber'],
        verseNumber: item['verseNumber'],
        name: item['name'],
        surah: item['surah'],
      ));
    }
    return val;
  }

  Future<int> insertSeperator(SeperatorModel seperator) async {
    final db = await this.db;

    return await db!.insert(seperatorsDB, seperator.toMap());
  }

  Future<int> updateSeperator(SeperatorModel seperator) async {
    final db = await this.db;
    // await clearSeperator(SeperatorModel(id: seperator.id));
    return await db!.update(seperatorsDB, seperator.toMap(),
        where: "id = ?", whereArgs: [seperator.id]);
  }

  // clear sepertaor surah and versenumber
  Future<int> clearSeperator(SeperatorModel seperator) async {
    final db = await this.db;
    return await db!.update(
        seperatorsDB,
        {
          'surah': null,
          'verseNumber': null,
        },
        where: "id = ?",
        whereArgs: [seperator.id]);
  }

  // get seperator by name
  Future<SeperatorModel?> getSeperatorByName(String name) async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient!
        .query(seperatorsDB, where: "name = ?", whereArgs: [name]);
    if (maps.isEmpty) return null;
    return SeperatorModel(
      id: maps[0]['id'],
      color: maps[0]['color'],
      pageNumber: maps[0]['pageNumber'],
      verseNumber: maps[0]['verseNumber'],
      name: maps[0]['name'],
    );
  }

  Future<int> deleteSeperator(int id) async {
    final db = await this.db;
    return await db!.delete(seperatorsDB, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteAllSeperators() async {
    final db = await this.db;
    return await db!.delete(seperatorsDB);
  }

  Future<int?> getCount() async {
    final db = await this.db;
    return Sqflite.firstIntValue(
        await db!.rawQuery("SELECT COUNT(*) FROM $seperatorsDB"));
  }

  Future<void> close() async {
    final db = await this.db;
    db!.close();
  }
}
