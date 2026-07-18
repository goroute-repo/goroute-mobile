import 'package:goroute_mobile/core/auth/session_store.dart';
import 'package:goroute_mobile/core/config/app_config.dart';
import 'package:goroute_mobile/core/providers/core_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> testProviderOverrides({
  SessionStore? sessionStore,
  AppConfig config = AppConfig.localhost,
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return [
    appConfigProvider.overrideWithValue(config),
    sessionStoreProvider.overrideWithValue(
      sessionStore ?? SessionStore(kv: MemorySecureKv()),
    ),
    sharedPreferencesProvider.overrideWithValue(prefs),
  ];
}
