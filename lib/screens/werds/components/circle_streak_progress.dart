import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CircleStreakProgress extends StatefulWidget {
  final String? latestWerd;

  const CircleStreakProgress({
    Key? key,
    this.latestWerd,
  }) : super(key: key);

  @override
  State<CircleStreakProgress> createState() => _CircleStreakProgressState();
}

class _CircleStreakProgressState extends State<CircleStreakProgress> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(alignment: Alignment.center, children: [
          SizedBox(
            width: 90,
            height: 90,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              value: 0.8,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,

              // borderRadius: 900,
            ),
          ),
          const Text("🌾", style: TextStyle(fontSize: 20))
        ]),
        const SizedBox(
          height: 10,
        ),
        Text("رائع جدا ، استمروا 👍",
            style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).primaryColor.withOpacity(0.8))),
      ],
    );
  }
}
