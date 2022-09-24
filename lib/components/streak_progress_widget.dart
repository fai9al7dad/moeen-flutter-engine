import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moeen/helpers/general/GeneralHelpers.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

class StreakProgressWidget extends StatefulWidget {
  final double? height;
  final double? width;
  final double? strokeWidth;
  final double? borderRadius;
  final String? latestWerd;
  const StreakProgressWidget(
      {Key? key,
      this.height,
      this.width,
      this.borderRadius,
      this.latestWerd,
      this.strokeWidth})
      : super(key: key);

  @override
  State<StreakProgressWidget> createState() => _StreakProgressWidgetState();
}

class _StreakProgressWidgetState extends State<StreakProgressWidget> {
  int value = 0;
  @override
  void initState() {
    super.initState();
    calculateStreak();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void calculateStreak() {
    final GeneralHelpers gh = GeneralHelpers();
    int streakPercentage = gh.calculateStreak(widget.latestWerd);
    setState(() {
      value = streakPercentage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SquarePercentIndicator(
      width: widget.width ?? 50,
      height: widget.height ?? 50,
      startAngle: StartAngle.bottomRight,
      reverse: true,
      borderRadius: 7,
      shadowWidth: widget.strokeWidth ?? 5,
      progressWidth: widget.strokeWidth ?? 5,
      shadowColor: Theme.of(context).scaffoldBackgroundColor,
      progressColor: value == 100
          ? Theme.of(context).colorScheme.primary
          : value <= 70 && value > 25
              ? Colors.yellow
              : Colors.red,
      progress: value / 100,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 7),
        ),
        child: Center(
            child: Text(
          value == 100
              ? "😍"
              : value < 99 && value == 70
                  ? "😁"
                  : value < 70 && value >= 1
                      ? "😨"
                      : "🌾",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        )),
      ),
    );
  }
}
