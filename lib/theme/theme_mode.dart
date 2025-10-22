import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autumn_conference/db/sharedPreferences/theme_mode_stroge.dart';

class DarkModeNotifier extends StateNotifier<bool> {
  DarkModeNotifier() : super(false) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final themeData = await getThemeData();
    final isDarkMode = themeData ?? ThemeMode.system == ThemeMode.dark;
    state = isDarkMode;
  }

  Future<void> toggle() async {
    setThemeData(!state);
    state = !state;
  }
}

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>(
  (ref) => DarkModeNotifier(),
);
