import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Key-value backend for session secrets (RS-01).
abstract class SecureKv {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
}

class FlutterSecureKv implements SecureKv {
  FlutterSecureKv([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

class MemorySecureKv implements SecureKv {
  final Map<String, String> _map = {};

  @override
  Future<void> write(String key, String value) async => _map[key] = value;

  @override
  Future<String?> read(String key) async => _map[key];

  @override
  Future<void> delete(String key) async => _map.remove(key);
}

/// RS-01 — session + mapper in Keychain/Keystore only (never SharedPreferences).
class SessionStore {
  SessionStore({SecureKv? kv}) : _kv = kv ?? FlutterSecureKv();

  static const _kSessionId = 'goroute_session_id';
  static const _kMapper = 'goroute_mapper_api';
  static const _kRole = 'goroute_role';

  final SecureKv _kv;

  Future<void> saveSession({
    required String sessionId,
    required String mapperApi,
    String? role,
  }) async {
    await _kv.write(_kSessionId, sessionId);
    await _kv.write(_kMapper, mapperApi);
    if (role != null) {
      await _kv.write(_kRole, role);
    }
  }

  Future<String?> readSessionId() => _kv.read(_kSessionId);

  Future<String?> readMapperApi() => _kv.read(_kMapper);

  Future<String?> readRole() => _kv.read(_kRole);

  Future<bool> get hasSession async {
    final sid = await readSessionId();
    final mapper = await readMapperApi();
    return (sid != null && sid.isNotEmpty) &&
        (mapper != null && mapper.isNotEmpty);
  }

  Future<void> clear() async {
    await _kv.delete(_kSessionId);
    await _kv.delete(_kMapper);
    await _kv.delete(_kRole);
  }
}
