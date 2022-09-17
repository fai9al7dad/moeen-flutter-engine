import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moeen/components/list_item.dart';
import 'package:moeen/helpers/database/werd_colors_map/WerdsColorsMap.dart';

import 'package:moeen/helpers/database/words_colors/WordsColorsMap.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:provider/provider.dart';

class SurahList extends StatelessWidget {
  const SurahList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: RenderList(),
    );
  }
}

class RenderList extends StatefulWidget {
  const RenderList({Key? key}) : super(key: key);

  @override
  State<RenderList> createState() => _RenderListState();
}

class _RenderListState extends State<RenderList> {
  var surahs;
  bool _loading = true;
  void loadJson() async {
    String data = await rootBundle.loadString('assets/json/SURAHS.json');
    var jsonResult = json.decode(data);
    // var c = Surah.fromJson(jsonResult);
    // inspect(c);
    // List<Surah> chapters = jsonResult["chapters"];
    setState(() {
      surahs = jsonResult["chapters"];
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading == true) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.builder(
        // separatorBuilder: (context, index) => const Divider(
        //   thickness: 0.8,
        //   height: 0,
        // ),
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: ListItem(
              index: index,
              onTap: () {
                Navigator.pop(context, surahs[index]["pages"][0] - 1);
              },
              // leading: Text(surahs[index]["id"].toString()),
              title: Row(
                children: [
                  Text(
                    surahs[index]["id"].toString().padLeft(3, '0'),
                    style:
                        const TextStyle(fontFamily: "surahname", fontSize: 29),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 1.0, bottom: 1.0),
                      child: Text(
                        "${surahs[index]["pages"][0]} - ${surahs[index]["pages"][1]}",
                        style: TextStyle(
                            fontSize: 8,
                            fontFamily: "montserrat",
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.5)),
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                "عدد صفحاتها ${surahs[index]["pages"][1] - surahs[index]["pages"][0] + 1}، عدد أياتها ${surahs[index]['verses_count']}",
                style: const TextStyle(fontSize: 10, fontFamily: "montserrat"),
              ),
              trailing: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 90,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SurahMistakesAndWarnings(
                        chapterCode:
                            surahs[index]["id"].toString().padLeft(3, '0')),
                    Icon(Icons.chevron_right,
                        color: Theme.of(context).colorScheme.primary),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SurahMistakesAndWarnings extends StatefulWidget {
  final chapterCode;
  const SurahMistakesAndWarnings({Key? key, required this.chapterCode})
      : super(key: key);

  @override
  State<SurahMistakesAndWarnings> createState() =>
      _SurahMistakesAndWarningsState();
}

class _SurahMistakesAndWarningsState extends State<SurahMistakesAndWarnings> {
  var _mistakes;
  var _warnings;
  bool _loading = true;
  final wordsColorsMap = WordColorMap();
  final werdColorsMap = WerdsColorsMap();
  void getMW() async {
    // if _isWerd;
    var mw;
    if (Provider.of<QuranProvider>(context, listen: false).isWerd) {
      mw =
          await werdColorsMap.getChapterColors(chapterCode: widget.chapterCode);
    } else {
      mw = await wordsColorsMap.getChapterColors(
          chapterCode: widget.chapterCode);
    }

    var mistakes =
        mw["mistakes"] == 0 || mw["mistakes"] == null ? 0 : mw["mistakes"];
    var warnings =
        mw["warnings"] == 0 || mw["warnings"] == null ? 0 : mw["warnings"];

    if (mounted) {
      setState(() {
        _mistakes = mistakes;
        _warnings = warnings;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getMW();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox(width: 10);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _mistakes > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(int.parse(MistakesColors.mistake))),
                        height: 12,
                        width: 12,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _mistakes.toString(),
                        style: TextStyle(
                            fontSize: 8,
                            color: Theme.of(context).primaryColor,
                            fontFamily: "montserrat"),
                      ),
                    ])
              : const SizedBox(width: 0),
          const SizedBox(width: 10),
          _warnings > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(int.parse(MistakesColors.warning))),
                        height: 12,
                        width: 12,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _warnings.toString(),
                        style: TextStyle(
                            fontSize: 8,
                            color: Theme.of(context).primaryColor,
                            fontFamily: "montserrat"),
                      ),
                    ])
              : const SizedBox(width: 0),
        ],
      ),
    );
  }
}
