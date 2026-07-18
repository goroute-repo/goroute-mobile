import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goroute_mobile/core/auth/session_store.dart';
import 'package:goroute_mobile/core/config/app_config.dart';
import 'package:goroute_mobile/core/network/api_client.dart';
import 'package:goroute_mobile/features/auth/auth_repository.dart';

void main() {
  late Dio dio;
  late SessionStore store;
  late AuthRepository repo;

  setUp(() {
    dio = Dio();
    store = SessionStore(kv: MemorySecureKv());
    final client = ApiClient(
      config: AppConfig.localhost,
      sessionStore: store,
      dio: dio,
    );
    repo = AuthRepository(client: client, sessionStore: store);
  });

  test('login with mfaRequired returns tempToken (no web-only block)', () async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.path, contains('/users/login'));
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'mfaRequired': true,
                'tempToken': 'temp-abc',
                'role': 'professional',
                'onboardingCompleted': true,
              },
            ),
          );
        },
      ),
    );

    final result = await repo.loginProfessional(
      email: 'pro@example.com',
      password: 'Secret123!',
    );

    expect(result.mfaRequired, isTrue);
    expect(result.tempToken, 'temp-abc');
    expect(await store.hasSession, isFalse);
  });

  test('verifyMfa persists sessionId and mapApiHash from body', () async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.path, contains('/users/mfa/verify'));
          expect(options.data, {
            'tempToken': 'temp-abc',
            'code': '123456',
          });
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'ok': true,
                'sessionId': 'sess-mfa',
                'mapApiHash': 'map-mfa',
                'role': 'professional',
                'onboardingCompleted': true,
              },
            ),
          );
        },
      ),
    );

    final result = await repo.verifyMfa(tempToken: 'temp-abc', code: '123456');

    expect(result.mfaRequired, isFalse);
    expect(await store.readSessionId(), 'sess-mfa');
    expect(await store.readMapperApi(), 'map-mfa');
  });
}
