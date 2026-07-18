import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goroute_mobile/core/network/error_mapper.dart';
import 'package:goroute_mobile/core/widgets/empty_state.dart';
import 'package:goroute_mobile/core/widgets/error_view.dart';
import 'package:goroute_mobile/core/widgets/skeleton_list.dart';
import 'package:goroute_mobile/features/jobs/jobs_models.dart';
import 'package:goroute_mobile/features/jobs/jobs_providers.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';

class JobsPage extends ConsumerStatefulWidget {
  const JobsPage({super.key});

  @override
  ConsumerState<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends ConsumerState<JobsPage> {
  final _query = TextEditingController();
  String _debounced = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _debounced = value.trim().toLowerCase());
    });
  }

  List<JobMatch> _filter(List<JobMatch> jobs) {
    if (_debounced.isEmpty) return jobs;
    return jobs
        .where(
          (j) =>
              j.title.toLowerCase().contains(_debounced) ||
              j.companyName.toLowerCase().contains(_debounced),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(jobMatchesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navJobs)),
      body: async.when(
        loading: () => const SkeletonList(),
        error: (err, _) => ErrorView(
          message: mapErrorMessage(err, l10n),
          onRetry: () => ref.invalidate(jobMatchesProvider),
        ),
        data: (jobs) {
          if (jobs.isEmpty) {
            return EmptyState(
              title: l10n.jobsEmptyTitle,
              body: l10n.jobsEmptyBody,
            );
          }
          final filtered = _filter(jobs);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextField(
                  controller: _query,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: l10n.jobsSearchHint,
                  ),
                  onChanged: _onQueryChanged,
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? EmptyState(
                        title: l10n.jobsEmptyTitle,
                        body: l10n.jobsEmptyBody,
                      )
                    : RefreshIndicator(
                        onRefresh: () async =>
                            ref.invalidate(jobMatchesProvider),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final job = filtered[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                title: Text(job.title),
                                subtitle: Text(
                                  [
                                    job.companyName,
                                    if (job.locationDisplay.isNotEmpty)
                                      job.locationDisplay,
                                  ].join(' · '),
                                ),
                                trailing: Text(
                                  '${job.matchScore}%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: job.fullyQualified
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : null,
                                      ),
                                ),
                                onTap: () => context.push(
                                  '/app/jobs/${Uri.encodeComponent(job.jobId)}',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
