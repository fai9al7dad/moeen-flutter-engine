import 'package:flutter/material.dart';
import 'package:moeen/features/quran_view/quran_view_provider.dart';
import 'package:moeen/screens/quran/components/page_header_mistakes_and_warnings.dart';
import 'package:provider/provider.dart';

class PageHeader extends StatelessWidget {
  final int pageIndex;
  const PageHeader({
    Key? key,
    required this.pageIndex,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double headerPadding = 10;

    return Padding(
      padding: EdgeInsets.only(left: headerPadding, right: headerPadding),
      child:
          Consumer<QuranViewProvider>(builder: (context, quranProvider, child) {
        var page = quranProvider.quran.pages![pageIndex][0];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SurahName(
                  surah: page.chapterCode!,
                  fixedFontSizePercentageForHeader: 10,
                ),
              ],
            ),
            Row(children: [
              PageNumber(
                pageNumber: page.pageNumber!,
                fixedFontSizePercentage: 14,
              ),
              PageHeaderMistakesAndWarnings(
                pageNumber: page.pageNumber!,
                fixedFontSizePercentageForHeader: 12,
              ),
            ]),
            Row(
              children: [
                Text(
                  "الحزب ${page.hizbNumber}",
                  style: const TextStyle(
                      color: Color(0xffae8f74),
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                Text(
                  "الجزء ${page.juzNumber}",
                  style: const TextStyle(
                      color: Color(0xffae8f74),
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class DuosOrWerd extends StatelessWidget {
  final double fixedFontSizePercentageForHeader;

  const DuosOrWerd({
    Key? key,
    required this.fixedFontSizePercentageForHeader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranViewProvider>(
      builder: (context, quranProvider, child) => false // is werd
          ? CircleAvatar(
              // constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
              backgroundColor: Colors.red,
              radius: fixedFontSizePercentageForHeader - 2,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
                  onPressed: () =>
                      {Navigator.pushNamed(context, "/finish-werd")},
                  icon: Icon(
                    Icons.group,
                    size: fixedFontSizePercentageForHeader - 1,
                    color: Colors.white,
                  )),
            )
          : CircleAvatar(
              // constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: fixedFontSizePercentageForHeader - 2,
              child: IconButton(
                  color: Colors.white,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
                  onPressed: () => {
                        Navigator.pushNamed(context, "/extra-screens-container")
                      },
                  icon: Icon(
                    Icons.segment,
                    size: fixedFontSizePercentageForHeader + 2,
                  )),
            ),
    );
  }
}

class SurahName extends StatefulWidget {
  final String surah;
  final double fixedFontSizePercentageForHeader;
  const SurahName(
      {Key? key,
      required this.surah,
      required this.fixedFontSizePercentageForHeader})
      : super(key: key);

  @override
  State<SurahName> createState() => _SurahNameState();
}

class _SurahNameState extends State<SurahName> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateAndGoToPage(context),
      child: Text(
        "${widget.surah}surah",
        style: const TextStyle(
            color: Color(0xffae8f74), fontFamily: "surahname", fontSize: 17),
      ),
    );
  }

  Future<void> _navigateAndGoToPage(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.pushNamed(context, '/surah-list');

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;
    if (result == null) return;

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    Provider.of<QuranViewProvider>(context, listen: false)
        .pageController
        // ugly way , but because result is object
        .jumpToPage(int.parse(result.toString()));
  }
}

TextEditingController pageNumberController = TextEditingController();

class PageNumber extends StatelessWidget {
  final int pageNumber;
  final double fixedFontSizePercentage;

  const PageNumber(
      {Key? key,
      required this.pageNumber,
      required this.fixedFontSizePercentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Consumer<QuranViewProvider>(
      builder: (context, quranProvider, _) => Row(
        children: [
          const SizedBox(width: 3),
          Text(pageNumber.toString(),
              style: const TextStyle(
                color: Color(0xffae8f74),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(width: 5),
          Transform.scale(
              scaleX: pageNumber % 2 == 0 ? 1 : -1,
              child: const Icon(
                Icons.menu_book_rounded,
                size: 12,
                color: Color(0xffae8f74),
              )),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
