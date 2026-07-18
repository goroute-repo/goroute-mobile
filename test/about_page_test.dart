import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goroute_mobile/features/more/about_page.dart';
import 'package:goroute_mobile/l10n/app_localizations.dart';

void main() {
  testWidgets('AboutPage shows ASO title and product help', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: AboutPage(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('GoRoute: Career Plan'), findsOneWidget);
    expect(find.text('Track, skills and matched jobs'), findsOneWidget);
    expect(find.text('What GoRoute does'), findsOneWidget);
    expect(find.text('How to use the app'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Privacy'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Privacy'), findsOneWidget);
  });
}
