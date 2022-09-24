import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moeen/components/streak_progress_widget.dart';
import 'package:moeen/helpers/general/GeneralHelpers.dart';
import 'package:moeen/screens/werds/components/circle_streak_progress.dart';
import 'package:moeen/screens/werds/werds_screen.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

class DuoInfoAppBar extends StatefulWidget {
  final String? username;
  final int? duoID;
  final String? latestWerd;
  const DuoInfoAppBar(
      {Key? key, required this.duoID, required this.username, this.latestWerd})
      : super(key: key);

  @override
  State<DuoInfoAppBar> createState() => _DuoInfoAppBarState();
}

class _DuoInfoAppBarState extends State<DuoInfoAppBar> {
  final GeneralHelpers gh = GeneralHelpers();
  int streakPercentage = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int streakPercentage = gh.calculateStreak(widget.latestWerd);
    setState(() {
      this.streakPercentage = streakPercentage;
    });
  }

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
          background: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Hero(
                  tag: "duo_${widget.duoID}",
                  child: StreakProgressWidget(
                    latestWerd: widget.latestWerd,
                    width: 100,
                    height: 100,
                    strokeWidth: 8,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _buildStreakText(context),
            ],
          )),
    );
  }

  Text _buildStreakText(BuildContext context) {
    return Text(
      streakPercentage == 100
          ? "رائع جدا، استمروا 👍"
          : streakPercentage == 70
              ? "ما سمعتم أمس، استعينوا بالله واستمروا "
              : streakPercentage == 25
                  ? "لكم مدة ما سمعتم، بادر وأكسر الفتور 💪"
                  : "أبدأوا بالتسميع اليوم، لتبدأوا ستريك",
      style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w600),
    );
  }
}
