import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight JSON read-cache for last successful roadmap/weekly payloads.
class JsonReadCache {
  JsonReadCache(this._prefs);

  final SharedPreferences _prefs;

  static const roadmapMeKey = 'cache_roadmap_me_v1';
  static const weeklyPlanKey = 'cache_weekly_plan_v1';

  Future<void> write(String key, Map<String, dynamic> json) async {
    await _prefs.setString(key, jsonEncode(json));
  }

  Map<String, dynamic>? read(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    return null;
  }

  Future<void> clear(String key) => _prefs.remove(key);
}
