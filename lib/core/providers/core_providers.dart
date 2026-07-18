import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goroute_mobile/core/auth/session_store.dart';
import 'package:goroute_mobile/core/cache/json_read_cache.dart';
import 'package:goroute_mobile/core/config/app_config.dart';
import 'package:goroute_mobile/core/network/api_client.dart';
import 'package:goroute_mobile/features/auth/auth_repository.dart';
import 'package:goroute_mobile/features/jobs/jobs_repository.dart';
import 'package:goroute_mobile/features/mentor/mentor_repository.dart';
import 'package:goroute_mobile/features/notifications/notifications_repository.dart';
import 'package:goroute_mobile/features/roadmap/roadmap_repository.dart';
import 'package:goroute_mobile/features/settings/settings_repository.dart';
import 'package:goroute_mobile/features/weekly/weekly_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appConfigProvider = Provider<AppConfig>((ref) => AppConfig.local);

final sessionStoreProvider = Provider<SessionStore>((ref) {
  throw UnimplementedError('Override sessionStoreProvider in main/tests');
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override sharedPreferencesProvider in main/tests');
});

final jsonReadCacheProvider = Provider<JsonReadCache>((ref) {
  return JsonReadCache(ref.watch(sharedPreferencesProvider));
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    config: ref.watch(appConfigProvider),
    sessionStore: ref.watch(sessionStoreProvider),
    onUnauthorized: () {
      // Drop cached session flags so router returns to login.
      ref.invalidate(sessionAuthProvider);
    },
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    client: ref.watch(apiClientProvider),
    sessionStore: ref.watch(sessionStoreProvider),
  );
});

final roadmapRepositoryProvider = Provider<RoadmapRepository>((ref) {
  return RoadmapRepository(
    client: ref.watch(apiClientProvider),
    cache: ref.watch(jsonReadCacheProvider),
  );
});

final weeklyPlanRepositoryProvider = Provider<WeeklyPlanRepository>((ref) {
  return WeeklyPlanRepository(
    client: ref.watch(apiClientProvider),
    cache: ref.watch(jsonReadCacheProvider),
  );
});

final jobsRepositoryProvider = Provider<JobsRepository>((ref) {
  return JobsRepository(client: ref.watch(apiClientProvider));
});

final mentorRepositoryProvider = Provider<MentorRepository>((ref) {
  return MentorRepository(client: ref.watch(apiClientProvider));
});

final notificationsRepositoryProvider =
    Provider<NotificationsRepository>((ref) {
  return NotificationsRepository(client: ref.watch(apiClientProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(client: ref.watch(apiClientProvider));
});

/// Session presence for router redirects (invalidate after login/logout).
final sessionAuthProvider = FutureProvider<bool>((ref) async {
  return ref.watch(sessionStoreProvider).hasSession;
});
