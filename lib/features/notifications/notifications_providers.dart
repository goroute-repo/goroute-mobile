import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goroute_mobile/core/providers/core_providers.dart';
import 'package:goroute_mobile/features/notifications/notifications_models.dart';

final notificationsProvider =
    FutureProvider.autoDispose<NotificationsList>((ref) {
  return ref.watch(notificationsRepositoryProvider).fetchAll();
});
