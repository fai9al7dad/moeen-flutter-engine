import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moeen/components/CustomInput.dart';
import 'package:moeen/helpers/database/highlight_notes/highlight_notes.dart';
import 'package:moeen/helpers/database/highlight_notes/models/highlight_note_model.dart';
import 'package:moeen/helpers/database/highlight_notes/models/quick_note_model.dart';
import 'package:moeen/screens/quran/components/page_words/notes/quick_notes.dart';

class NewNoteView extends StatefulWidget {
  final word;
  const NewNoteView({
    Key? key,
    required this.word,
  }) : super(key: key);

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  TextEditingController noteController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    noteController.dispose();
  }

  Future<void> addNote({saveAsQuick = false}) async {
    HapticFeedback.lightImpact();
    final hnDB = HighLightNotesDB();
    if (saveAsQuick) {
      await hnDB.addQuickNoteByName(noteController.text);
    }
    await hnDB.insertHighLightNote(HighLightNoteModel(
        wordID: widget.word["wordID"],
        createdAt: DateTime.now().toString(),
        note: noteController.text,
        username: "خاصة"));
    noteController.clear();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          "إضافة سريعة",
          style: TextStyle(
            fontFamily: "montserrat",
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        QuickNotes(word: widget.word),
        const Text(
          "أو",
          style: TextStyle(
            fontFamily: "montserrat",
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        _newNoteInput(),
        const SizedBox(
          height: 10,
        ),
        _bottomActions(context, addNote)
      ],
    );
  }

  CustomInput _newNoteInput() {
    return CustomInput(
      controller: noteController,
      prefixIcon: Icons.subject_rounded,
      keyboardType: TextInputType.multiline,
      minLines: 3,
      maxLength: 100,
      maxLines: 3,
      label: "ملاحظة مفصلة ",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء ادخال موضوع الرسالة';
        }
        return null;
      },
    );
  }
}

Row _bottomActions(BuildContext context, Function addNote) {
  return Row(
    children: [
      ElevatedButton(
          onPressed: () => addNote(),
          child: Text("إضافة",
              style: TextStyle(
                fontFamily: "montserrat",
                color: Theme.of(context).primaryColor,
                fontSize: 14,
              ))),
      const SizedBox(
        width: 20,
      ),
      TextButton(
        child: Text("إضافة + تسجيل كإضافة سريعة",
            style: TextStyle(
              fontFamily: "montserrat",
              color: Theme.of(context).colorScheme.primary,
              fontSize: 10,
            )),
        onPressed: () => addNote(saveAsQuick: true),
      )
    ],
  );
}
