import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/list_item.dart';
import 'package:moeen/helpers/database/quran/quran_database_helper.dart';
import 'package:moeen/helpers/database/words_colors/WordsColorsMap.dart';
import 'package:moeen/helpers/dio/api.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/helpers/models/werds_model.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:provider/provider.dart';

class WerdsScreen extends StatefulWidget {
  final int? duoID;
  final String? username;
  final int? reciterID;
  const WerdsScreen({Key? key, this.duoID, this.username, this.reciterID})
      : super(key: key);

  @override
  State<WerdsScreen> createState() => _WerdsScreenState();
}

class _WerdsScreenState extends State<WerdsScreen> {
  List<WerdsModel>? werds = [];
  bool loading = true;
  bool appBarLoading = false;

  @override
  void initState() {
    super.initState();
    getWerds();
  }

  Api api = Api();
  void getWerds() async {
    setState(() {
      loading = true;
    });
    List<WerdsModel>? res = await api.getWerds(duoID: widget.duoID);
    if (mounted) {
      setState(() {
        loading = false;
        werds = res;
      });
    }
  }

  String parseDate({date}) {
    var d = DateTime.parse(date);
    return "${d.year}-${d.month}-${d.day}";
  }

  void startWerd() async {
    setState(() {
      appBarLoading = true;
    });
    final DatabaseHelper db = DatabaseHelper();
    var werd =
        await api.addWerd(duoID: widget.duoID, reciterID: widget.reciterID);

    var highlightsRes =
        await api.getHighlightsByUserID(userID: widget.reciterID);

    // this will not return pagenumber, chaptercode, but will return wordID
    // so we need to fetch word by id from local db, and append it

    List<WordColorMapModel> arr = [];
    // mw will have pagenumber as key
    // and mistakes and warnings as value
    // output: 3-> {mistakes: 1, warnings: 2}
    Map mw = {};
    for (var i = 0; i < highlightsRes.length; i++) {
      var item = highlightsRes[i];
      var word = await db.getWordByID(id: item.wordID);
      var line = await db.getLineByID(id: word.lineID); // to get pagenumber

      if (mw[line.pageID] == null) {
        mw[line.pageID] = {"warnings": 0, "mistakes": 0};
      }
      var color;

      switch (item.type) {
        case "warning":
          mw[line.pageID] = {
            ...mw[line.pageID],
            "warnings": mw[line.pageID]["warnings"] + 1
          };
          color = MistakesColors.warning;
          break;
        case "mistake":
          mw[line.pageID] = {
            ...mw[line.pageID],
            "mistakes": mw[line.pageID]["mistakes"] + 1
          };
          color = MistakesColors.mistake;
          break;
        case "revert":
          color = MistakesColors.revert;
          break;
      }
      // arr.push({color: color, wordID: item.wordID});

      WordColorMapModel data = WordColorMapModel(
          color: color,
          wordID: item.wordID,
          pageNumber: line.pageID,
          chapterCode: word.chapterCode,
          mistakes: mw[line.pageID]["mistakes"],
          warnings: mw[line.pageID]["warnings"]);
      arr.add(data);
    }

    Provider.of<QuranProvider>(context, listen: false).startWerd(creds: {
      "duoID": widget.duoID,
      "username": widget.username,
      "werdID": werd["id"],
      "reciterID": widget.reciterID,
      "mistakes": highlightsRes.isEmpty ? [WordColorMapModel()] : arr
    });
    setState(() {
      appBarLoading = false;
    });
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as DuosScreen;

    return Scaffold(
      appBar: CustomAppBar(title: "الأوراد", showLoading: appBarLoading),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xff059669),
          onPressed: () => startWerd(),
          label: const Text("إضافة ورد")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: werds!.isNotEmpty
                      ? ListView.separated(
                          itemCount: werds!.length,
                          separatorBuilder: (context, index) => const Divider(
                                thickness: 0.8,
                                height: 1,
                                color: Color(0xffe4e4e7),
                              ),
                          itemBuilder: (context, index) {
                            return ListItem(
                                index: index,
                                title: parseDate(date: werds![index].createdAt),
                                subtitle: "رقم المعرف: ${werds![index].id}");
                          })
                      : const Center(child: Text("لا يوجد أوراد بينكم"))),
            ),
    );
  }
}
