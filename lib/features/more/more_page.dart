import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goroute_mobile/features/notifications/notifications_providers.dart';
import 'package:goroute_mobile/features/settings/appearance_controls.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unread = ref.watch(notificationsProvider).maybeWhen(
          data: (d) => d.unreadCount,
          orElse: () => 0,
        );
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navMore)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: AppearanceControls(dense: true),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.settingsTitle,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.smart_toy_outlined),
                  title: Text(l10n.mentorTitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/app/mentor'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Badge(
                    isLabelVisible: unread > 0,
                    label: Text('$unread'),
                    child: const Icon(Icons.notifications_outlined),
                  ),
                  title: Text(l10n.notificationsTitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/app/notifications'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: Text(l10n.settingsTitle),
                  subtitle: Text(l10n.profileSection),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/app/settings'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.aboutTitle),
                  subtitle: Text(l10n.asoSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/app/about'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: Text(l10n.connectionHelpTitle),
                  subtitle: Text(l10n.connectionHelpShort),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/app/about', extra: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
