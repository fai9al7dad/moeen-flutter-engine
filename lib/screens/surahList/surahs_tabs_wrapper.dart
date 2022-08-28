import 'package:flutter/material.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/screens/duo/components/view_duos_invites.dart';
import 'package:moeen/screens/surahList/surah_filters.dart';
import 'package:moeen/screens/surahList/surah_list.dart';

class SurahTabsWrapper extends StatelessWidget {
  const SurahTabsWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.8,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Tertiary().s800,
            title: const Text(
              "السور",
              style: TextStyle(fontFamily: "montserrat", fontSize: 14),
            ),
            centerTitle: true,
            bottom: TabBar(
                labelStyle: TextStyle(
                    fontFamily: "montserrat",
                    fontSize: 14,
                    color: Tertiary().s800),
                labelColor: Tertiary().s800,
                tabs: const [
                  Tab(
                    text: "فهرس السور",
                  ),
                  Tab(text: "فهرسة الأخطاء"),
                ]),
          ),
          body: const TabBarView(children: [SurahList(), SurahFilters()]),
        ),
      ),
    );
  }
}
