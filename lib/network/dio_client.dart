import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'auth.dart';

class DioClient {

  final Dio dio;

  DioClient({Dio? customDio}) : dio = customDio ?? Dio();
  static final DioClient _instance = DioClient._internal();

  final CookieJar cookieJar = CookieJar();

  DioClient._internal()
      : dio = Dio(BaseOptions(
          baseUrl: "http://10.0.2.2:3000/api",
          contentType: "application/json",
          connectTimeout: Duration(seconds: 10),
          receiveTimeout: Duration(seconds: 10),
          headers: {
            "Cache-Control": "no-cache", // Prevents caching of responses
            "Pragma": "no-cache",
            "Authorization": accessToken
          },
        )) {
    dio.interceptors.add(CookieManager(cookieJar));
    dio.options.extra["withCredentials"] = true;
  }
}

var dioClient = DioClient();
  