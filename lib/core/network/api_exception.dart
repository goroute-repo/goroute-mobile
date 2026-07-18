import 'package:dio/dio.dart';

/// Typed API failure with optional BFF `code` (SPEC-18).
class ApiException implements Exception {
  ApiException(this.message, {this.code, this.statusCode});

  final String message;
  final String? code;
  final int? statusCode;

  bool get isPremiumRequired => code == 'PREMIUM_REQUIRED';

  bool get isNotEligible => code == 'JOB_APPLY_NOT_ELIGIBLE';

  bool get isUnauthorized =>
      statusCode == 401 || code == 'UNAUTHORIZED' || looksLikeSessionError(message);

  @override
  String toString() => message;
}

bool looksLikeSessionError(String? text) {
  if (text == null || text.isEmpty) return false;
  final t = text.toLowerCase();
  return t.contains('invalid or missing session') ||
      t.contains('missing x-mapper-api') ||
      t.contains('invalid mapper') ||
      t.contains('mapper hash does not match') ||
      t.contains('mobile session');
}

String? _messageFromBody(dynamic data) {
  if (data is Map) {
    final raw = data['message'];
    if (raw is String && raw.isNotEmpty) return raw;
    if (raw is List && raw.isNotEmpty) {
      return raw.map((e) => e.toString()).join(', ');
    }
    final code = data['code']?.toString();
    if (code != null && code.isNotEmpty) return code;
  }
  return null;
}

ApiException mapDioToApiException(DioException e, String fallback) {
  final status = e.response?.statusCode;
  final data = e.response?.data;
  final message = _messageFromBody(data);
  if (data is Map) {
    final code = data['code']?.toString();
    if (status == 401) {
      return ApiException(
        message ?? 'Invalid or missing session',
        code: code ?? 'UNAUTHORIZED',
        statusCode: 401,
      );
    }
    if (code != null && code.isNotEmpty) {
      return ApiException(
        message ?? code,
        code: code,
        statusCode: status,
      );
    }
    if (message != null && message.isNotEmpty) {
      return ApiException(message, statusCode: status);
    }
  }
  if (status == 401) {
    return ApiException(
      message ?? 'Invalid or missing session',
      code: 'UNAUTHORIZED',
      statusCode: 401,
    );
  }
  if (status == 403) {
    return ApiException(
      e.message ?? fallback,
      code: 'PREMIUM_REQUIRED',
      statusCode: 403,
    );
  }
  return ApiException(e.message ?? fallback, statusCode: status);
}
