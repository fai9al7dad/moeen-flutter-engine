import 'package:moeen/features/quran_seperators/seperator.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const seperatorsDB = "seperators";

class QuranSeperatorsDatabaseAPI {
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
          'create table $seperatorsDB (id INTEGER PRIMARY KEY NOT NULL,verseNumber INTEGER ,color TEXT NOT NULL,pageNumber INTEGER ,name TEXT NOT NULL,surah TEXT,wordID INTEGER )',
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        var batch = db.batch()
          ..execute("update $seperatorsDB  set color = 0xff76ff03 where id =1")
          ..execute("update $seperatorsDB  set color = 0xff00e5ff where id =2")
          ..execute("update $seperatorsDB  set color = 0xffd500f9 where id =3")
          ..execute("update $seperatorsDB  set color = 0xfff50057 where id =4")
          ..execute("ALTER TABLE $seperatorsDB  ADD COLUMN wordID INTEGER")
          ..execute(
              "update $seperatorsDB  set name = 'الفاصل الوردي' where id =4");
        await batch.commit();
        return;
      },
      version: 5,
    );

    _db = await database;
    return await database;
  }

  Future<void> fillTable() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient!.query(seperatorsDB);
    if (maps.isEmpty) {
      await insertSeperator(
          const Seperator(id: 1, color: "0xff76ff03", name: "الفاصل الأخضر"));
      await insertSeperator(
          const Seperator(id: 2, color: "0xff00e5ff", name: "الفاصل الأزرق"));
      await insertSeperator(
          const Seperator(id: 3, color: "0xffd500f9", name: "الفاصل البنفسجي"));
      await insertSeperator(
          const Seperator(id: 4, color: "0xFFF50057", name: "الفاصل الوردي"));
    }
    return;
  }

  Future<List<Seperator>> getAllSeperators() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient!.query(seperatorsDB);
    List<Seperator> val = [];
    for (var item in maps) {
      val.add(Seperator(
        id: item['id'],
        color: item['color'],
        pageNumber: item['pageNumber'],
        verseNumber: item['verseNumber'],
        name: item['name'],
        surah: item['surah'],
        wordID: item['wordID'],
      ));
    }
    return val;
  }

  Future<int> insertSeperator(Seperator seperator) async {
    var dbClient = await db;

    return await dbClient!.insert(seperatorsDB, seperator.toMap());
  }

  Future<void> updateSeperator(Seperator seperator) async {
    var dbClient = await db;
    // if seperator with same verse number and page number exists, clear old and update new
    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery(
        "select * from $seperatorsDB where wordID = ${seperator.wordID} ");
    if (maps.isNotEmpty) {
      await dbClient.update(
          seperatorsDB,
          {
            'surah': null,
            'verseNumber': null,
            'wordID': null,
          },
          where: "wordID = ?",
          whereArgs: [seperator.wordID]);
    }
    // print(seperator.toMap());
    await dbClient.update(seperatorsDB, seperator.toMap(),
        where: "id= ?", whereArgs: [seperator.id]);
  }

  // clear sepertaor surah and versenumber
  Future<int> clearSeperator(Seperator seperator) async {
    var dbClient = await db;
    return await dbClient!.update(
        seperatorsDB,
        {
          'surah': null,
          'verseNumber': null,
          'wordID': null,
          'pageNumber': null,
        },
        where: "id = ?",
        whereArgs: [seperator.id]);
  }

  // get seperator by id
  Future<Seperator?> getSeperator(int id) async {
    final db = await this.db;
    final List<Map<String, dynamic>> maps =
        await db!.query(seperatorsDB, where: "id = ?", whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Seperator(
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
