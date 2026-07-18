import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goroute_mobile/core/providers/core_providers.dart';
import 'package:goroute_mobile/features/weekly/weekly_models.dart';

final weeklyPlanProvider = FutureProvider.autoDispose<WeeklyPlan>((ref) {
  return ref.watch(weeklyPlanRepositoryProvider).fetchCurrent();
});
