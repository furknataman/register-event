import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/dependency_injection/injection.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';

part 'event_provider.g.dart';

// Event repository provider
final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return getIt<EventRepository>();
});

// All events provider
@riverpod
class EventsNotifier extends _$EventsNotifier {
  @override
  FutureOr<List<Event>> build() async {
    final repository = ref.read(eventRepositoryProvider);
    final result = await repository.getAllEvents();
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (events) => events,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    
    final repository = ref.read(eventRepositoryProvider);
    final result = await repository.getAllEvents();
    
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (events) => AsyncValue.data(events),
    );
  }

  Future<bool> registerForEvent(int userId, int eventId) async {
    final repository = ref.read(eventRepositoryProvider);
    final result = await repository.registerForEvent(userId, eventId);
    
    return result.fold(
      (failure) {
        // You might want to show an error message here
        return false;
      },
      (success) {
        if (success) {
          // Refresh the events list
          refresh();
        }
        return success;
      },
    );
  }

  Future<bool> unregisterFromEvent(int userId, int eventId) async {
    final repository = ref.read(eventRepositoryProvider);
    final result = await repository.unregisterFromEvent(userId, eventId);
    
    return result.fold(
      (failure) => false,
      (success) {
        if (success) {
          // Refresh the events list
          refresh();
        }
        return success;
      },
    );
  }

  Future<bool> markAttendance(int userId, int eventId) async {
    final repository = ref.read(eventRepositoryProvider);
    final result = await repository.markAttendance(userId, eventId);
    
    return result.fold(
      (failure) => false,
      (success) {
        if (success) {
          // Refresh the events list
          refresh();
        }
        return success;
      },
    );
  }
}

// Single event provider
@riverpod
class EventDetailNotifier extends _$EventDetailNotifier {
  @override
  FutureOr<Event?> build(int eventId) async {
    final repository = ref.read(eventRepositoryProvider);
    final result = await repository.getEventById(eventId);
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (event) => event,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    
    final repository = ref.read(eventRepositoryProvider);
    final result = await repository.getEventById(eventId);
    
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (event) => AsyncValue.data(event),
    );
  }
}

// User registered events provider
@riverpod
class UserRegisteredEventsNotifier extends _$UserRegisteredEventsNotifier {
  @override
  FutureOr<List<Event>> build(int userId) async {
    final repository = ref.read(eventRepositoryProvider);
    final result = await repository.getUserRegisteredEvents(userId);
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (events) => events,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    
    final repository = ref.read(eventRepositoryProvider);
    final result = await repository.getUserRegisteredEvents(userId);
    
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (events) => AsyncValue.data(events),
    );
  }
}

// User attended events provider
@riverpod
class UserAttendedEventsNotifier extends _$UserAttendedEventsNotifier {
  @override
  FutureOr<List<Event>> build(int userId) async {
    final repository = ref.read(eventRepositoryProvider);
    final result = await repository.getUserAttendedEvents(userId);
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (events) => events,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    
    final repository = ref.read(eventRepositoryProvider);
    final result = await repository.getUserAttendedEvents(userId);
    
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (events) => AsyncValue.data(events),
    );
  }
}