import 'dart:developer';

import 'package:moeen/helpers/database/highlight_notes/models/highlight_note_model.dart';
import 'package:moeen/helpers/database/highlight_notes/models/quick_note_model.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

const _highLightNotesTable = "HighLightNotes";

class HighLightNotesDB {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), '$_highLightNotesTable.db'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.

        return db.execute(
          'create table $_highLightNotesTable (id INTEGER PRIMARY KEY NOT NULL,wordID INTEGER NOT NULL,note TEXT NOT NULL,username TEXT NOT NULL,createdAt text default CURRENT_TIMESTAMP)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        // check if version changed
        if (newVersion > oldVersion) {
          db.execute("drop table $_highLightNotesTable");
          db.execute(
            'create table $_highLightNotesTable (id INTEGER PRIMARY KEY NOT NULL,wordID INTEGER NOT NULL,note TEXT NOT NULL,username TEXT NOT NULL,createdAt text default CURRENT_TIMESTAMP)',
          );
        }
      },
      version: 3,
    );
    _db = await database;
    return await database;
  }

  Future<void> insertHighLightNote(HighLightNoteModel note) async {
    final Database? db = await this.db;
    await db!.insert(
      _highLightNotesTable,
      note.toMap(),
    );
  }

  Future<List<HighLightNoteModel>> getHighLightNotes() async {
    final Database? db = await this.db;
    final List<Map<String, dynamic>> maps =
        await db!.query(_highLightNotesTable);
    return List.generate(maps.length, (i) {
      return HighLightNoteModel(
        id: maps[i]['id'],
        wordID: maps[i]['wordID'],
        note: maps[i]['note'],
        username: maps[i]['username'],
        createdAt: maps[i]['createdAt'],
      );
    });
  }

  // remove note by id
  Future<void> removeHighLightNoteByID({id}) async {
    final Database? db = await this.db;
    await db!.delete(
      _highLightNotesTable,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // get note by wordID
  Future<List<HighLightNoteModel>> getHighLightNotesByWordID(int wordID) async {
    final Database? db = await this.db;
    final List<Map<String, dynamic>> maps = await db!.query(
      _highLightNotesTable,
      where: 'wordID = ?',
      whereArgs: [wordID],
    );
    return List.generate(maps.length, (i) {
      return HighLightNoteModel(
        id: maps[i]['id'],
        wordID: maps[i]['wordID'],
        note: maps[i]['note'],
        username: maps[i]['username'],
        createdAt: maps[i]['createdAt'],
      );
    });
  }

  Future<HighLightNoteModel?> getFirstHighlightNoteFromWord(int? wordID) async {
    final Database? db = await this.db;
    final List<Map<String, dynamic>> maps = await db!.query(
      _highLightNotesTable,
      where: 'wordID = ?',
      limit: 1,
      whereArgs: [wordID],
    );
    if (maps.isNotEmpty) {
      return HighLightNoteModel(
        id: maps[0]['id'],
        wordID: maps[0]['wordID'],
        note: maps[0]['note'],
        username: maps[0]['username'],
        createdAt: maps[0]['createdAt'],
      );
    }
    return null;
  }

  Future<void> initDefaultQuickAdd() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final existingQuickNotes = prefs.getStringList("quick_note_add");
    if (existingQuickNotes == null) {
      final List<String> quickNotes = ["خطأ تجويد", "نسيت الكلمة"];
      prefs.setStringList("quick_note_add", quickNotes);
    }
  }

  // delete quick note
  Future<void> deleteQuickNoteByIndex(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> quickNotes = prefs.getStringList("quick_note_add")!;
    quickNotes.removeAt(index);
    prefs.setStringList("quick_note_add", quickNotes);
  }

  // add quick note by name
  Future<void> addQuickNoteByName(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> quickNotes = prefs.getStringList("quick_note_add")!;
    quickNotes.add(name);
    prefs.setStringList("quick_note_add", quickNotes);
  }

  Future<List<String>> getQuickNotes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> quickNotes = prefs.getStringList("quick_note_add") ?? [];
    return quickNotes;
  }
}
