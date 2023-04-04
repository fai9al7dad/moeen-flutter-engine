class HighlightModel {
  final int? id;
  final int? wordID;
  final int? pageNumber;
  final int? verseNumber;
  final String? chapterCode;
  final String? color;
  final int? mistakes;
  final int? warnings;

  const HighlightModel(
      {this.id,
      this.wordID,
      this.chapterCode,
      this.color,
      this.pageNumber,
      this.verseNumber,
      this.mistakes,
      this.warnings});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'wordID': wordID,
      'pageNumber': pageNumber,
      'color': color,
      'verseNumber': verseNumber,
      'chapterCode': chapterCode,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return '$HighlightModel{id: $id, wordID: $wordID, pageNumber: $pageNumber, color: $color,verseNumber: $verseNumber,chapterCode: $chapterCode,}';
  }
}
