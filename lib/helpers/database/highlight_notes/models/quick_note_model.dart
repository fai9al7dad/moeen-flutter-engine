class QuickNoteModel {
  String note;
  QuickNoteModel({required this.note});
  Map<String, dynamic> toMap() {
    return {
      'note': note,
    };
  }
}
