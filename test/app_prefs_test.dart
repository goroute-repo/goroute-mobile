import 'package:flutter_test/flutter_test.dart';
import 'package:goroute_mobile/core/prefs/app_prefs.dart';
import 'package:flutter/material.dart';

void main() {
  test('themeModeFromStorage maps known values', () {
    expect(themeModeFromStorage(null), ThemeMode.system);
    expect(themeModeFromStorage('light'), ThemeMode.light);
    expect(themeModeFromStorage('dark'), ThemeMode.dark);
    expect(themeModeToStorage(ThemeMode.system), 'system');
  });
}
