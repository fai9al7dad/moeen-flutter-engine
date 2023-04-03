import 'package:flutter/material.dart';
import 'package:moeen/common/services/utils.dart';
import 'package:moeen/features/quran_search/quran_simple_database_api.dart';
import 'package:moeen/features/quran_search/quran_simple_model.dart';

final quranSimpleAPI = QuranSimpleDatabaseApi();

class QuranSearchProvider extends ChangeNotifier {
  List<QuranSimpleModel> _searchResult = [];

  List<QuranSimpleModel> get searchResult {
    return _searchResult;
  }

  void search(text) async {
    String convertedString = Utils().replaceArabicNumber(text);
    List<QuranSimpleModel> res =
        await quranSimpleAPI.search(query: convertedString);

    _searchResult = res;
    notifyListeners();
  }
}
