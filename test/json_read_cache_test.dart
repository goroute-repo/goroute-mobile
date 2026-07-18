import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goroute_mobile/core/auth/session_store.dart';
import 'package:goroute_mobile/core/cache/json_read_cache.dart';
import 'package:goroute_mobile/core/config/app_config.dart';
import 'package:goroute_mobile/core/network/api_client.dart';
import 'package:goroute_mobile/features/roadmap/roadmap_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('fetchMe falls back to read cache on network failure', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final cache = JsonReadCache(prefs);
    await cache.write(JsonReadCache.roadmapMeKey, {
      'nodes': [
        {'id': 'a', 'label': 'Cached', 'slug': 'a', 'state': 'available'},
      ],
      'timeMachine': {'percentDone': 25, 'weeksToGoal': 8},
      'targetRoleLabel': 'Cached Role',
    });

    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
              error: 'offline',
            ),
          );
        },
      ),
    );

    final repo = RoadmapRepository(
      client: ApiClient(
        config: AppConfig.localhost,
        sessionStore: SessionStore(kv: MemorySecureKv()),
        dio: dio,
      ),
      cache: cache,
    );

    final snap = await repo.fetchMe();
    expect(snap.targetRoleLabel, 'Cached Role');
    expect(snap.percentDone, 25);
    expect(snap.nodes.first.label, 'Cached');
  });
}
