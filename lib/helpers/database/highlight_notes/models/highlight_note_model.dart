class HighLightNoteModel {
  int? id;
  int wordID;
  String? createdAt;
  String note;
  String? username;

  // assign default for created at as current date
  // and assign default for username as خاصة

  HighLightNoteModel({
    this.id,
    required this.wordID,
    this.createdAt,
    required this.note,
    this.username,
  }) {
    createdAt = createdAt ?? DateTime.now().toString();
    username = username ?? "خاصة";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'wordID': wordID,
      'createdAt': createdAt,
      'note': note,
      'username': username,
    };
  }
}
