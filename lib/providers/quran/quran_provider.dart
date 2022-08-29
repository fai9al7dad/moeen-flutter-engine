import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:moeen/helpers/database/quran/quran_database_helper.dart';
import 'package:moeen/helpers/database/seperators/seperators_database.dart';
import 'package:moeen/helpers/database/temp_word_colors/TempWordsColorsMap.dart';
import 'package:moeen/helpers/database/werd_colors_map/WerdsColorsMap.dart';
import 'package:moeen/helpers/database/words_colors/WordsColorsMap.dart';
import 'package:moeen/helpers/dio/api.dart';
import 'package:moeen/helpers/general/constants.dart';

import 'package:collection/collection.dart';

class QuranProvider with ChangeNotifier {
  final wordsColorsMap = WordColorMap();
  final werdColorsMaps = WerdsColorsMap();
  final _pageController = PageController(initialPage: 0);
  final Api api = Api();
  List _quran = [];
  List<WordColorMapModel> _mistakes = [];
  bool _loadingGetData = false;
  List<SeperatorModel> _seperators = [];

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

  List<SeperatorModel> get seperators {
    return _seperators;
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
    await werdColorsMaps.deleteAllColors();
  }

  void getData() async {
    _loadingGetData = true;
    var databaseHelper = DatabaseHelper();
    List q = await databaseHelper.getJoinedQuran();
    _quran = q;
    _loadingGetData = false;
    notifyListeners();
  }

  Future refreshData({pageNumber}) async {
    var m;
    if (_isWerd) {
      m = await werdColorsMaps.getPageColors(pageNumber: pageNumber);
    } else {
      m = await wordsColorsMap.getPageColors(pageNumber: pageNumber);
    }

    _mistakes = m;
    // disabling notify listeners here might mean that first two renderd pages will not show colors
    notifyListeners();
  }

  void refreshSeperotrs() async {
    var databaseHelper = SeperatorsDB();
    _seperators = await databaseHelper.getAllSeperators();
    notifyListeners();
  }

  void updateSeperator(
      {id, name, color, pageNumber, surah, verseNumber}) async {
    var databaseHelper = SeperatorsDB();

    await databaseHelper.updateSeperator(SeperatorModel(
        id: id,
        color: color,
        pageNumber: pageNumber,
        surah: surah,
        name: name,
        verseNumber: int.parse(verseNumber)));

    refreshSeperotrs();
  }

  // clear seperator
  void clearSeperator({id, name, color, pageNumber, surah, verseNumber}) async {
    var databaseHelper = SeperatorsDB();
    databaseHelper.clearSeperator(
      SeperatorModel(
          id: id,
          color: color,
          pageNumber: pageNumber,
          surah: surah,
          name: name,
          verseNumber: int.parse(verseNumber)),
    );
    refreshSeperotrs();
  }

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

    var isExist = _mistakes.firstWhereOrNull((element) => element.wordID == id);
    if (isExist != null) {
      _mistakes.removeWhere((element) => element.wordID == id);
    }
    var word = WordColorMapModel(
        pageNumber: pageNumber,
        verseNumber: int.parse(verseNumber),
        chapterCode: chapterCode,
        color: newColor,
        wordID: id);
    if (!_isWerd) {
      await wordsColorsMap.insertWord(word);
      refreshData(pageNumber: pageNumber);
      try {
        await api.addHighlightBySelfUserID(wordID: id, type: type);
      } on DioError catch (e) {
        print("error from highlight/add endpoint... adding to temp colors ");
        // init tempwrodsColorsMap, and add word to it
        final tempWordsColorsMap = TempWordColorMap();
        var word = TempWordColorMapModel(
            pageNumber: pageNumber,
            verseNumber: int.parse(verseNumber),
            chapterCode: chapterCode,
            color: newColor,
            wordID: id);
        await tempWordsColorsMap.insertWord(word);
      }
    } else {
      await werdColorsMaps.insertWord(word);
      refreshData(pageNumber: pageNumber);

      await api.addHighlightByWerdID(
          werdID: _werd["werdID"],
          reciterUserID: _werd["reciterID"],
          type: type,
          wordID: id);
      if (type == "warning") {
        _werd = {..._werd, "warningsCounter": _werd["warningsCounter"] += 1};
      }
      if (type == "mistake") {
        _werd = {..._werd, "mistakesCounter": _werd["mistakesCounter"] += 1};
        _werd = {..._werd, "warningsCounter": _werd["warningsCounter"] -= 1};
      }
      if (type == "revert") {
        if (_werd["mistakesCounter"] > 0) {
          _werd = {..._werd, "mistakesCounter": _werd["mistakesCounter"] -= 1};
        } else {
          _werd = {..._werd, "mistakesCounter": 0};
        }
      }
    }

    // if (newColor == MistakesColors.revert) {
    //   _werdMistakes.removeWhere((element) => element.wordID == id);
    //   notifyListeners();

    //   return;
    // }

    // notifyListeners();
  }
}
