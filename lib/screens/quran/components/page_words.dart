import 'dart:developer';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moeen/components/CustomShowCase.dart';
import 'package:moeen/helpers/database/quran/quran_models.dart';
import 'package:moeen/helpers/database/seperators/seperators_database.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
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
          fontSize: fixedFontSizePercentage,
          height: fixedLineHeightPercentage,
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

                // TextSpan(
                //     text: "${item["chapterCode"]}\n",
                //     style: const TextStyle(fontFamily: "surahname"));
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
              return TextSpan(
                  text: lineChanged
                      ? page[index]['text'] + " "
                      : page[index]['text'],
                  style: TextStyle(
                      color:
                          found != null ? Color(int.parse(found.color)) : null,
                      fontFamily: "p${page[index]['pageNumber']}",
                      letterSpacing:
                          index == 0 ? fixedFontSizePercentage - 18.5 : 0,
                      fontSize: fixedFontSizePercentage),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => {
                          // setMW(),
                          // quranProvider.addSeperator(
                          //     pageNumber: item["pageNumber"],
                          //     verseNumber: item["verseNumber"],
                          //     color: found?.color),
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

class VerseOptionsBottomSheet extends StatefulWidget {
  const VerseOptionsBottomSheet({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Map<String, dynamic> item;

  @override
  State<VerseOptionsBottomSheet> createState() =>
      _VerseOptionsBottomSheetState();
}

class _VerseOptionsBottomSheetState extends State<VerseOptionsBottomSheet> {
  List<SeperatorModel> seperators = [];
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSeperators();
  }

  void fetchSeperators() async {
    final seperatorsDB = SeperatorsDB();
    var _seperators = await seperatorsDB.getAllSeperators();
    if (mounted) {
      setState(() {
        seperators = _seperators;
        loading = false;
      });
    }
  }

  void addSeperator(context, id, color, name, pageNumber, verseNumber) {
    Navigator.of(context).pop();
    // if new seperator same as exisiting delete it
    if (pageNumber == widget.item["pageNumber"] &&
        verseNumber.toString() == widget.item["verseNumber"]) {
      Provider.of<QuranProvider>(context, listen: false).clearSeperator(
          id: id,
          pageNumber: widget.item["pageNumber"],
          verseNumber: widget.item["verseNumber"],
          color: color,
          surah: widget.item["chapterCode"],
          name: name);
    } else {
      Provider.of<QuranProvider>(context, listen: false).updateSeperator(
          id: id,
          pageNumber: widget.item["pageNumber"],
          verseNumber: widget.item["verseNumber"],
          color: color,
          surah: widget.item["chapterCode"],
          name: name);
    }
  }

  void navigateToQuranPage({required int page}) {
    Navigator.of(context).pop();

    Provider.of<QuranProvider>(context, listen: false)
        .pageController
        .jumpToPage(page - 1);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 180,
      );
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: const Color(0xfffff8ed),
        height: 400,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("وضع فاصل",
                  style: TextStyle(
                    fontFamily: "montserrat-bold",
                    fontSize: 20,
                  )),
              const SizedBox(
                height: 10,
              ),
              const Text("اضفط مطولا للإنتقال إلى الموضع",
                  style: TextStyle(
                    fontFamily: "montserrat",
                    color: Colors.grey,
                    fontSize: 14,
                  )),
              Expanded(
                child: ListView.builder(
                    itemCount: seperators.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          iconColor: Color(int.parse(
                              seperators[index].color ?? "0xffae8f74")),
                          leading: seperators[index].verseNumber != null
                              ? const Icon(Icons.bookmark)
                              : const Icon(Icons.bookmark_add_outlined),
                          trailing: seperators[index].verseNumber != null
                              ? IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: () => navigateToQuranPage(
                                      page: seperators[index].pageNumber!))
                              : null,
                          onLongPress: seperators[index].pageNumber != null
                              ? () => navigateToQuranPage(
                                  page: seperators[index].pageNumber!)
                              : null,
                          onTap: () => addSeperator(
                                context,
                                seperators[index].id,
                                seperators[index].color,
                                seperators[index].name,
                                seperators[index].pageNumber,
                                seperators[index].verseNumber,
                              ),
                          title: Text(
                            "${seperators[index].name}",
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: seperators[index].surah != null
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("${seperators[index].surah}surah",
                                        style: const TextStyle(
                                            fontSize: 26,
                                            letterSpacing: -3,
                                            fontFamily: "surahname")),
                                    Text(
                                        "أية ${seperators[index].verseNumber} صفحة ${seperators[index].pageNumber}",
                                        style: const TextStyle(fontSize: 14)),
                                  ],
                                )
                              : const Text(""));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
