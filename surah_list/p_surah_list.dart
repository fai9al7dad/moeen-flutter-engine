// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:moeen/common/components/list_item.dart';
import 'package:moeen/features/surah_list/surah.dart';

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
  final _scrollController = ScrollController();

  List<Surah> surahs = [];
  bool _loading = true;
  void loadJson() async {
    String data = await rootBundle.loadString('assets/json/SURAHS.json');
    var jsonResult = json.decode(data);

    List<Surah> surahsFormatted = [];

    for (var surah in jsonResult["chapters"]) {
      surahsFormatted.add(Surah.fromJson(surah));
    }
    setState(() {
      surahs = surahsFormatted;
      _loading = false;
    });
  }


  @override
  void initState() {
    super.initState();
    loadJson();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading == true) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 30),
        child: GroupedListView<Surah, String>(
          controller: _scrollController,
          elements: surahs,
          groupBy: (element) {
            return element.juzNumber.toString();
          },
          groupSeparatorBuilder: (value) => SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
              child: Text(
                "الجزء $value",
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          groupComparator: ((value1, value2) =>
              int.parse(value1).compareTo(int.parse(value2))),
          itemComparator: (item1, item2) => item1.id!.compareTo(item2.id!),
          indexedItemBuilder: (context, element, index) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: ListItem(
                index: index,
                onTap: () {
                  Navigator.pop(context, element.pages![0] - 1);
                },
                title: Row(
                  children: [
                    Text(
                      element.id.toString().padLeft(3, '0'),
                      style: const TextStyle(
                          fontFamily: "surahname", fontSize: 29),
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
                          "${element.pages![0]} - ${element.pages![1]}",
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
                  "عدد صفحاتها ${element.pages![1] - element.pages![0] + 1}، عدد أياتها ${element.versesCount}",
                  style:
                      const TextStyle(fontSize: 10, fontFamily: "montserrat"),
                ),
                trailing: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 90,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.chevron_right,
                          color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ]);
  }
}
