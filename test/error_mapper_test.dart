import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goroute_mobile/core/network/api_exception.dart';
import 'package:goroute_mobile/core/network/error_mapper.dart';
import 'package:goroute_mobile/features/auth/auth_repository.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';

void main() {
  Future<AppLocalizations> l10nFor(WidgetTester tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    return l10n;
  }

  testWidgets('maps connection Dio errors to connectionError', (tester) async {
    final l10n = await l10nFor(tester);
    final msg = mapErrorMessage(
      DioException(
        requestOptions: RequestOptions(path: '/x'),
        type: DioExceptionType.connectionError,
      ),
      l10n,
    );
    expect(msg, l10n.connectionError);
  });

  testWidgets('maps NETWORK AuthException to connectionError', (tester) async {
    final l10n = await l10nFor(tester);
    final msg = mapErrorMessage(
      AuthException('Connection refused', code: 'NETWORK'),
      l10n,
    );
    expect(msg, l10n.connectionError);
  });

  testWidgets('maps PREMIUM_REQUIRED ApiException', (tester) async {
    final l10n = await l10nFor(tester);
    final msg = mapErrorMessage(
      ApiException('need plan', code: 'PREMIUM_REQUIRED', statusCode: 403),
      l10n,
    );
    expect(msg, l10n.premiumRequired);
  });

  testWidgets('keeps AuthException message for other codes', (tester) async {
    final l10n = await l10nFor(tester);
    final msg = mapErrorMessage(
      AuthException('Invalid email or password', code: 'INVALID_CREDENTIALS'),
      l10n,
    );
    expect(msg, 'Invalid email or password');
  });

  testWidgets('maps session failures to sessionExpired', (tester) async {
    final l10n = await l10nFor(tester);
    final msg = mapErrorMessage(
      ApiException(
        'Invalid or missing session',
        code: 'UNAUTHORIZED',
        statusCode: 401,
      ),
      l10n,
    );
    expect(msg, l10n.sessionExpired);
    expect(
      isSessionFailure(
        DioException(
          requestOptions: RequestOptions(path: '/x'),
          response: Response(
            requestOptions: RequestOptions(path: '/x'),
            statusCode: 401,
            data: {'message': 'Invalid or missing session'},
          ),
        ),
      ),
      isTrue,
    );
  });
}
