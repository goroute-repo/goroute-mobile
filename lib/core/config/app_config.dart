/// App flavor + endpoints. Override via `--dart-define`.
///
/// - `APP_FLAVOR=dev` (default): allows HTTP LAN / emulator hosts
/// - `APP_FLAVOR=prod`: HTTPS only (rejects cleartext base URLs)
class AppConfig {
  const AppConfig({
    required this.authBaseUrl,
    required this.apiBaseUrl,
    required this.flavor,
    this.applicationFrom = 'goroute-mobile',
    this.pricingWebUrl = 'https://goroute.app/pricing',
  });

  final String authBaseUrl;
  final String apiBaseUrl;
  final String applicationFrom;
  final String pricingWebUrl;

  /// `dev` | `prod`
  final String flavor;

  bool get isProd => flavor == 'prod';
  bool get allowCleartext => !isProd;

  /// Emulator / device LAN defaults (dev).
  static const AppConfig local = AppConfig(
    authBaseUrl: String.fromEnvironment(
      'AUTH_BASE_URL',
      defaultValue: 'http://10.0.2.2:3010',
    ),
    apiBaseUrl: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:3000/api',
    ),
    flavor: String.fromEnvironment('APP_FLAVOR', defaultValue: 'dev'),
    pricingWebUrl: String.fromEnvironment(
      'PRICING_WEB_URL',
      defaultValue: 'http://10.0.2.2:4200/pricing',
    ),
  );

  /// Desktop / tests default to localhost.
  static const AppConfig localhost = AppConfig(
    authBaseUrl: 'http://127.0.0.1:3010',
    apiBaseUrl: 'http://127.0.0.1:3000/api',
    flavor: 'dev',
    pricingWebUrl: 'http://127.0.0.1:4200/pricing',
  );

  /// Resolve from dart-defines; enforces HTTPS when `APP_FLAVOR=prod`.
  factory AppConfig.resolve() {
    const flavor = String.fromEnvironment('APP_FLAVOR', defaultValue: 'dev');
    const auth = String.fromEnvironment(
      'AUTH_BASE_URL',
      defaultValue: 'http://10.0.2.2:3010',
    );
    const api = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:3000/api',
    );
    const pricing = String.fromEnvironment(
      'PRICING_WEB_URL',
      defaultValue: 'http://10.0.2.2:4200/pricing',
    );
    const config = AppConfig(
      authBaseUrl: auth,
      apiBaseUrl: api,
      flavor: flavor,
      pricingWebUrl: pricing,
    );
    if (config.isProd) {
      config.assertHttps();
    }
    return config;
  }

  void assertHttps() {
    if (!_isHttps(authBaseUrl) || !_isHttps(apiBaseUrl)) {
      throw StateError(
        'APP_FLAVOR=prod requires HTTPS AUTH_BASE_URL and API_BASE_URL '
        '(got auth=$authBaseUrl api=$apiBaseUrl).',
      );
    }
  }

  static bool _isHttps(String url) =>
      url.toLowerCase().startsWith('https://');
}
