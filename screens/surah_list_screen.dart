import 'package:flutter/material.dart';
import 'package:moeen/common/components/CustomAppBar.dart';
import 'package:moeen/screens/surahList/surah_list.dart';

class SurahListScreen extends StatelessWidget {
  static const String routeName = '/surah_list';
  const SurahListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: CustomAppBar(title: "قائمة السور"), body: SurahList());
  }
}
