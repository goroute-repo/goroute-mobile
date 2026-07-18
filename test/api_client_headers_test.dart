import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goroute_mobile/core/auth/session_store.dart';
import 'package:goroute_mobile/core/config/app_config.dart';
import 'package:goroute_mobile/core/network/api_client.dart';

class _CaptureAdapter implements HttpClientAdapter {
  Map<String, dynamic>? lastHeaders;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastHeaders = options.headers;
    return ResponseBody.fromString('{}', 200, headers: {
      Headers.contentTypeHeader: ['application/json'],
    });
  }
}

void main() {
  test('ApiClient injects x-session-id and x-mapper-api (RF-151)', () async {
    final store = SessionStore(kv: MemorySecureKv());
    await store.saveSession(sessionId: 'sid', mapperApi: 'mapper');
    final adapter = _CaptureAdapter();
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ApiClient(
      config: AppConfig.localhost,
      sessionStore: store,
      dio: dio,
    );

    await client.raw.get('http://example.test/api/roadmap/me');

    expect(adapter.lastHeaders?['x-session-id'], 'sid');
    expect(adapter.lastHeaders?['x-mapper-api'], 'mapper');
    expect(adapter.lastHeaders?['X-Application-From'], 'goroute-mobile');
  });
}
