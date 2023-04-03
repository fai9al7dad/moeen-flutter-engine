
import 'package:flutter/material.dart';

import 'package:moeen/features/quran_view/p_page_header.dart';
import 'package:moeen/features/quran_view/p_page_words.dart';

class RenderPage extends StatelessWidget {
  final int pageIndex;

  const RenderPage({
    Key? key,
    required this.pageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // Text(mistakes[0]['id'].toString()),
        Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top),

        PageHeader(
          pageIndex: pageIndex,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: PageWords(
            pageIndex: pageIndex,
          ),
        ),
        // PageWords(page: page),
      ],
    );
  }
}
