import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_state.g.dart';

// Seçili kategori için Notifier
// 0 = Tümü, 1 = Kayıt Olduklarım, 2 = Oturum 1, 3 = Oturum 2, 4 = Oturum 3, 5 = Oturum 4
@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  int build() => 0;

  void set(int value) => state = value;
}

// Program filter için Notifier (PYP, MYP, DP)
// null = Hepsi
@riverpod
class SelectedProgramFilter extends _$SelectedProgramFilter {
  @override
  String? build() => null;

  void set(String? value) => state = value;
}

// Type filter için Notifier (Sunum, Atölye)
// null = Hepsi
@riverpod
class SelectedTypeFilter extends _$SelectedTypeFilter {
  @override
  String? build() => null;

  void set(String? value) => state = value;
}

// PageController için Provider - Event cards sayfaları için
final categoryPageControllerProvider = Provider<PageController>((ref) {
  final controller = PageController(initialPage: 0);
  ref.onDispose(() => controller.dispose());
  return controller;
});

// ScrollController için Provider - Kategori chips listesi için
final chipScrollControllerProvider = Provider<ScrollController>((ref) {
  final controller = ScrollController();
  ref.onDispose(() => controller.dispose());
  return controller;
});
