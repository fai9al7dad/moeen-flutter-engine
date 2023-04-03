import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moeen/features/quran_search/p_quran_search.dart';
import 'package:moeen/features/quran_search/quran_search_provider.dart';
import 'package:moeen/screens/quran/render_quran_list.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class QuranScreen extends StatelessWidget {
  static const String routeName = '/quran';
  const QuranScreen({Key? key}) : super(key: key);
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
  final DraggableScrollableController scrollableController =
      DraggableScrollableController();
  bool showExtra = false;

  void setShowExtra(bool value) {
    // if value is false hide the bottom sheet
    Provider.of<QuranSearchProvider>(context, listen: false).search('');

    if (!value) {
      Navigator.pop(context);
      // Provider.of<QuranSearchProvider>(context, listen: false).search('');
      return;
    }
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.94, //set this as you want
              // maxChildSize: 0.75, //set this as you want
              expand: true,
              builder: (context, scrollController) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: QuranSearch(
                    scrollController: scrollController,
                    setShowExtra: setShowExtra,
                  ),
                );
              });
        });
  }

  @override
  void dispose() {
    super.dispose();
    scrollableController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onVerticalDragUpdate: (details) {
            int sensitivity = 8;
            if (details.delta.dy > sensitivity) {
              // Down Swipe
              // setShowExtra(true);
            } else if (details.delta.dy < -sensitivity) {
              // Up Swipe
              setShowExtra(true);
            }
          },
          child: const RenderQuranList(),
        ));
  }
}
