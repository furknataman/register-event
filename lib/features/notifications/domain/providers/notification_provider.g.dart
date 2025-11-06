// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotificationList)
const notificationListProvider = NotificationListProvider._();

final class NotificationListProvider
    extends $NotifierProvider<NotificationList, NotificationState> {
  const NotificationListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificationListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificationListHash();

  @$internal
  @override
  NotificationList create() => NotificationList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationState>(value),
    );
  }
}

String _$notificationListHash() => r'6052feb1660cd9315c6cf0fb149217528e453368';

abstract class _$NotificationList extends $Notifier<NotificationState> {
  NotificationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<NotificationState, NotificationState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<NotificationState, NotificationState>,
        NotificationState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(unreadCount)
const unreadCountProvider = UnreadCountProvider._();

final class UnreadCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  const UnreadCountProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'unreadCountProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$unreadCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return unreadCount(ref);
  }
}

String _$unreadCountHash() => r'5cdf3da668d74cb5687883ff1771037f6f29809d';
