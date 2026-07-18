import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goroute_mobile/core/network/api_exception.dart';
import 'package:goroute_mobile/core/network/error_mapper.dart';
import 'package:goroute_mobile/core/providers/core_providers.dart';
import 'package:goroute_mobile/core/theme/app_theme.dart';
import 'package:goroute_mobile/core/widgets/dashboard_widgets.dart';
import 'package:goroute_mobile/core/widgets/empty_state.dart';
import 'package:goroute_mobile/core/widgets/feature_error.dart';
import 'package:goroute_mobile/core/widgets/skeleton_list.dart';
import 'package:goroute_mobile/features/weekly/weekly_models.dart';
import 'package:goroute_mobile/features/weekly/weekly_providers.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class WeeklyPlanPage extends ConsumerStatefulWidget {
  const WeeklyPlanPage({super.key});

  @override
  ConsumerState<WeeklyPlanPage> createState() => _WeeklyPlanPageState();
}

class _WeeklyPlanPageState extends ConsumerState<WeeklyPlanPage> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await action();
      ref.invalidate(weeklyPlanProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.actionSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapErrorMessage(e, l10n))),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _typeLabel(AppLocalizations l10n, String type) {
    switch (type.toLowerCase()) {
      case 'study':
      case 'learn':
        return l10n.taskTypeStudy;
      case 'project':
        return l10n.taskTypeProject;
      case 'practice':
      case 'drill':
        return l10n.taskTypePractice;
      default:
        return l10n.taskTypeOther;
    }
  }

  IconData _typeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'study':
      case 'learn':
        return Icons.menu_book_outlined;
      case 'project':
        return Icons.handyman_outlined;
      case 'practice':
      case 'drill':
        return Icons.fitness_center_outlined;
      default:
        return Icons.task_alt_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(weeklyPlanProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: BrandHeaderBackground(
        child: SafeArea(
          bottom: false,
          child: async.when(
            loading: () => const SkeletonList(itemCount: 4),
            error: (err, _) {
              if (err is ApiException && err.isPremiumRequired) {
                return EmptyState(
                  title: l10n.premiumRequiredTitle,
                  body: l10n.premiumCtaBody,
                  actionLabel: l10n.viewPlans,
                  onAction: () async {
                    final uri = Uri.parse(
                      ref.read(appConfigProvider).pricingWebUrl,
                    );
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  },
                );
              }
              return buildFeatureError(
                context: context,
                error: err,
                onRetry: () => ref.invalidate(weeklyPlanProvider),
              );
            },
            data: (plan) {
              if (plan.tasks.isEmpty) {
                return EmptyState(
                  title: l10n.weeklyEmptyTitle,
                  body: l10n.weeklyEmptyBody,
                  actionLabel: l10n.recalculateWeek,
                  onAction: _busy
                      ? null
                      : () => _run(
                            () => ref
                                .read(weeklyPlanRepositoryProvider)
                                .recalculate()
                                .then((_) {}),
                          ),
                );
              }

              final done = plan.tasks.where((t) => t.completed).length;
              final total = plan.tasks.length;

              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(weeklyPlanProvider),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.weeklyHeroTitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: scheme.onSurfaceVariant,
                                        ),
                                  ),
                                  Text(
                                    plan.weekFocusLabel.isEmpty
                                        ? l10n.navWeekly
                                        : plan.weekFocusLabel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: l10n.recalculateWeek,
                              onPressed: _busy
                                  ? null
                                  : () => _run(
                                        () => ref
                                            .read(weeklyPlanRepositoryProvider)
                                            .recalculate()
                                            .then((_) {}),
                                      ),
                              icon: const Icon(Icons.refresh),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ProgressRing(
                                        percent: plan.progressPercent,
                                        size: 72,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              l10n.weeklyTasksDone(done, total),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              plan.weekKey,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: scheme
                                                        .onSurfaceVariant,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.seed.withValues(
                                        alpha: 0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      l10n.weeklyTip,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SectionLabel(l10n.weeklyChecklist),
                          const SizedBox(height: 10),
                          ...plan.tasks.map(
                            (task) => _TaskCard(
                              task: task,
                              typeLabel: _typeLabel(l10n, task.type),
                              typeIcon: _typeIcon(task.type),
                              busy: _busy,
                              doneLabel: l10n.completeTask,
                              onComplete: () => _run(
                                () => ref
                                    .read(weeklyPlanRepositoryProvider)
                                    .completeTask(task.id)
                                    .then((_) {}),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SectionLabel(l10n.weeklyActions),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: _busy
                                ? null
                                : () => _run(
                                      () => ref
                                          .read(weeklyPlanRepositoryProvider)
                                          .skipWeek()
                                          .then((_) {}),
                                    ),
                            icon: const Icon(Icons.skip_next),
                            label: Text(l10n.skipWeek),
                          ),
                          const SizedBox(height: 8),
                          FilledButton.tonalIcon(
                            onPressed: _busy
                                ? null
                                : () => _run(
                                      () => ref
                                          .read(weeklyPlanRepositoryProvider)
                                          .recalculate()
                                          .then((_) {}),
                                    ),
                            icon: const Icon(Icons.auto_awesome),
                            label: Text(l10n.recalculateWeek),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.typeLabel,
    required this.typeIcon,
    required this.busy,
    required this.doneLabel,
    required this.onComplete,
  });

  final WeeklyTask task;
  final String typeLabel;
  final IconData typeIcon;
  final bool busy;
  final String doneLabel;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              task.completed ? Icons.check_circle : typeIcon,
              color: task.completed ? scheme.primary : scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      typeLabel,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          decoration: task.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                  ),
                  if (task.description != null &&
                      task.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      task.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            if (!task.completed)
              FilledButton(
                onPressed: busy ? null : onComplete,
                child: Text(doneLabel),
              ),
          ],
        ),
      ),
    );
  }
}
