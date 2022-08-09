import 'package:flutter/material.dart';

import 'package:moeen/screens/quran/components/page_header.dart';
import 'package:moeen/screens/quran/components/page_words.dart';

class RenderPage extends StatelessWidget {
  final List page;
  final double fontSize;
  final double lineHeight;
  const RenderPage(
      {Key? key,
      required this.page,
      required this.fontSize,
      required this.lineHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;

    return
        // Text(mistakes[0]['id'].toString()),
        Column(
      children: [
        const SizedBox(height: 50),
        PageHeader(page: page[0]),
        const SizedBox(height: 10),
        page[0]["pageNumber"] == 1 || page[0]["pageNumber"] == 2
            ? Expanded(
                child: Center(
                child: PageWords(
                  page: page,
                  fontSize: fontSize,
                  lineHeight: lineHeight,
                ),
              ))
            : PageWords(
                page: page,
                fontSize: fontSize,
                lineHeight: lineHeight,
              ),
        // PageWords(page: page),
      ],
    );
  }
}
