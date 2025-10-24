// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EventsNotifier)
const eventsProvider = EventsNotifierProvider._();

final class EventsNotifierProvider
    extends $AsyncNotifierProvider<EventsNotifier, List<Event>> {
  const EventsNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'eventsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$eventsNotifierHash();

  @$internal
  @override
  EventsNotifier create() => EventsNotifier();
}

String _$eventsNotifierHash() => r'b32a218bc2ed781de4d18c9330d8c7320f58056c';

abstract class _$EventsNotifier extends $AsyncNotifier<List<Event>> {
  FutureOr<List<Event>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Event>>, List<Event>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Event>>, List<Event>>,
        AsyncValue<List<Event>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(EventDetailNotifier)
const eventDetailProvider = EventDetailNotifierFamily._();

final class EventDetailNotifierProvider
    extends $AsyncNotifierProvider<EventDetailNotifier, Event?> {
  const EventDetailNotifierProvider._(
      {required EventDetailNotifierFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'eventDetailProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$eventDetailNotifierHash();

  @override
  String toString() {
    return r'eventDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EventDetailNotifier create() => EventDetailNotifier();

  @override
  bool operator ==(Object other) {
    return other is EventDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventDetailNotifierHash() =>
    r'b19a3d071f3b34a14f1e87128b0059b48ffd4fee';

final class EventDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<EventDetailNotifier, AsyncValue<Event?>, Event?,
            FutureOr<Event?>, int> {
  const EventDetailNotifierFamily._()
      : super(
          retry: null,
          name: r'eventDetailProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  EventDetailNotifierProvider call(
    int eventId,
  ) =>
      EventDetailNotifierProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventDetailProvider';
}

abstract class _$EventDetailNotifier extends $AsyncNotifier<Event?> {
  late final _$args = ref.$arg as int;
  int get eventId => _$args;

  FutureOr<Event?> build(
    int eventId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<Event?>, Event?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Event?>, Event?>,
        AsyncValue<Event?>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(UserRegisteredEventsNotifier)
const userRegisteredEventsProvider = UserRegisteredEventsNotifierFamily._();

final class UserRegisteredEventsNotifierProvider
    extends $AsyncNotifierProvider<UserRegisteredEventsNotifier, List<Event>> {
  const UserRegisteredEventsNotifierProvider._(
      {required UserRegisteredEventsNotifierFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'userRegisteredEventsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userRegisteredEventsNotifierHash();

  @override
  String toString() {
    return r'userRegisteredEventsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UserRegisteredEventsNotifier create() => UserRegisteredEventsNotifier();

  @override
  bool operator ==(Object other) {
    return other is UserRegisteredEventsNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userRegisteredEventsNotifierHash() =>
    r'1c4e0528ace0a8515a3f7f9a86fd854d955806d8';

final class UserRegisteredEventsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<UserRegisteredEventsNotifier,
            AsyncValue<List<Event>>, List<Event>, FutureOr<List<Event>>, int> {
  const UserRegisteredEventsNotifierFamily._()
      : super(
          retry: null,
          name: r'userRegisteredEventsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  UserRegisteredEventsNotifierProvider call(
    int userId,
  ) =>
      UserRegisteredEventsNotifierProvider._(argument: userId, from: this);

  @override
  String toString() => r'userRegisteredEventsProvider';
}

abstract class _$UserRegisteredEventsNotifier
    extends $AsyncNotifier<List<Event>> {
  late final _$args = ref.$arg as int;
  int get userId => _$args;

  FutureOr<List<Event>> build(
    int userId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<List<Event>>, List<Event>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Event>>, List<Event>>,
        AsyncValue<List<Event>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(UserAttendedEventsNotifier)
const userAttendedEventsProvider = UserAttendedEventsNotifierFamily._();

final class UserAttendedEventsNotifierProvider
    extends $AsyncNotifierProvider<UserAttendedEventsNotifier, List<Event>> {
  const UserAttendedEventsNotifierProvider._(
      {required UserAttendedEventsNotifierFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'userAttendedEventsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userAttendedEventsNotifierHash();

  @override
  String toString() {
    return r'userAttendedEventsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UserAttendedEventsNotifier create() => UserAttendedEventsNotifier();

  @override
  bool operator ==(Object other) {
    return other is UserAttendedEventsNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userAttendedEventsNotifierHash() =>
    r'954e9093f645743aade69747f9c7e14c6b2d427c';

final class UserAttendedEventsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<UserAttendedEventsNotifier,
            AsyncValue<List<Event>>, List<Event>, FutureOr<List<Event>>, int> {
  const UserAttendedEventsNotifierFamily._()
      : super(
          retry: null,
          name: r'userAttendedEventsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  UserAttendedEventsNotifierProvider call(
    int userId,
  ) =>
      UserAttendedEventsNotifierProvider._(argument: userId, from: this);

  @override
  String toString() => r'userAttendedEventsProvider';
}

abstract class _$UserAttendedEventsNotifier
    extends $AsyncNotifier<List<Event>> {
  late final _$args = ref.$arg as int;
  int get userId => _$args;

  FutureOr<List<Event>> build(
    int userId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<List<Event>>, List<Event>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Event>>, List<Event>>,
        AsyncValue<List<Event>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
