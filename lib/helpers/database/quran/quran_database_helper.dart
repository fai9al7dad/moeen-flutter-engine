import "dart:io" as io;
import 'package:flutter/services.dart';
import 'package:moeen/helpers/database/quran/quran_models.dart';
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
    String path = join(documentsDirectory.path, "quran-v2.db");
    bool dbExists = await io.File(path).exists();
    if (!dbExists) {
      ByteData data =
          await rootBundle.load(join("assets/databases", "quran-v2.db"));
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

  Future<Word> getWordByID({id}) async {
    var dbClient = await db;
    List<Map> word = await dbClient!.rawQuery(
        "select * from line join word on word.lineID = line.id where word.id = $id");

    return Word(
      id: word[0]["id"],
      text: word[0]["text"],
      chapterCode: word[0]["chapterCode"],
      lineID: word[0]["lineID"],
      pageID: word[0]["pageID"],
      verseNumber: word[0]["verseNumber"],
    );
  }

  Future<Line> getLineByID({id}) async {
    var dbClient = await db;
    List<Map> line =
        await dbClient!.query("line", where: "id = ?", whereArgs: [id]);

    return Line(
      id: line[0]["id"],
      pageID: line[0]["pageID"],
    );
  }

  Future<List<List>> getJoinedQuran() async {
    int limit = 604;
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
    String query =
        "select page.id as pageID, page.pageNumber, page.rubNumber, page.hizbNumber, page.juzNumber,word.text,word.lineNumber, word.transliteration,word.isBismillah,word.isNewChapter,word.color,word.chapterCode,word.id as wordID,word.charType, word.verseNumber  from  page inner join line  on line.pageID = page.id inner join word on word.lineID = line.id order by word.lineNumber";
    var batch = dbClient!.batch()
      ..execute("CREATE VIEW IF NOT EXISTS joined_quran_view AS $query");
    await batch.commit();

    List list = await dbClient.rawQuery("select * from joined_quran_view");

    // List<JoinedQuran> quran = [];
    List<List> pages = initializePagesArray();
    for (int i = 0; i < list.length; i++) {
      var item = list[i];

      pages[item["pageNumber"] - 1].add(item);
    }
    return pages;
  }
}
