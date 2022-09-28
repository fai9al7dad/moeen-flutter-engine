import 'package:flutter/material.dart';
import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/CustomShowCase.dart';
import 'package:moeen/components/streak_progress_widget.dart';
import 'package:moeen/helpers/database/quran/quran_database_helper.dart';
import 'package:moeen/helpers/database/werd_colors_map/WerdsColorsMap.dart';
import 'package:moeen/helpers/database/words_colors/WordsColorsMap.dart';
import 'package:moeen/helpers/dio/api.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/helpers/models/highlights_model.dart';
import 'package:moeen/helpers/models/werds_model.dart';
import 'package:moeen/providers/auth/auth_provider.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:moeen/screens/werds/components/werd_shimmer.dart';
import 'package:moeen/screens/werds/components/werds_calendar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

GlobalKey _one = GlobalKey();
GlobalKey _two = GlobalKey();

class WerdsScreen extends StatefulWidget {
  final int? duoID;
  final String? username;
  final int? reciterID;
  final String? latestWerd;
  const WerdsScreen(
      {Key? key, this.duoID, this.username, this.reciterID, this.latestWerd})
      : super(key: key);

  @override
  State<WerdsScreen> createState() => _WerdsScreenState();
}

class _WerdsScreenState extends State<WerdsScreen> {
  final now = DateTime.now();

  List<WerdsModel>? werdsApi = [];
  List<WerdsModel>? werds = [];
  bool loading = true;
  bool appBarLoading = false;
  int sliderValue = 0;
  @override
  void initState() {
    super.initState();
    getWerds();
    checkIfFirstTime();
  }

  void checkIfFirstTime() async {
    final prefs = await SharedPreferences.getInstance();

    bool? firstTime = prefs.getBool("seenWerdsScreenShowcase");
    if (firstTime == null || firstTime != true) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Future.delayed(const Duration(milliseconds: 400), () {
          return ShowCaseWidget.of(context).startShowCase([_one, _two]);
        });
      });
      await prefs.setBool("seenWerdsScreenShowcase", true);
    }
  }

  // String getWerdType({required int reciterID}) {
  //   final int? authUserID =
  //       Provider.of<AuthProvider>(context, listen: false).authUser?.id;
  //   if (authUserID == reciterID) {
  //     return "asReciter";
  //   } else {
  //     return "asCorrector";
  //   }
  // }

  void filterWerds(type) {
    final int? authUserID =
        Provider.of<AuthProvider>(context, listen: false).authUser?.id;

    var filteredWerdsByReciter = werdsApi!.where((element) {
      if (type == "asReciter") {
        return element.reciterID == authUserID;
      } else if (type == "asListener") {
        return element.reciterID != authUserID;
      } else {
        return true;
      }
    }).toList();

    setState(() {
      werds = filteredWerdsByReciter;
    });
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
        werdsApi = res;
      });
      filterWerds("all");
    }
  }

  void startWerd() async {
    final prefs = await SharedPreferences.getInstance();

    bool? showWerdTutorial = prefs.getBool("showWerdTutorial");
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
    if (showWerdTutorial != false) {
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
        appBar: CustomAppBar(
            title: "${widget.username}",
            showLoading: appBarLoading,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: "duo_${widget.duoID}",
                  child: StreakProgressWidget(
                    width: 40,
                    height: 40,
                    latestWerd: widget.latestWerd,
                  ),
                ),
              )
            ]),
        floatingActionButton: CustomShowCase(
          overlayPadding: const EdgeInsets.all(10),
          shapeBorder: const CircleBorder(),
          caseKey: _one,
          title: "الأوراد",
          description: "قم بإضافة ورد لتتمكن من رؤية مصحف صديقك والتصحيح له",
          child: FloatingActionButton.extended(
              backgroundColor: const Color(0xff059669),
              onPressed: () => startWerd(),
              label: const Text("إضافة ورد",
                  style: TextStyle(color: Colors.white))),
        ),
        body: Directionality(
            textDirection: TextDirection.rtl,
            child: loading
                ? const WerdShimmer()
                : werds!.isNotEmpty
                    ? WerdsCalendar(
                        werds: werds,
                        username: widget.username ?? "",
                      )
                    : const Center(child: Text("لا يوجد أوراد بينكم"))));
  }
}


// SliverToBoxAdapter _slidingWerdFIlter(BuildContext context) {
//   return SliverToBoxAdapter(
//       child: Align(
//           alignment: Alignment.centerRight,
//           child: Padding(
//               padding: const EdgeInsets.only(right: 15.0),
//               child: CupertinoSlidingSegmentedControl<int>(
//                 // backgroundColor: CupertinoColors.white,
//                 thumbColor: Theme.of(context).colorScheme.primary,
//                 padding: const EdgeInsets.all(8),
//                 groupValue: sliderValue,
//                 children: const {
//                   0: Text("جميع الأوراد"),
//                   1: Text("أورادك"),
//                   2: Text("أوراد زميلك"),
//                 },
//                 onValueChanged: (value) {
//                   setState(() {
//                     sliderValue = value!;
//                   });
//                   if (value == 0) {
//                     filterWerds("all");
//                   } else if (value == 1) {
//                     filterWerds("asReciter");
//                   } else if (value == 2) {
//                     filterWerds("asListener");
//                   }
//                 },
//               ))));
// }
