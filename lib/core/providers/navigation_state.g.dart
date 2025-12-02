// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ResetBottomBar)
const resetBottomBarProvider = ResetBottomBarProvider._();

final class ResetBottomBarProvider
    extends $NotifierProvider<ResetBottomBar, int> {
  const ResetBottomBarProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'resetBottomBarProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$resetBottomBarHash();

  @$internal
  @override
  ResetBottomBar create() => ResetBottomBar();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$resetBottomBarHash() => r'2d3baff5c6e2b87144cfbb8f6b52b1e16714f26e';

abstract class _$ResetBottomBar extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(HideBottomBar)
const hideBottomBarProvider = HideBottomBarProvider._();

final class HideBottomBarProvider
    extends $NotifierProvider<HideBottomBar, bool> {
  const HideBottomBarProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'hideBottomBarProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$hideBottomBarHash();

  @$internal
  @override
  HideBottomBar create() => HideBottomBar();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hideBottomBarHash() => r'233adb9a930e8580485825abce18e6329e18f52a';

abstract class _$HideBottomBar extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
