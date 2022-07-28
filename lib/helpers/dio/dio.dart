import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = Dio();
  //   axios.defaults.headers.post["Content-Type"] = "application/json";
  // axios.defaults.headers.post["Accept"] = "application/json";
  // axios.defaults.withCredentials = true;
  dio.options.baseUrl = "http://moeen-api.herokuapp.com";
  dio.options.headers["Accept"] = "application/json";
  dio.options.headers["Content-Type"] = "application/json";

  return dio;
}
