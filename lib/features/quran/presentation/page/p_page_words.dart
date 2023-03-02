import 'package:flutter/material.dart';
import 'package:moeen/common/data/data_sources/GeneralHelpers.dart';
import 'package:moeen/features/quran/domain/usecases/quran_provider.dart';
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
    return Consumer<QuranProvider>(builder: (context, quranProvider, child) {
      var page = quranProvider.quran.pages![index];
      String pageNumber = (index + 1).toString();
      var lastItem = quranProvider.quran.pages![index].last;
      return LayoutBuilder(builder: (context, constraints) {
        double xOffset = constraints.maxWidth / 1080;
        double lineHeight = (constraints.maxHeight - 50) / 15;
        return Column(
          mainAxisAlignment:
              index < 2 ? MainAxisAlignment.center : MainAxisAlignment.start,
          // loop by the number of lines -> to render the lines in the page
          children: List.generate(lastItem.lineNumber!, (line) {
            int lineNumber = line + 1;
            return Stack(children: [
              ...List.generate(page.length, (i) {
                var e = page[i];

                if (lineNumber == e.lineNumber) {
                  if (e.isNewChapter! && !e.isBismillah!) {
                    return Center(
                      child: Image.asset(
                        "assets/images/markers/ayah_2.png",
                        // width: double.infinity * 0.8,
                        // height: 52,
                        fit: BoxFit.fitWidth,
                      ),
                    );
                  }
                  if (e.charType == "end") {
                    return Positioned(
                      top: lineHeight / 3, // through trail and error
                      left: e.xStart!.toDouble() * xOffset,
                      child: Stack(alignment: Alignment.center, children: [
                        Image.asset(
                          "assets/images/markers/ayah_3.png",
                          // fit: BoxFit.fitWidth,
                          width: lineHeight / 2.2, // through trail and error
                          height: lineHeight / 2.2, // through trail and error
                        ),
                        Text(
                          helpers
                              .replaceEnglishNumber(e.verseNumber.toString()),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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
                  // final db = DatabaseHelper();
                  // var word = await db.getWordByX(
                  //     x: x, pageNumber: pageNumber, lineNumber: lineNumber);

                  // quranProvider.addMistake(
                  //     id: word["id"],
                  //     pageNumber: int.parse(pageNumber),
                  //     verseNumber: word["verseNumber"],
                  //     lineNumber: lineNumber,
                  //     x_start: word["x_start"],
                  //     x_end: word["x_end"],
                  //     chapterCode: word["chapterCode"],
                  //     context: context);
                  // // data.add(word[0]);
                  // // setState(() {});
                },
                child: Image.asset(
                  "assets/images/quran_images/$pageNumber/$lineNumber.png",
                  fit: BoxFit.fitWidth,
                  width: 1080,
                  height: lineHeight,
                ),
              ),
              // ...List.generate(quranProvider.mistakes.length, (i) {
              //   if (quranProvider.mistakes[i]["lineNumber"] == lineNumber) {
              //     return Positioned(
              //       left: quranProvider.mistakes[i]["x_start"].toDouble() * xOffset,
              //       child: Container(
              //         width: quranProvider.mistakes[i]["x_end"].toDouble() * xOffset -
              //             quranProvider.mistakes[i]["x_start"].toDouble() * xOffset,
              //         height: lineHeight,
              //         decoration: const BoxDecoration(
              //             color: Colors.red,
              //             backgroundBlendMode: BlendMode.lighten),
              //         // make the color of thi
              //       ),
              //     );
              //   }
              //   return const SizedBox();
              // }),
            ]);
          }),
        );
      });
    });
  }
}

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
