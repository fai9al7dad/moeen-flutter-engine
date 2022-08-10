import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:sizer/sizer.dart';

class PageWords extends StatelessWidget {
  final List page;

  const PageWords({
    Key? key,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (context, quranProvider, child) => RichText(
        text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.3.sp,
              height: 1.45.sp,
              // shadows: const [
              //   Shadow(
              //     offset: Offset(0.0, 0.0),
              //     blurRadius: 0.2,
              //     color: Color.fromARGB(255, 0, 0, 0),
              //   ),
              // ],
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
                  return const TextSpan(
                      text: "ﱁﱂﱃﱄ\n", style: TextStyle(fontFamily: "p1"));
                }
                return WidgetSpan(
                    child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    SvgPicture.asset(
                      "assets/svg/surah_header_svg.svg",
                    ),
                    Text("${item["chapterCode"].padLeft(3, '0')}",
                        style: const TextStyle(
                            fontFamily: "surahname", fontSize: 25))
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
                    text: "${item["text"]}\n",
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
                  text: "${item["text"]}                       ",
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
                              color: found?.color)
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
                    fontSize: index == 0 ? 18.299.sp : 18.3.sp,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => {
                          // setMW(),
                          quranProvider.addMistake(
                              id: item["wordID"],
                              pageNumber: item["pageNumber"],
                              verseNumber: item["verseNumber"],
                              chapterCode: item["chapterCode"],
                              color: found?.color)
                        });
            })),
        textAlign: TextAlign.center,
      ),
    );
  }
}
