import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:moeen/helpers/dio/api.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuth = false;
  final storage = const FlutterSecureStorage();
  late UserModel? _authUser;
  bool get isAuth {
    return _isAuth;
  }

  UserModel? get authUser {
    return _authUser;
  }

  void login({required creds}) async {
    _isAuth = true;
    UserModel user = UserModel.fromJson(creds);
    _authUser = user;
    await storage.write(key: "accessToken", value: user.accessToken);

    notifyListeners();
  }

  void tryToken() async {
    try {
      Api api = Api();
      var user = await api.getAuthUser();
      if (user == null) return;
      _isAuth = true;
      _authUser = user;

      notifyListeners();
    } catch (e) {
      logout();
    }
    // dio().options.headers["Authorization"] = user.accessToken;
  }

  void logout() async {
    _isAuth = false;
    _authUser = null;
    await storage.delete(key: "accessToken");
    // dio().options.headers["Authorization"] = "";
    notifyListeners();
  }
}

class UserModel {
  final int? id;
  final String? username;
  final String? email;
  final String? accessToken;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.accessToken,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : accessToken = json["accessToken"],
        username = json["username"],
        email = json["email"],
        id = json["id"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'accessToken': accessToken,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return '$UserModel{id: $id, username: $username, email: $email}';
  }
}
