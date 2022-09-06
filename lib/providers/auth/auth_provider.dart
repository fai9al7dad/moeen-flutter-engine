import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:moeen/helpers/dio/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuth = false;

  bool _checkingAuth = false;
  late UserModel? _authUser;
  bool get isAuth {
    return _isAuth;
  }

  UserModel? get authUser {
    return _authUser;
  }

  bool get checkingAuth {
    return _checkingAuth;
  }

  void login({required creds}) async {
    final prefs = await SharedPreferences.getInstance();

    _isAuth = true;
    UserModel user = UserModel.fromJson(creds);
    _authUser = user;
    prefs.setString("accessToken", user.accessToken ?? "");
    notifyListeners();
  }

  void tryToken() async {
    try {
      _checkingAuth = true;
      Api api = Api();
      try {
        var user = await api.getAuthUser();
        if (user == null) {
          _checkingAuth = false;
          return;
        }
        _isAuth = true;
        _authUser = user;
        _checkingAuth = false;

        notifyListeners();
      } on DioError catch (e) {
        if (e.response?.data["statusCode"] == 401) {
          print("logged out");
          logout();
        }
        _checkingAuth = false;
      }

      notifyListeners();
    } catch (e) {
      _checkingAuth = false;
    }
    // dio().options.headers["Authorization"] = user.accessToken;
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();

    _isAuth = false;
    _authUser = null;
    prefs.remove("accessToken");
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
        id = json["userID"] ?? json["id"];

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
