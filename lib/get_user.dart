import 'package:first_app/network/users.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/network/dio_client.dart';
import 'package:first_app/network/auth.dart';

void printuserprofile() async {
  UserProfile? userFuture = await getUserProfile();
  print(userFuture?.role);
}