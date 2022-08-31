import 'dart:developer';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moeen/components/CustomShowCase.dart';
import 'package:moeen/helpers/database/quran/quran_models.dart';
import 'package:moeen/helpers/database/seperators/seperators_database.dart';
import 'package:moeen/helpers/database/words_colors/WordsColorsMap.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:moeen/screens/quran/components/verse_options_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:showcaseview/showcaseview.dart';

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
          height: fixedLineHeightPercentage,
          fontSize: fixedFontSizePercentage,
        ),
        text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              height: fixedLineHeightPercentage,
              fontSize: fixedFontSizePercentage,
              shadows: const [
                Shadow(
                  offset: Offset(0.0, 0.0),
                  blurRadius: 0.1,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
            ),
            children: List.generate(page.length, (index) {
              var item = page[index];
              int curLineNum = page[index]["lineNumber"];
              // if last item this will return undefined
              int aftLineNum =
                  index != page.length - 1 ? page[index + 1]["lineNumber"] : 15;
              bool lineChanged = curLineNum != aftLineNum;

              var hasSeperator = quranProvider.seperators.firstWhereOrNull(
                (element) =>
                    element.verseNumber.toString() == item["verseNumber"] &&
                    element.pageNumber == item["pageNumber"],
              );

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
                            fontSize: fixedFontSizePercentage + 3,
                          )),
                      Text("ﱃ",
                          style: TextStyle(
                            fontFamily: "p1",
                            fontSize: fixedFontSizePercentage + 3,
                          )),
                      Text("ﱂ",
                          style: TextStyle(
                            fontFamily: "p1",
                            fontSize: fixedFontSizePercentage + 3,
                          )),
                      Text("ﱁ",
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
                    Text("${item["chapterCode"].padLeft(3, '0')}surah",
                        style: TextStyle(
                          fontFamily: "surahname",
                          letterSpacing: -3,
                          fontSize: fixedFontSizePercentage + 5,
                        ))
                  ],
                ));
              }
              if (item["charType"] == "end" && !lineChanged) {
                return TextSpan(
                    text: item["text"],
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return VerseOptionsBottomSheet(item: item);
                                })
                          },
                    style: TextStyle(
                      // backgroundColor: hasSeperator != null
                      //     ? Color(int.parse(hasSeperator.color ?? "0xffae8f74"))
                      //     : null,
                      color: hasSeperator != null
                          ? Color(int.parse(hasSeperator.color ?? "0xffae8f74"))
                          : const Color(0xffae8f74),
                      fontFamily: "p${page[index]['pageNumber']}",
                    ));
              }
              if (item["charType"] == "end" && lineChanged) {
                return TextSpan(
                    text: page[index]['pageNumber'] < 3 ||
                            item["chapterCode"] == "114"
                        ? "${item["text"]}                                      "
                        : "${item["text"]} ",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return VerseOptionsBottomSheet(item: item);
                                })
                          },
                    style: TextStyle(
                      // backgroundColor: hasSeperator != null
                      //     ? Color(int.parse(hasSeperator.color ?? "0xffae8f74"))
                      //     : null,

                      color: hasSeperator != null
                          ? Color(int.parse(hasSeperator.color ?? "0xffae8f74"))
                          : const Color(0xffae8f74),
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
                  text:
                      "${item["text"]}                                        ",
                  style: TextStyle(
                    color: found != null ? Color(int.parse(found.color)) : null,
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
              if (index == 0 ||
                  (item['audioUrl'] != null &&
                      item['audioUrl'].substring(8, 15) == "001_001")) {
                return TextSpan(
                  text: item["text"] + " ",
                  style: TextStyle(
                    // backgroundColor: Colors.red,
                    letterSpacing: -4,
                    color: found != null ? Color(int.parse(found.color)) : null,
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
                      color:
                          found != null ? Color(int.parse(found.color)) : null,
                      fontFamily: "p${page[index]['pageNumber']}",
                      letterSpacing:
                          index == 0 ? fixedFontSizePercentage - 18.5 : null,
                      fontSize: fixedFontSizePercentage),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => {
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



// class PageWords extends StatefulWidget {
//   final List page;
//   final double fixedFontSizePercentage;
//   final double fixedLineHeightPercentage;

//   const PageWords(
//       {Key? key,
//       required this.page,
//       required this.fixedFontSizePercentage,
//       required this.fixedLineHeightPercentage})
//       : super(key: key);

//   @override
//   State<PageWords> createState() => _PageWordsState();
// }

// class _PageWordsState extends State<PageWords> {
//   List<List<Widget>> rows = [];
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fillRows();
//   }

//   void fillRows() {
//     // List mistakes = Provider.of<QuranProvider>(context, listen: false).mistakes;
//     List<List<Widget>> rows = [];
//     for (int i = 0; i < 15; i++) {
//       rows.add([]);
//     }
//     int curRow = 0;

//     for (int i = 0; i < widget.page.length; i++) {
//       var item = widget.page[i];

//       final row = Row(
//         children: [
//           if (item["isNewChapter"] == 1 &&
//               item["isBismillah"] == 1 &&
//               item["pageNumber"] != 187)
//             Bismillah(
//               fixedFontSizePercentage: widget.fixedFontSizePercentage,
//             ),
//           if (item["isNewChapter"] == 1 && item["isBismillah"] != 1)
//             SurahHeader(
//               fixedFontSizePercentage: widget.fixedFontSizePercentage,
//               chapterCode: item["chapterCode"],
//             ),
//           if (item["isNewChapter"] == 1 && item["pageNumber"] == 187)
//             SurahHeader(
//               fixedFontSizePercentage: widget.fixedFontSizePercentage,
//               chapterCode: item["chapterCode"],
//             ),
//           if (item["charType"] == "end")
//             VerseNumber(
//               context: context,
//               item: item,
//               fixedFontSizePercentage: widget.fixedFontSizePercentage,
//             ),
//           if (item["charType"] == "word")
//             Word(
//               color: null,
//               item: item,
//               index: i,
//               fixedFontSizePercentage: widget.fixedFontSizePercentage,
//             ),
//         ],
//       );
//       int curLineNum = item["lineNumber"];
//       // if last item this will return undefined
//       int aftLineNum =
//           i != widget.page.length - 1 ? widget.page[i + 1]["lineNumber"] : 15;
//       bool lineChanged = curLineNum != aftLineNum;

//       rows[curRow].add(row);
//       if (lineChanged) {
//         curRow++;
//       }
//     }
//     if (mounted) {
//       setState(() {
//         this.rows = rows;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//         children: List.generate(rows.length, (row) {
//       return SizedBox(
//         height: widget.fixedLineHeightPercentage *
//             MediaQuery.of(context).size.height *
//             0.0315,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: rows[row],
//         ),
//       );
//     }));
//   }
// }

// class SurahHeader extends StatelessWidget {
//   final double fixedFontSizePercentage;
//   final String chapterCode;
//   const SurahHeader({
//     Key? key,
//     required this.fixedFontSizePercentage,
//     required this.chapterCode,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: AlignmentDirectional.center,
//       children: [
//         SvgPicture.asset(
//           "assets/svg/surah_header_svg.svg",
//           width: fixedFontSizePercentage > 30
//               ? fixedFontSizePercentage * 20
//               : fixedFontSizePercentage * 16,
//           height: fixedFontSizePercentage > 30
//               ? fixedFontSizePercentage * 1.789
//               : fixedFontSizePercentage * 1.72,
//         ),
//         Text("${chapterCode.padLeft(3, '0')}surah",
//             style: TextStyle(
//               fontFamily: "surahname",
//               letterSpacing: -3,
//               fontSize: fixedFontSizePercentage + 5,
//             ))
//       ],
//     );
//   }
// }

// class Bismillah extends StatelessWidget {
//   const Bismillah({
//     Key? key,
//     required this.fixedFontSizePercentage,
//   }) : super(key: key);

//   final double fixedFontSizePercentage;

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       "ﱁﱂﱃﱄ",
//       style: TextStyle(fontFamily: "p1", fontSize: fixedFontSizePercentage),
//     );
//   }
// }

// class VerseNumber extends StatelessWidget {
//   const VerseNumber({
//     Key? key,
//     required this.context,
//     required this.item,
//     required this.fixedFontSizePercentage,
//   }) : super(key: key);

//   final double fixedFontSizePercentage;
//   final BuildContext context;
//   final item;

//   @override
//   Widget build(BuildContext context) {
//     // var hasSeperator = quranProvider.seperators.firstWhereOrNull(
//     //   (element) =>
//     //       element.verseNumber.toString() == item["verseNumber"] &&
//     //       element.pageNumber == item["pageNumber"],
//     // );
//     return GestureDetector(
//       onTap: () => {
//         showModalBottomSheet(
//             context: context,
//             builder: (context) {
//               return VerseOptionsBottomSheet(item: item);
//             })
//       },
//       child: Text(item["text"],
//           style: TextStyle(
//             color: const Color(0xffae8f74),
//             fontSize: fixedFontSizePercentage,
//             fontFamily: "p${item['pageNumber']}",
//           )),
//     );
//   }
// }

// class Word extends StatelessWidget {
//   const Word({
//     Key? key,
//     required this.color,
//     required this.item,
//     required this.fixedFontSizePercentage,
//     required this.index,
//   }) : super(key: key);

//   final double fixedFontSizePercentage;
//   final item;
//   final color;
//   final int index;

//   @override
//   Widget build(BuildContext context) {
//     // var found = quranProvider.mistakes
//     //     .firstWhereOrNull((element) => element.wordID == item["wordID"]);
//     return GestureDetector(
//       onTap: () => {
//         // quranProvider.addMistake(
//         //     id: item["wordID"],
//         //     pageNumber: item["pageNumber"],
//         //     verseNumber: item["verseNumber"],
//         //     chapterCode: item["chapterCode"],
//         //     color: found?.color),
//         // HapticFeedback.lightImpact(),
//       },
//       child: Text(
//         "${item["text"]}",
//         style: TextStyle(
//           fontSize: fixedFontSizePercentage,
//           fontFamily: "p${item["pageNumber"]}",
//           color: color,
//           letterSpacing: index == 0 ? 4 : 0,
//           shadows: const [
//             Shadow(
//               offset: Offset(0.0, 0.0),
//               blurRadius: 0.1,
//               color: Color.fromARGB(255, 0, 0, 0),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }