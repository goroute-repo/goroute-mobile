import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goroute_mobile/core/providers/core_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeMode = 'goroute.themeMode';
const _kLocale = 'goroute.locale';

ThemeMode themeModeFromStorage(String? raw) {
  switch (raw) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

String themeModeToStorage(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return 'light';
    case ThemeMode.dark:
      return 'dark';
    case ThemeMode.system:
      return 'system';
  }
}

class ThemeModeNotifier extends Notifier<ThemeMode> {
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  ThemeMode build() => themeModeFromStorage(_prefs.getString(_kThemeMode));

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(_kThemeMode, themeModeToStorage(mode));
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

/// `null` = follow device locale (within supported en/pt).
class AppLocaleNotifier extends Notifier<Locale?> {
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  Locale? build() {
    final code = _prefs.getString(_kLocale);
    if (code == null || code.isEmpty || code == 'system') return null;
    return Locale(code);
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    if (locale == null) {
      await _prefs.setString(_kLocale, 'system');
    } else {
      await _prefs.setString(_kLocale, locale.languageCode);
    }
  }
}

final appLocaleProvider =
    NotifierProvider<AppLocaleNotifier, Locale?>(AppLocaleNotifier.new);
