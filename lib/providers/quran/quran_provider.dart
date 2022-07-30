import 'package:flutter/cupertino.dart';
import 'package:moeen/helpers/database/quran/quran_database_helper.dart';
import 'package:moeen/helpers/database/words_colors/WordsColorsMap.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/helpers/models/highlights_model.dart';
import 'package:moeen/helpers/models/werds_model.dart';

class QuranProvider with ChangeNotifier {
  final wordsColorsMap = WordColorMap();
  final _pageController = PageController(initialPage: 0);

  List _quran = [];
  List<WordColorMapModel> _mistakes = [];
  List<HighlightsModel> _werdMistakes = [];
  bool _loadingGetData = false;

  bool _isWerd = false;
  // used mainly when changing to another page, ex: sleect surah

  // late JoinedQuran _currentPage;
  List<WordColorMapModel> get mistakes {
    return _mistakes;
  }

  List<HighlightsModel> get werdMistakes {
    return _werdMistakes;
  }

  bool get loadingGetData {
    return _loadingGetData;
  }

  bool get isWerd {
    return _isWerd;
  }

  PageController get pageController {
    return _pageController;
  }

  List get quran {
    return _quran;
  }

  void getData() async {
    _loadingGetData = true;
    var databaseHelper = DatabaseHelper();
    List q = await databaseHelper.getJoinedQuran();
    _quran = q;
    _loadingGetData = false;
    notifyListeners();
  }

  Future refreshData() async {
    var m = await wordsColorsMap.getAllColors();
    _mistakes = m;
    notifyListeners();
  }

  void setWerdMistakes({required data}) {
    _isWerd = true;
    _werdMistakes = data;
  }

  void addMistake(
      {required id,
      required pageNumber,
      required verseNumber,
      required chapterCode,
      color}) async {
    String newColor;
    newColor = MistakesColors.warning;
    if (color != null) {
      if (color == MistakesColors.warning) {
        newColor = MistakesColors.mistake;
      }
      if (color == MistakesColors.mistake) {
        newColor = MistakesColors.revert;
      }
    }

    // setState(() {
    //   _mistakes[id] = newMistake;
    // });
    // inspect(s);
    if (!_isWerd) {
      var word = WordColorMapModel(
          pageNumber: pageNumber,
          verseNumber: int.parse(verseNumber),
          chapterCode: chapterCode,
          color: newColor,
          wordID: id);
      await wordsColorsMap.insertWord(word);
      refreshData();
    } else {
      HighlightsModel data =
          {"color": newColor, "wordID": id} as HighlightsModel;
      _werdMistakes.add(data);
    }
    // notifyListeners();
  }
}
