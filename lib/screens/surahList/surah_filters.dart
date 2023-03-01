import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:moeen/common/presentation/atoms/list_item.dart';
import 'package:moeen/helpers/database/highlight_notes/highlight_notes.dart';
import 'package:moeen/helpers/database/highlight_notes/models/highlight_note_model.dart';
import 'package:moeen/helpers/database/quran/quran_database_helper.dart';
import 'package:moeen/helpers/database/quran/quran_models.dart';
import 'package:moeen/helpers/database/werd_colors_map/WerdsColorsMap.dart';
import 'package:moeen/helpers/database/words_colors/WordsColorsMap.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:provider/provider.dart';

class SurahFilters extends StatefulWidget {
  const SurahFilters({Key? key}) : super(key: key);

  @override
  State<SurahFilters> createState() => _SurahFiltersState();
}

class _SurahFiltersState extends State<SurahFilters> {
  final wcm = WordColorMap();
  final db = DatabaseHelper();
  final werdsColorsMap = WerdsColorsMap();
  final highLightNotes = HighLightNotesDB();

  List<Word> data = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var isWerd = Provider.of<QuranProvider>(context, listen: false).isWerd;
    List<WordColorMapModel> colors = [];
    if (isWerd) {
      colors = await werdsColorsMap.getAllColors();
    } else {
      colors = await wcm.getAllColors();
    }
    List<Word> _data = [];
    for (var item in colors) {
      Word word = await db.getWordByID(id: item.wordID);
      // get highlight note by word.id if exists and append it to the word
      HighLightNoteModel? highlightNote =
          await highLightNotes.getFirstHighlightNoteFromWord(word.id);

      if (item.color == MistakesColors.revert) continue;
      _data.add(Word(
          id: word.id,
          verseNumber: word.verseNumber,
          text: word.text,
          chapterCode: word.chapterCode,
          highlightNote: highlightNote?.note,
          pageID: word.pageID,
          color: item.color));
    }

    if (mounted) {
      setState(() {
        data = _data;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (data.isEmpty) {
      return const Center(child: Text("لم تسجل أخطاء أو تنبيهات بعد"));
    }
    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: GroupedListView<dynamic, String>(
            elements: data,
            // separatorBuilder: (context, index) => const Divider(
            //       thickness: 0.8,
            //     ),

            groupBy: (element) {
              return element.chapterCode;
            },
            // separator: const Divider(
            //   thickness: 0.8,
            //   height: 0,
            // ),
            useStickyGroupSeparators: true,
            stickyHeaderBackgroundColor:
                Theme.of(context).scaffoldBackgroundColor,
            groupSeparatorBuilder: (value) => SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
                    child: Text(
                      value,
                      style: const TextStyle(
                          fontSize: 29, fontFamily: "surahname"),
                    ),
                  ),
                ),
            indexedItemBuilder: (context, element, index) {
              return ListItem(
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () {
                    Navigator.pop(context, element.pageID - 1);
                  },
                  title: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    child: Row(children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(int.parse(
                              element.color == MistakesColors.warning
                                  ? MistakesColors.warning
                                  : element.color == MistakesColors.revert
                                      ? MistakesColors.revert
                                      : MistakesColors.mistake,
                            ))),
                        height: 8,
                        width: 8,
                      ),
                      const SizedBox(width: 8),
                      Text("${element.text}",
                          style: TextStyle(
                              fontSize: 18, fontFamily: "p${element.pageID}")),
                    ]),
                  ),
                  subtitle: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (element.highlightNote != null)
                            Text("${element.highlightNote}",
                                style: TextStyle(
                                    color: Color(int.parse(element.color)))),
                          if (element.highlightNote != null)
                            const SizedBox(height: 8),
                          Row(children: [
                            Text("${element.chapterCode}surah",
                                style: const TextStyle(
                                    fontSize: 18, fontFamily: "surahname")),
                            const SizedBox(width: 8),
                            Text(
                              "رقم الصفحة: ${element.pageID}",
                              style: const TextStyle(fontSize: 10),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "رقم الآية: ${element.verseNumber}",
                              style: const TextStyle(fontSize: 10),
                            ),
                          ]),
                        ],
                      )));
            }));
  }
}
