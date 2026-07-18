import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goroute_mobile/core/theme/app_theme.dart';
import 'package:goroute_mobile/core/widgets/dashboard_widgets.dart';
import 'package:goroute_mobile/core/widgets/feature_error.dart';
import 'package:goroute_mobile/core/widgets/skeleton_list.dart';
import 'package:goroute_mobile/features/mentor/mentor_models.dart';
import 'package:goroute_mobile/features/notifications/notifications_providers.dart';
import 'package:goroute_mobile/features/roadmap/roadmap_models.dart';
import 'package:goroute_mobile/features/roadmap/roadmap_providers.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.greetingMorning;
    if (hour < 18) return l10n.greetingAfternoon;
    return l10n.greetingEvening;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(roadmapMeProvider);
    final unread = ref.watch(notificationsProvider).maybeWhen(
          data: (d) => d.unreadCount,
          orElse: () => 0,
        );
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: BrandHeaderBackground(
        child: SafeArea(
          bottom: false,
          child: async.when(
            loading: () => const SkeletonList(itemCount: 4),
            error: (err, _) => buildFeatureError(
              context: context,
              error: err,
              onRetry: () => ref.invalidate(roadmapMeProvider),
            ),
            data: (data) => RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(roadmapMeProvider);
                ref.invalidate(notificationsProvider);
              },
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
                                  _greeting(l10n),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'GoRoute',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: isDark
                                            ? scheme.primary
                                            : AppTheme.deep,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: l10n.notificationsTitle,
                            onPressed: () =>
                                context.push('/app/notifications'),
                            icon: Badge(
                              isLabelVisible: unread > 0,
                              label: Text('$unread'),
                              child: const Icon(Icons.notifications_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _ProgressHero(data: data, l10n: l10n),
                        const SizedBox(height: 20),
                        SectionLabel(l10n.nextFocus),
                        const SizedBox(height: 8),
                        _NextFocusCard(data: data, l10n: l10n),
                        const SizedBox(height: 24),
                        SectionLabel(l10n.dashboardShortcuts),
                        const SizedBox(height: 10),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.35,
                          children: [
                            QuickActionTile(
                              icon: Icons.route,
                              label: l10n.homeCtaRoadmap,
                              emphasized: true,
                              onTap: () => context.go('/app/roadmap'),
                            ),
                            QuickActionTile(
                              icon: Icons.calendar_view_week,
                              label: l10n.homeCtaWeekly,
                              onTap: () => context.go('/app/weekly'),
                            ),
                            QuickActionTile(
                              icon: Icons.work_outline,
                              label: l10n.homeCtaJobs,
                              onTap: () => context.go('/app/jobs'),
                            ),
                            QuickActionTile(
                              icon: Icons.smart_toy_outlined,
                              label: l10n.homeCtaMentor,
                              onTap: () => context.push(
                                '/app/mentor',
                                extra: MentorRouteExtra(
                                  prefillQuestion: data.recommendedLabel == null
                                      ? null
                                      : l10n.mentorPrefillNext(
                                          data.recommendedLabel!,
                                        ),
                                  contextLabel: data.targetRoleLabel,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _StatChip(
                                icon: Icons.flag_outlined,
                                label: l10n.dashboardNodes,
                                value: '${data.nodesCount}',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _StatChip(
                                icon: Icons.schedule_outlined,
                                label: l10n.etaWeeks,
                                value: '${data.weeksToGoal}',
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressHero extends StatelessWidget {
  const _ProgressHero({required this.data, required this.l10n});

  final RoadmapSnapshot data;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            ProgressRing(percent: data.percentDone),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dashboardOverview,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.targetRoleLabel ?? l10n.yourTrack,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.homeSubtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextFocusCard extends StatelessWidget {
  const _NextFocusCard({required this.data, required this.l10n});

  final RoadmapSnapshot data;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final hasNext = data.recommendedNext != null &&
        data.recommendedNext!.slug.isNotEmpty;

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer.withValues(
            alpha: 0.55,
          ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          child: const Icon(Icons.bolt, size: 22),
        ),
        title: Text(
          data.recommendedLabel ?? l10n.homeNoNext,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          hasNext ? l10n.homeOpenNode : l10n.homeCtaRoadmap,
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: hasNext
            ? () => context.push(
                  '/app/roadmap/nodes/${Uri.encodeComponent(data.recommendedNext!.slug)}',
                )
            : () => context.go('/app/roadmap'),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: scheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
