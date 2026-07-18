import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goroute_mobile/core/providers/core_providers.dart';
import 'package:goroute_mobile/features/settings/settings_models.dart';

final settingsProfileProvider = FutureProvider.autoDispose<UserProfile>((ref) {
  return ref.watch(settingsRepositoryProvider).fetchProfile();
});

final settingsAiProvider = FutureProvider.autoDispose<AiSettings>((ref) {
  return ref.watch(settingsRepositoryProvider).fetchAi();
});
