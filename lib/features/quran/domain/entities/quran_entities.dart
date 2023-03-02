class Quran {
  List<List<QuranEntity>>? pages;

  Quran({this.pages});
}

class QuranEntity {
  int? id;
  int? lineNumber;
  int? pageNumber;
  int? verseNumber;
  double? xStart;
  double? xEnd;
  String? chapterCode;
  bool? isNewChapter;
  bool? isBismillah;
  String? juzNumber;
  String? rubNumber;
  String? hizbNumber;
  String? charType;

  QuranEntity(
      {required this.id,
      required this.lineNumber,
      required this.pageNumber,
      required this.verseNumber,
      required this.xStart,
      required this.xEnd,
      required this.chapterCode,
      required this.isNewChapter,
      required this.isBismillah,
      required this.juzNumber,
      required this.rubNumber,
      required this.charType,
      required this.hizbNumber});

  factory QuranEntity.fromJson(Map<String, dynamic> json) {
    return QuranEntity(
        id: json['id'],
        lineNumber: json['lineNumber'],
        pageNumber: json['pageNumber'],
        verseNumber: json['verseNumber'],
        xStart: json['x_start'].toDouble(),
        xEnd: json['x_end'].toDouble(),
        chapterCode: json['chapterCode'],
        isNewChapter: json['isNewChapter'] == 1,
        isBismillah: json['isBismillah'] == 1,
        juzNumber: json['juzNumber'],
        rubNumber: json['rubNumber'],
        charType: json['charType'],
        hizbNumber: json['hizbNumber']);
  }
}
