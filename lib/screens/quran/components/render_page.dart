import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:moeen/helpers/database/words_colors/WordsColorsMap.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:moeen/screens/quran/components/page_header.dart';
import 'package:provider/provider.dart'; // You have to add this manually, for some reason it cannot be added automatically
import 'package:flutter_svg/flutter_svg.dart';

class RenderPage extends StatefulWidget {
  final List page;
  const RenderPage({Key? key, required this.page}) : super(key: key);

  @override
  State<RenderPage> createState() => _RenderPageState();
}

class _RenderPageState extends State<RenderPage> {
  List? _mw;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshMw();
  }

  void refreshMw() async {
    final WordColorMap wordColorMap = WordColorMap();
    var mw = await wordColorMap.getPageColorsPage(
        pageNumber: widget.page[0]["pageNumber"]);
    setState(() {
      _mw = mw;
    });
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child:
          // Text(mistakes[0]['id'].toString()),
          Column(
        children: [
          PageHeader(page: widget.page[0]),
          const SizedBox(height: 10),
          Consumer<QuranProvider>(
            builder: (context, quranProvider, child) => RichText(
              text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    height: 1.8,
                  ),
                  // shadows: [
                  //   Shadow(
                  //     offset: Offset(0.0, 0.0),
                  //     blurRadius: 0.5,
                  //     color: Color.fromARGB(255, 0, 0, 0),
                  //   ),
                  // ]),

                  children: List.generate(widget.page.length, (index) {
                    var item = widget.page[index];
                    int curLineNum = widget.page[index]["lineNumber"];
                    // if last item this will return undefined
                    int aftLineNum = index != widget.page.length - 1
                        ? widget.page[index + 1]["lineNumber"]
                        : 15;
                    bool lineChanged = curLineNum != aftLineNum;
                    var found;
                    if (_mw != null) {
                      found = _mw?.firstWhereOrNull(
                          (element) => element.wordID == item["wordID"]);
                    }
                    //   found = mistakes.firstWhere(
                    //       (e) => e.id == page[index]["wordID"]);
                    // }
                    // if()
                    if (item["isNewChapter"] == 1) {
                      if (item["isBismillah"] == 1 &&
                          item["pageNumber"] != 187) {
                        return const TextSpan(
                            text: "ﱁﱂﱃﱄ\n", style: TextStyle(fontFamily: "p1"));
                      }
                      return WidgetSpan(
                          child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          SvgPicture.asset(
                            "assets/svg/surah_header_svg.svg",
                            // color: Colors.blueGrey,
                            // matchTextDirection: true,
                          ),
                          Text("${item["chapterCode"]}",
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
                            fontFamily: "p${widget.page[index]['pageNumber']}",
                          ));
                    }
                    if (item["charType"] == "end" && lineChanged) {
                      return TextSpan(
                          text: "${item["text"]}\n",
                          style: TextStyle(
                            color: const Color(0xffae8f74),
                            fontFamily: "p${widget.page[index]['pageNumber']}",
                          ));
                    }
                    return lineChanged
                        ? TextSpan(
                            text: "${widget.page[index]['text']}\n",
                            style: TextStyle(
                              color: found != null
                                  ? Color(int.parse(found.color))
                                  : Colors.black,
                              fontFamily:
                                  "p${widget.page[index]['pageNumber']}",
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => {
                                    setMW(),
                                    quranProvider.addMistake(
                                        id: item["wordID"],
                                        pageNumber: item["pageNumber"],
                                        verseNumber: item["verseNumber"],
                                        chapterCode: item["chapterCode"],
                                        color: found?.color)
                                  })
                        : TextSpan(
                            text: index == 0
                                ? "${widget.page[index]['text']} "
                                : widget.page[index]['text'],
                            style: TextStyle(
                              color: found != null
                                  ? Color(int.parse(found.color))
                                  : Colors.black,
                              fontFamily:
                                  "p${widget.page[index]['pageNumber']}",
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => {
                                    setMW(),
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
          ),
        ],
      ),
    );
  }
}



// class Word extends StatelessWidget {
//   final int index;
//   final item;
//   final bool lineChanged;

//   const Word(
//       {Key? key,
//       required this.index,
//       required this.item,
//       required this.lineChanged})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<QuranProvider>(builder: (context, quranProvider, child) {
//       var found = quranProvider.mistakes
//           .firstWhereOrNull((element) => element.wordID == item["wordID"]);
//       if (item["isNewChapter"] == 1) {
//         if (item["isBismillah"] == 1 && item["pageNumber"] != 187) {
//           return RichText(
//               text: const TextSpan(
//                   text: "ﱁﱂﱃﱄ\n", style: TextStyle(fontFamily: "p1")));
//         }
//         return RichText(
//             text: TextSpan(
//                 text: "${item["chapterCode"]}\n",
//                 style: const TextStyle(fontFamily: "surahname")));
//       }
//       if (item["charType"] == "end" && !lineChanged) {
//         return RichText(
//             text: TextSpan(
//                 text: item["text"],
//                 style: TextStyle(
//                   color: Colors.green,
//                   fontFamily: "p${item['pageNumber']}",
//                 )));
//       }
//       if (item["charType"] == "end" && lineChanged) {
//         return RichText(
//             text: TextSpan(
//                 text: "${item["text"]}\n",
//                 style: TextStyle(
//                   color: Colors.green,
//                   fontFamily: "p${item['pageNumber']}",
//                 )));
//       }
//       return RichText(
//           text: TextSpan(
//               text: index == 0
//                   ? "${item['text']} "
//                   : lineChanged
//                       ? "${item['text']}\n"
//                       : item['text'],
//               style: TextStyle(
//                 color: found != null
//                     ? Color(int.parse(found.color))
//                     : Colors.black,
//                 fontFamily: "p${item['pageNumber']}",
//               ),
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () => {
//                       quranProvider.addMistake(
//                           id: item["wordID"],
//                           pageNumber: item["pageNumber"],
//                           verseNumber: item["verseNumber"],
//                           chapterCode: item["chapterCode"],
//                           color: found?.color)
//                     }));
//     });
//   }
// }
