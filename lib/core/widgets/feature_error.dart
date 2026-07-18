import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goroute_mobile/core/network/error_mapper.dart';
import 'package:goroute_mobile/core/widgets/error_view.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';

/// Shared error UI with optional “Sign in again” when session died.
Widget buildFeatureError({
  required BuildContext context,
  required Object error,
  required VoidCallback onRetry,
}) {
  final l10n = AppLocalizations.of(context);
  final session = isSessionFailure(error);
  return ErrorView(
    message: mapErrorMessage(error, l10n),
    onRetry: session ? null : onRetry,
    secondaryLabel: session ? l10n.signInAgain : null,
    onSecondary: session ? () => context.go('/login') : null,
  );
}
