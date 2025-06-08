import "package:app_mobile_frontend/api/dio_client.dart";
import "package:app_mobile_frontend/core/models/user.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";


String? accessToken;
final FlutterSecureStorage _secureStorage = FlutterSecureStorage();


Future<void> saveToken(String token) async {
  await _secureStorage.write(key: 'accessToken', value: token);
}

Future<String?> getToken() async {
  String? token = await _secureStorage.read(key: "accessToken");
  if (token != null) {
    print("Token retrieved: $token");
    return token;
  }
  print("No token found.");
  return null;
}

Future<bool> loginUser(String email, String password) async {
  try {
    final response = await dioClient.dio.post(
      "/auth/login",
      data: {"email": email, "password": password},
    );
    if (response.data["success"]) {
      print("access Token: ${response.data["data"]?["accessToken"]}");
      final String token = response.data["data"]?["accessToken"];
      saveToken(token);
      return true;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

void handleAccessToken(String? newAccessToken) async {
  if (newAccessToken != null) {
    accessToken = newAccessToken;
    print("Login successful! Access Token stored.");
  } else {
    print("Error: Access Token not found in response.");
  }
}

Future<void> refreshToken() async {
  try {
    //await checkCookies();
    final response = await dioClient.dio.post("/auth/refresh-token");

    if (response.data["success"]) {
      final String newAccessToken = response.data["data"]?["accessToken"];
      handleAccessToken(newAccessToken);
    } else {
      print("Refresh token failed: ${response.data}");
    }
  } catch (error) {
    print("Refresh token error: $error");
  }
}

Future<bool> registerUser(RegisterUserDTO data) async {
  try {
    final response = await dioClient.dio.post("/auth/register", data: data.toJson());
    if (response.data["success"]) {
      return true;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

Future<bool> logoutUser() async {
  try {
    clearToken();
    final response = await dioClient.dio.post("/auth/logout");
    if (response.data["success"]) {
      return true;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

Future<void> clearToken() async {
  await _secureStorage.delete(key: 'accessToken');
  print("Deleted Token: ${getToken()}");
  print("Token cleared");
}
