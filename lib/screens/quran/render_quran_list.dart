import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moeen/providers/auth/auth_provider.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:moeen/screens/on_boarding/on_boarding.dart';
import 'package:moeen/screens/quran/components/render_page.dart';
import 'package:provider/provider.dart';

class RenderQuranList extends StatefulWidget {
  const RenderQuranList({Key? key}) : super(key: key);

  @override
  State<RenderQuranList> createState() => _RenderQuranListState();
}

class _RenderQuranListState extends State<RenderQuranList> {
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
  @override
  void initState() {
    super.initState();
    Provider.of<QuranProvider>(context, listen: false).getData();

    // Provider.of<QuranProvider>(context, listen: false).refreshData();
    Provider.of<AuthProvider>(context, listen: false).tryToken();

    checkOnBoarding();

    // Provider.of<AuthProvider>(context, listen: false).tryToken(token: );
  }

  void checkOnBoarding() async {
    final storage = const FlutterSecureStorage();

    var finishedOnBoarding = await storage.read(key: "finishedOnBoarding");
    if (finishedOnBoarding != "true") {
      setState(() {
        showOnBoarding = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final pageController = PageController();
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
            : (PageView.builder(
                controller: quranProvider.pageController,
                allowImplicitScrolling: true,

                reverse: true,
                // physics: const AlwaysScrollableScrollPhysics(),
                // scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: quranProvider.quran.length,
                onPageChanged: (p) {
                  quranProvider.refreshData(pageNumber: p + 1);
                },
                itemBuilder: (context, index) {
                  return RenderPage(page: quranProvider.quran[index]);
                  // return const Text("sdf");
                  // return const Text("sdf");
                },
                // itemBuilder: (context, index) {
                //   return RenderPage(lines: _items[index]["lines"]);
                // }
              )),
      ),
    );
  }
}
