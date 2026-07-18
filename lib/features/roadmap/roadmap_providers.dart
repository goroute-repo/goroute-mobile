import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goroute_mobile/core/providers/core_providers.dart';
import 'package:goroute_mobile/features/roadmap/roadmap_models.dart';

final roadmapMeProvider = FutureProvider.autoDispose<RoadmapSnapshot>((ref) {
  return ref.watch(roadmapRepositoryProvider).fetchMe();
});

final roadmapNodeProvider =
    FutureProvider.autoDispose.family<RoadmapNodeDetail, String>((ref, slug) {
  return ref.watch(roadmapRepositoryProvider).fetchNode(slug);
});
