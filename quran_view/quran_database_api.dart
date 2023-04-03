import "dart:io" as io;
import 'package:flutter/services.dart';
import 'package:moeen/features/quran_view/quran_models.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class QuranDatabaseAPI {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "quran-v5.db");
    bool dbExists = await io.File(path).exists();
    if (!dbExists) {
      ByteData data =
          await rootBundle.load(join("assets/databases", "quran-v5.db"));
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
    List<Map> word =
        await dbClient!.rawQuery("select * from data where id = $id");

    return Word(
      id: word[0]["id"],
      text: word[0]["text"],
      chapterCode: word[0]["chapterCode"],
      lineID: word[0]["lineID"],
      pageNumber: word[0]["pageNumber"],
      verseNumber: word[0]["verseNumber"],
    );
  }

  Future<Quran> getJoinedQuran() async {
    int limit = 604;

    List<List<QuranEntity>> initializePagesArray() {
      List<List<QuranEntity>> pages = [];
      for (int i = 0; i < limit; i++) {
        pages.add([]);
      }
      return pages;
    }

    var dbClient = await db;
    String query = "select * from data order by pageNumber, lineNumber";

    List list = await dbClient!.rawQuery(query);

    // List<JoinedQuran> quran = [];
    List<List<QuranEntity>> pages = initializePagesArray();

    for (int i = 0; i < list.length; i++) {
      QuranEntity item = QuranEntity.fromJson(list[i]);
      pages[item.pageNumber! - 1].add(item);
    }

    Quran returnPages = Quran(pages: pages);
    return returnPages;
  }
}
