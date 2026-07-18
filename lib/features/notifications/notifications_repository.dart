import 'package:dio/dio.dart';
import 'package:goroute_mobile/core/network/api_client.dart';
import 'package:goroute_mobile/core/network/api_exception.dart';
import 'package:goroute_mobile/features/notifications/notifications_models.dart';

class NotificationsRepository {
  NotificationsRepository({required ApiClient client}) : _client = client;

  final ApiClient _client;

  Future<NotificationsList> fetchAll() async {
    try {
      final res = await _client.raw.get<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/notifications',
      );
      return NotificationsList.fromJson(res.data ?? {});
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to load notifications');
    }
  }

  Future<void> markRead(String id) async {
    try {
      await _client.raw.patch<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/notifications/${Uri.encodeComponent(id)}/read',
        data: <String, dynamic>{},
      );
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to mark read');
    }
  }

  Future<void> markAllRead() async {
    try {
      await _client.raw.patch<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/notifications/read-all',
      );
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to mark all read');
    }
  }
}
