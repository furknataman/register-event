import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_remote_datasource.dart';
import '../datasources/event_local_datasource.dart';
import '../models/event_model.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource _remoteDataSource;
  final EventLocalDataSource _localDataSource;

  EventRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Either<Failure, List<Event>>> getAllEvents() async {
    try {
      // Try to get events from remote
      final remoteEvents = await _remoteDataSource.getAllEvents();
      final events = remoteEvents.map((model) => model.toDomain()).toList();
      
      // Cache the events locally
      await _localDataSource.cacheEvents(remoteEvents);
      
      return Right(events);
    } on NetworkException catch (e) {
      // If network fails, try to get cached events
      try {
        final cachedEvents = await _localDataSource.getCachedEvents();
        if (cachedEvents != null) {
          final events = cachedEvents.map((model) => model.toDomain()).toList();
          return Right(events);
        }
        return Left(NetworkFailure(e.message));
      } catch (cacheError) {
        return Left(NetworkFailure(e.message));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Event>> getEventById(int id) async {
    try {
      // Try to get event from remote
      final remoteEvent = await _remoteDataSource.getEventById(id);
      final event = remoteEvent.toDomain();
      
      // Cache the event locally
      await _localDataSource.cacheEvent(remoteEvent);
      
      return Right(event);
    } on NetworkException catch (e) {
      // If network fails, try to get cached event
      try {
        final cachedEvent = await _localDataSource.getCachedEvent(id);
        if (cachedEvent != null) {
          return Right(cachedEvent.toDomain());
        }
        return Left(NetworkFailure(e.message));
      } catch (cacheError) {
        return Left(NetworkFailure(e.message));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> registerForEvent(int userId, int eventId) async {
    try {
      final result = await _remoteDataSource.registerForEvent(userId, eventId);
      
      // Clear cache to force refresh on next load
      await _localDataSource.clearCache();
      
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> unregisterFromEvent(int userId, int eventId) async {
    try {
      final result = await _remoteDataSource.unregisterFromEvent(userId, eventId);
      
      // Clear cache to force refresh on next load
      await _localDataSource.clearCache();
      
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> markAttendance(int userId, int eventId) async {
    try {
      final result = await _remoteDataSource.markAttendance(userId, eventId);
      
      // Clear cache to force refresh on next load
      await _localDataSource.clearCache();
      
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getUserRegisteredEvents(int userId) async {
    try {
      final remoteEvents = await _remoteDataSource.getUserRegisteredEvents(userId);
      final events = remoteEvents.map((model) => model.toDomain()).toList();
      
      return Right(events);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getUserAttendedEvents(int userId) async {
    try {
      final remoteEvents = await _remoteDataSource.getUserAttendedEvents(userId);
      final events = remoteEvents.map((model) => model.toDomain()).toList();
      
      return Right(events);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }
}