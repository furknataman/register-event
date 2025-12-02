import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_state.g.dart';

// Bottom bar reset için Notifier
@riverpod
class ResetBottomBar extends _$ResetBottomBar {
  @override
  int build() => 0;

  void increment() => state++;
}

// Bottom bar gizleme için Notifier (filter bottom sheet vs.)
@riverpod
class HideBottomBar extends _$HideBottomBar {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}
