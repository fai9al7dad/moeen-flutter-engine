import 'package:flutter/material.dart';
import 'package:moeen/features/highlights/highlight_model.dart';
import 'package:moeen/features/highlights/self_highlights_provider.dart';
import 'package:moeen/features/werds/werds_provider.dart';
import 'package:provider/provider.dart';

abstract class IHighlightsProvider {
  void addMistake(BuildContext context,
      {required id,
      required pageNumber,
      required verseNumber,
      required chapterCode,
      color});
}

class HighlightsProvider with ChangeNotifier implements IHighlightsProvider {
  List<HighlightModel> _mistakes = [];
  List<HighlightModel> get mistakes => _mistakes;

  Future refreshPage(BuildContext context, {pageNumber}) async {
    // bool isWerd = Provider.of<WerdsProvider>(context, listen: false).isWerd;
    // if (isWerd) {
    //   _mistakes = await werdDatabaseApi.getPageColors(pageNumber: pageNumber);
    // } else {
    _mistakes =
        await highlightsDatabaseApi.getPageColors(pageNumber: pageNumber);
    // }

    notifyListeners();
  }

  Future refreshData() async {
    _mistakes = await highlightsDatabaseApi.getAllColors();
    notifyListeners();
  }

  @override
  void addMistake(BuildContext context,
      {required id,
      required pageNumber,
      required verseNumber,
      required chapterCode,
      color}) async {
    bool isWerd = Provider.of<WerdsProvider>(context, listen: false).isWerd;
    if (isWerd) {
      Provider.of<WerdsProvider>(context, listen: false).addMistake(context,
          id: id,
          pageNumber: pageNumber,
          verseNumber: verseNumber,
          color: color,
          chapterCode: chapterCode);
    } else {
      Provider.of<SelfHighLightsProvider>(context, listen: false).addMistake(
          context,
          id: id,
          pageNumber: pageNumber,
          verseNumber: verseNumber,
          color: color,
          chapterCode: chapterCode);
    }
  }
}
