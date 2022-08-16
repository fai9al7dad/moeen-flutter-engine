import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/list_item.dart';
import 'package:moeen/helpers/database/quran/quran_database_helper.dart';
import 'package:moeen/helpers/database/werd_colors_map/WerdsColorsMap.dart';
import 'package:moeen/helpers/database/words_colors/WordsColorsMap.dart';
import 'package:moeen/helpers/dio/api.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/helpers/models/highlights_model.dart';
import 'package:moeen/helpers/models/werds_model.dart';
import 'package:moeen/providers/auth/auth_provider.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:moeen/screens/werds/werd_highlights/view_werd_highlights.dart';
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
    const storage = FlutterSecureStorage();
    String? showWerdTutorial = await storage.read(key: "showWerdTutorial");
    setState(() {
      appBarLoading = true;
    });
    final werdColorsMaps = WerdsColorsMap();
    final DatabaseHelper db = DatabaseHelper();
    var werd =
        await api.addWerd(duoID: widget.duoID, reciterID: widget.reciterID);

    // this will not return pagenumber, chaptercode, but will return wordID
    // so we need to fetch word by id from local db, and append it
    var highlightsRes =
        await api.getHighlightsByUserID(userID: widget.reciterID);
    await werdColorsMaps.deleteAllColors();

    await Future.forEach(highlightsRes, (HighlightsModel item) async {
      var word = await db.getWordByID(id: item.wordID);

      var color;
      switch (item.type) {
        case "warning":
          color = MistakesColors.warning;
          break;
        case "mistake":
          color = MistakesColors.mistake;
          break;
        case "revert":
          color = MistakesColors.revert;
          break;
      }
      // cause of null, mostly will not be null
      var vn = int.parse(word.verseNumber ?? "0");
      WordColorMapModel data = WordColorMapModel(
        color: color,
        wordID: word.id,
        pageNumber: word.pageID,
        chapterCode: word.chapterCode,
        verseNumber: vn,
      );

      await werdColorsMaps.insertWord(data);
    });
    Provider.of<QuranProvider>(context, listen: false).startWerd(creds: {
      "duoID": widget.duoID,
      "username": widget.username,
      "werdID": werd["id"],
      "reciterID": widget.reciterID,
    });
    if (showWerdTutorial != "false") {
      Navigator.pushNamedAndRemoveUntil(
          context, "/werd-introduction", (Route route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, "/", (Route route) => false);
    }
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
                            String type;
                            if (Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .authUser
                                    ?.id ==
                                werds![index].reciterID) {
                              type = "asReciter";
                            } else {
                              type = "asCorrector";
                            }
                            return ListItem(
                                index: index,
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewWerdHighlights(
                                                werdID: werds![index].id,
                                                isAccepted:
                                                    werds![index].isAccepted,
                                                type: type))),
                                title: Text(
                                    "${parseDate(date: werds![index].createdAt)}"),
                                subtitle:
                                    Text("رقم المعرف: ${werds![index].id}"));
                          })
                      : const Center(child: Text("لا يوجد أوراد بينكم"))),
            ),
    );
  }
}
