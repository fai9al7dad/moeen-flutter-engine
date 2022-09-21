import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

class StreakProgressWidget extends StatefulWidget {
  final double? height;
  final double? width;
  final double? borderRadius;
  const StreakProgressWidget({
    Key? key,
    this.height,
    this.width,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<StreakProgressWidget> createState() => _StreakProgressWidgetState();
}

class _StreakProgressWidgetState extends State<StreakProgressWidget> {
  int value = 50;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    // timer = Timer.periodic(Duration(milliseconds: 20), (Timer t) {
    //   // setState(() {
    //   //   value = (value + 1) % 50;
    //   // });
    //   timer?.cancel();
    // });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SquarePercentIndicator(
      width: widget.width ?? 50,
      height: widget.height ?? 50,
      startAngle: StartAngle.bottomRight,
      reverse: true,
      borderRadius: 7,
      shadowWidth: 5,
      progressWidth: 5,
      shadowColor: Theme.of(context).scaffoldBackgroundColor,
      progressColor: Theme.of(context).colorScheme.primary,
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
              : value < 99 && value > 50
                  ? "😁"
                  : value < 50 && value > 30
                      ? "😐"
                      : value < 30 && value > 1
                          ? "😨"
                          : "🌾",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        )),
      ),
    );
  }
}
