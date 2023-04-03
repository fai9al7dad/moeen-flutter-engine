class Seperator {
  final int? id;
  final int? pageNumber;
  final int? verseNumber;
  final int? wordID;
  final String? color;
  final String? name;
  final String? surah;
  const Seperator(
      {this.id,
      this.wordID,
      this.color,
      this.pageNumber,
      this.verseNumber,
      this.name,
      this.surah});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pageNumber': pageNumber,
      'color': color,
      'verseNumber': verseNumber,
      'wordID': wordID,
      'name': name,
      'surah': surah,
    };
  }

  @override
  String toString() {
    return 'Seperator{id: $id, pageNumber: $pageNumber, color: $color,verseNumber: $verseNumber,name: $name,}';
  }
}
