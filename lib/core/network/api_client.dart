import 'package:dio/dio.dart';

import '../auth/session_store.dart';
import '../config/app_config.dart';

/// Dio client with SPEC-01 headers: X-Application-From, x-mapper-api, x-session-id.
class ApiClient {
  ApiClient({
    required AppConfig config,
    required SessionStore sessionStore,
    Dio? dio,
    void Function()? onUnauthorized,
  })  : _config = config,
        _sessionStore = sessionStore,
        _dio = dio ?? Dio(),
        _onUnauthorized = onUnauthorized {
    _dio.options
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 20)
      ..headers['X-Application-From'] = _config.applicationFrom
      ..headers['Accept'] = 'application/json';
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final sessionId = await _sessionStore.readSessionId();
          final mapper = await _sessionStore.readMapperApi();
          if (sessionId != null && sessionId.isNotEmpty) {
            options.headers['x-session-id'] = sessionId;
          }
          if (mapper != null && mapper.isNotEmpty) {
            options.headers['x-mapper-api'] = mapper;
          }
          // Always stamp application for BFF/auth consistency.
          options.headers['X-Application-From'] = _config.applicationFrom;
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _sessionStore.clear();
            _onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );
  }

  final AppConfig _config;
  final SessionStore _sessionStore;
  final Dio _dio;
  final void Function()? _onUnauthorized;

  Dio get raw => _dio;

  String get authBaseUrl => _config.authBaseUrl;
  String get apiBaseUrl => _config.apiBaseUrl;
  String get applicationFrom => _config.applicationFrom;
}
