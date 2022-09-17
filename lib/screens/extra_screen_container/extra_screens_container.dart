import 'package:flutter/material.dart';

import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/screens/about/about_app.dart';
import 'package:moeen/screens/analytics/analytics.dart';
import 'package:moeen/screens/contact/ContactScreen.dart';
import 'package:moeen/screens/duo/duosScreen.dart';
import 'package:moeen/screens/seperators/seperators_screen.dart';
import 'package:moeen/screens/settings/settings.dart';

class ExtraScreensContainer extends StatefulWidget {
  const ExtraScreensContainer({Key? key}) : super(key: key);

  @override
  State<ExtraScreensContainer> createState() => _ExtraScreensContainerState();
}

class _ExtraScreensContainerState extends State<ExtraScreensContainer> {
  List<Widget> tabs = [
    const DuosScreen(),
    // const Analytics(),
    const SeperatorsScreen(),
    const Settings(),
  ];
  int currentTab = 0;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: (Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          // type: BottomNavigationBarType.shifting,
          unselectedItemColor: Colors.grey,

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              label: '',
              // label: 'الثنائيات',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.bar_chart_outlined),
            //   label: 'الإحصائيات',
            //   backgroundColor: Color(0xfffff8ed),
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmarks_outlined),
              // backgroundColor: Color(0xfffff8ed),
              label: '',
              // label: 'الفواصل',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              // backgroundColor: Color(0xfffff8ed),
              label: '',
              // label: 'الإعدادات',
            ),
          ],
          currentIndex: currentTab,
          selectedItemColor: Tertiary().s600,
          onTap: (index) {
            setState(() {
              currentTab = index;
            });
          },
          // onTap: _onItemTapped,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: tabs[currentTab],
      )),
    );
  }
}
