import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:moeen/screens/quran/components/verse_options_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class PageWords extends StatelessWidget {
  final int pageIndex;
  const PageWords({
    Key? key,
    required this.pageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(builder: (context, quranProvider, child) {
      var page = quranProvider.quran.pages![pageIndex];
      return LayoutBuilder(
        builder: (context, constraints) {
          double fixedFontSizePercentage = constraints.maxWidth / 16.5;
          double fixedLineHeightPercentage =
              (constraints.maxHeight / 15) / fixedFontSizePercentage * 0.92;
          return RichText(
            textDirection: TextDirection.rtl,
            text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  height: fixedLineHeightPercentage,
                  fontSize: fixedFontSizePercentage,
                ),
                children: List.generate(page.length, (index) {
                  var item = page[index];
                  int curLineNum = page[index].lineNumber!;
                  // if last item this will return undefined
                  int aftLineNum = index != page.length - 1
                      ? page[index + 1].lineNumber!
                      : 15;
                  bool lineChanged = curLineNum != aftLineNum;

                  var hasSeperator = quranProvider.seperators.firstWhereOrNull(
                      (element) => element.wordID == item.id!);

                  var found = quranProvider.mistakes.firstWhereOrNull(
                      (element) => element.wordID == item.id!);
                  if (item.isNewChapter!) {
                    if (item.isBismillah! && item.pageNumber! != 187) {
                      return WidgetSpan(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("ﱁ",
                              style: TextStyle(
                                fontFamily: "p1",
                                fontSize: fixedFontSizePercentage + 3,
                              )),
                          Text("ﱂ",
                              style: TextStyle(
                                fontFamily: "p1",
                                fontSize: fixedFontSizePercentage + 3,
                              )),
                          Text("ﱃ",
                              style: TextStyle(
                                fontFamily: "p1",
                                fontSize: fixedFontSizePercentage + 3,
                              )),
                          Text("ﱄ",
                              style: TextStyle(
                                fontFamily: "p1",
                                fontSize: fixedFontSizePercentage + 3,
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
                        Text("${item.chapterCode!.padLeft(3, '0')}surah",
                            style: TextStyle(
                              fontFamily: "surahname",
                              letterSpacing: -3,
                              fontSize: fixedFontSizePercentage + 5,
                            )),
                      ],
                    ));
                  }
                  if (item.charType! == "end" && !lineChanged) {
                    return TextSpan(
                        text: item.text!,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return VerseOptionsBottomSheet(
                                          item: item);
                                    })
                              },
                        style: TextStyle(
                          // backgroundColor: hasSeperator != null
                          //     ? Color(int.parse(hasSeperator.color ?? "0xffae8f74"))
                          //     : null,
                          color: hasSeperator != null
                              ? Color(
                                  int.parse(hasSeperator.color ?? "0xffae8f74"))
                              : const Color(0xffae8f74),
                          fontFamily: "p${page[index].pageNumber}",
                        ));
                  }
                  if (item.charType! == "end" && lineChanged) {
                    return TextSpan(
                        text: page[index].pageNumber! < 3 ||
                                item.chapterCode! == "114"
                            ? "${item.text}                                      "
                            : "${item.text} ",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return VerseOptionsBottomSheet(
                                          item: item);
                                    })
                              },
                        style: TextStyle(
                          // backgroundColor: hasSeperator != null
                          //     ? Color(int.parse(hasSeperator.color ?? "0xffae8f74"))
                          //     : null,

                          color: hasSeperator != null
                              ? Color(
                                  int.parse(hasSeperator.color ?? "0xffae8f74"))
                              : const Color(0xffae8f74),
                          fontFamily: "p${page[index].pageNumber}",
                        ));
                  }

                  if ((page[index].pageNumber == 1 ||
                          page[index].pageNumber == 2) &&
                      lineChanged) {
                    return TextSpan(
                      text:
                          "${item.text}                                        ",
                      style: TextStyle(
                        color: found != null
                            ? Color(int.parse(found.color ?? "0xff000000"))
                            : null,
                        fontFamily: "p${page[index].pageNumber}",
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => {
                              quranProvider.addMistake(
                                  context: context,
                                  id: item.id!,
                                  pageNumber: item.pageNumber!,
                                  verseNumber: item.verseNumber!,
                                  chapterCode: item.chapterCode!,
                                  color: found?.color),
                              HapticFeedback.lightImpact(),
                            },
                    );
                  }

                  if (index == 0 ||
                      (item.audioUrl != null &&
                          item.audioUrl!.substring(8, 15) == "001_001")) {
                    return TextSpan(
                      text: item.text == "ﱁﱂ" ? item.text : "${item.text!} ",
                      style: TextStyle(
                        // backgroundColor: Colors.red,
                        letterSpacing: item.text == "ﱁﱂ" ? 4 : -5,
                        color: found != null
                            ? Color(int.parse(found.color ?? "0xff000000"))
                            : null,
                        fontFamily: "p${page[index].pageNumber}",
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => {
                              // setMW(),
                              quranProvider.addMistake(
                                  context: context,
                                  id: item.id,
                                  pageNumber: item.pageNumber,
                                  verseNumber: item.verseNumber,
                                  chapterCode: item.chapterCode,
                                  color: found?.color),
                              HapticFeedback.lightImpact(),
                            },
                    );
                  }
                  return TextSpan(
                      text: lineChanged
                          ? "${page[index].text!} "
                          : page[index].text!,
                      style: TextStyle(
                        color: found != null
                            ? Color(int.parse(found.color ?? "0xff000000"))
                            : null,
                        fontFamily: "p${page[index].pageNumber}",
                        fontSize: index == 0
                            ? fixedFontSizePercentage + 0.1
                            : fixedFontSizePercentage,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => {
                              quranProvider.addMistake(
                                  context: context,
                                  id: item.id!,
                                  pageNumber: item.pageNumber!,
                                  verseNumber: item.verseNumber!,
                                  chapterCode: item.chapterCode!,
                                  color: found?.color),
                              HapticFeedback.lightImpact(),
                            });
                })),
            textAlign: TextAlign.center,
          );
        },
      );
    });
  }
}
