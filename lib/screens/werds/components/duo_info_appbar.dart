import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moeen/screens/werds/components/circle_streak_progress.dart';
import 'package:moeen/screens/werds/werds_screen.dart';

class DuoInfoAppBar extends StatefulWidget {
  final String? username;
  final int? duoID;
  const DuoInfoAppBar({Key? key, required this.duoID, required this.username})
      : super(key: key);

  @override
  State<DuoInfoAppBar> createState() => _DuoInfoAppBarState();
}

class _DuoInfoAppBarState extends State<DuoInfoAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      // scrolledUnderElevation: 10,
      backgroundColor: Theme.of(context).colorScheme.background,
      expandedHeight: 230.0,
      centerTitle: true,
      foregroundColor: Theme.of(context).primaryColor,
      // title: const Text(
      //   "الأوراد",
      //   style: TextStyle(fontSize: 14),
      // ),
      elevation: 0,
      // actions: [WerdFilterSlider()],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        // expandedTitleScale: 1,
        title: Text(
          "${widget.username}",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        background:
            Hero(tag: "duo_${widget.duoID}", child: CircleStreakProgress()),
      ),
    );
  }
}
