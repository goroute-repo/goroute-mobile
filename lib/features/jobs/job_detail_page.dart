import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goroute_mobile/core/network/error_mapper.dart';
import 'package:goroute_mobile/core/providers/core_providers.dart';
import 'package:goroute_mobile/core/widgets/error_view.dart';
import 'package:goroute_mobile/core/widgets/loading_view.dart';
import 'package:goroute_mobile/features/jobs/jobs_providers.dart';
import 'package:goroute_mobile/features/mentor/mentor_models.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';

class JobDetailPage extends ConsumerStatefulWidget {
  const JobDetailPage({super.key, required this.jobId});

  final String jobId;

  @override
  ConsumerState<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends ConsumerState<JobDetailPage> {
  bool _busy = false;

  Future<void> _apply() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(jobsRepositoryProvider).apply(widget.jobId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.applySuccess)),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(jobDetailProvider(widget.jobId));
    final narrativeAsync = ref.watch(jobNarrativeProvider(widget.jobId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.jobDetailTitle)),
      body: detailAsync.when(
        loading: () => const LoadingView(),
        error: (err, _) => ErrorView(
          message: mapErrorMessage(err, l10n),
          onRetry: () => ref.invalidate(jobDetailProvider(widget.jobId)),
        ),
        data: (job) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                job.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              if (job.locationLabel != null && job.locationLabel!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  job.locationLabel!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
              const SizedBox(height: 16),
              Text(job.description),
              if (job.skills.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  l10n.jobSkills,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: job.skills
                      .map(
                        (s) => Chip(label: Text('${s.slug} · ${s.minLevel}')),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                l10n.whyThisMatch,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              narrativeAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: LinearProgressIndicator(),
                ),
                error: (err, _) => Text(mapErrorMessage(err, l10n)),
                data: (n) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${n.matchScore}%',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(n.summary),
                        if (n.closingSkills.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            l10n.closingSkills,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          ...n.closingSkills.map(
                            (s) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(s.label),
                              subtitle: Text(s.minLevel),
                              trailing: Text(l10n.openInTrack),
                              onTap: s.slug.isEmpty
                                  ? null
                                  : () => context.push(
                                        '/app/roadmap/nodes/${Uri.encodeComponent(s.slug)}',
                                      ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => context.push(
                  '/app/mentor',
                  extra: MentorRouteExtra(
                    prefillQuestion: l10n.mentorPrefillJob(job.title),
                    contextLabel: job.title,
                  ),
                ),
                icon: const Icon(Icons.smart_toy_outlined),
                label: Text(l10n.askMentor),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _busy ? null : _apply,
                child: Text(_busy ? l10n.working : l10n.applyJob),
              ),
            ],
          );
        },
      ),
    );
  }
}
