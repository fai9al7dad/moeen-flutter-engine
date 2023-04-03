class Quran {
  List<List<QuranEntity>>? pages;

  Quran({this.pages});
}

class QuranEntity {
  int? id;
  int? lineNumber;
  int? pageNumber;
  int? verseNumber;
  String? chapterCode;
  bool? isNewChapter;
  bool? isBismillah;
  String? juzNumber;
  String? rubNumber;
  String? hizbNumber;
  String? charType;
  String? text;
  String? audioUrl;

  QuranEntity(
      {required this.id,
      required this.lineNumber,
      required this.pageNumber,
      required this.verseNumber,
      required this.chapterCode,
      required this.isNewChapter,
      required this.isBismillah,
      required this.juzNumber,
      required this.rubNumber,
      required this.charType,
      required this.text,
      required this.audioUrl,
      required this.hizbNumber});

  factory QuranEntity.fromJson(Map<dynamic, dynamic> json) {
    return QuranEntity(
        id: json['id'],
        lineNumber: json['lineNumber'],
        pageNumber: json['pageNumber'],
        verseNumber: json['verseNumber'],
        chapterCode: json['chapterCode'],
        isNewChapter: json['isNewChapter'] == 1,
        isBismillah: json['isBismillah'] == 1,
        juzNumber: json['juzNumber'],
        rubNumber: json['rubNumber'],
        charType: json['charType'],
        text: json['text'],
        audioUrl: json['audioUrl'],
        hizbNumber: json['hizbNumber']);
  }
}

class Page {
  String? chapterCode;
  int? id, pageNumber, hizbNumber, juz;
  Page({this.chapterCode, this.hizbNumber, this.id, this.juz, this.pageNumber});
}

class Line {
  int? id, pageID;
  Line({this.id, this.pageID});
}

class Word {
  String? chapterCode,
      audioUrl,
      charType,
      transliteration,
      text,
      highlightNote,
      color;

  int? id, lineID, isNewChapter, wordID, isBismillah, verseNumber;
  int? lineNumber;
  int? pageNumber;
  Word(
      {this.id,
      this.audioUrl,
      this.charType,
      this.isBismillah,
      this.isNewChapter,
      this.lineID,
      this.lineNumber,
      this.chapterCode,
      this.highlightNote,
      this.text,
      this.transliteration,
      this.verseNumber,
      this.pageNumber,
      this.color});
}

class JoinedQuran {
  String? chapterCode, audioUrl, charType, transliteration;
  String text;
  int? id,
      hizbNumber,
      juz,
      lineID,
      isNewChapter,
      wordID,
      verseNumber,
      isBismillah;
  int pageNumber, lineNumber;
  JoinedQuran(
      {this.id,
      this.chapterCode,
      this.hizbNumber,
      this.juz,
      required this.pageNumber,
      this.audioUrl,
      this.charType,
      this.isBismillah,
      this.isNewChapter,
      this.lineID,
      required this.lineNumber,
      required this.text,
      this.transliteration,
      this.verseNumber});
}


// class Word {
//   int? ID, PageID;
//   Line(this.ID, this.PageID);
// }
