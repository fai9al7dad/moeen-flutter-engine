import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moeen/common/presentation/atoms/list_item.dart';
import 'package:moeen/helpers/database/highlight_notes/highlight_notes.dart';
import 'package:moeen/helpers/database/highlight_notes/models/highlight_note_model.dart';
import 'package:moeen/screens/duo/components/select_duo.dart';

class QuickNotes extends StatefulWidget {
  final word;
  const QuickNotes({Key? key, required this.word}) : super(key: key);
  @override
  State<QuickNotes> createState() => _QuickNotesState();
}

class _QuickNotesState extends State<QuickNotes> {
  List<String> quickNotes = [];
  bool isLoading = true;
  // call the get quick notes function from highlight notes db
  // and then show them in a list view
  @override
  void initState() {
    super.initState();
    initQuickNotes();
    getQuickNotes();
  }

  Future<void> initQuickNotes() async {
    HapticFeedback.lightImpact();

    final highlightNotesDB = HighLightNotesDB();
    await highlightNotesDB.initDefaultQuickAdd();
  }

  Future<void> getQuickNotes() async {
    final hnDB = HighLightNotesDB();
    final List<String> notes = await hnDB.getQuickNotes();
    setState(() {
      quickNotes = notes;
      isLoading = false;
    });
  }

  Future<void> addNote(note) async {
    HapticFeedback.lightImpact();

    final hnDB = HighLightNotesDB();
    await hnDB.insertHighLightNote(
        HighLightNoteModel(note: note, wordID: widget.word["wordID"]));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(height: 120, child: ShimmerLoading());
    }
    return SizedBox(
        child: ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) => Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) async {
          final hnDB = HighLightNotesDB();
          await hnDB.deleteQuickNoteByIndex(index);
          setState(() {
            quickNotes.removeAt(index);
          });
        },
        direction: DismissDirection.startToEnd,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.clear,
            color: Colors.white,
          ),
        ),
        child: ListItem(
          title: Text(quickNotes[index]),
          onTap: () => addNote(quickNotes[index]),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              border: Border.all(
                  width: 2, color: Theme.of(context).scaffoldBackgroundColor),
              borderRadius: const BorderRadius.all(Radius.circular(7)),
            ),
            child: Center(
                child: Icon(
              Icons.add,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            )),
          ),
        ),
      ),
      itemCount: quickNotes.length,
    ));
  }
}
