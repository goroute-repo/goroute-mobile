import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goroute_mobile/core/network/error_mapper.dart';
import 'package:goroute_mobile/core/providers/core_providers.dart';
import 'package:goroute_mobile/features/auth/auth_repository.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';

class LoginMfaPage extends ConsumerStatefulWidget {
  const LoginMfaPage({super.key, required this.tempToken});

  final String tempToken;

  @override
  ConsumerState<LoginMfaPage> createState() => _LoginMfaPageState();
}

class _LoginMfaPageState extends ConsumerState<LoginMfaPage> {
  final _code = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authRepositoryProvider).verifyMfa(
            tempToken: widget.tempToken,
            code: _code.text,
          );
      if (!mounted) return;
      ref.invalidate(sessionAuthProvider);
      context.go('/app/home');
    } on AuthException catch (e) {
      setState(() => _error = mapErrorMessage(e, l10n));
    } catch (e) {
      setState(() => _error = mapErrorMessage(e, l10n));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.mfaTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              l10n.mfaHeadline,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.mfaBody,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _code,
              keyboardType: TextInputType.number,
              autofocus: true,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Za-z-]')),
              ],
              decoration: InputDecoration(labelText: l10n.code),
              onSubmitted: (_) => _busy ? null : _submit(),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: scheme.error)),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _busy ? null : _submit,
              child: Text(_busy ? l10n.verifying : l10n.verify),
            ),
          ],
        ),
      ),
    );
  }
}
