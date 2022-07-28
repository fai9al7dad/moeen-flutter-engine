import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moeen/helpers/models/duos_model.dart';
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
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future login({data}) async {
    try {
      Response res = await api.post("/api/auth/login", data: data);
      return res;
    } on DioError catch (e) {
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
    } on DioError catch (e) {
      rethrow;
    }
  }
}
