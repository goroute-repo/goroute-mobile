import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goroute_mobile/core/network/error_mapper.dart';
import 'package:goroute_mobile/core/widgets/empty_state.dart';
import 'package:goroute_mobile/core/widgets/error_view.dart';
import 'package:goroute_mobile/core/widgets/skeleton_list.dart';
import 'package:goroute_mobile/features/roadmap/roadmap_models.dart';
import 'package:goroute_mobile/features/roadmap/roadmap_providers.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';

class RoadmapPage extends ConsumerWidget {
  const RoadmapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(roadmapMeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.roadmapTitle)),
      body: async.when(
        loading: () => const SkeletonList(),
        error: (err, _) => ErrorView(
          message: mapErrorMessage(err, l10n),
          onRetry: () => ref.invalidate(roadmapMeProvider),
        ),
        data: (data) {
          if (data.nodes.isEmpty) {
            return EmptyState(
              title: l10n.roadmapEmptyTitle,
              body: l10n.roadmapEmptyBody,
            );
          }
          final ordered = _sortedNodes(data.nodes);
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(roadmapMeProvider),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: ordered.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.targetRoleLabel ?? l10n.yourTrack,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${l10n.progress}: ${data.percentDone}% · ${l10n.nodes}: ${data.nodesCount}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  );
                }
                final node = ordered[index - 1];
                return _NodeTile(node: node);
              },
            ),
          );
        },
      ),
    );
  }

  List<RoadmapNodeSummary> _sortedNodes(List<RoadmapNodeSummary> nodes) {
    const order = {
      'recommended': 0,
      'in_progress': 1,
      'available': 2,
      'completed': 3,
      'locked': 4,
    };
    final copy = [...nodes];
    copy.sort((a, b) {
      final sa = order[a.state] ?? 5;
      final sb = order[b.state] ?? 5;
      if (sa != sb) return sa.compareTo(sb);
      return a.label.compareTo(b.label);
    });
    return copy;
  }
}

class _NodeTile extends StatelessWidget {
  const _NodeTile({required this.node});

  final RoadmapNodeSummary node;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slug = node.slug;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(node.label),
        subtitle: Text(_stateLabel(l10n, node.state)),
        leading: Icon(_stateIcon(node.state)),
        trailing: const Icon(Icons.chevron_right),
        onTap: slug == null || slug.isEmpty
            ? null
            : () => context.push(
                  '/app/roadmap/nodes/${Uri.encodeComponent(slug)}',
                ),
      ),
    );
  }

  String _stateLabel(AppLocalizations l10n, String? state) {
    switch (state) {
      case 'completed':
        return l10n.nodeStateCompleted;
      case 'in_progress':
        return l10n.nodeStateInProgress;
      case 'available':
        return l10n.nodeStateAvailable;
      case 'recommended':
        return l10n.nodeStateRecommended;
      case 'locked':
        return l10n.nodeStateLocked;
      default:
        return state ?? l10n.nodeStateUnknown;
    }
  }

  IconData _stateIcon(String? state) {
    switch (state) {
      case 'completed':
        return Icons.check_circle_outline;
      case 'in_progress':
        return Icons.play_circle_outline;
      case 'recommended':
        return Icons.star_outline;
      case 'locked':
        return Icons.lock_outline;
      default:
        return Icons.radio_button_unchecked;
    }
  }
}
