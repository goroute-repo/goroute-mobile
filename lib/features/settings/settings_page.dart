import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goroute_mobile/core/network/error_mapper.dart';
import 'package:goroute_mobile/core/providers/core_providers.dart';
import 'package:goroute_mobile/core/widgets/feature_error.dart';
import 'package:goroute_mobile/features/mentor/mentor_chat_store.dart';
import 'package:goroute_mobile/features/settings/appearance_controls.dart';
import 'package:goroute_mobile/features/settings/settings_providers.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _headline = TextEditingController();
  final _eraseConfirm = TextEditingController();
  String? _mentorMode;
  bool _lgpdConsent = false;
  bool _busy = false;
  bool _headlineSeeded = false;

  @override
  void dispose() {
    _headline.dispose();
    _eraseConfirm.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(settingsRepositoryProvider).updateProfile(
            headline: _headline.text.trim(),
          );
      ref.invalidate(settingsProfileProvider);
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

  Future<void> _saveAi() async {
    final l10n = AppLocalizations.of(context);
    final mode = _mentorMode ?? 'off';
    setState(() => _busy = true);
    try {
      await ref.read(settingsRepositoryProvider).updateMentorMode(
            mode,
            lgpdConsent: _lgpdConsent,
          );
      ref.invalidate(settingsAiProvider);
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

  Future<void> _export() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final json = await ref.read(settingsRepositoryProvider).exportPrivacyJson();
      await Clipboard.setData(ClipboardData(text: json));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.exportCopied)),
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

  Future<void> _erase() async {
    final l10n = AppLocalizations.of(context);
    if (_eraseConfirm.text.trim() != 'DELETE') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.eraseConfirmHint)),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(settingsRepositoryProvider).eraseAccount();
      await ref.read(authRepositoryProvider).logout();
      await ref.read(mentorChatStoreProvider).clear();
      ref.invalidate(sessionAuthProvider);
      if (mounted) context.go('/login');
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
    final profileAsync = ref.watch(settingsProfileProvider);
    final aiAsync = ref.watch(settingsAiProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: profileAsync.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(24),
          children: const [
            AppearanceControls(),
            SizedBox(height: 32),
            Center(child: CircularProgressIndicator()),
          ],
        ),
        error: (err, _) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const AppearanceControls(),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            SizedBox(
              height: 280,
              child: buildFeatureError(
                context: context,
                error: err,
                onRetry: () {
                  ref.invalidate(settingsProfileProvider);
                  ref.invalidate(settingsAiProvider);
                },
              ),
            ),
          ],
        ),
        data: (profile) {
          if (!_headlineSeeded) {
            _headline.text = profile.headline;
            _headlineSeeded = true;
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const AppearanceControls(),
              const SizedBox(height: 28),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                l10n.profileSection,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                profile.fullName.isEmpty ? '—' : profile.fullName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.nameReadOnlyHint,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _headline,
                decoration: InputDecoration(labelText: l10n.headlineLabel),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _busy ? null : _saveProfile,
                child: Text(l10n.saveProfile),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.aiSection,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              aiAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (err, _) => Text(mapErrorMessage(err, l10n)),
                data: (ai) {
                  _mentorMode ??= ai.mentorMode;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: _mentorMode,
                        items: [
                          DropdownMenuItem(
                            value: 'off',
                            child: Text(l10n.mentorModeOff),
                          ),
                          DropdownMenuItem(
                            value: 'managed',
                            child: Text(l10n.mentorModeManaged),
                          ),
                          DropdownMenuItem(
                            value: 'byok',
                            child: Text(l10n.mentorModeByok),
                          ),
                        ],
                        onChanged: _busy
                            ? null
                            : (v) => setState(() => _mentorMode = v),
                        decoration: InputDecoration(
                          labelText: l10n.mentorModeLabel,
                        ),
                      ),
                      if (_mentorMode == 'managed' || _mentorMode == 'byok')
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          value: _lgpdConsent,
                          onChanged: _busy
                              ? null
                              : (v) => setState(() => _lgpdConsent = v ?? false),
                          title: Text(l10n.lgpdConsentLabel),
                        ),
                      if (_mentorMode == 'byok')
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            l10n.byokWebHint,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      FilledButton(
                        onPressed: _busy ? null : _saveAi,
                        child: Text(l10n.saveAi),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                l10n.privacySection,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _busy ? null : _export,
                child: Text(l10n.exportPrivacy),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.eraseSection,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
              const SizedBox(height: 8),
              Text(l10n.eraseBody),
              const SizedBox(height: 8),
              TextField(
                controller: _eraseConfirm,
                decoration: InputDecoration(
                  labelText: l10n.eraseConfirmLabel,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: _busy ? null : _erase,
                child: Text(l10n.eraseAccount),
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout),
                title: Text(l10n.signOut),
                onTap: () async {
                  await ref.read(authRepositoryProvider).logout();
                  await ref.read(mentorChatStoreProvider).clear();
                  ref.invalidate(sessionAuthProvider);
                  if (context.mounted) context.go('/login');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
