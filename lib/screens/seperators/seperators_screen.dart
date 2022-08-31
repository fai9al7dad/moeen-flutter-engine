import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/CustomButton.dart';
import 'package:moeen/components/CustomInput.dart';
import 'package:moeen/helpers/database/seperators/seperators_database.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:provider/provider.dart';

class SeperatorsScreen extends StatefulWidget {
  const SeperatorsScreen({Key? key}) : super(key: key);

  @override
  State<SeperatorsScreen> createState() => _SeperatorsScreenState();
}

class _SeperatorsScreenState extends State<SeperatorsScreen> {
  bool loading = true;
  List<SeperatorModel> seperators = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

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

  void updateSeperator(context, index) async {
    Navigator.of(context).pop();
    final seperatorsDB = SeperatorsDB();
    await seperatorsDB.updateSeperator(SeperatorModel(
      color: seperators[index].color,
      name: nameController.text,
      id: seperators[index].id,
      verseNumber: seperators[index].verseNumber,
      pageNumber: seperators[index].pageNumber,
      surah: seperators[index].surah,
    ));
    fetchSeperators();
  }

  void clearSeperator(index) async {
    final seperatorsDB = SeperatorsDB();
    await seperatorsDB.clearSeperator(SeperatorModel(
      color: seperators[index].color,
      name: nameController.text,
      id: seperators[index].id,
      verseNumber: seperators[index].verseNumber,
      pageNumber: seperators[index].pageNumber,
      surah: seperators[index].surah,
    ));
    fetchSeperators();
  }

  void navigateToQuranPage({required int page}) {
    Navigator.of(context).pop();

    Provider.of<QuranProvider>(context, listen: false)
        .pageController
        .jumpToPage(page - 1);
  }

  @override
  Widget build(BuildContext context) {
    // get height of screen
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const CustomAppBar(title: "الفواصل"),
      body: loading
          ? const SizedBox(
              height: 10,
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("اضفط على رقم الأية لإضافة فاصل",
                      style: TextStyle(
                        fontFamily: "montserrat",
                        color: Colors.grey,
                        fontSize: 14,
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                              thickness: 0.8,
                              height: 0,
                            ),
                        itemCount: seperators.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                              tileColor: Colors.white,
                              onTap: seperators[index].pageNumber != null
                                  ? () => navigateToQuranPage(
                                      page: seperators[index].pageNumber!)
                                  : null,
                              trailing: IconButton(
                                onPressed: () => {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: SizedBox(
                                              height: height * 0.8,
                                              child: Column(children: [
                                                const Text(
                                                  "تعديل الفاصل",
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontFamily:
                                                          "montserrat-bold"),
                                                ),
                                                Icon(
                                                  Icons.bookmark,
                                                  size: 50,
                                                  color: Color(int.parse(
                                                      seperators[index]
                                                          .color!)),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Form(
                                                  key: _formKey,
                                                  child: CustomInput(
                                                      autoFocus: true,
                                                      controller:
                                                          nameController,
                                                      prefixIcon:
                                                          Icons.edit_outlined,
                                                      validator: (value) {
                                                        if (value!.isEmpty ||
                                                            value == "") {
                                                          return 'الإسم مطلوب';
                                                        }
                                                      },
                                                      label: seperators[index]
                                                              .name ??
                                                          ""),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                // submit buttonCustomButton(
                                                CustomButton(
                                                    onPressed: () async {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        updateSeperator(
                                                            context, index);
                                                      }
                                                    },
                                                    text: "تعديل"),
                                              ]),
                                            ),
                                          ),
                                        );
                                      })
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: 18,
                                ),
                              ),
                              iconColor: Color(int.parse(
                                  seperators[index].color ?? "0xffae8f74")),
                              leading: seperators[index].verseNumber != null
                                  ? IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.bookmark),
                                      onPressed: () => clearSeperator(index))
                                  : const Icon(Icons.bookmark_outline),
                              title: Text(
                                "${seperators[index].name}",
                                style: const TextStyle(fontSize: 18),
                              ),
                              subtitle: seperators[index].surah != null
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("${seperators[index].surah}surah",
                                            style: const TextStyle(
                                                fontSize: 26,
                                                letterSpacing: -3,
                                                fontFamily: "surahname")),
                                        Text(
                                            "أية ${seperators[index].verseNumber} صفحة ${seperators[index].pageNumber}",
                                            style:
                                                const TextStyle(fontSize: 14)),
                                      ],
                                    )
                                  : const Text(""));
                        }),
                  ),
                ],
              )),
    );
  }
}
