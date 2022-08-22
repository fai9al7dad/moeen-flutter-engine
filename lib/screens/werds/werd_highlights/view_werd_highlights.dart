import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/CustomShowCase.dart';
import 'package:moeen/components/list_item.dart';
import 'package:moeen/helpers/database/quran/quran_database_helper.dart';
import 'package:moeen/helpers/database/quran/quran_models.dart';
import 'package:moeen/helpers/dio/api.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/helpers/models/highlights_model.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

GlobalKey _one = GlobalKey();

class ViewWerdHighlights extends StatefulWidget {
  final int? werdID;
  final bool? isAccepted;
  final String? type;
  const ViewWerdHighlights({Key? key, this.werdID, this.isAccepted, this.type})
      : super(key: key);

  @override
  State<ViewWerdHighlights> createState() => _ViewWerdHighlightsState();
}

class _ViewWerdHighlightsState extends State<ViewWerdHighlights> {
  final Api api = Api();
  final DatabaseHelper db = DatabaseHelper();
  bool? acceptedState;
  late final List<Word> highlights;
  bool loading = true;
  bool appBarLoading = false;
  bool hasReverts = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchHighlights();
    checkIfFirstTime();
  }

  void checkIfFirstTime() async {
    const storage = FlutterSecureStorage();
    String? firstTime =
        await storage.read(key: "seenViewWerdHighlightsShowcase");
    if (firstTime == null || firstTime != "true") {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Future.delayed(const Duration(milliseconds: 2000), () {
          return ShowCaseWidget.of(context).startShowCase([_one]);
        });
      });
      await storage.write(key: "seenViewWerdHighlightsShowcase", value: "true");
    }
  }

  // call function api to get highlights by werdID
  void fetchHighlights() async {
    // set loading state to true
    setState(() {
      loading = true;
      acceptedState = widget.isAccepted ?? false;
    });
    var res = await api.getHighlightsByWerdID(werdID: widget.werdID);

    List<Word> data = [];
    if (res.isNotEmpty) {
      for (var i = 0; i < res.length; i++) {
        Word word = await db.getWordByID(id: res[i].wordID);
        if (res[i].type == "revert") {
          setHasReverts();
        }
        data.add(Word(
          id: word.id,
          verseNumber: word.verseNumber,
          text: word.text,
          chapterCode: word.chapterCode,
          pageID: word.pageID,
          color: res[i].type == "mistake"
              ? MistakesColors.mistake
              : res[i].type == "warning"
                  ? MistakesColors.warning
                  : MistakesColors.revert,
        ));
      }
    }
    if (mounted) {
      setState(() {
        highlights = data;
        loading = false;
      });
    }
  }

  void acceptHighlights() async {
    if (acceptedState == true) return;
    setState(() {
      appBarLoading = true;
    });
    for (var i = 0; i < highlights.length; i++) {
      // old color is required, because add mistake takes current color and gives next color, but in this context we are giving new color. so we need to save old color
      var oldColor;
      switch (highlights[i].color) {
        case MistakesColors.revert:
          oldColor = MistakesColors.mistake;
          break;

        case MistakesColors.mistake:
          oldColor = MistakesColors.warning;
          break;
        case MistakesColors.warning:
          oldColor = MistakesColors.revert;
          break;
      }

      Provider.of<QuranProvider>(context, listen: false).addMistake(
          color: oldColor,
          id: highlights[i].id,
          pageNumber: highlights[i].pageID,
          verseNumber: highlights[i].verseNumber,
          chapterCode: highlights[i].chapterCode);
    }
    await api.acceptWerd(werdID: widget.werdID);

    setState(() {
      acceptedState = true;
      appBarLoading = false;
    });
  }

  void setHasReverts() {
    setState(() {
      hasReverts = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: CustomAppBar(
        title: 'تفاصيل الورد',
        showLoading: appBarLoading,
      ),
      floatingActionButton: widget.type == "asReciter"
          ? CustomShowCase(
              overlayPadding: const EdgeInsets.all(10),
              shapeBorder: const CircleBorder(),
              caseKey: _one,
              title: "قبول الورد",
              description:
                  "قم بقبول الورد لحفظ الأخطاء والتنبيهات المسجلة في هذا الورد في مصحفك",
              child: FloatingActionButton.extended(
                onPressed: () => acceptHighlights(),
                label:
                    Text(acceptedState == true ? "تم القبول 👍" : 'قبول الورد'),
                backgroundColor: const Color(0xff059669),
              ),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: highlights.isEmpty
              ? const Text('لم تسجل أخطاء أو تنبيهات في هذا الورد')
              : Column(
                  children: [
                    if (hasReverts)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Flexible(
                            child: Text(
                              "وجود اللون الأسود بجانب تحديد، يعني أنه هنالك خطأ مسجل في مصحف المسمع تم تصحيحه",
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(int.parse(MistakesColors.revert))),
                            height: 8,
                            width: 8,
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListView.separated(
                          itemCount: highlights.length,
                          separatorBuilder: (context, index) => const Divider(
                            thickness: 0.8,
                            height: 1,
                            color: Color(0xffe4e4e7),
                          ),
                          itemBuilder: (context, index) {
                            return ListItem(
                                index: index,
                                title: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.8,
                                  ),
                                  child: Row(children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(int.parse(
                                            highlights[index].color ==
                                                    MistakesColors.warning
                                                ? MistakesColors.warning
                                                : highlights[index].color ==
                                                        MistakesColors.revert
                                                    ? MistakesColors.revert
                                                    : MistakesColors.mistake,
                                          ))),
                                      height: 8,
                                      width: 8,
                                    ),
                                    const SizedBox(width: 8),
                                    Text("${highlights[index].text}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily:
                                                "p${highlights[index].pageID}")),
                                  ]),
                                ),
                                subtitle: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.8,
                                    ),
                                    child: Row(children: [
                                      Text(
                                          "${highlights[index].chapterCode}surah",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: "surahname")),
                                      const SizedBox(width: 8),
                                      Text(
                                        "رقم الصفحة: ${highlights[index].pageID}",
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "رقم الآية: ${highlights[index].verseNumber}",
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ])));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
