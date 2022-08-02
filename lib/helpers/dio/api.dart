import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moeen/helpers/models/duos_model.dart';
import 'package:moeen/helpers/models/highlights_model.dart';
import 'package:moeen/helpers/models/werds_model.dart';
import 'package:moeen/providers/auth/auth_provider.dart';

class Api {
  static Dio api = Dio();
  final storage = const FlutterSecureStorage();

  Api() {
    api.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      options.baseUrl = "http://moeen-api.herokuapp.com";
      options.headers["Accept"] = "application/json";
      options.headers["Content-Type"] = "application/json";
      var token = await storage.read(key: "accessToken");

      options.headers["Authorization"] = "Bearer $token";
      options.extra['withCredentials'] = true;
      return handler.next(options);
    }));
  }

  // auth
  Future register({data}) async {
    try {
      Response res = await api.post("/api/auth/register", data: data);
      return res;
    } on DioError {
      rethrow;
    }
  }

  Future login({data}) async {
    try {
      Response res = await api.post("/api/auth/login", data: data);
      return res;
    } on DioError {
      rethrow;
    }
  }

  Future<UserModel?> getAuthUser() async {
    Response res = await api.get(
      "/api/users/me",
    );
    UserModel user = UserModel.fromJson(res.data);
    return user;
  }

  // duos
  Future<List<DuosModel>> getDuos() async {
    try {
      Response res = await api.get(
        "/api/duo/all-duos",
      );
      List data = res.data;
      List<DuosModel> list = [];

      for (var i = 0; i < data.length; i++) {
        DuosModel duo = DuosModel.fromJson(res.data[i]);
        list.add(duo);
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  Future<List<DuoInviteModel>> getDuosInvites() async {
    try {
      Response res = await api.get(
        "/api/duo/view-invites",
      );
      List data = res.data;
      List<DuoInviteModel> list = [];

      for (var i = 0; i < data.length; i++) {
        DuoInviteModel duo = DuoInviteModel.fromJson(res.data[i]);
        list.add(duo);
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  Future acceptOrRejectInvite({fromUserID, type}) async {
    Map payload = {"fromUserID": fromUserID};
    try {
      Response res = await api.post("/api/duo/$type-invite", data: payload);
      return res;
    } on DioError {
      rethrow;
    }
  }

  Future searchUsers({query}) async {
    Map payload = {"query": query};
    try {
      Response res = await api.post("/api/users/search", data: payload);
      List data = res.data["result"];
      List<SearchUserModel> list = [];
      for (var i = 0; i < data.length; i++) {
        SearchUserModel duo = SearchUserModel.fromJson(data[i]);
        list.add(duo);
      }
      return list;
    } on DioError {
      return null;
    }
  }

  Future sendInvite({toUserID}) async {
    Map payload = {"toUserID": toUserID};
    try {
      Response res = await api.post("/api/duo/send-invite", data: payload);
      return res;
    } on DioError {
      rethrow;
    }
  }

  // werds

  Future<List<WerdsModel>> getWerds({duoID}) async {
    try {
      Response res = await api.get(
        "/api/werd/duo-id/$duoID",
      );
      List data = res.data;
      List<WerdsModel> list = [];

      for (var i = 0; i < data.length; i++) {
        WerdsModel duo = WerdsModel.fromJson(res.data[i]);
        list.add(duo);
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  Future addWerd({duoID, reciterID}) async {
    Map payload = {"duoID": duoID.toString(), "reciterID": reciterID};
    try {
      Response res = await api.post("/api/werd/add", data: payload);
      return res.data;
    } on DioError {
      rethrow;
    }
  }

  // highlights
  Future<List<HighlightsModel>> getHighlightsByUserID({userID}) async {
    try {
      Response res = await api.get(
        "/api/highlight/user-id/$userID",
      );
      List data = res.data;
      List<HighlightsModel> list = [];

      for (var i = 0; i < data.length; i++) {
        HighlightsModel duo = HighlightsModel.fromJson(res.data[i]);
        list.add(duo);
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  Future addHighlightByWerdID({werdID, reciterUserID, type, wordID}) async {
    Map payload = {
      "werdID": werdID.toString(),
      "reciterID": reciterUserID,
      "type": type,
      "wordID": wordID
    };
    try {
      Response res = await api.post("/api/highlight/add", data: payload);
      return res.data;
    } on DioError {
      rethrow;
    }
  }
}
