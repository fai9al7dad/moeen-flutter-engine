import 'package:flutter/material.dart';
import 'package:moeen/screens/quran/components/page_header.dart';

import 'package:moeen/screens/quran/components/page_words.dart';

class RenderPage extends StatelessWidget {
  final int index;
  const RenderPage({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return
        // Text(mistakes[0]['id'].toString()),
        Column(
      children: [
        const SizedBox(height: 50),

        PageHeader(
          index: index,
        ),
        const SizedBox(height: 5),
        Expanded(
          child: PageWords(
            index: index,
          ),
        ),

        // PageWords(page: page),
      ],
    );
  }
}
