import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:moeen/common/components/CustomInput.dart';
import 'package:moeen/common/components/list_item.dart';
import 'package:moeen/features/quran_search/quran_search_provider.dart';
import 'package:moeen/features/quran_search/quran_simple_database_api.dart';
import 'package:moeen/features/quran_view/quran_view_provider.dart';
import 'package:provider/provider.dart';

class QuranSearch extends StatefulWidget {
  final Function setShowExtra;
  final ScrollController scrollController;
  const QuranSearch(
      {Key? key, required this.setShowExtra, required this.scrollController})
      : super(key: key);

  @override
  State<QuranSearch> createState() => _QuranSearchState();
}

class _QuranSearchState extends State<QuranSearch>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController queryController = TextEditingController();
  final quranSimpleDataBase = QuranSimpleDatabaseApi();

  void navigateToQuranPage({required String page}) {
    widget.setShowExtra(false);

    Provider.of<QuranViewProvider>(context, listen: false)
        .navigateToQuranPage(page: page);
  }

  @override
  void dispose() {
    super.dispose();
    queryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranSearchProvider>(
      builder: (context, quranSearchProvider, child) => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
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
                                onChanged: quranSearchProvider.search,
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
                Text(
                    "نتيجة البحث : ${quranSearchProvider.searchResult.length}"),
                Expanded(
                    child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: quranSearchProvider.searchResult.isNotEmpty
                            ? GroupedListView<dynamic, String>(
                                controller: widget.scrollController,
                                elements: quranSearchProvider.searchResult,
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
                                      child: ListItem(
                                        // tileColor: Colors.white,

                                        title: Text(
                                            "الصفحة : ${element.page.toString()}"),
                                        subtitle:
                                            Text("سورة ${element.suraNameAr}"),
                                        onTap: () => navigateToQuranPage(
                                            page: element.page),
                                      ),
                                    );
                                  } else if (element.type == "surah") {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: ListItem(
                                        // tileColor: Colors.white,

                                        title: Text(
                                            "${element.suraNo.toString()}. ${element.suraNameAr.toString()}"),
                                        subtitle: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: ListItem(
                                        // tileColor: Colors.white,

                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "السورة : ${element.suraNameAr.toString()}",
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "الصفحة : ${element.page.toString()}",
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    "الجزء : ${element.jozz.toString()}",
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Text(
                                              "\n${element.ayaTextEmlaey}"),
                                        ),
                                        onTap: () => navigateToQuranPage(
                                            page: element.page),
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
