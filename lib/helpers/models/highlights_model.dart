class HighlightsModel {
  int? id;
  int? selfUserID;
  int? werdID;
  String? type;
  late int wordID;
  HighlightsModel({
    this.id,
    this.selfUserID,
    this.werdID,
    this.type,
    required this.wordID,
  });

  HighlightsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    selfUserID = json['selfUserID'];
    werdID = json['werdID'];
    type = json['type'];
    wordID = json['wordID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['selfUserID'] = selfUserID;
    data['werdID'] = werdID;
    data['type'] = type;
    data['wordID'] = wordID;
    return data;
  }
}
