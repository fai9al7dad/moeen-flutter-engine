import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moeen/screens/quran/components/page_words.dart';
import 'package:moeen/screens/quran/components/page_words/notes/new_note_view.dart';
import 'package:moeen/screens/quran/components/page_words/notes/note_word_details.dart';
import 'package:moeen/screens/quran/components/page_words/notes/prev_notes_view.dart';

class WordExtras extends StatefulWidget {
  final item;
  final mistake;
  const WordExtras({Key? key, required this.item, required this.mistake})
      : super(key: key);

  @override
  State<WordExtras> createState() => _WordExtrasState();
}

class _WordExtrasState extends State<WordExtras> {
  int groupValue = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      builder: ((context, scrollController) => Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SingleChildScrollView(
                controller: scrollController,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child:
                      // height: 600,
                      Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NoteWordDetails(
                            item: widget.item,
                            mistake: widget.mistake,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _notesSlider(context),
                          if (groupValue == 0) NewNoteView(word: widget.item),
                          if (groupValue == 1) PrevNotesView(word: widget.item)
                        ]),
                  ),
                )),
          )),
    );
  }

  CupertinoSlidingSegmentedControl<int> _notesSlider(BuildContext context) {
    return CupertinoSlidingSegmentedControl<int>(
      children: const {
        0: Text("إضافة ملاحظة"),
        1: Text("الملاحظات"),
      },
      groupValue: groupValue,
      onValueChanged: (val) => {
        setState(() {
          groupValue = val!;
        })
      },
      thumbColor: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.all(8),
    );
  }
}
