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
            foregroundColor: Theme.of(context).primaryColor,
            title: Text(
              "السور",
              style: TextStyle(
                  fontFamily: "montserrat",
                  fontSize: 14,
                  color: Theme.of(context).primaryColor),
            ),
            centerTitle: true,
            bottom: TabBar(
                enableFeedback: true,
                indicatorColor: Theme.of(context).colorScheme.primary,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor:
                    Theme.of(context).primaryColor.withOpacity(0.5),
                labelStyle: TextStyle(
                    fontFamily: "montserrat",
                    fontSize: 14,
                    color: Theme.of(context).primaryColor),
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
