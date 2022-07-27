import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:moeen/helpers/database/words_colors/WordsColorsMap.dart';
import 'package:moeen/helpers/general/constants.dart';

class SurahList extends StatelessWidget {
  const SurahList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("السور"),
        centerTitle: true,
      ),
      body: const RenderList(),
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
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        thickness: 0.8,
        endIndent: 70,
      ),
      itemCount: surahs.length,
      itemBuilder: (context, index) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: ListTile(
            onTap: () {
              Navigator.pop(context, surahs[index]["pages"][0] - 1);
            },
            leading: Text(surahs[index]["id"].toString()),
            title: Text(
              surahs[index]["id"].toString().padLeft(3, '0'),
              style: const TextStyle(fontFamily: "surahname", fontSize: 29),
            ),
            subtitle: Text(
              "عدد صفحاتها ${surahs[index]["pages"][1] - surahs[index]["pages"][0] + 1}، عدد أياتها ${surahs[index]['verses_count']}",
              style: const TextStyle(fontSize: 10, fontFamily: "montserrat"),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${surahs[index]["pages"][0]} - ${surahs[index]["pages"][1]}",
                  style:
                      const TextStyle(fontSize: 10, fontFamily: "montserrat"),
                ),
                const SizedBox(
                  height: 5,
                ),
                SurahMistakesAndWarnings(
                    chapterCode: surahs[index]["id"].toString().padLeft(3, '0'))
              ],
            ),
          ),
        );
      },
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
  void getMW() async {
    var mw =
        await wordsColorsMap.getChapterColors(chapterCode: widget.chapterCode);

    var mistakes =
        mw["mistakes"] == 0 || mw["mistakes"] == null ? 0 : mw["mistakes"];
    var warnings =
        mw["warnings"] == 0 || mw["warnings"] == null ? 0 : mw["warnings"];
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _mistakes = mistakes;
          _warnings = warnings;
          _loading = false;
        });
      }
    });
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
              ? Row(children: [
                  Text(
                    _mistakes.toString(),
                    style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xffae8f74),
                        fontFamily: "montserrat"),
                  ),
                  const SizedBox(width: 1),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(int.parse(MistakesColors.mistake))),
                    height: 8,
                    width: 8,
                  )
                ])
              : const SizedBox(width: 0),
          const SizedBox(width: 4),
          _warnings > 0
              ? Row(children: [
                  Text(
                    _warnings.toString(),
                    style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xffae8f74),
                        fontFamily: "montserrat"),
                  ),
                  const SizedBox(width: 1),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(int.parse(MistakesColors.warning))),
                    height: 8,
                    width: 8,
                  )
                ])
              : const SizedBox(width: 0),
        ],
      ),
    );
  }
}
