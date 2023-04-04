import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:moeen/common/services/constants.dart';
import 'package:moeen/features/highlights/highlights_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class PageMistakesAndWarnings extends StatelessWidget {
  final int pageNumber;
  final double fixedFontSizePercentageForHeader;

  const PageMistakesAndWarnings(
      {Key? key,
      required this.pageNumber,
      required this.fixedFontSizePercentageForHeader})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textColor = 0xffae8f74;

    return Consumer<HighlightsProvider>(
        builder: (context, highlightsProvider, _) {
      var ff = highlightsProvider.mistakes
          .firstWhereOrNull((element) => element.pageNumber == pageNumber);

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
                          fontSize: fixedFontSizePercentageForHeader,
                          color: Color(textColor),
                          fontFamily: "montserrat"),
                    ),
                    const SizedBox(width: 1),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(int.parse(MistakesColors.warning))),
                      height: fixedFontSizePercentageForHeader - 5,
                      width: fixedFontSizePercentageForHeader - 5,
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
                          fontSize: fixedFontSizePercentageForHeader,
                          color: Color(textColor),
                          fontFamily: "montserrat"),
                    ),
                    const SizedBox(width: 1),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(int.parse(MistakesColors.mistake))),
                      height: fixedFontSizePercentageForHeader - 5,
                      width: fixedFontSizePercentageForHeader - 5,
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
