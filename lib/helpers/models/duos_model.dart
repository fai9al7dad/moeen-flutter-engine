class DuosModel {
  String? username;
  int? id;
  int? duoID;
  String? latestWerd;
  DuosModel({this.username, this.id, this.duoID, this.latestWerd});

  DuosModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    id = json['id'];
    duoID = json['duoID'];
    latestWerd = json['latestWerd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['username'] = username;
    data['id'] = id;
    data['duoID'] = duoID;
    data['latestWerd'] = latestWerd;
    return data;
  }
}

class DuoInviteModel {
  int? id;
  FirstUser? firstUser;
  FirstUser? secondUser;

  String? type;

  DuoInviteModel({this.id, this.firstUser, this.type, this.secondUser});

  DuoInviteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstUser = json['firstUser'] != null
        ? FirstUser.fromJson(json['firstUser'])
        : null;
    secondUser = json['secondUser'] != null
        ? FirstUser.fromJson(json['secondUser'])
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

class SearchUserModel {
  String? username;
  String? email;
  int? id;

  SearchUserModel({this.username, this.email, this.id});

  SearchUserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['username'] = username;
    data['email'] = email;
    data['id'] = id;
    return data;
  }
}
