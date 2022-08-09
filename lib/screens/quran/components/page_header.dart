import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:moeen/screens/quran/components/page_header_mistakes_and_warnings.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class PageHeader extends StatelessWidget {
  final page;
  const PageHeader({Key? key, required this.page}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Expanded(
        //     child: Row(children: [
        // ])),
        Row(
          children: [
            Text(
              "الحزب ${page["hizbNumber"].toString()}",
              style: const TextStyle(
                  color: Color(0xffae8f74),
                  fontFamily: "montserrat",
                  fontSize: 12),
            ),
            const SizedBox(width: 5),
            Text(
              "الجزء ${page["juzNumber"].toString()}",
              style: const TextStyle(
                  color: Color(0xffae8f74),
                  fontFamily: "montserrat",
                  fontSize: 12),
            ),
          ],
        ),

        Row(children: [
          PageNumber(pageNumber: page["pageNumber"]),
          PageHeaderMistakesAndWarnings(pageNumber: page["pageNumber"]),
        ]),
        Row(
          children: [
            SurahName(
              surah: page["chapterCode"],
            ),
            const SizedBox(
              width: 5,
            ),
            const DuosOrWerd()
          ],
        )
      ],
    );
  }
}

class DuosOrWerd extends StatelessWidget {
  const DuosOrWerd({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (context, quranProvider, child) => quranProvider.isWerd
          ? CircleAvatar(
              // constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
              backgroundColor: Colors.red,
              radius: 8,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
                  onPressed: () =>
                      {Navigator.pushNamed(context, "/finish-werd")},
                  icon: const Icon(
                    Icons.group,
                    size: 12,
                    color: Colors.white,
                  )),
            )
          : CircleAvatar(
              // constraints: const BoxConstraints(minHeight: 0, minWidth: 0),

              radius: 10,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
                  onPressed: () => {Navigator.pushNamed(context, "/duos")},
                  icon: const Icon(
                    Icons.group,
                    size: 13,
                  )),
            ),
    );
  }
}

class SurahName extends StatefulWidget {
  final String surah;
  const SurahName({Key? key, required this.surah}) : super(key: key);

  @override
  State<SurahName> createState() => _SurahNameState();
}

class _SurahNameState extends State<SurahName> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateAndGoToPage(context),
      child: Row(
        children: [
          const Icon(Icons.unfold_more, size: 10, color: Color(0xffae8f74)),
          Text(
            "${widget.surah}surah",
            style: const TextStyle(
                color: Color(0xffae8f74),
                fontFamily: "surahname",
                fontSize: 18),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateAndGoToPage(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.pushNamed(context, "/surah-list");

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;
    if (result == null) return;

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    Provider.of<QuranProvider>(context, listen: false)
        .pageController
        // ugly way , but because result is object
        .jumpToPage(int.parse(result.toString()));
  }
}

TextEditingController pageNumberController = TextEditingController();

class PageNumber extends StatelessWidget {
  final int pageNumber;
  PageNumber({Key? key, required this.pageNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Consumer<QuranProvider>(
      builder: (context, quranProvider, _) => GestureDetector(
        onTap: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('انتقل الى صفحة'),
            content: PageNumberForm(formKey: _formKey),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('الغاء'),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    quranProvider.pageController
                        .jumpToPage(int.parse(pageNumberController.text) - 1);
                    Navigator.pop(context, 'ok');
                  }
                },
                child: const Text('انتقل'),
              ),
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 15,
              height: 15,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xfff7f0e7)),
              child: const Icon(
                Icons.unfold_more,
                size: 10,
                color: Color(0xffae8f74),
              ),
            ),
            const SizedBox(width: 3),
            Text(pageNumber.toString(),
                style: const TextStyle(
                    color: Color(0xffae8f74),
                    fontSize: 12,
                    fontFamily: "montserrat")),
            const SizedBox(width: 5),
            Transform.scale(
                scaleX: pageNumber % 2 == 0 ? 1 : -1,
                child: const Icon(
                  Icons.menu_book_rounded,
                  size: 15,
                  color: Color(0xffae8f74),
                )),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}

class PageNumberForm extends StatefulWidget {
  final formKey;
  const PageNumberForm({Key? key, this.formKey}) : super(key: key);

  @override
  State<PageNumberForm> createState() => _PageNumberFormState();
}

class _PageNumberFormState extends State<PageNumberForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: TextFormField(
          controller: pageNumberController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            if (int.parse(value) > 604 || int.parse(value) < 1) {
              return 'الرجاء ادخل رقم بين 1-604';
            }
            return null;
          },
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'ادخل رقم الصفحة',
          ),
        ));
  }
}
