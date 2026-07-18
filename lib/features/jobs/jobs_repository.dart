import 'package:dio/dio.dart';
import 'package:goroute_mobile/core/network/api_client.dart';
import 'package:goroute_mobile/core/network/api_exception.dart';
import 'package:goroute_mobile/features/jobs/jobs_models.dart';

class JobsRepository {
  JobsRepository({required ApiClient client}) : _client = client;

  final ApiClient _client;

  Future<List<JobMatch>> fetchMatches({bool eligibleOnly = false}) async {
    try {
      final res = await _client.raw.get<List<dynamic>>(
        '${_client.apiBaseUrl}/jobs/match',
        queryParameters: eligibleOnly ? {'eligibleOnly': 'true'} : null,
      );
      final data = res.data ?? const [];
      return data
          .whereType<Map>()
          .map((e) => JobMatch.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to load job matches');
    }
  }

  Future<JobDetail> fetchJob(String jobId) async {
    try {
      final res = await _client.raw.get<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/jobs/${Uri.encodeComponent(jobId)}',
      );
      return JobDetail.fromJson(res.data ?? {});
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to load job');
    }
  }

  Future<JobApplyResult> apply(String jobId) async {
    try {
      final res = await _client.raw.post<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/jobs/${Uri.encodeComponent(jobId)}/apply',
        data: <String, dynamic>{},
      );
      return JobApplyResult.fromJson(res.data ?? {});
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to apply');
    }
  }

  Future<JobMatchNarrative> fetchNarrative(String jobId) async {
    try {
      final res = await _client.raw.get<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/jobs/${Uri.encodeComponent(jobId)}/match-narrative',
      );
      return JobMatchNarrative.fromJson(res.data ?? {});
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to load match narrative');
    }
  }
}
