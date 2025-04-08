import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'package:first_app/network/dio_client.dart';
import 'package:first_app/network/auth.dart';
import 'auth_network_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dioClient = DioClient(customDio: mockDio);
  });

  group('loginUser & handleAccessToken Tests', () {
    test('T2.1.1 - loginUser with valid credentials and success response', () async {
      final fakeResponse = {
        "success": true,
        "data": {
          "accessToken": "abc123"
        }
      };

      when(mockDio.post("/auth/login", data: anyNamed("data"))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/login'),
          data: fakeResponse,
        ),
      );

      await loginUser("test@email.com", "password123");

      expect(accessToken, equals("abc123"));
    });

    test('T2.1.2 - loginUser with failure response', () async {
      when(mockDio.post("/auth/login", data: anyNamed("data"))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/login'),
          data: {"success": false},
        ),
      );

      await loginUser("test@email.com", "wrongpass");
      expect(accessToken, isNull); // should not update
    });

    test('T2.1.3 - loginUser with exception from dio', () async {
      when(mockDio.post("/auth/login", data: anyNamed("data"))).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/auth/login')),
      );

      await loginUser("email", "pass");
      expect(accessToken, isNull);
    });

    test('T2.1.4 - handleAccessToken with new token', () {
      accessToken = "oldToken";
      handleAccessToken("newToken");

      expect(accessToken, equals("newToken"));
    });

    test('T2.1.5 - handleAccessToken with null token', () {
      accessToken = null;
      handleAccessToken(null);
      expect(accessToken, isNull);
    });

    test('T2.1.6 - handleAccessToken with same token', () {
      accessToken = "sameToken";
      handleAccessToken("sameToken");
      expect(accessToken, equals("sameToken")); // no change, but still valid
    });
  });
}
