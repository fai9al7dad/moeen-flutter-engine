import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moeen/components/list_item.dart';
import 'package:moeen/helpers/database/highlight_notes/highlight_notes.dart';
import 'package:moeen/helpers/database/highlight_notes/models/highlight_note_model.dart';
import 'package:moeen/screens/duo/components/select_duo.dart';

class PrevNotesView extends StatefulWidget {
  final word;
  const PrevNotesView({
    Key? key,
    required this.word,
  }) : super(key: key);

  @override
  State<PrevNotesView> createState() => _PrevNotesViewState();
}

class _PrevNotesViewState extends State<PrevNotesView> {
  bool isLoading = true;
  List<HighLightNoteModel> notes = [];

  @override
  void initState() {
    super.initState();
    fetchHighLightNotes();
  }

  // fetch highlight notes by word id
  Future<void> fetchHighLightNotes() async {
    HapticFeedback.lightImpact();
    final hnDB = HighLightNotesDB();
    final List<HighLightNoteModel> _notes =
        await hnDB.getHighLightNotesByWordID(widget.word["wordID"]);
    if (mounted) {
      setState(() {
        notes = _notes;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const ShimmerLoading();
    }
    if (notes.isEmpty) {
      return const SizedBox(
          height: 50, child: Center(child: Text("لا يوجد ملاحظات...")));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(notes[index].id.toString()),
              onDismissed: (direction) async {
                final hnDB = HighLightNotesDB();
                await hnDB.removeHighLightNoteByID(id: notes[index].id);
                setState(() {
                  notes.removeAt(index);
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
                title: Text(
                  notes[index].note,
                  style: const TextStyle(fontSize: 12),
                ),
                subtitle: SizedBox(
                  width: 400,
                  child: Row(
                    children: [
                      Text(
                        notes[index].username ?? "",
                        style: const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${notes[index].createdAt}",
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
