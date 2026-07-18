import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goroute_mobile/app.dart';
import 'package:goroute_mobile/core/auth/session_store.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('session present redirects to home shell', (tester) async {
    final store = SessionStore(kv: MemorySecureKv());
    await store.saveSession(sessionId: 'sid-1', mapperApi: 'mapper-1');
    final overrides = await testProviderOverrides(sessionStore: store);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [...overrides],
        child: const GoRouteApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text('Sign in'), findsNothing);
    expect(find.text('Home'), findsWidgets);
  });
}
