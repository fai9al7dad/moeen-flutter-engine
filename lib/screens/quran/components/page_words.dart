import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moeen/helpers/database/quran/quran_database_helper.dart';
import 'package:moeen/helpers/general/GeneralHelpers.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:moeen/screens/quran/components/verse_options_bottom_sheet.dart';
import 'package:provider/provider.dart';

final helpers = GeneralHelpers();

class PageWords extends StatefulWidget {
  final int index;
  const PageWords({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<PageWords> createState() => _PageWordsState();
}

class _PageWordsState extends State<PageWords> {
  List data = [];
  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(builder: (context, quranProvider, child) {
      String pageNumber = (widget.index + 1).toString();
      var lastItem = quranProvider.quran[widget.index].last;
      return LayoutBuilder(builder: (context, constraints) {
        double xOffset = constraints.maxWidth / 1080;
        double lineHeight = (constraints.maxHeight - 50) / 15;
        return Column(
          mainAxisAlignment: widget.index < 2
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          // loop by the number of lines -> to render the lines in the page
          children: List.generate(lastItem["lineNumber"], (line) {
            int lineNumber = line + 1;
            return Stack(children: [
              ...List.generate(quranProvider.quran[widget.index].length, (i) {
                var e = quranProvider.quran[widget.index][i];

                if (lineNumber == e["lineNumber"]) {
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
                      left: e["x_start"].toDouble() * xOffset,
                      child: Stack(alignment: Alignment.center, children: [
                        Image.asset(
                          "assets/images/markers/ayah_3.png",
                          // fit: BoxFit.fitWidth,
                          width: 22,
                          height: 22,
                        ),
                        Text(
                          helpers.replaceEnglishNumber(
                              e["verseNumber"].toString()),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Colors.black,
                          ),
                        ),
                      ]),
                    );
                  }
                }
                return const SizedBox();
              }),
              GestureDetector(
                // get coordinates of the tap
                onTapDown: (TapDownDetails details) async {
                  double x = details.localPosition.dx * 2.6;
                  // call sqlite to get the word
                  final db = DatabaseHelper();
                  var word = await db.getWordByX(
                      x: x, pageNumber: pageNumber, lineNumber: lineNumber);
                  // data.add(word[0]);
                  // setState(() {});
                },
                child: Image.asset(
                  "assets/images/quran_images/$pageNumber/$lineNumber.png",
                  fit: BoxFit.fitWidth,
                  width: 1080,
                  height: lineHeight,
                ),
              ),
              ...List.generate(data.length, (i) {
                if (data[i]["lineNumber"] == lineNumber) {
                  return Positioned(
                    left: data[i]["x_start"].toDouble() * xOffset,
                    child: Container(
                      width: data[i]["x_end"].toDouble() * xOffset -
                          data[i]["x_start"].toDouble() * xOffset,
                      height: lineHeight,
                      decoration: const BoxDecoration(
                          color: Colors.red,
                          backgroundBlendMode: BlendMode.lighten),
                      // make the color of thi
                    ),
                  );
                }
                return const SizedBox();
              }),
            ]);
          }),
        );
      });
    });
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
