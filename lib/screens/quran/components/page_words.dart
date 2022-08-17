import 'dart:developer';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class PageWords extends StatelessWidget {
  final List page;
  final double fixedFontSizePercentage;
  final double fixedLineHeightPercentage;
  const PageWords(
      {Key? key,
      required this.page,
      required this.fixedFontSizePercentage,
      required this.fixedLineHeightPercentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (context, quranProvider, child) => RichText(
        strutStyle: StrutStyle(
          fontSize: fixedFontSizePercentage,
          height: fixedLineHeightPercentage,
        ),
        text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              height: fixedLineHeightPercentage,
              fontSize: fixedFontSizePercentage,
            ),
            children: List.generate(page.length, (index) {
              var item = page[index];
              int curLineNum = page[index]["lineNumber"];
              // if last item this will return undefined
              int aftLineNum =
                  index != page.length - 1 ? page[index + 1]["lineNumber"] : 15;
              bool lineChanged = curLineNum != aftLineNum;

              var found;

              found = quranProvider.mistakes.firstWhereOrNull(
                  (element) => element.wordID == item["wordID"]);
              if (item["isNewChapter"] == 1) {
                if (item["isBismillah"] == 1 && item["pageNumber"] != 187) {
                  return WidgetSpan(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("ﱄ",
                          style: TextStyle(
                            fontFamily: "p1",
                            fontSize: fixedFontSizePercentage,
                          )),
                      Text("ﱃ",
                          style: TextStyle(
                            fontFamily: "p1",
                            fontSize: fixedFontSizePercentage,
                          )),
                      Text("ﱂ",
                          style: TextStyle(
                            fontFamily: "p1",
                            fontSize: fixedFontSizePercentage,
                          )),
                      Text("ﱁ",
                          style: TextStyle(
                            fontFamily: "p1",
                            fontSize: fixedFontSizePercentage,
                          )),
                    ],
                  ));
                }
                return WidgetSpan(
                    child: Stack(
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
                    Text("${item["chapterCode"].padLeft(3, '0')}",
                        style: TextStyle(
                            fontFamily: "surahname",
                            fontSize: fixedFontSizePercentage))
                  ],
                ));

                // TextSpan(
                //     text: "${item["chapterCode"]}\n",
                //     style: const TextStyle(fontFamily: "surahname"));
              }
              if (item["charType"] == "end" && !lineChanged) {
                return TextSpan(
                    text: item["text"],
                    style: TextStyle(
                      color: const Color(0xffae8f74),
                      fontFamily: "p${page[index]['pageNumber']}",
                      // shadows: const [
                      //   Shadow(
                      //     offset: Offset(0.0, 0.0),
                      //     blurRadius: 0.2,
                      //     color: Color.fromARGB(255, 0, 0, 0),
                      //   ),
                      // ],
                    ));
              }
              if (item["charType"] == "end" && lineChanged) {
                return TextSpan(
                    text: page[index]['pageNumber'] < 3 ||
                            item["chapterCode"] == "114"
                        ? "${item["text"]}\n"
                        : "${item["text"]} ",
                    style: TextStyle(
                      color: const Color(0xffae8f74),
                      fontFamily: "p${page[index]['pageNumber']}",

                      // shadows: const [
                      //   Shadow(
                      //     offset: Offset(0.0, 0.0),
                      //     blurRadius: 0.2,
                      //     color: Color.fromARGB(255, 0, 0, 0),
                      //   ),
                      // ],
                    ));
              }
              // for fatihah
              if ((page[index]['pageNumber'] == 1 ||
                      page[index]['pageNumber'] == 2) &&
                  lineChanged) {
                return TextSpan(
                  text: "${item["text"]}\n",
                  style: TextStyle(
                    color: found != null
                        ? Color(int.parse(found.color))
                        : Colors.black,
                    fontFamily: "p${page[index]['pageNumber']}",
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => {
                          // setMW(),
                          quranProvider.addMistake(
                              id: item["wordID"],
                              pageNumber: item["pageNumber"],
                              verseNumber: item["verseNumber"],
                              chapterCode: item["chapterCode"],
                              color: found?.color),
                          HapticFeedback.lightImpact(),
                        },
                );
              }
              return TextSpan(
                  text: lineChanged
                      ? page[index]['text'] + " "
                      : page[index]['text'],
                  style: TextStyle(
                    color: found != null
                        ? Color(int.parse(found.color))
                        : Colors.black,
                    fontFamily: "p${page[index]['pageNumber']}",
                    fontSize: index == 0
                        ? fixedFontSizePercentage - 0.001
                        : index == 1
                            ? fixedFontSizePercentage - 0.002
                            : index == 2
                                ? fixedFontSizePercentage - 0.003
                                : fixedFontSizePercentage,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => {
                          // setMW(),
                          quranProvider.addMistake(
                              id: item["wordID"],
                              pageNumber: item["pageNumber"],
                              verseNumber: item["verseNumber"],
                              chapterCode: item["chapterCode"],
                              color: found?.color),
                          HapticFeedback.lightImpact(),
                        });
            })),
        textAlign: TextAlign.center,
      ),
    );
  }
}
