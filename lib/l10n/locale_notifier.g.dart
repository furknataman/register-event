// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocaleNotifier)
const localeProvider = LocaleNotifierProvider._();

final class LocaleNotifierProvider
    extends $AsyncNotifierProvider<LocaleNotifier, Locale> {
  const LocaleNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'localeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$localeNotifierHash();

  @$internal
  @override
  LocaleNotifier create() => LocaleNotifier();
}

String _$localeNotifierHash() => r'b79c070d43540213d93c2678cbedbd2d32b7a4d3';

abstract class _$LocaleNotifier extends $AsyncNotifier<Locale> {
  FutureOr<Locale> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Locale>, Locale>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Locale>, Locale>,
        AsyncValue<Locale>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
