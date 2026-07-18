import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goroute_mobile/core/auth/session_store.dart';
import 'package:goroute_mobile/core/config/app_config.dart';
import 'package:goroute_mobile/core/network/api_client.dart';
import 'package:goroute_mobile/features/settings/settings_repository.dart';

void main() {
  late Dio dio;
  late SettingsRepository repo;

  setUp(() {
    dio = Dio();
    repo = SettingsRepository(
      client: ApiClient(
        config: AppConfig.localhost,
        sessionStore: SessionStore(kv: MemorySecureKv()),
        dio: dio,
      ),
    );
  });

  test('fetchProfile maps fullName and headline', () async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.path, contains('/settings/profile'));
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'profile': {
                  'fullName': 'Ada Lovelace',
                  'headline': 'Engineer',
                  'bio': 'Math',
                },
                'skills': <dynamic>[],
              },
            ),
          );
        },
      ),
    );
    final p = await repo.fetchProfile();
    expect(p.fullName, 'Ada Lovelace');
    expect(p.headline, 'Engineer');
  });

  test('eraseAccount sends confirm DELETE', () async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.method, 'DELETE');
          expect(options.path, contains('/settings/privacy/account'));
          expect(options.data['confirm'], 'DELETE');
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {'ok': true},
            ),
          );
        },
      ),
    );
    await repo.eraseAccount();
  });

  test('updateMentorMode sends lgpdConsent for managed', () async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.path, contains('/settings/ai'));
          expect(options.data['mentorMode'], 'managed');
          expect(options.data['lgpdConsent'], isTrue);
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {'mentorMode': 'managed'},
            ),
          );
        },
      ),
    );
    await repo.updateMentorMode('managed', lgpdConsent: true);
  });
}
