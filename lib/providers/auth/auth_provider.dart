import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:moeen/helpers/dio/dio.dart';

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
    dio().options.headers["Authorization"] = "Bearer ${user.accessToken}";
    await storage.write(key: "accessToken", value: user.accessToken);

    notifyListeners();
  }

  void tryToken() async {
    var token = await storage.read(key: "accessToken");
    if (token == null) return;
    try {
      Dio.Response res = await dio().get("/api/users/me",
          options: Dio.Options(headers: {"Authorization": "Bearer $token"}));
      _isAuth = true;
      UserModel user = UserModel.fromJson(res.data);
      _authUser = user;
      // await storage.write(key: "accessToken", value: token);
      notifyListeners();
    } catch (e) {
      logout();
    }
    // dio().options.headers["Authorization"] = user.accessToken;
  }

  void logout() {
    _isAuth = false;
    _authUser = null;
    dio().options.headers["Authorization"] = "";
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
        id = json["userID"];

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
