import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:moeen/screens/quran/components/page_words/word_extras.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class Word extends StatefulWidget {
  const Word({
    Key? key,
    required this.item,
    required this.fixedFontSizePercentage,
    required this.index,
  }) : super(key: key);

  final double fixedFontSizePercentage;
  final item;
  final int index;

  @override
  State<Word> createState() => _WordState();
}

class _WordState extends State<Word> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isAnimating = false;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void toggleIsAnimating() {
    setState(() {
      isAnimating = !isAnimating;
    });
  }

  Offset _tapPosition = const Offset(0, 0);
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    // var found = quranProvider.mistakes
    //     .firstWhereOrNull((element) => element.wordID == item["wordID"]);
    return Consumer<QuranProvider>(
      builder: (context, quranProvider, child) {
        var found = quranProvider.mistakes.firstWhereOrNull(
            (element) => element.wordID == widget.item["wordID"]);
        // var found = null;
        return Stack(clipBehavior: Clip.none, children: [
          GestureDetector(
            onTapDown: _storePosition,
            onLongPress: () => {
              if (found != null)
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return WordExtras(
                        item: widget.item,
                        mistake: found,
                      );
                    })
            },
            onTap: () async {
              toggleIsAnimating();
              quranProvider.addMistake(
                  context: context,
                  id: widget.item["wordID"],
                  pageNumber: widget.item["pageNumber"],
                  verseNumber: widget.item["verseNumber"],
                  chapterCode: widget.item["chapterCode"],
                  color: found?.color);
              HapticFeedback.lightImpact();
              try {
                await controller.forward().orCancel;
                Future.delayed(const Duration(milliseconds: 1500), () async {
                  if (mounted) {
                    await controller.reverse().orCancel;
                    toggleIsAnimating();
                  }
                });
              } on TickerCanceled {
                toggleIsAnimating();
              }
            },
            child: Text(
              "${widget.item["text"]}",
              style: TextStyle(
                fontSize: widget.fixedFontSizePercentage,
                fontFamily: "p${widget.item["pageNumber"]}",
                color: Color(int.parse(found?.color ?? "0xFF000000")),
                // shadows: const [
                //   Shadow(
                //     offset: Offset(0.0, 0.0),
                //     blurRadius: 0.1,
                //     color: Color.fromARGB(255, 0, 0, 0),
                //   ),
                // ],
              ),
            ),
          ),
          if (isAnimating)
            Positioned(
              top: 0,
              child: StaggeredToolTip(
                controller: controller,
                item: widget.item,
                found: found,
              ),
            ),
        ]);
      },
    );
  }
}

class StaggeredToolTip extends StatefulWidget {
  final AnimationController controller;
  final item;
  final found;
  const StaggeredToolTip(
      {Key? key,
      required this.controller,
      required this.item,
      required this.found})
      : super(key: key);

  @override
  State<StaggeredToolTip> createState() => _StaggeredToolTipState();
}

class _StaggeredToolTipState extends State<StaggeredToolTip> {
  late SequenceAnimation sequenceAnimation;
  @override
  initState() {
    super.initState();
    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<Offset>(
                begin: const Offset(0, 0), end: const Offset(0, -30)),
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 150),
            curve: Curves.elasticOut,
            tag: "position")
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 1),
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 150),
            curve: Curves.elasticOut,
            tag: "scale")
        .animate(widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return Transform.translate(
          offset: sequenceAnimation["position"].value,
          child: Transform.scale(
              scale: sequenceAnimation["scale"].value,
              child: ElevatedButton(
                child: const Text("+", style: TextStyle(fontSize: 10)),
                onPressed: () => {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return WordExtras(
                          item: widget.item,
                          mistake: widget.found,
                        );
                      })
                },
              )),
        );
      },
    );
  }
}
