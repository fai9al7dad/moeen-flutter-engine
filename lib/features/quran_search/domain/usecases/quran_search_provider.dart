import 'package:flutter/material.dart';
import 'package:moeen/common/data/data_sources/GeneralHelpers.dart';
import 'package:moeen/features/quran_search/data/datasources/quran_simple_database_api.dart';

final quranSimpleAPI = QuranSimpleDatabaseApi();

class QuranSearchProvider extends ChangeNotifier {
  List<QuranSimpleModel> _searchResult = [];

  List<QuranSimpleModel> get searchResult {
    return _searchResult;
  }

  void search(text) async {
    String convertedString = GeneralHelpers().replaceArabicNumber(text);
    List<QuranSimpleModel> res =
        await quranSimpleAPI.search(query: convertedString);

    _searchResult = res;
    notifyListeners();
  }
}
