import "dart:io" as io;
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "quran.db");
    bool dbExists = await io.File(path).exists();
    if (!dbExists) {
      ByteData data =
          await rootBundle.load(join("assets/databases", "quran.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await io.File(path).writeAsBytes(bytes, flush: true);
    }
    var openedDatabase = await openDatabase(path, version: 1);

    return openedDatabase;
  }

  Future<List<Map<dynamic, dynamic>>> getPages() async {
    var dbClient = await db;
    List<Map> list = await dbClient!.rawQuery("SELECT * FROM page");
    return list;
  }

  Future<List<List>> getJoinedQuran() async {
    int limit = 10;
    List<List> initializePagesArray() {
      List<List> pages = [];
      // initialze lines
      // make less because last surah returns empty array
      for (int i = 0; i < limit; i++) {
        pages.add([]);
      }
      return pages;
    }

    var dbClient = await db;
    // List list = await dbClient!.rawQuery(
    //     "select * from (select * from page limit 10) page inner join line on line.pageID = page.id inner join word on word.lineID = line.id order by pageNumber,lineNumber");
    List list = await dbClient!.rawQuery(
        "select page.id as pageID, page.pageNumber, page.rubNumber, page.hizbNumber, page.juzNumber,word.text,word.lineNumber, word.transliteration,word.isBismillah,word.isNewChapter,word.color,word.chapterCode,word.id as wordID,word.charType, word.verseNumber  from (select * from page limit $limit) page inner join line  on line.pageID = page.id inner join word on word.lineID = line.id order by word.lineNumber ");

    // List<JoinedQuran> quran = [];
    List<List> pages = initializePagesArray();
    for (int i = 0; i < list.length; i++) {
      var item = list[i];

      pages[item["pageNumber"] - 1].add(item);
    }
    return pages;
  }
}
