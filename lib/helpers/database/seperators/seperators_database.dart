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
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        var batch = db.batch()
          ..execute("update $seperatorsDB  set color = 0xff76ff03 where id =1")
          ..execute("update $seperatorsDB  set color = 0xff00e5ff where id =2")
          ..execute("update $seperatorsDB  set color = 0xffd500f9 where id =3")
          ..execute("update $seperatorsDB  set color = 0xfff50057 where id =4")
          ..execute(
              "update $seperatorsDB  set name = 'الفاصل الوردي' where id =4");
        await batch.commit();
        return;
      },
      version: 3,
    );

    _db = await database;
    return await database;
  }

  Future<void> fillTable() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient!.query(seperatorsDB);
    if (maps.isEmpty) {
      await insertSeperator(const SeperatorModel(
          id: 1, color: "0xff76ff03", name: "الفاصل الأخضر"));
      await insertSeperator(const SeperatorModel(
          id: 2, color: "0xff00e5ff", name: "الفاصل الأزرق"));
      await insertSeperator(const SeperatorModel(
          id: 3, color: "0xFF7B1FA2", name: "الفاصل البنفسجي"));
      await insertSeperator(const SeperatorModel(
          id: 4, color: "0xFF5D4037", name: "الفاصل الوردي"));
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
    var dbClient = await db;

    return await dbClient!.insert(seperatorsDB, seperator.toMap());
  }

  Future<void> updateSeperator(SeperatorModel seperator) async {
    var dbClient = await db;
    // if seperator with same verse number and page number exists, clear old and update new
    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery(
        "select * from $seperatorsDB where verseNumber = ${seperator.verseNumber} and surah = ${seperator.surah}");
    if (maps.isNotEmpty) {
      await dbClient.update(
          seperatorsDB,
          {
            'surah': null,
            'verseNumber': null,
          },
          where: "verseNumber = ? and pageNumber = ?",
          whereArgs: [seperator.verseNumber, seperator.pageNumber]);
    }
    // print(seperator.toMap());
    await dbClient.update(seperatorsDB, seperator.toMap(),
        where: "id= ?", whereArgs: [seperator.id]);
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

  // get seperator by id
  Future<SeperatorModel?> getSeperator(int id) async {
    final db = await this.db;
    final List<Map<String, dynamic>> maps =
        await db!.query(seperatorsDB, where: "id = ?", whereArgs: [id]);
    if (maps.isEmpty) return null;
    return SeperatorModel(
      id: maps.first['id'],
      color: maps.first['color'],
      pageNumber: maps.first['pageNumber'],
      verseNumber: maps.first['verseNumber'],
      name: maps.first['name'],
      surah: maps.first['surah'],
    );
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
