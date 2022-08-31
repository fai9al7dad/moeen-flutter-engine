import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moeen/components/CustomInput.dart';
import 'package:moeen/components/CustomShowCase.dart';
import 'package:moeen/helpers/database/seperators/seperators_database.dart';
import 'package:moeen/helpers/general/GeneralHelpers.dart';
import 'package:moeen/providers/auth/auth_provider.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:moeen/screens/on_boarding/on_boarding.dart';
import 'package:moeen/screens/quran/components/render_page.dart';
import 'package:moeen/screens/quran/components/show_extras.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class RenderQuranList extends StatelessWidget {
  const RenderQuranList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
    Provider.of<QuranProvider>(context, listen: false).getData();
    Provider.of<QuranProvider>(context, listen: false).refreshSeperotrs();

    // Provider.of<QuranProvider>(context, listen: false).refreshData();

    // Provider.of<AuthProvider>(context, listen: false).tryToken(token: );
  }

  void initSeperators() async {
    final seperatorsDB = SeperatorsDB();
    await seperatorsDB.fillTable();
  }

  void checkOnBoarding() async {
    const storage = FlutterSecureStorage();

    var finishedOnBoarding = await storage.read(key: "finishedOnBoarding");
    if (finishedOnBoarding != "finished" || finishedOnBoarding == null) {
      setState(() {
        showOnBoarding = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // set default to shut up null errors
    final gh = GeneralHelpers();
    var flMap = gh.getResponsiveFontAndLineHeightPercentage(
        height: height, width: width);
    var fixedFontSizePercentageForHeader =
        gh.getResponsiveFontAndLineHeightPercentageForHeader(height: height);
    // final pageController = PageController();
    double fixedFontSizePercentage = flMap["fixedFontSizePercentage"] ?? 25.928;
    double fixedLineHeightPercentage =
        flMap["fixedLineHeightPercentage"] ?? 1.852;

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
                  PageView.builder(
                    controller: quranProvider.pageController,
                    allowImplicitScrolling: true,

                    physics: const CustomPageViewScrollPhysics(),
                    reverse: true,
                    // physics: const AlwaysScrollableScrollPhysics(),
                    // scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,

                    itemCount: quranProvider.quran.length,
                    onPageChanged: (p) {
                      quranProvider.refreshData(pageNumber: p + 1);
                    },
                    itemBuilder: (context, index) {
                      return RenderPage(
                          page: quranProvider.quran[index],
                          fixedFontSizePercentageForHeader:
                              fixedFontSizePercentageForHeader,
                          fixedFontSizePercentage: fixedFontSizePercentage,
                          fixedLineHeightPercentage: fixedLineHeightPercentage);
                      // return const Text("sdf");
                      // return const Text("sdf");
                    },
                    // itemBuilder: (context, index) {
                    //   return RenderPage(lines: _items[index]["lines"]);
                    // }
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
