import 'package:flutter/material.dart';
import 'package:moeen/providers/quran/quran_provider.dart';

import 'package:moeen/screens/quran/components/page_header.dart';
import 'package:moeen/screens/quran/components/page_words.dart';
import 'package:showcaseview/showcaseview.dart';

class RenderPage extends StatefulWidget {
  final List page;
  final double fixedFontSizePercentage;
  final double fixedLineHeightPercentage;
  final double fixedFontSizePercentageForHeader;
  const RenderPage(
      {Key? key,
      required this.page,
      required this.fixedFontSizePercentage,
      required this.fixedFontSizePercentageForHeader,
      required this.fixedLineHeightPercentage})
      : super(key: key);

  @override
  State<RenderPage> createState() => _RenderPageState();
}

class _RenderPageState extends State<RenderPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return
        // Text(mistakes[0]['id'].toString()),
        Column(
      children: [
        SizedBox(
            height: widget.fixedFontSizePercentageForHeader < 13 ? 10 : 50),

        PageHeader(
          page: widget.page[0],
          fixedFontSizePercentageForHeader:
              widget.fixedFontSizePercentageForHeader,
        ),
        const SizedBox(height: 10),
        PageWords(
          page: widget.page,
          fixedFontSizePercentage: widget.fixedFontSizePercentage,
          fixedLineHeightPercentage: widget.fixedLineHeightPercentage,
        ),
        // PageWords(page: page),
      ],
    );
  }
}
