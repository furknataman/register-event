import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/event.dart';

abstract class EventRepository {
  Future<Either<Failure, List<Event>>> getAllEvents();
  Future<Either<Failure, Event>> getEventById(int id);
  Future<Either<Failure, bool>> registerForEvent(int userId, int eventId);
  Future<Either<Failure, bool>> unregisterFromEvent(int userId, int eventId);
  Future<Either<Failure, bool>> markAttendance(int userId, int eventId);
  Future<Either<Failure, List<Event>>> getUserRegisteredEvents(int userId);
  Future<Either<Failure, List<Event>>> getUserAttendedEvents(int userId);
}