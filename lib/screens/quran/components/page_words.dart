import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moeen/components/CustomButton.dart';
import 'package:moeen/components/CustomInput.dart';
import 'package:moeen/components/list_item.dart';
import 'package:moeen/helpers/database/words_colors/WordsColorsMap.dart';

import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:moeen/screens/quran/components/verse_options_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

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
            0.0315,
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

class Word extends StatefulWidget {
  const Word({
    Key? key,
    // required this.color,
    required this.item,
    required this.fixedFontSizePercentage,
    required this.index,
  }) : super(key: key);

  final double fixedFontSizePercentage;
  final item;
  // final Color color;
  final int index;

  @override
  State<Word> createState() => _WordState();
}

class _WordState extends State<Word> {
  Offset _tapPosition = const Offset(0, 0);
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    // var found = quranProvider.mistakes
    //     .firstWhereOrNull((element) => element.wordID == item["wordID"]);
    return Consumer<QuranProvider>(
      builder: (context, quranProvider, child) {
        var found = quranProvider.mistakes.firstWhereOrNull(
            (element) => element.wordID == widget.item["wordID"]);
        return GestureDetector(
          onTapDown: _storePosition,
          onLongPress: () => {
            if (found != null)
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return WordExtras(
                      item: widget.item,
                      mistake: found,
                    );
                  })
          },
          onTap: () => {
            quranProvider.addMistake(
                context: context,
                id: widget.item["wordID"],
                pageNumber: widget.item["pageNumber"],
                verseNumber: widget.item["verseNumber"],
                chapterCode: widget.item["chapterCode"],
                color: found?.color),
            HapticFeedback.lightImpact(),
          },
          child: Text(
            "${widget.item["text"]}",
            style: TextStyle(
              fontSize: widget.fixedFontSizePercentage,
              fontFamily: "p${widget.item["pageNumber"]}",
              color: Color(int.parse(found?.color ?? "0xFF000000")),
              // shadows: const [
              //   Shadow(
              //     offset: Offset(0.0, 0.0),
              //     blurRadius: 0.1,
              //     color: Color.fromARGB(255, 0, 0, 0),
              //   ),
              // ],
            ),
          ),
        );
      },
    );
  }
}

class WordExtras extends StatefulWidget {
  final item;
  final mistake;
  const WordExtras({Key? key, required this.item, required this.mistake})
      : super(key: key);

  @override
  State<WordExtras> createState() => _WordExtrasState();
}

class _WordExtrasState extends State<WordExtras> {
  TextEditingController noteController = TextEditingController();

  int groupValue = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      builder: ((context, scrollController) => Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SingleChildScrollView(
                controller: scrollController,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child:
                      // height: 600,
                      Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _wordDetails(),
                          const SizedBox(
                            height: 10,
                          ),
                          _notesSlider(context),
                          if (groupValue == 0) _newNoteView(context),
                          if (groupValue == 1) _notesView(context),
                        ]),
                  ),
                )),
          )),
    );
  }

  Column _notesView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) {
            return ListItem(
              title: Text(
                "هذه الأية متشابهة مع التي في سورة البقرة، انتبه",
                style: TextStyle(fontSize: 12),
              ),
              subtitle: SizedBox(
                width: 400,
                child: Row(
                  children: [
                    Text(
                      "ahmed",
                      style: TextStyle(fontSize: 10),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "2021-2-21",
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Column _newNoteView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          "إضافة سريعة",
          style: TextStyle(
            fontFamily: "montserrat",
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        _quickNoteBuilder(),
        const Text(
          "أو",
          style: TextStyle(
            fontFamily: "montserrat",
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        _newNoteInput(),
        const SizedBox(
          height: 10,
        ),
        _bottomActions(context)
      ],
    );
  }

  Row _bottomActions(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
            onPressed: () => {},
            child: Text("إضافة",
                style: TextStyle(
                  fontFamily: "montserrat",
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                ))),
        const SizedBox(
          width: 20,
        ),
        TextButton(
          child: Text("إضافة + تسجيل كإضافة سريعة",
              style: TextStyle(
                fontFamily: "montserrat",
                color: Theme.of(context).colorScheme.primary,
                fontSize: 10,
              )),
          onPressed: () => {},
        )
      ],
    );
  }

  CustomInput _newNoteInput() {
    return CustomInput(
      controller: noteController,
      prefixIcon: Icons.subject_rounded,
      keyboardType: TextInputType.multiline,
      minLines: 3,
      maxLength: 100,
      maxLines: 3,
      label: "ملاحظة مفصلة ",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء ادخال موضوع الرسالة';
        }
        return null;
      },
    );
  }

  SizedBox _quickNoteBuilder() {
    return SizedBox(
        child: ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) => ListItem(
        title: const Text("خطأ تجويد"),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            border: Border.all(
                width: 2, color: Theme.of(context).scaffoldBackgroundColor),
            borderRadius: const BorderRadius.all(Radius.circular(7)),
          ),
          child: Center(
              child: Icon(
            Icons.add,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          )),
        ),
      ),
      itemCount: 2,
    ));
  }

  CupertinoSlidingSegmentedControl<int> _notesSlider(BuildContext context) {
    return CupertinoSlidingSegmentedControl<int>(
      children: const {
        0: Text("إضافة ملاحظة"),
        1: Text("الملاحظات السابقة"),
      },
      groupValue: groupValue,
      onValueChanged: (val) => {
        setState(() {
          groupValue = val!;
        })
      },
      thumbColor: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.all(8),
    );
  }

  Row _wordDetails() {
    return Row(
      children: [
        Text("${widget.item['text']}",
            style: TextStyle(
              fontFamily: "p${widget.item["pageNumber"]}",
              color: Color(int.parse(widget.mistake.color)),
              fontSize: 30,
            )),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(" - "),
        ),
        Text(
            "آية ${widget.item["verseNumber"]} - ص${widget.item["pageNumber"]}",
            style: const TextStyle(
              fontFamily: "montserrat",
              color: Colors.grey,
              fontSize: 14,
            )),
      ],
    );
  }
}
