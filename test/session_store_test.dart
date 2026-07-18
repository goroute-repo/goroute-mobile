import 'package:flutter_test/flutter_test.dart';
import 'package:goroute_mobile/core/auth/session_store.dart';

void main() {
  test('saveSession stores session + mapper; clear wipes (RS-01 memory kv)', () async {
    final store = SessionStore(kv: MemorySecureKv());
    expect(await store.hasSession, isFalse);

    await store.saveSession(
      sessionId: 'sess-1',
      mapperApi: 'map-1',
      role: 'professional',
    );
    expect(await store.hasSession, isTrue);
    expect(await store.readSessionId(), 'sess-1');
    expect(await store.readMapperApi(), 'map-1');
    expect(await store.readRole(), 'professional');

    await store.clear();
    expect(await store.hasSession, isFalse);
    expect(await store.readSessionId(), isNull);
  });
}
