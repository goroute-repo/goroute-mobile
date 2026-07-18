import 'package:flutter/material.dart';
import 'package:goroute_mobile/core/theme/app_theme.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';

/// Store-facing identity + product help (Growth ASO + UX).
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const _version = '0.1.0';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.seed,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'GR',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.asoTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? scheme.primary : AppTheme.deep,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.asoSubtitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 10),
          Text(l10n.asoPromise),
          const SizedBox(height: 8),
          Text(
            l10n.aboutVersion(_version),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 28),
          _Section(
            title: l10n.aboutWhatTitle,
            body: l10n.aboutWhatBody,
          ),
          const SizedBox(height: 20),
          Text(
            l10n.aboutHowTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          _Bullet(l10n.aboutHow1),
          _Bullet(l10n.aboutHow2),
          _Bullet(l10n.aboutHow3),
          _Bullet(l10n.aboutHow4),
          _Bullet(l10n.aboutHow5),
          const SizedBox(height: 20),
          _Section(
            title: l10n.aboutPrivacyTitle,
            body: l10n.aboutPrivacyBody,
          ),
          const SizedBox(height: 20),
          _Section(
            title: l10n.connectionHelpTitle,
            body: l10n.connectionHelpBody,
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
        ),
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
