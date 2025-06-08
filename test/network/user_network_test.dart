import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'package:app_mobile_frontend/network/dio_client.dart';
import 'package:app_mobile_frontend/network/users_services.dart';
import 'package:app_mobile_frontend/models/user.dart';

import 'user_network_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dioClient = DioClient(customDio: mockDio);
  });

  group('User API Tests', () {
    test('T2.2.1 - updateUserProfile success', () async {
      final dto = UpdateUserProfileDTO(firstName: "Alice");

      when(mockDio.put(any, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: ''), data: {"success": true}),
      );

      await updateUserProfile(1, dto);
    });

    test('T2.2.2 - updateUserProfile failure', () async {
      final dto = UpdateUserProfileDTO(firstName: "Alice");

      when(mockDio.put(any, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: ''), data: {"success": false}),
      );

      await updateUserProfile(1, dto);
    });

    test('T2.2.3 - updateUserProfile error', () async {
      when(mockDio.put(any, data: anyNamed('data'), options: anyNamed('options'))).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );

      await updateUserProfile(1, UpdateUserProfileDTO());
    });

    test('T2.2.4 - createUser success', () async {
      final dto = CreateUserDTO(
        firstName: "Test",
        lastName: "User",
        email: "test@example.com",
        password: "pass",
        role: "admin",
      );

      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: ''), data: {"success": true}),
      );

      await createUser(dto);
    });

    test('T2.2.5 - createUser failure', () async {
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: ''), data: {"success": false}),
      );

      await createUser(CreateUserDTO(
        firstName: "",
        lastName: "",
        email: "",
        password: "",
        role: "user",
      ));
    });

    test('T2.2.6 - createUser exception', () async {
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options'))).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );

      await createUser(CreateUserDTO(
        firstName: "",
        lastName: "",
        email: "",
        password: "",
        role: "user",
      ));
    });

    test('T2.2.7 - getAllUsers success', () async {
      final usersJson = [
        {
          "id": 1,
          "firstName": "A",
          "lastName": "B",
          "email": "a@b.com",
          "phoneNo": "123456789",
          "role": "user",
          "createdAt": DateTime.now().toIso8601String(),
          "updatedAt": DateTime.now().toIso8601String(),
        }
      ];

      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: ''), data: {"success": true, "data": usersJson}),
      );

      await getAllUsers();
    });

    test('T2.2.8 - getAllUsers failure', () async {
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: ''), data: {"success": false}),
      );

      await getAllUsers();
    });

    test('T2.2.9 - getAllUsers exception', () async {
      when(mockDio.get(any, options: anyNamed('options'))).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );

      await getAllUsers();
    });

    test('T2.2.10 - getUserById success', () async {
      final userJson = {
        "id": 1,
        "firstName": "John",
        "lastName": "Doe",
        "email": "john@example.com",
        "phoneNo": "123456789",
        "role": "admin",
        "createdAt": DateTime.now().toIso8601String(),
        "updatedAt": DateTime.now().toIso8601String(),
      };

      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: ''), data: {"success": true, "data": userJson}),
      );

      await getUserById(1);
    });

    test('T2.2.11 - getUserById failure', () async {
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: ''), data: {"success": false}),
      );

      await getUserById(1);
    });

    test('T2.2.12 - getUserById exception', () async {
      when(mockDio.get(any, options: anyNamed('options'))).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );

      await getUserById(1);
    });

    test('T2.2.13 - updateUserRole success', () async {
      when(mockDio.put(any, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: ''), data: {"success": true}),
      );

      await updateUserRole(1, "user", "admin");
    });

    test('T2.2.14 - updateUserRole failure', () async {
      when(mockDio.put(any, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: ''), data: {"success": false}),
      );

      await updateUserRole(1, "user", "admin");
    });

    test('T2.2.15 - updateUserRole exception', () async {
      when(mockDio.put(any, data: anyNamed('data'), options: anyNamed('options'))).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );

      await updateUserRole(1, "user", "admin");
    });

    test('T2.2.16 - deleteUser success', () async {
      when(mockDio.delete(any, options: anyNamed('options'))).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: ''), data: {"success": true}),
      );

      await deleteUser(1);
    });

    test('T2.2.17 - deleteUser failure', () async {
      when(mockDio.delete(any, options: anyNamed('options'))).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: ''), data: {"success": false}),
      );

      await deleteUser(1);
    });

    test('T2.2.18 - deleteUser exception', () async {
      when(mockDio.delete(any, options: anyNamed('options'))).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );

      await deleteUser(1);
    });
  });
}
