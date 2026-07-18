import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goroute_mobile/core/prefs/app_prefs.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';

/// Language + theme controls used in Settings and More.
class AppearanceControls extends ConsumerWidget {
  const AppearanceControls({super.key, this.dense = false});

  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(appLocaleProvider);
    final pad = dense ? 12.0 : 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.appearanceSection,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        SizedBox(height: dense ? 8 : 12),
        Text(
          l10n.themeLabel,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        SegmentedButton<ThemeMode>(
          showSelectedIcon: false,
          style: const ButtonStyle(
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          segments: [
            ButtonSegment(
              value: ThemeMode.system,
              label: Text(l10n.themeSystem),
              icon: const Icon(Icons.brightness_auto, size: 16),
            ),
            ButtonSegment(
              value: ThemeMode.light,
              label: Text(l10n.themeLight),
              icon: const Icon(Icons.light_mode_outlined, size: 16),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              label: Text(l10n.themeDark),
              icon: const Icon(Icons.dark_mode_outlined, size: 16),
            ),
          ],
          selected: {themeMode},
          onSelectionChanged: (set) {
            ref.read(themeModeProvider.notifier).setMode(set.first);
          },
        ),
        SizedBox(height: pad),
        Text(
          l10n.languageLabel,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          showSelectedIcon: false,
          style: const ButtonStyle(
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          segments: [
            ButtonSegment(
              value: 'system',
              label: Text(l10n.languageSystem),
            ),
            ButtonSegment(
              value: 'pt',
              label: Text(l10n.languagePt),
            ),
            ButtonSegment(
              value: 'en',
              label: Text(l10n.languageEn),
            ),
          ],
          selected: {
            locale == null ? 'system' : locale.languageCode,
          },
          onSelectionChanged: (set) {
            final v = set.first;
            if (v == 'system') {
              ref.read(appLocaleProvider.notifier).setLocale(null);
            } else {
              ref.read(appLocaleProvider.notifier).setLocale(Locale(v));
            }
          },
        ),
      ],
    );
  }
}
