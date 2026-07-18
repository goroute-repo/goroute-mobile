import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goroute_mobile/core/providers/core_providers.dart';
import 'package:goroute_mobile/features/jobs/jobs_models.dart';

final jobMatchesProvider = FutureProvider.autoDispose<List<JobMatch>>((ref) {
  return ref.watch(jobsRepositoryProvider).fetchMatches();
});

final jobDetailProvider =
    FutureProvider.autoDispose.family<JobDetail, String>((ref, jobId) {
  return ref.watch(jobsRepositoryProvider).fetchJob(jobId);
});

final jobNarrativeProvider =
    FutureProvider.autoDispose.family<JobMatchNarrative, String>((ref, jobId) {
  return ref.watch(jobsRepositoryProvider).fetchNarrative(jobId);
});
