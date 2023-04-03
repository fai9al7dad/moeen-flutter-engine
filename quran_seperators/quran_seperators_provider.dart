import 'package:flutter/cupertino.dart';
import 'package:moeen/features/quran_seperators/seperator.dart';
import 'package:moeen/features/quran_seperators/seperators_database.dart';
import 'package:moeen/features/quran_view/quran_models.dart';

class QuranSeperatorsProvider extends ChangeNotifier {
  List<Seperator> _seperators = [];
  QuranSeperatorsDatabaseAPI databaseHelper = QuranSeperatorsDatabaseAPI();
  List<Seperator> get seperators => _seperators;

  void addSeperator(Seperator selectedSeperator, QuranEntity word) async {
    // if new seperator same as exisiting delete it
    if (selectedSeperator.wordID == word.id) {
      clearSeperator(
          id: selectedSeperator.id,
          pageNumber: word.pageNumber,
          verseNumber: word.verseNumber,
          color: selectedSeperator.color,
          surah: word.chapterCode,
          wordID: word.id,
          name: selectedSeperator.name);
    } else {
      updateSeperator(
          id: selectedSeperator.id,
          pageNumber: word.pageNumber,
          verseNumber: word.verseNumber,
          color: selectedSeperator.color,
          wordID: word.id,
          surah: word.chapterCode,
          name: selectedSeperator.name);
    }
  }

  void clearSeperator(
      {id, name, color, pageNumber, surah, verseNumber, wordID}) async {
    await databaseHelper.clearSeperator(
      Seperator(
          id: id,
          color: color,
          pageNumber: pageNumber,
          surah: surah,
          name: name,
          wordID: wordID,
          verseNumber: verseNumber),
    );
    refreshSeperotrs();
  }

  void refreshSeperotrs() async {
    _seperators = await databaseHelper.getAllSeperators();
    notifyListeners();
  }

  void updateSeperator(
      {id, name, color, pageNumber, surah, verseNumber, wordID}) async {
    await databaseHelper.updateSeperator(Seperator(
        id: id,
        color: color,
        pageNumber: pageNumber,
        surah: surah,
        name: name,
        wordID: wordID,
        verseNumber: verseNumber));

    refreshSeperotrs();
  }
}
