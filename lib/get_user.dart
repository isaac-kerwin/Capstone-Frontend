import 'package:app_mobile_frontend/network/users.dart';
import 'package:app_mobile_frontend/models/user.dart';
import 'package:app_mobile_frontend/network/dio_client.dart';
import 'package:app_mobile_frontend/network/auth.dart';

void printuserprofile() async {
  UserProfile? userFuture = await getUserProfile();
  print(userFuture?.role);
}