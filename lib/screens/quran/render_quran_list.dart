import 'package:flutter/material.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:moeen/screens/quran/components/render_page.dart';
import 'package:provider/provider.dart';

class RenderQuranList extends StatelessWidget {
  const RenderQuranList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuranProvider>(
        create: (_) => QuranProvider(), child: const MainScaffold());
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  void initState() {
    super.initState();
    Provider.of<QuranProvider>(context, listen: false).getData();
    Provider.of<QuranProvider>(context, listen: false).refreshData();
  }

  @override
  Widget build(BuildContext context) {
    // final pageController = PageController();
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

                reverse: false,
                // physics: const AlwaysScrollableScrollPhysics(),
                // scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: quranProvider.quran.length,
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
