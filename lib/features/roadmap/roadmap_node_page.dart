import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goroute_mobile/core/network/error_mapper.dart';
import 'package:goroute_mobile/core/providers/core_providers.dart';
import 'package:goroute_mobile/core/widgets/feature_error.dart';
import 'package:goroute_mobile/core/widgets/loading_view.dart';
import 'package:goroute_mobile/features/mentor/mentor_models.dart';
import 'package:goroute_mobile/features/roadmap/roadmap_models.dart';
import 'package:goroute_mobile/features/roadmap/roadmap_providers.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';

class RoadmapNodePage extends ConsumerStatefulWidget {
  const RoadmapNodePage({super.key, required this.slug});

  final String slug;

  @override
  ConsumerState<RoadmapNodePage> createState() => _RoadmapNodePageState();
}

class _RoadmapNodePageState extends ConsumerState<RoadmapNodePage> {
  bool _busy = false;

  Future<void> _runAction(Future<RoadmapNodeDetail> Function() action) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await action();
      ref.invalidate(roadmapNodeProvider(widget.slug));
      ref.invalidate(roadmapMeProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.actionSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            content: Text(mapErrorMessage(e, l10n)),
            action: isSessionFailure(e)
                ? SnackBarAction(
                    label: l10n.signInAgain,
                    onPressed: () => context.go('/login'),
                  )
                : null,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(roadmapNodeProvider(widget.slug));
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.nodeDetailTitle)),
      body: async.when(
        loading: () => const LoadingView(),
        error: (err, _) => buildFeatureError(
          context: context,
          error: err,
          onRetry: () => ref.invalidate(roadmapNodeProvider(widget.slug)),
        ),
        data: (node) {
          final hasHours =
              node.estimatedHours != null || node.hoursLogged != null;
          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            children: [
              Text(
                node.label,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    avatar: Icon(Icons.flag_outlined, size: 16, color: scheme.primary),
                    label: Text(_stateLabel(l10n, node.state)),
                  ),
                  if (hasHours)
                    Chip(
                      avatar: const Icon(Icons.schedule, size: 16),
                      label: Text(
                        l10n.nodeHours(
                          node.hoursLogged ?? 0,
                          node.estimatedHours ?? 0,
                        ),
                      ),
                    ),
                ],
              ),
              if (node.description != null && node.description!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  node.description!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.4,
                      ),
                ),
              ],
              if (node.notes != null && node.notes!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.nodeNotes,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(node.notes!),
              ],
              if (node.isLocked) ...[
                const SizedBox(height: 20),
                Card(
                  color: scheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.nodeLockedHint,
                      style: TextStyle(color: scheme.onErrorContainer),
                    ),
                  ),
                ),
              ],
              if (node.prerequisites.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  l10n.prerequisites,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                ...node.prerequisites.map(
                  (p) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      p.satisfied ? Icons.check_circle : Icons.cancel_outlined,
                      color: p.satisfied ? scheme.primary : scheme.error,
                    ),
                    title: Text(p.label),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => context.push(
                  '/app/mentor',
                  extra: MentorRouteExtra(
                    prefillQuestion: l10n.mentorPrefillNode(node.label),
                    contextLabel: node.label,
                  ),
                ),
                icon: const Icon(Icons.smart_toy_outlined),
                label: Text(l10n.askMentor),
              ),
              const SizedBox(height: 12),
              if (node.canStart)
                FilledButton(
                  onPressed: _busy
                      ? null
                      : () => _runAction(
                            () => ref
                                .read(roadmapRepositoryProvider)
                                .startNode(widget.slug),
                          ),
                  child: Text(_busy ? l10n.working : l10n.startNode),
                ),
              if (node.canComplete) ...[
                FilledButton(
                  onPressed: _busy
                      ? null
                      : () => _runAction(
                            () => ref
                                .read(roadmapRepositoryProvider)
                                .completeNode(widget.slug),
                          ),
                  child: Text(_busy ? l10n.working : l10n.completeNode),
                ),
              ],
              if (!node.canStart && !node.canComplete && !node.isLocked)
                Text(
                  l10n.nodeNoAction,
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
            ],
          );
        },
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
}
