import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autumn_conference/db/sharedPreferences/theme_mode_stroge.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = await getThemeMode();
    if (savedTheme != null) {
      state = savedTheme;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await saveThemeMode(mode);
    state = mode;
  }

  Future<void> setLight() async {
    await setThemeMode(ThemeMode.light);
  }

  Future<void> setDark() async {
    await setThemeMode(ThemeMode.dark);
  }

  Future<void> setSystem() async {
    await setThemeMode(ThemeMode.system);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

// Backward compatibility - deprecated
@Deprecated('Use themeModeProvider instead')
final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>(
  (ref) => DarkModeNotifier(),
);

// Backward compatibility class - deprecated
@Deprecated('Use ThemeModeNotifier instead')
class DarkModeNotifier extends StateNotifier<bool> {
  DarkModeNotifier() : super(false) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final themeData = await getThemeData();
    final isDarkMode = themeData ?? false;
    state = isDarkMode;
  }

  Future<void> toggle() async {
    await setThemeData(!state);
    state = !state;
  }
}
