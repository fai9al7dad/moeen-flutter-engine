import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:moeen/helpers/database/words_colors/WordsColorsMap.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class PageHeaderMistakesAndWarnings extends StatelessWidget {
  final int pageNumber;

  PageHeaderMistakesAndWarnings({Key? key, required this.pageNumber})
      : super(key: key);

  final wordsColorsMap = WordColorMap();

  @override
  Widget build(BuildContext context) {
    var textColor = 0xffae8f74;

    return Consumer<QuranProvider>(builder: (context, quranProvider, _) {
      var ff;
      if (quranProvider.isWerd) {
        ff = quranProvider.werdMistakes
            .lastWhereOrNull((element) => element.pageNumber == pageNumber);
      } else {
        ff = quranProvider.mistakes
            .firstWhereOrNull((element) => element.pageNumber == pageNumber);
      }

      var mistakes =
          ff?.mistakes == 0 || ff?.mistakes == null ? 0 : ff?.mistakes;
      var warnings =
          ff?.warnings == 0 || ff?.warnings == null ? 0 : ff?.warnings;

      return Row(
        children: [
          warnings! > 0
              ? Row(
                  children: [
                    Text(
                      warnings.toString(),
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(textColor),
                          fontFamily: "montserrat"),
                    ),
                    const SizedBox(width: 1),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(int.parse(MistakesColors.warning))),
                      height: 8,
                      width: 8,
                    ),
                  ],
                )
              : const SizedBox(width: 13),
          const SizedBox(width: 4),
          mistakes! > 0
              ? Row(
                  children: [
                    Text(
                      mistakes.toString(),
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(textColor),
                          fontFamily: "montserrat"),
                    ),
                    const SizedBox(width: 1),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(int.parse(MistakesColors.mistake))),
                      height: 8,
                      width: 8,
                    ),
                  ],
                )
              : const SizedBox(width: 13),
        ],
      );
    });
    // return Text("a");
  }
}
