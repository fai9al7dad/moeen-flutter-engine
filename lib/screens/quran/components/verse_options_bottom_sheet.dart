import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moeen/helpers/database/seperators/seperators_database.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:provider/provider.dart';

class VerseOptionsBottomSheet extends StatefulWidget {
  const VerseOptionsBottomSheet({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Map<String, dynamic> item;

  @override
  State<VerseOptionsBottomSheet> createState() =>
      _VerseOptionsBottomSheetState();
}

class _VerseOptionsBottomSheetState extends State<VerseOptionsBottomSheet> {
  List<SeperatorModel> seperators = [];
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSeperators();
  }

  void fetchSeperators() async {
    final seperatorsDB = SeperatorsDB();
    var _seperators = await seperatorsDB.getAllSeperators();
    if (mounted) {
      setState(() {
        seperators = _seperators;
        loading = false;
      });
    }
  }

  void addSeperator(context, id, color, name, pageNumber, verseNumber, wordID) {
    Navigator.of(context).pop();

    // if new seperator same as exisiting delete it
    if (pageNumber == widget.item["pageNumber"] &&
        verseNumber.toString() == widget.item["verseNumber"]) {
      Provider.of<QuranProvider>(context, listen: false).clearSeperator(
          id: id,
          pageNumber: widget.item["pageNumber"],
          verseNumber: widget.item["verseNumber"],
          color: color,
          surah: widget.item["chapterCode"],
          wordID: widget.item["wordID"],
          name: name);
    } else {
      Provider.of<QuranProvider>(context, listen: false).updateSeperator(
          id: id,
          pageNumber: widget.item["pageNumber"],
          verseNumber: widget.item["verseNumber"],
          color: color,
          wordID: widget.item["wordID"],
          surah: widget.item["chapterCode"],
          name: name);
    }
  }

  void navigateToQuranPage({required int page}) {
    Navigator.of(context).pop();

    Provider.of<QuranProvider>(context, listen: false)
        .pageController
        .jumpToPage(page - 1);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 180,
      );
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: const Color(0xfffff8ed),
        height: 400,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("وضع فاصل",
                  style: TextStyle(
                    fontFamily: "montserrat-bold",
                    fontSize: 20,
                  )),
              const SizedBox(
                height: 10,
              ),
              const Text("اضفط مطولا للإنتقال إلى الموضع",
                  style: TextStyle(
                    fontFamily: "montserrat",
                    color: Colors.grey,
                    fontSize: 14,
                  )),
              Expanded(
                child: ListView.builder(
                    itemCount: seperators.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          iconColor: Color(int.parse(
                              seperators[index].color ?? "0xffae8f74")),
                          leading: seperators[index].verseNumber != null
                              ? const Icon(Icons.bookmark)
                              : const Icon(Icons.bookmark_add_outlined),
                          trailing: seperators[index].verseNumber != null
                              ? IconButton(
                                  icon: Icon(
                                    Icons.chevron_right,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () => navigateToQuranPage(
                                      page: seperators[index].pageNumber!))
                              : null,
                          onLongPress: seperators[index].pageNumber != null
                              ? () => navigateToQuranPage(
                                  page: seperators[index].pageNumber!)
                              : null,
                          onTap: () => addSeperator(
                                context,
                                seperators[index].id,
                                seperators[index].color,
                                seperators[index].name,
                                seperators[index].pageNumber,
                                seperators[index].verseNumber,
                                seperators[index].wordID,
                              ),
                          title: Text(
                            "${seperators[index].name}",
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: seperators[index].surah != null
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("${seperators[index].surah}surah",
                                        style: const TextStyle(
                                            fontSize: 26,
                                            letterSpacing: -3,
                                            fontFamily: "surahname")),
                                    Text(
                                        "أية ${seperators[index].verseNumber} صفحة ${seperators[index].pageNumber}",
                                        style: const TextStyle(fontSize: 14)),
                                  ],
                                )
                              : const Text(""));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
