import "dart:io" as io;
import 'package:flutter/services.dart';
import 'package:moeen/features/quran_search/quran_simple_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class QuranSimpleDatabaseApi {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "quran_simple.sqlite");
    bool dbExists = await io.File(path).exists();
    if (!dbExists) {
      ByteData data = await rootBundle
          .load(join("assets/databases", "quran_simple.sqlite"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await io.File(path).writeAsBytes(bytes, flush: true);
    }
    var openedDatabase = await openDatabase(path, version: 1);

    return openedDatabase;
  }

  Future<List<QuranSimpleModel>> search({query}) async {
    if (query == null || query.trim() == '') {
      return [];
    }
    var verses = await searchByVerse(query: query);
    var pageNumber = await searchByPageNumber(query: query);
    var surahs = await searchBySurahName(query: query);
    // List<Map> word = await dbClient!.rawQuery(
    //     "select * from line join word on word.lineID = line.id where word.id = $id");

    List<QuranSimpleModel> list = [...verses, ...pageNumber, ...surahs];

    return list;
  }

  Future<List<QuranSimpleModel>> searchByVerse({query}) async {
    if (query == null || query.trim() == '') {
      return [];
    }
    var dbClient = await db;
    var res = await dbClient!.query("hafs_smart_v8",
        where: "aya_text_emlaey LIKE ?", whereArgs: ['%$query%']);
    // List<Map> word = await dbClient!.rawQuery(
    //     "select * from line join word on word.lineID = line.id where word.id = $id");
    List<QuranSimpleModel> list = [];
    for (var item in res) {
      var newItem = {...item, "type": "verse"};

      list.add(QuranSimpleModel.fromJson(newItem));
    }

    return list;
  }

  Future<List<QuranSimpleModel>> searchByPageNumber({query}) async {
    var dbClient = await db;
    var res = await dbClient!.query("hafs_smart_v8",
        where: "page = ? limit 1", whereArgs: ['$query']);
    // List<Map> word = await dbClient!.rawQuery(
    //     "select * from line join word on word.lineID = line.id where word.id = $id");
    List<QuranSimpleModel> list = [];
    for (var item in res) {
      var newItem = {...item, "type": "pageNumber"};

      list.add(QuranSimpleModel.fromJson(newItem));
    }

    return list;
  }

  Future<List<QuranSimpleModel>> searchBySurahName({query}) async {
    var dbClient = await db;
    var res = await dbClient!.query("hafs_smart_v8",
        where: "sura_name_ar LIKE ? group by sura_name_ar",
        whereArgs: ['%$query%']);
    // List<Map> word = await dbClient!.rawQuery(
    //     "select * from line join word on word.lineID = line.id where word.id = $id");
    List<QuranSimpleModel> list = [];
    for (var item in res) {
      var newItem = {...item, "type": "surah"};

      list.add(QuranSimpleModel.fromJson(newItem));
    }

    return list;
  }
}
