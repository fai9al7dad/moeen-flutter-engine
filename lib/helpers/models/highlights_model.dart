class HighlightsModel {
  int? id;
  int? selfUserID;
  int? werdID;
  String? type;
  var color;
  int? wordID;

  HighlightsModel(
      {this.id,
      this.selfUserID,
      this.werdID,
      this.type,
      this.wordID,
      this.color});

  HighlightsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    selfUserID = json['selfUserID'];
    werdID = json['werdID'];
    type = json['type'];
    wordID = json['wordID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['selfUserID'] = selfUserID;
    data['werdID'] = werdID;
    data['type'] = type;
    data['wordID'] = wordID;
    return data;
  }
}
