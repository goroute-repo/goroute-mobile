import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:goroute_mobile/core/network/api_client.dart';
import 'package:goroute_mobile/core/network/api_exception.dart';
import 'package:goroute_mobile/features/settings/settings_models.dart';

class SettingsRepository {
  SettingsRepository({required ApiClient client}) : _client = client;

  final ApiClient _client;

  Future<UserProfile> fetchProfile() async {
    try {
      final res = await _client.raw.get<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/settings/profile',
      );
      return UserProfile.fromSettingsJson(res.data ?? {});
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to load profile');
    }
  }

  Future<void> updateProfile({required String headline, String? bio}) async {
    try {
      await _client.raw.patch<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/settings/profile',
        data: {
          'headline': headline,
          if (bio != null) 'bio': bio,
        },
      );
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to save profile');
    }
  }

  Future<AiSettings> fetchAi() async {
    try {
      final res = await _client.raw.get<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/settings/ai',
      );
      return AiSettings.fromJson(res.data ?? {});
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to load AI settings');
    }
  }

  Future<void> updateMentorMode(String mentorMode, {bool lgpdConsent = false}) async {
    try {
      await _client.raw.patch<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/settings/ai',
        data: {
          'mentorMode': mentorMode,
          if (mentorMode == 'managed' || mentorMode == 'byok')
            'lgpdConsent': lgpdConsent,
        },
      );
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to save AI settings');
    }
  }

  Future<String> exportPrivacyJson() async {
    try {
      final res = await _client.raw.get<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/settings/privacy/export',
      );
      return const JsonEncoder.withIndent('  ').convert(res.data ?? {});
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to export privacy data');
    }
  }

  Future<void> eraseAccount() async {
    try {
      await _client.raw.delete<Map<String, dynamic>>(
        '${_client.apiBaseUrl}/settings/privacy/account',
        data: {'confirm': 'DELETE'},
      );
    } on DioException catch (e) {
      throw mapDioToApiException(e, 'Failed to erase account');
    }
  }
}
