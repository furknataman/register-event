// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventsNotifierHash() => r'b32a218bc2ed781de4d18c9330d8c7320f58056c';

/// See also [EventsNotifier].
@ProviderFor(EventsNotifier)
final eventsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<EventsNotifier, List<Event>>.internal(
  EventsNotifier.new,
  name: r'eventsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EventsNotifier = AutoDisposeAsyncNotifier<List<Event>>;
String _$eventDetailNotifierHash() =>
    r'b19a3d071f3b34a14f1e87128b0059b48ffd4fee';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$EventDetailNotifier
    extends BuildlessAutoDisposeAsyncNotifier<Event?> {
  late final int eventId;

  FutureOr<Event?> build(
    int eventId,
  );
}

/// See also [EventDetailNotifier].
@ProviderFor(EventDetailNotifier)
const eventDetailNotifierProvider = EventDetailNotifierFamily();

/// See also [EventDetailNotifier].
class EventDetailNotifierFamily extends Family<AsyncValue<Event?>> {
  /// See also [EventDetailNotifier].
  const EventDetailNotifierFamily();

  /// See also [EventDetailNotifier].
  EventDetailNotifierProvider call(
    int eventId,
  ) {
    return EventDetailNotifierProvider(
      eventId,
    );
  }

  @override
  EventDetailNotifierProvider getProviderOverride(
    covariant EventDetailNotifierProvider provider,
  ) {
    return call(
      provider.eventId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'eventDetailNotifierProvider';
}

/// See also [EventDetailNotifier].
class EventDetailNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<EventDetailNotifier, Event?> {
  /// See also [EventDetailNotifier].
  EventDetailNotifierProvider(
    int eventId,
  ) : this._internal(
          () => EventDetailNotifier()..eventId = eventId,
          from: eventDetailNotifierProvider,
          name: r'eventDetailNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventDetailNotifierHash,
          dependencies: EventDetailNotifierFamily._dependencies,
          allTransitiveDependencies:
              EventDetailNotifierFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  EventDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.eventId,
  }) : super.internal();

  final int eventId;

  @override
  FutureOr<Event?> runNotifierBuild(
    covariant EventDetailNotifier notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(EventDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: EventDetailNotifierProvider._internal(
        () => create()..eventId = eventId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        eventId: eventId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<EventDetailNotifier, Event?>
      createElement() {
    return _EventDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventDetailNotifierProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EventDetailNotifierRef on AutoDisposeAsyncNotifierProviderRef<Event?> {
  /// The parameter `eventId` of this provider.
  int get eventId;
}

class _EventDetailNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EventDetailNotifier, Event?>
    with EventDetailNotifierRef {
  _EventDetailNotifierProviderElement(super.provider);

  @override
  int get eventId => (origin as EventDetailNotifierProvider).eventId;
}

String _$userRegisteredEventsNotifierHash() =>
    r'1c4e0528ace0a8515a3f7f9a86fd854d955806d8';

abstract class _$UserRegisteredEventsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Event>> {
  late final int userId;

  FutureOr<List<Event>> build(
    int userId,
  );
}

/// See also [UserRegisteredEventsNotifier].
@ProviderFor(UserRegisteredEventsNotifier)
const userRegisteredEventsNotifierProvider =
    UserRegisteredEventsNotifierFamily();

/// See also [UserRegisteredEventsNotifier].
class UserRegisteredEventsNotifierFamily
    extends Family<AsyncValue<List<Event>>> {
  /// See also [UserRegisteredEventsNotifier].
  const UserRegisteredEventsNotifierFamily();

  /// See also [UserRegisteredEventsNotifier].
  UserRegisteredEventsNotifierProvider call(
    int userId,
  ) {
    return UserRegisteredEventsNotifierProvider(
      userId,
    );
  }

  @override
  UserRegisteredEventsNotifierProvider getProviderOverride(
    covariant UserRegisteredEventsNotifierProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userRegisteredEventsNotifierProvider';
}

/// See also [UserRegisteredEventsNotifier].
class UserRegisteredEventsNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UserRegisteredEventsNotifier,
        List<Event>> {
  /// See also [UserRegisteredEventsNotifier].
  UserRegisteredEventsNotifierProvider(
    int userId,
  ) : this._internal(
          () => UserRegisteredEventsNotifier()..userId = userId,
          from: userRegisteredEventsNotifierProvider,
          name: r'userRegisteredEventsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userRegisteredEventsNotifierHash,
          dependencies: UserRegisteredEventsNotifierFamily._dependencies,
          allTransitiveDependencies:
              UserRegisteredEventsNotifierFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserRegisteredEventsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final int userId;

  @override
  FutureOr<List<Event>> runNotifierBuild(
    covariant UserRegisteredEventsNotifier notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(UserRegisteredEventsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserRegisteredEventsNotifierProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UserRegisteredEventsNotifier,
      List<Event>> createElement() {
    return _UserRegisteredEventsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserRegisteredEventsNotifierProvider &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserRegisteredEventsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<Event>> {
  /// The parameter `userId` of this provider.
  int get userId;
}

class _UserRegisteredEventsNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        UserRegisteredEventsNotifier,
        List<Event>> with UserRegisteredEventsNotifierRef {
  _UserRegisteredEventsNotifierProviderElement(super.provider);

  @override
  int get userId => (origin as UserRegisteredEventsNotifierProvider).userId;
}

String _$userAttendedEventsNotifierHash() =>
    r'954e9093f645743aade69747f9c7e14c6b2d427c';

abstract class _$UserAttendedEventsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Event>> {
  late final int userId;

  FutureOr<List<Event>> build(
    int userId,
  );
}

/// See also [UserAttendedEventsNotifier].
@ProviderFor(UserAttendedEventsNotifier)
const userAttendedEventsNotifierProvider = UserAttendedEventsNotifierFamily();

/// See also [UserAttendedEventsNotifier].
class UserAttendedEventsNotifierFamily extends Family<AsyncValue<List<Event>>> {
  /// See also [UserAttendedEventsNotifier].
  const UserAttendedEventsNotifierFamily();

  /// See also [UserAttendedEventsNotifier].
  UserAttendedEventsNotifierProvider call(
    int userId,
  ) {
    return UserAttendedEventsNotifierProvider(
      userId,
    );
  }

  @override
  UserAttendedEventsNotifierProvider getProviderOverride(
    covariant UserAttendedEventsNotifierProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userAttendedEventsNotifierProvider';
}

/// See also [UserAttendedEventsNotifier].
class UserAttendedEventsNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UserAttendedEventsNotifier,
        List<Event>> {
  /// See also [UserAttendedEventsNotifier].
  UserAttendedEventsNotifierProvider(
    int userId,
  ) : this._internal(
          () => UserAttendedEventsNotifier()..userId = userId,
          from: userAttendedEventsNotifierProvider,
          name: r'userAttendedEventsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userAttendedEventsNotifierHash,
          dependencies: UserAttendedEventsNotifierFamily._dependencies,
          allTransitiveDependencies:
              UserAttendedEventsNotifierFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserAttendedEventsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final int userId;

  @override
  FutureOr<List<Event>> runNotifierBuild(
    covariant UserAttendedEventsNotifier notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(UserAttendedEventsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserAttendedEventsNotifierProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UserAttendedEventsNotifier,
      List<Event>> createElement() {
    return _UserAttendedEventsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserAttendedEventsNotifierProvider &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserAttendedEventsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<Event>> {
  /// The parameter `userId` of this provider.
  int get userId;
}

class _UserAttendedEventsNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserAttendedEventsNotifier,
        List<Event>> with UserAttendedEventsNotifierRef {
  _UserAttendedEventsNotifierProviderElement(super.provider);

  @override
  int get userId => (origin as UserAttendedEventsNotifierProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
