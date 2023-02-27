import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moeen/helpers/general/GeneralHelpers.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:moeen/screens/quran/components/verse_options_bottom_sheet.dart';
import 'package:provider/provider.dart';

final helpers = GeneralHelpers();

class PageWords extends StatelessWidget {
  final int index;
  const PageWords({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (context, quranProvider, child) {
        String pageNumber = (index + 1).toString();
        var lastItem = quranProvider.quran[index].last;
        return Column(
            // loop by the number of lines -> to render the lines in the page
            children: List.generate(lastItem["lineNumber"], (line) {
          int lineNumber = line + 1;
          return Stack(
            children: [
              ...List.generate(quranProvider.quran[index].length, (i) {
                var e = quranProvider.quran[index][i];
                if (e["lineNumber"] == lineNumber) {
                  if (e["isNewChapter"] == 1 && e["isBismillah"] != 1) {
                    return Center(
                      child: Image.asset(
                        "assets/images/markers/ayah_2.png",
                        width: 350,
                        // height: 50,
                        fit: BoxFit.fitWidth,
                      ),
                    );
                  }
                  if (e["charType"] == "end") {
                    return Positioned(
                      top: 15,
                      left: e["x_start"].toDouble() * 0.38,
                      child: Stack(alignment: Alignment.center, children: [
                        Image.asset(
                          "assets/images/markers/ayah_3.png",
                          // fit: BoxFit.fitWidth,
                          width: 25,
                          height: 25,
                        ),
                        Text(
                          helpers.replaceEnglishNumber(
                              e["verseNumber"].toString()),
                          style: const TextStyle(
                            fontFamily: "naskh",
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ]),
                    );
                  }
                  return Positioned(
                    left: e["x_start"].toDouble() * 0.38,
                    child: GestureDetector(
                      child: const SizedBox(
                        width: 20,
                        height: 20,
                      ),

                      // onTap: () {

                      // },
                    ),
                  );
                }
                return const SizedBox();
              }),
              Image.asset(
                "assets/images/quran_images/$pageNumber/$lineNumber.png",
                fit: BoxFit.fitWidth,
                width: 1080,
                height: 50,
              )
            ],
          );
        }));
      },
    );
  }
}

class SurahHeader extends StatelessWidget {
  final double fixedFontSizePercentage;
  final String chapterCode;
  const SurahHeader({
    Key? key,
    required this.fixedFontSizePercentage,
    required this.chapterCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SvgPicture.asset(
          "assets/svg/surah_header_svg.svg",
          width: fixedFontSizePercentage > 30
              ? fixedFontSizePercentage * 20
              : fixedFontSizePercentage * 16,
          height: fixedFontSizePercentage > 30
              ? fixedFontSizePercentage * 1.789
              : fixedFontSizePercentage * 1.72,
        ),
        Text("${chapterCode.padLeft(3, '0')}surah",
            style: TextStyle(
              fontFamily: "surahname",
              letterSpacing: -3,
              fontSize: fixedFontSizePercentage + 5,
            ))
      ],
    );
  }
}

class Bismillah extends StatelessWidget {
  const Bismillah({
    Key? key,
    required this.fixedFontSizePercentage,
  }) : super(key: key);

  final double fixedFontSizePercentage;

  @override
  Widget build(BuildContext context) {
    return Text(
      "ﱁﱂﱃﱄ",
      style: TextStyle(fontFamily: "p1", fontSize: fixedFontSizePercentage),
    );
  }
}

class VerseNumber extends StatelessWidget {
  const VerseNumber({
    Key? key,
    required this.context,
    required this.item,
    required this.fixedFontSizePercentage,
  }) : super(key: key);

  final double fixedFontSizePercentage;
  final BuildContext context;
  final item;

  @override
  Widget build(BuildContext context) {
    // var hasSeperator = quranProvider.seperators.firstWhereOrNull(
    //   (element) =>
    //       element.verseNumber.toString() == item["verseNumber"] &&
    //       element.pageNumber == item["pageNumber"],
    // );
    return GestureDetector(
      onTap: () => {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return VerseOptionsBottomSheet(item: item);
            })
      },
      child: Text(item["text"],
          style: TextStyle(
            color: const Color(0xffae8f74),
            fontSize: fixedFontSizePercentage,
            fontFamily: "p${item['pageNumber']}",
          )),
    );
  }
}
