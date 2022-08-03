class WerdsModel {
  int? id;
  String? createdAt;
  int? duoID;
  int? reciterID;
  int? correctorID;
  bool? isAccepted;

  WerdsModel(
      {this.id,
      this.createdAt,
      this.duoID,
      this.reciterID,
      this.correctorID,
      this.isAccepted});

  WerdsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    duoID = json['duoID'];
    reciterID = json['reciterID'];
    correctorID = json['correctorID'];
    isAccepted = json['isAccepted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['duoID'] = duoID;
    data['reciterID'] = reciterID;
    data['correctorID'] = correctorID;
    return data;
  }
}
