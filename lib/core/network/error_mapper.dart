import 'package:dio/dio.dart';
import 'package:goroute_mobile/core/network/api_exception.dart';
import 'package:goroute_mobile/features/auth/auth_repository.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';

/// Maps Dio / auth / API failures to user-facing copy.
String mapErrorMessage(Object error, AppLocalizations l10n) {
  if (error is ApiException) {
    if (error.isPremiumRequired) return l10n.premiumRequired;
    if (error.isAiManagedNotEntitled) return l10n.aiManagedNotEntitled;
    if (error.isNotEligible) return l10n.jobApplyNotEligible;
    if (error.isUnauthorized) return l10n.sessionExpired;
    if (error.message.toLowerCase().contains('connection')) {
      return l10n.connectionError;
    }
    return error.message;
  }
  if (error is AuthException) {
    if (error.code == 'NETWORK' ||
        error.message.toLowerCase().contains('connection')) {
      return l10n.connectionError;
    }
    if (looksLikeSessionError(error.message)) return l10n.sessionExpired;
    return error.message;
  }
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return l10n.connectionError;
      default:
        break;
    }
    final mapped = mapDioToApiException(error, l10n.unexpectedError);
    if (mapped.isPremiumRequired) return l10n.premiumRequired;
    if (mapped.isAiManagedNotEntitled) return l10n.aiManagedNotEntitled;
    if (mapped.isNotEligible) return l10n.jobApplyNotEligible;
    if (mapped.isUnauthorized) return l10n.sessionExpired;
    if (error.message?.toLowerCase().contains('connection') == true) {
      return l10n.connectionError;
    }
    return mapped.message;
  }
  final text = error.toString();
  if (looksLikeSessionError(text)) return l10n.sessionExpired;
  if (text.toLowerCase().contains('connection')) {
    return l10n.connectionError;
  }
  return l10n.unexpectedError;
}

bool isSessionFailure(Object error) {
  if (error is ApiException) return error.isUnauthorized;
  if (error is DioException) {
    return mapDioToApiException(error, '').isUnauthorized;
  }
  return looksLikeSessionError(error.toString());
}
