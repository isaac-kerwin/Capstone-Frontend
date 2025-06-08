import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'auth_services.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  final Dio dio;
  final CookieJar cookieJar = CookieJar();

  DioClient._internal()
      : dio = Dio(BaseOptions(
          baseUrl: "http://145.223.23.210:3000/api", 
          contentType: "application/json",
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            "Cache-Control": "no-cache", // Prevents caching of responses
            "Pragma": "no-cache",
          },
        )) {
    // keep cookies
    dio.interceptors.add(CookieManager(cookieJar));

    // inject Bearer header on every request if we have one
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer ${getToken()}';
        }
        return handler.next(options);
      },
    ));
  }
}

final dioClient = DioClient();


// import 'package:dio/dio.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:cookie_jar/cookie_jar.dart';
// import 'auth.dart';

// class DioClient {
//   static final DioClient _instance = DioClient._internal();
//   factory DioClient() => _instance;

//   final Dio dio;
//   final CookieJar cookieJar = CookieJar();

//   DioClient._internal()
//       : dio = Dio(BaseOptions(
//           baseUrl: "http://10.0.2.2:3000/api",
//           contentType: "application/json",
//           connectTimeout: Duration(seconds: 10),
//           receiveTimeout: Duration(seconds: 10),
//           headers: {
//             "Cache-Control": "no-cache", // Prevents caching of responses
//             "Pragma": "no-cache",
//             "Authorization": accessToken
//           },
//         )) {
//     dio.interceptors.add(CookieManager(cookieJar));
//     dio.options.extra["withCredentials"] = true;
//   }
// }

// final dioClient = DioClient();

/* 
Enable when testing using mockito 
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
   */

