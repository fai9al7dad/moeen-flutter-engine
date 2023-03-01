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
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top),
        PageHeader(
          index: index,
        ),
        const SizedBox(height: 5),
        // if index == 0 return center else return expanded

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
