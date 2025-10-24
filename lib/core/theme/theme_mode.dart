import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:autumn_conference/core/data/local/theme_mode_stroge.dart';

part 'theme_mode.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  Future<ThemeMode> build() async {
    final savedTheme = await getThemeMode();
    return savedTheme ?? ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await saveThemeMode(mode);
    state = AsyncValue.data(mode);
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
