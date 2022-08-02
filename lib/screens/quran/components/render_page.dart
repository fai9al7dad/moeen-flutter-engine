import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:moeen/screens/quran/components/page_header.dart';
import 'package:moeen/screens/quran/components/page_words.dart';

class RenderPage extends StatelessWidget {
  final List page;
  const RenderPage({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;

    return
        // Text(mistakes[0]['id'].toString()),
        Column(
      children: [
        const SizedBox(height: 40),
        PageHeader(page: page[0]),
        const SizedBox(height: 20),
        PageWords(page: page),
      ],
    );
  }
}
