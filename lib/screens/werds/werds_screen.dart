import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/CustomShowCase.dart';
import 'package:moeen/components/list_item.dart';
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
import 'package:moeen/screens/werds/werd_highlights/view_werd_highlights.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

GlobalKey _one = GlobalKey();
GlobalKey _two = GlobalKey();

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

  String parseDate({date}) {
    var d = DateTime.parse(date);
    return "${d.year}-${d.month}-${d.day}";
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
      // appBar: CustomAppBar(title: "الأوراد", showLoading: appBarLoading),
      floatingActionButton: CustomShowCase(
        overlayPadding: const EdgeInsets.all(10),
        shapeBorder: const CircleBorder(),
        caseKey: _one,
        title: "الأوراد",
        description: "قم بإضافة ورد لتتمكن من رؤية مصحف صديقك والتصحيح له",
        child: FloatingActionButton.extended(
            backgroundColor: const Color(0xff059669),
            onPressed: () => startWerd(),
            label:
                const Text("إضافة ورد", style: TextStyle(color: Colors.white))),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: CustomScrollView(
          slivers: <Widget>[
            _appBar(context),
            const SliverPadding(
              padding: EdgeInsets.only(top: 10),
            ),
            _slidingWerdFIlter(context),
            loading
                ? const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()))
                : SliverPadding(
                    padding: const EdgeInsets.all(15),
                    sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        String type;
                        if (Provider.of<AuthProvider>(context, listen: false)
                                .authUser
                                ?.id ==
                            werds![index].reciterID) {
                          type = "asReciter";
                        } else {
                          type = "asCorrector";
                        }
                        return _werdCard(context, index, type);
                      },
                      childCount: werds!.length,
                    )),
                  ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _slidingWerdFIlter(BuildContext context) {
    return SliverToBoxAdapter(
        child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: CupertinoSlidingSegmentedControl<int>(
                  // backgroundColor: CupertinoColors.white,
                  thumbColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.all(8),
                  groupValue: sliderValue,
                  children: const {
                    0: Text("جميع الأوراد"),
                    1: Text("أورادك"),
                    2: Text("أوراد زميلك"),
                  },
                  onValueChanged: (value) {
                    setState(() {
                      sliderValue = value!;
                    });
                    if (value == 0) {
                      filterWerds("all");
                    } else if (value == 1) {
                      filterWerds("asReciter");
                    } else if (value == 2) {
                      filterWerds("asListener");
                    }
                  },
                ))));
  }

  SliverAppBar _appBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      // scrolledUnderElevation: 10,
      backgroundColor: Theme.of(context).colorScheme.background,
      expandedHeight: 230.0,
      centerTitle: true,
      foregroundColor: Theme.of(context).primaryColor,
      // title: const Text(
      //   "الأوراد",
      //   style: TextStyle(fontSize: 14),
      // ),
      elevation: 0,
      // actions: [WerdFilterSlider()],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        // expandedTitleScale: 1,
        title: Text(
          "${widget.username}",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        background:
            Hero(tag: "duo_${widget.duoID}", child: CircleStreakProgress()),
        //  Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: const [
        //     CircleStreakProgress(),

        //   ],
        // ),
      ),
    );
  }

  ListItem _werdCard(BuildContext context, int index, String type) {
    return ListItem(
        index: index,
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewWerdHighlights(
                    werdID: werds![index].id,
                    isAccepted: werds![index].isAccepted,
                    type: type))),
        title: Text("الورد الأول"),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.primary,
        ),
        subtitle: Text("${parseDate(date: werds![index].createdAt)}"));
  }
}

class CircleStreakProgress extends StatelessWidget {
  const CircleStreakProgress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(alignment: Alignment.center, children: [
          SizedBox(
            width: 90,
            height: 90,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              value: 0.8,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,

              // borderRadius: 900,
            ),
          ),
          const Text("🌾", style: TextStyle(fontSize: 20))
        ]),
        const SizedBox(
          height: 10,
        ),
        Text("رائع جدا ، استمروا 👍",
            style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).primaryColor.withOpacity(0.8))),
      ],
    );
  }
}
