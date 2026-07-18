import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goroute_mobile/app.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('shows Sign in when no session', (tester) async {
    final overrides = await testProviderOverrides();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [...overrides],
        child: const GoRouteApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sign in'), findsWidgets);
    expect(find.textContaining('career'), findsOneWidget);
  });
}
