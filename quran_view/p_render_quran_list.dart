import 'package:flutter/material.dart';
import 'package:moeen/features/quran_view/quran_view_provider.dart';
import 'package:provider/provider.dart';

import 'p_render_page.dart';

class RenderQuranList extends StatelessWidget {
  const RenderQuranList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<QuranViewProvider>(
      builder: (context, quranProvider, child) => quranProvider.loadingGetData
          ? Center(
              child: (CircularProgressIndicator(
                strokeWidth: 7,
                color: Colors.green[700],
              )),
            )
          : Directionality(
              textDirection: TextDirection.rtl,
              child: PageView.builder(
                controller: quranProvider.pageController,
                allowImplicitScrolling: true,
                physics: const CustomPageViewScrollPhysics(),
                clipBehavior: Clip.none,
                itemCount: 604,
                onPageChanged: (p) {
                  // quranProvider.refreshData(pageNumber: p + 1);
                },
                itemBuilder: (context, index) {
                  return FractionallySizedBox(
                    widthFactor: 1 / 1.1,
                    child: RenderPage(
                      pageIndex: index,
                    ),
                  );
                },
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
