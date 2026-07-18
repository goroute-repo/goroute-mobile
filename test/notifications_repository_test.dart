import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goroute_mobile/core/auth/session_store.dart';
import 'package:goroute_mobile/core/config/app_config.dart';
import 'package:goroute_mobile/core/network/api_client.dart';
import 'package:goroute_mobile/features/notifications/notifications_repository.dart';

void main() {
  late Dio dio;
  late NotificationsRepository repo;

  setUp(() {
    dio = Dio();
    repo = NotificationsRepository(
      client: ApiClient(
        config: AppConfig.localhost,
        sessionStore: SessionStore(kv: MemorySecureKv()),
        dio: dio,
      ),
    );
  });

  test('fetchAll maps unreadCount and items', () async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.path, contains('/notifications'));
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'unreadCount': 1,
                'items': [
                  {
                    'id': 'n1',
                    'kind': 'info',
                    'title': 'Hello',
                    'body': 'Body',
                    'read': false,
                    'createdAt': '2026-07-18T00:00:00.000Z',
                  },
                ],
              },
            ),
          );
        },
      ),
    );
    final list = await repo.fetchAll();
    expect(list.unreadCount, 1);
    expect(list.items.first.title, 'Hello');
  });

  test('markRead patches /:id/read', () async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.method, 'PATCH');
          expect(options.path, contains('/notifications/n1/read'));
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
    await repo.markRead('n1');
  });
}
