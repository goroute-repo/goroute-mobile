import 'package:flutter_test/flutter_test.dart';
import 'package:goroute_mobile/core/config/app_config.dart';

void main() {
  test('assertHttps rejects cleartext for prod', () {
    const config = AppConfig(
      authBaseUrl: 'http://example.com',
      apiBaseUrl: 'https://api.example.com/api',
      flavor: 'prod',
    );
    expect(config.assertHttps, throwsStateError);
  });

  test('assertHttps accepts https pair', () {
    const config = AppConfig(
      authBaseUrl: 'https://auth.example.com',
      apiBaseUrl: 'https://api.example.com/api',
      flavor: 'prod',
    );
    expect(config.assertHttps, returnsNormally);
    expect(config.allowCleartext, isFalse);
  });

  test('dev allows cleartext', () {
    expect(AppConfig.localhost.allowCleartext, isTrue);
    expect(AppConfig.localhost.isProd, isFalse);
  });
}
