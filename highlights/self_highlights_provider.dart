import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moeen/common/services/api.dart';
import 'package:moeen/common/services/constants.dart';
import 'package:moeen/features/highlights/highlight_model.dart';
import 'package:moeen/features/highlights/highlights_database_api.dart';
import 'package:collection/collection.dart';
import 'package:moeen/features/highlights/highlights_provider.dart';
import 'package:moeen/features/temp_highlights/temp_highlights_database_api.dart';
import 'package:provider/provider.dart';

final highlightsDatabaseApi = HighlightsDatabaseApi();
final tempHighlightsDatabaseApi = TempHighlightsDatabaseApi();
final api = Api();

class SelfHighLightsProvider
    with ChangeNotifier
    implements IHighlightsProvider {
  @override
  void addMistake(BuildContext context,
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

    var word = HighlightModel(
        pageNumber: pageNumber,
        verseNumber: verseNumber,
        chapterCode: chapterCode,
        color: newColor,
        wordID: id);
    await highlightsDatabaseApi.insertWord(word);
    Provider.of<HighlightsProvider>(context, listen: false)
        .refreshPage(context, pageNumber: pageNumber);
   
  }
}
