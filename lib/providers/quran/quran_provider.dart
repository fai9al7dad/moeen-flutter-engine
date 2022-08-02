import 'package:flutter/cupertino.dart';
import 'package:moeen/helpers/database/quran/quran_database_helper.dart';
import 'package:moeen/helpers/database/words_colors/WordsColorsMap.dart';
import 'package:moeen/helpers/dio/api.dart';
import 'package:moeen/helpers/general/constants.dart';

import 'package:collection/collection.dart';

class QuranProvider with ChangeNotifier {
  final wordsColorsMap = WordColorMap();
  final _pageController = PageController(initialPage: 0);
  final Api api = Api();
  List _quran = [];
  List<WordColorMapModel> _mistakes = [];
  List<WordColorMapModel> _werdMistakes = [];
  bool _loadingGetData = false;

  // ignore: prefer_final_fields
  Map _werd = {
    "duoID": 0,
    "werdID": 0,
    "username": "",
    "mistakesCounter": 0,
    "warningsCounter": 0,
    "reciterID": 0
  };
  bool _isWerd = false;
  // used mainly when changing to another page, ex: sleect surah

  // late JoinedQuran _currentPage;
  List<WordColorMapModel> get mistakes {
    return _mistakes;
  }

  List<WordColorMapModel> get werdMistakes {
    return _werdMistakes;
  }

  bool get loadingGetData {
    return _loadingGetData;
  }

  bool get isWerd {
    return _isWerd;
  }

  Map get werd {
    return _werd;
  }

  PageController get pageController {
    return _pageController;
  }

  List get quran {
    return _quran;
  }

  void startWerd({required creds}) async {
    _isWerd = true;
    _werd["werdID"] = creds["werdID"];
    _werd["duoID"] = creds["duoID"];
    _werd["username"] = creds["username"];
    _werd["reciterID"] = creds["reciterID"];
    _werdMistakes = creds["mistakes"];

    notifyListeners();
  }

  void finishWerd() async {
    var m = await wordsColorsMap.getAllColors();
    _mistakes = m;
    _isWerd = false;
    _werd["werdID"] = 0;
    _werd["duoID"] = 0;
    _werd["username"] = "";
    _werd["mistakesCounter"] = 0;
    _werd["warningsCounter"] = 0;
    notifyListeners();
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

  // void setWerdMistakes({required List<WordColorMapModel> data}) {
  //   _isWerd = true;
  //   _werdMistakes = data;
  // }

  void addMistake(
      {required id,
      required pageNumber,
      required verseNumber,
      required chapterCode,
      color}) async {
    String newColor;
    String type;
    newColor = MistakesColors.warning;
    type = "warning";

    if (color != null) {
      if (color == MistakesColors.warning) {
        type = "mistake";
        newColor = MistakesColors.mistake;
      }
      if (color == MistakesColors.mistake) {
        type = "revert";

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
      if (type == "warning") {
        _werd = {..._werd, "warningsCounter": _werd["warningsCounter"] += 1};
      }
      if (type == "mistake") {
        _werd = {..._werd, "mistakesCounter": _werd["mistakesCounter"] += 1};
        _werd = {..._werd, "warningsCounter": _werd["warningsCounter"] -= 1};
      }
      if (type == "revert") {
        _werd = {..._werd, "mistakesCounter": _werd["mistakesCounter"] -= 1};
      }
      if (newColor == MistakesColors.revert) {
        _werdMistakes.removeWhere((element) => element.wordID == id);
        notifyListeners();

        return;
      }

      var isExist =
          _werdMistakes.firstWhereOrNull((element) => element.wordID == id);
      if (isExist != null) {
        _werdMistakes.removeWhere((element) => element.wordID == id);
      }
      WordColorMapModel data = WordColorMapModel(
          color: newColor,
          wordID: id,
          pageNumber: pageNumber,
          chapterCode: chapterCode);
      _werdMistakes.add(data);
      notifyListeners();
      await api.addHighlightByWerdID(
          werdID: _werd["werdID"],
          reciterUserID: _werd["reciterID"],
          type: type,
          wordID: id);
    }
    // notifyListeners();
  }
}
