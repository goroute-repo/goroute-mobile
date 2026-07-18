import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goroute_mobile/core/auth/session_store.dart';
import 'package:goroute_mobile/core/config/app_config.dart';
import 'package:goroute_mobile/core/network/api_client.dart';
import 'package:goroute_mobile/features/roadmap/roadmap_repository.dart';

void main() {
  late Dio dio;
  late RoadmapRepository repo;

  setUp(() {
    dio = Dio();
    final client = ApiClient(
      config: AppConfig.localhost,
      sessionStore: SessionStore(kv: MemorySecureKv()),
      dio: dio,
    );
    repo = RoadmapRepository(client: client);
  });

  test('startNode posts to /roadmap/nodes/:slug/start', () async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.method, 'POST');
          expect(options.path, contains('/roadmap/nodes/react/start'));
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'id': '1',
                'label': 'React',
                'slug': 'react',
                'state': 'in_progress',
                'prerequisites': <dynamic>[],
              },
            ),
          );
        },
      ),
    );

    final detail = await repo.startNode('react');
    expect(detail.state, 'in_progress');
    expect(detail.canComplete, isTrue);
  });

  test('completeNode posts to /roadmap/nodes/:slug/complete', () async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.path, contains('/roadmap/nodes/react/complete'));
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'id': '1',
                'label': 'React',
                'slug': 'react',
                'state': 'completed',
                'prerequisites': <dynamic>[],
              },
            ),
          );
        },
      ),
    );

    final detail = await repo.completeNode('react');
    expect(detail.state, 'completed');
    expect(detail.canStart, isFalse);
  });
}
