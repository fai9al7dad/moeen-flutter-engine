import 'package:flutter/material.dart';

class NoteWordDetails extends StatelessWidget {
  final item;
  final mistake;
  const NoteWordDetails({
    Key? key,
    required this.item,
    required this.mistake,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("${item['text']}",
            style: TextStyle(
              fontFamily: "p${item["pageNumber"]}",
              color: Color(int.parse(mistake.color)),
              fontSize: 30,
            )),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(" - "),
        ),
        Text("آية ${item["verseNumber"]} - ص${item["pageNumber"]}",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            )),
      ],
    );
  }
}
