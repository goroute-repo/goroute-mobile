import 'package:dio/dio.dart';
import 'package:goroute_mobile/core/cache/json_read_cache.dart';
import 'package:goroute_mobile/core/network/api_client.dart';
import 'package:goroute_mobile/core/network/api_exception.dart';

import 'roadmap_models.dart';

export 'roadmap_models.dart';

class RoadmapRepository {
  RoadmapRepository({
    required ApiClient client,
    JsonReadCache? cache,
  })  : _client = client,
        _cache = cache;

  final ApiClient _client;
  final JsonReadCache? _cache;

  Future<RoadmapSnapshot> fetchMe() async {
    try {
      final res = await _client.raw.get<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/roadmap/me',
      );
      final data = res.data ?? <String, dynamic>{};
      await _cache?.write(JsonReadCache.roadmapMeKey, data);
      return RoadmapSnapshot.fromJson(data);
    } on DioException catch (e) {
      // Never mask auth failures with stale cache.
      if (e.response?.statusCode == 401) {
        throw mapDioToApiException(e, 'Failed to load roadmap');
      }
      final cached = _cache?.read(JsonReadCache.roadmapMeKey);
      if (cached != null) {
        return RoadmapSnapshot.fromJson(cached);
      }
      throw mapDioToApiException(e, 'Failed to load roadmap');
    }
  }

  Future<RoadmapNodeDetail> fetchNode(String slug) async {
    try {
      final res = await _client.raw.get<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/roadmap/nodes/${Uri.encodeComponent(slug)}',
      );
      return RoadmapNodeDetail.fromJson(res.data ?? {});
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to load node');
    }
  }

  Future<RoadmapNodeDetail> startNode(String slug) async {
    try {
      final res = await _client.raw.post<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/roadmap/nodes/${Uri.encodeComponent(slug)}/start',
        data: <String, dynamic>{},
      );
      return RoadmapNodeDetail.fromJson(res.data ?? {});
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to start node');
    }
  }

  Future<RoadmapNodeDetail> completeNode(String slug) async {
    try {
      final res = await _client.raw.post<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/roadmap/nodes/${Uri.encodeComponent(slug)}/complete',
        data: <String, dynamic>{},
      );
      return RoadmapNodeDetail.fromJson(res.data ?? {});
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to complete node');
    }
  }
}
