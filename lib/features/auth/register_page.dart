import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goroute_mobile/core/network/error_mapper.dart';
import 'package:goroute_mobile/core/providers/core_providers.dart';
import 'package:goroute_mobile/features/auth/auth_repository.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';

/// Cadastro de conta profissional. Espelha o fluxo web (`/login/register`):
/// cria a conta e manda a pessoa entrar em seguida — sem login automático.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _acceptedTerms = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);

    if (_password.text != _confirm.text) {
      setState(() => _error = l10n.passwordMismatch);
      return;
    }
    if (!_acceptedTerms) {
      setState(() => _error = l10n.errorTermsRequired);
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authRepositoryProvider).registerProfessional(
            email: _email.text,
            password: _password.text,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.accountCreatedSuccess)),
      );
      context.pop();
    } on AuthException catch (e) {
      setState(() => _error = switch (e.code) {
            'USER_EXISTS' => l10n.errorEmailInUse,
            'WEAK_PASSWORD' => l10n.errorWeakPassword,
            'TERMS_NOT_ACCEPTED' => l10n.errorTermsRequired,
            _ => mapErrorMessage(e, l10n),
          });
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
      appBar: AppBar(title: Text(l10n.createAccount)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          children: [
            Text(
              l10n.signUpTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.signUpSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: InputDecoration(labelText: l10n.email),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.password),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirm,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.confirmPassword),
              onSubmitted: (_) => _busy ? null : _submit(),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: _acceptedTerms,
              onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.acceptTerms,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: scheme.error)),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _busy ? null : _submit,
              child: Text(_busy ? l10n.signingUp : l10n.createAccount),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: _busy ? null : () => context.pop(),
                child: Text(l10n.backToLogin),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
