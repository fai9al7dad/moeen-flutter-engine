import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:moeen/helpers/database/highlight_notes/highlight_notes.dart';

import 'package:moeen/helpers/database/seperators/seperators_database.dart';
import 'package:moeen/helpers/general/GeneralHelpers.dart';
import 'package:moeen/providers/auth/auth_provider.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:moeen/screens/on_boarding/on_boarding.dart';
import 'package:moeen/screens/quran/components/render_page.dart';
import 'package:moeen/screens/quran/components/show_extras.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

class RenderQuranList extends StatelessWidget {
  const RenderQuranList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return const MainScaffold();
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  bool showOnBoarding = false;
  bool showExtra = false;

  void setShowExtra(bool value) {
    setState(() {
      showExtra = value;
    });
  }

  @override
  void initState() {
    super.initState();
    checkOnBoarding();
    initSeperators();
    Provider.of<AuthProvider>(context, listen: false).tryToken();
    Provider.of<QuranProvider>(context, listen: false).refreshSeperotrs();
    Provider.of<QuranProvider>(context, listen: false)
        .refreshData(pageNumber: 1);
    checkTemp();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void initSeperators() async {
    final seperatorsDB = SeperatorsDB();
    await seperatorsDB.fillTable();
  }

  Future<void> checkTemp() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("accessToken");
    if (token != null && mounted) {
      Provider.of<QuranProvider>(context, listen: false).syncTemp();
    }
  }

  void checkOnBoarding() async {
    final prefs = await SharedPreferences.getInstance();

    bool? finishedOnBoarding = prefs.getBool("finishedOnBoarding");

    if (finishedOnBoarding != true || finishedOnBoarding == null) {
      setState(() {
        showOnBoarding = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showOnBoarding) {
      return OnBoarding(updateOnBoarding: () {
        setState(() {
          showOnBoarding = false;
        });
      });
    }

    return Consumer<QuranProvider>(
      builder: (context, quranProvider, child) => Scaffold(
        body: quranProvider.loadingGetData
            ? Center(
                child: (CircularProgressIndicator(
                  strokeWidth: 7,
                  color: Colors.green[700],
                )),
              )
            : GestureDetector(
                onVerticalDragUpdate: (details) {
                  int sensitivity = 8;
                  if (details.delta.dy > sensitivity) {
                    // Down Swipe
                    setShowExtra(true);
                  } else if (details.delta.dy < -sensitivity) {
                    // Up Swipe
                    setShowExtra(false);
                  }
                },
                child: Stack(children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: PageView.builder(
                      controller: quranProvider.pageController,
                      allowImplicitScrolling: true,
                      physics: const CustomPageViewScrollPhysics(),
                      // scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: 604,
                      onPageChanged: (p) {
                        quranProvider.refreshData(pageNumber: p + 1);
                      },
                      itemBuilder: (context, index) {
                        return FractionallySizedBox(
                          widthFactor: 1 / 1.1,
                          child: RenderPage(
                            index: index,
                          ),
                        );
                        // return const Text("sdf");
                        // return const Text("sdf");
                      },
                      // itemBuilder: (context, index) {
                      //   return RenderPage(lines: _items[index]["lines"]);
                      // }
                    ),
                  ),
                  if (showExtra)
                    ShowExtras(
                      setShowExtra: setShowExtra,
                    ),
                ]),
              ),
      ),
    );
  }
}

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 50,
        stiffness: 100,
        damping: 1,
      );
}
