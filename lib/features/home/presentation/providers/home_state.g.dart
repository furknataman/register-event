// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedCategory)
const selectedCategoryProvider = SelectedCategoryProvider._();

final class SelectedCategoryProvider
    extends $NotifierProvider<SelectedCategory, int> {
  const SelectedCategoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedCategoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedCategoryHash();

  @$internal
  @override
  SelectedCategory create() => SelectedCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$selectedCategoryHash() => r'8105439d906407e17589f63990015f0c661930a1';

abstract class _$SelectedCategory extends $Notifier<int> {
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

@ProviderFor(SelectedProgramFilter)
const selectedProgramFilterProvider = SelectedProgramFilterProvider._();

final class SelectedProgramFilterProvider
    extends $NotifierProvider<SelectedProgramFilter, String?> {
  const SelectedProgramFilterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedProgramFilterProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedProgramFilterHash();

  @$internal
  @override
  SelectedProgramFilter create() => SelectedProgramFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedProgramFilterHash() =>
    r'73476ec65fcb00c7a32a094c160d28d922445ef1';

abstract class _$SelectedProgramFilter extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String?, String?>, String?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SelectedTypeFilter)
const selectedTypeFilterProvider = SelectedTypeFilterProvider._();

final class SelectedTypeFilterProvider
    extends $NotifierProvider<SelectedTypeFilter, String?> {
  const SelectedTypeFilterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedTypeFilterProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedTypeFilterHash();

  @$internal
  @override
  SelectedTypeFilter create() => SelectedTypeFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedTypeFilterHash() =>
    r'145ea730c8fe3a084fe034955cb98bb209272776';

abstract class _$SelectedTypeFilter extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String?, String?>, String?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
