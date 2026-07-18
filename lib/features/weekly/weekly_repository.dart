import 'package:dio/dio.dart';
import 'package:goroute_mobile/core/cache/json_read_cache.dart';
import 'package:goroute_mobile/core/network/api_client.dart';
import 'package:goroute_mobile/core/network/api_exception.dart';
import 'package:goroute_mobile/features/weekly/weekly_models.dart';

class WeeklyPlanRepository {
  WeeklyPlanRepository({
    required ApiClient client,
    JsonReadCache? cache,
  })  : _client = client,
        _cache = cache;

  final ApiClient _client;
  final JsonReadCache? _cache;

  Future<WeeklyPlan> fetchCurrent() async {
    try {
      final res = await _client.raw.get<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/weekly-plan',
      );
      final data = res.data ?? <String, dynamic>{};
      await _cache?.write(JsonReadCache.weeklyPlanKey, data);
      return WeeklyPlan.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw mapDioToApiException(e, 'Failed to load weekly plan');
      }
      final cached = _cache?.read(JsonReadCache.weeklyPlanKey);
      if (cached != null) {
        return WeeklyPlan.fromJson(cached);
      }
      throw mapDioToApiException(e, 'Failed to load weekly plan');
    }
  }

  Future<WeeklyPlan> completeTask(String taskId) async {
    try {
      final res = await _client.raw.post<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/weekly-plan/tasks/${Uri.encodeComponent(taskId)}/complete',
        data: <String, dynamic>{},
      );
      final data = res.data ?? <String, dynamic>{};
      await _cache?.write(JsonReadCache.weeklyPlanKey, data);
      return WeeklyPlan.fromJson(data);
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to complete task');
    }
  }

  Future<WeeklyPlan> skipWeek() async {
    try {
      final res = await _client.raw.post<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/weekly-plan/skip',
        data: <String, dynamic>{},
      );
      final data = res.data ?? <String, dynamic>{};
      await _cache?.write(JsonReadCache.weeklyPlanKey, data);
      return WeeklyPlan.fromJson(data);
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to skip week');
    }
  }

  Future<WeeklyPlan> recalculate() async {
    try {
      final res = await _client.raw.post<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/weekly-plan/recalculate',
        data: <String, dynamic>{},
      );
      final data = res.data ?? <String, dynamic>{};
      await _cache?.write(JsonReadCache.weeklyPlanKey, data);
      return WeeklyPlan.fromJson(data);
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to recalculate week');
    }
  }
}
