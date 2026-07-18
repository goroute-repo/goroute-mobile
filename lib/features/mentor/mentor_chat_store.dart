import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goroute_mobile/core/providers/core_providers.dart';
import 'package:goroute_mobile/features/mentor/mentor_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Session-scoped mentor chat history (cleared on logout).
class MentorChatStore {
  MentorChatStore(this._prefs);

  final SharedPreferences _prefs;
  static const storageKey = 'mentor_chat_session_v1';

  List<MentorChatMessage> load() {
    final raw = _prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];
    return decoded
        .whereType<Map>()
        .map((e) => MentorChatMessage.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> save(List<MentorChatMessage> messages) async {
    final payload = messages.map((m) => m.toJson()).toList();
    await _prefs.setString(storageKey, jsonEncode(payload));
  }

  Future<void> clear() => _prefs.remove(storageKey);
}

final mentorChatStoreProvider = Provider<MentorChatStore>((ref) {
  return MentorChatStore(ref.watch(sharedPreferencesProvider));
});
