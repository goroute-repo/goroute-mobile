import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goroute_mobile/core/network/error_mapper.dart';
import 'package:goroute_mobile/core/providers/core_providers.dart';
import 'package:goroute_mobile/core/widgets/empty_state.dart';
import 'package:goroute_mobile/core/widgets/error_view.dart';
import 'package:goroute_mobile/core/widgets/loading_view.dart';
import 'package:goroute_mobile/features/notifications/notifications_providers.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationsTitle),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await ref.read(notificationsRepositoryProvider).markAllRead();
                ref.invalidate(notificationsProvider);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(mapErrorMessage(e, l10n))),
                  );
                }
              }
            },
            child: Text(l10n.markAllRead),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingView(),
        error: (err, _) => ErrorView(
          message: mapErrorMessage(err, l10n),
          onRetry: () => ref.invalidate(notificationsProvider),
        ),
        data: (data) {
          if (data.items.isEmpty) {
            return EmptyState(
              title: l10n.notificationsEmptyTitle,
              body: l10n.notificationsEmptyBody,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(notificationsProvider),
            child: ListView.builder(
              itemCount: data.items.length,
              itemBuilder: (context, index) {
                final n = data.items[index];
                return ListTile(
                  leading: Icon(
                    n.read
                        ? Icons.notifications_none
                        : Icons.notifications_active,
                    color: n.read
                        ? null
                        : Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    n.title,
                    style: TextStyle(
                      fontWeight: n.read ? FontWeight.w400 : FontWeight.w700,
                    ),
                  ),
                  subtitle: n.body == null || n.body!.isEmpty
                      ? null
                      : Text(n.body!),
                  onTap: () async {
                    if (!n.read) {
                      try {
                        await ref
                            .read(notificationsRepositoryProvider)
                            .markRead(n.id);
                        ref.invalidate(notificationsProvider);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(mapErrorMessage(e, l10n)),
                            ),
                          );
                        }
                      }
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
