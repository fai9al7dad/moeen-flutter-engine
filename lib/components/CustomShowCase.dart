import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:showcaseview/showcaseview.dart';

class CustomShowCase extends StatelessWidget {
  final GlobalKey<State<StatefulWidget>> caseKey;
  final String title;
  final String description;
  final Widget child;
  final EdgeInsets? overlayPadding;
  final ShapeBorder? shapeBorder;
  final bool? showArrow;
  const CustomShowCase(
      {Key? key,
      required this.caseKey,
      required this.child,
      required this.description,
      this.overlayPadding,
      this.shapeBorder,
      this.showArrow,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Showcase(
        key: caseKey,
        title: title,
        showArrow: showArrow ?? true,
        overlayPadding: overlayPadding ?? const EdgeInsets.all(0),
        description: description,
        shapeBorder: shapeBorder,
        showcaseBackgroundColor: Tertiary().s400,
        // overlayPadding: const EdgeInsets.all(8),
        contentPadding: const EdgeInsets.all(10),
        titleTextStyle: TextStyle(
            color: Tertiary().s900,
            fontFamily: "montserrat-bold",
            fontSize: 16),
        descTextStyle: TextStyle(
            color: Tertiary().s900, fontFamily: "montserrat", fontSize: 14),
        child: child);
  }
}
