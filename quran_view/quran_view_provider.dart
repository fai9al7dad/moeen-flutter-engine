import 'package:flutter/material.dart';
import 'package:moeen/features/quran_view/quran_database_api.dart';
import 'package:moeen/features/quran_view/quran_models.dart';

QuranDatabaseAPI quranDB = QuranDatabaseAPI();

class QuranViewProvider with ChangeNotifier {
  final _pageController = PageController(initialPage: 0, viewportFraction: 1.1);
  Quran _quran = Quran();
  bool _loadingGetData = false;

  bool get loadingGetData {
    return _loadingGetData;
  }

  PageController get pageController {
    return _pageController;
  }

  Quran get quran {
    return _quran;
  }

  void getData() async {
    _loadingGetData = true;
    Quran q = await quranDB.getJoinedQuran();
    _quran = q;
    _loadingGetData = false;
    notifyListeners();
  }

  void navigateToQuranPage({required String page}) {
    pageController.jumpToPage(int.parse(page) - 1);
  }
}
