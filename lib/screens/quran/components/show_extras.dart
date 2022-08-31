import 'package:flutter/material.dart';

import 'package:grouped_list/grouped_list.dart';
import 'package:moeen/components/CustomInput.dart';
import 'package:moeen/helpers/database/quran_simple/quran_simple_database.dart';
import 'package:moeen/helpers/general/GeneralHelpers.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:provider/provider.dart';

class ShowExtras extends StatelessWidget {
  final Function setShowExtra;
  const ShowExtras({Key? key, required this.setShowExtra}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SearchQuran(setShowExtra: setShowExtra);
  }
}

class SearchQuran extends StatefulWidget {
  final Function setShowExtra;
  const SearchQuran({Key? key, required this.setShowExtra}) : super(key: key);
  // const SearchQuran({
  //   Key? key,
  // }) : super(key: key);

  @override
  State<SearchQuran> createState() => _SearchQuranState();
}

class _SearchQuranState extends State<SearchQuran>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController queryController = TextEditingController();
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  final quranSimpleDataBase = QuranSimpleDatabaseHelper();
  List<QuranSimpleModel> searchResult = [];
  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));

    _offset = Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 0.01))
        .animate(_controller);

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void searchQuran(text) async {
    String convertedString = GeneralHelpers().replaceArabicNumber(text);
    List<QuranSimpleModel> res =
        await quranSimpleDataBase.search(query: convertedString);
    setState(() {
      searchResult = res;
    });
  }

  void navigateToQuranPage({required String page}) {
    widget.setShowExtra(false);

    Provider.of<QuranProvider>(context, listen: false)
        .pageController
        .jumpToPage(int.parse(page) - 1);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: Container(
        color: const Color(0xfffff8ed),
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: const Color(0xfffff8ed),
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!))),
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(10.0, 50.0, 15.0, 15.0),
                      child: Form(
                        key: _formKey,
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomInput(
                                controller: queryController,
                                prefixIcon: Icons.search,
                                autoFocus: true,
                                label: "ابحث",
                                onChanged: searchQuran,
                                validator: (value) {
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            TextButton(
                                onPressed: () => {
                                      widget.setShowExtra(false),
                                    },
                                child: const Text("الغاء"))
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: 10),
                Text("نتيجة البحث : ${searchResult.length}"),
                Expanded(
                    child: Container(
                        color: const Color(0xfffff8ed),
                        child: searchResult.isNotEmpty
                            ? GroupedListView<dynamic, String>(
                                elements: searchResult,
                                groupBy: (element) {
                                  return element.type;
                                },
                                // useStickyGroupSeparators: true,
                                groupSeparatorBuilder: (value) => SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 8.0, 8.0, 8.0),
                                        child: Text(
                                          value == "pageNumber"
                                              ? "الصفحات"
                                              : value == "surah"
                                                  ? "السور"
                                                  : "الآيات",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                itemBuilder: (context, element) {
                                  if (element.type == "pageNumber") {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Card(
                                        // color: Colors.white,

                                        margin: const EdgeInsets.all(5),
                                        elevation: 0.5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            // tileColor: Colors.white,

                                            title: Text(
                                                "الصفحة : ${element.page.toString()}"),
                                            subtitle: Text(
                                                "سورة ${element.suraNameAr}"),
                                            onTap: () => navigateToQuranPage(
                                                page: element.page),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (element.type == "surah") {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Card(
                                        // color: Colors.white,

                                        margin: const EdgeInsets.all(5),
                                        elevation: 0.5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            // tileColor: Colors.white,

                                            title: Text(
                                                "${element.suraNo.toString()}. ${element.suraNameAr.toString()}"),
                                            subtitle: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "الصفحة : ${element.page.toString()}"),
                                                Text(
                                                    "الجزء : ${element.jozz.toString()}"),
                                              ],
                                            ),
                                            onTap: () => navigateToQuranPage(
                                                page: element.page),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Card(
                                        // color: Colors.white,

                                        margin: const EdgeInsets.all(5),
                                        elevation: 0.5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            // tileColor: Colors.white,

                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "الصفحة : ${element.page.toString()}"),
                                                Text(
                                                    "الجزء : ${element.jozz.toString()}"),
                                              ],
                                            ),
                                            subtitle: Text(
                                                "\n${element.ayaTextEmlaey}"),
                                            onTap: () => navigateToQuranPage(
                                                page: element.page),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                })
                            : const Text("")))
              ],
            )),
      ),
    );
  }
}
