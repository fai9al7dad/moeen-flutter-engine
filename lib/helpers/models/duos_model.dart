class DuosModel {
  String? username;
  int? id;
  int? duoID;

  DuosModel({this.username, this.id, this.duoID});

  DuosModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    id = json['id'];
    duoID = json['duoID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['id'] = this.id;
    data['duoID'] = this.duoID;
    return data;
  }
}

class DuoInviteModel {
  int? id;
  FirstUser? firstUser;

  DuoInviteModel({this.id, this.firstUser});

  DuoInviteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstUser = json['firstUser'] != null
        ? FirstUser.fromJson(json['firstUser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    if (firstUser != null) {
      data['firstUser'] = firstUser!.toJson();
    }
    return data;
  }
}

class FirstUser {
  String? username;
  int? id;

  FirstUser({this.username, this.id});

  FirstUser.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['username'] = username;
    data['id'] = id;
    return data;
  }
}
