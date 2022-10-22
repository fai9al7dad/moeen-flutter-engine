import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moeen/screens/quran/components/page_words/word.dart';
import 'package:moeen/screens/quran/components/verse_options_bottom_sheet.dart';

class PageWords extends StatefulWidget {
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
  State<PageWords> createState() => _PageWordsState();
}

class _PageWordsState extends State<PageWords> {
  List<List<Widget>> rows = [];

  void fillRows(context) {
    // print quran provider mistakes
    List<List<Widget>> rows = [];
    for (int i = 0; i < 15; i++) {
      rows.add([]);
    }
    int curRow = 0;
    for (int i = 0; i < widget.page.length; i++) {
      var item = widget.page[i];

      // var found = _mistakes
      //     .firstWhereOrNull((element) => element.wordID == item["wordID"]);
      Widget? el;
      if (item["isNewChapter"] == 1 &&
          item["isBismillah"] == 1 &&
          item["pageNumber"] != 187) {
        el = Bismillah(
          fixedFontSizePercentage: widget.fixedFontSizePercentage,
        );
      }
      if (item["isNewChapter"] == 1 && item["isBismillah"] != 1) {
        el = SurahHeader(
          fixedFontSizePercentage: widget.fixedFontSizePercentage,
          chapterCode: item["chapterCode"],
        );
      }
      if (item["isNewChapter"] == 1 && item["pageNumber"] == 187) {
        el = SurahHeader(
          fixedFontSizePercentage: widget.fixedFontSizePercentage,
          chapterCode: item["chapterCode"],
        );
      }
      if (item["charType"] == "end") {
        el = VerseNumber(
          context: context,
          item: item,
          fixedFontSizePercentage: widget.fixedFontSizePercentage,
        );
      }
      if (item["charType"] == "word") {
        el = Word(
          // color: Color(int.parse(found?.color ?? "0xFF000000")),
          item: item,
          index: i,
          fixedFontSizePercentage: widget.fixedFontSizePercentage,
        );
      }
      int curLineNum = item["lineNumber"];
      // if last item this will return undefined
      int aftLineNum =
          i != widget.page.length - 1 ? widget.page[i + 1]["lineNumber"] : 15;
      bool lineChanged = curLineNum != aftLineNum;

      rows[curRow].add(el!);
      if (lineChanged) {
        curRow++;
      }
    }
    // rows[0].add(const Text("s"));
    if (mounted) {
      setState(() {
        this.rows = rows;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fillRows(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(rows.length, (row) {
      return SizedBox(
        height: widget.fixedLineHeightPercentage *
            MediaQuery.of(context).size.height *
            0.03,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rows[row],
        ),
      );
    }));
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
