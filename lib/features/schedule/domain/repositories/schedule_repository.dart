import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/features/schedule/domain/entities/schedule_event.dart';
import 'package:hafiz/features/schedule/domain/entities/session.dart';

abstract class ScheduleRepository {
  /// Get events for a date range.
  Future<Either<Failure, List<ScheduleEvent>>> getEvents({
    required String organizationId,
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
    EventType? type,
    String? classId,
    String? teacherId,
  });

  /// Get a specific event.
  Future<Either<Failure, ScheduleEvent>> getEvent(String id);

  /// Create an event.
  Future<Either<Failure, ScheduleEvent>> createEvent({
    required String organizationId,
    required String branchId,
    required String title,
    String? description,
    required EventType eventType,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    String? classId,
    String? teacherId,
    List<String>? studentIds,
    List<String>? recurrenceDays,
    String? recurrenceEndDate,
  });

  /// Update an event.
  Future<Either<Failure, ScheduleEvent>> updateEvent(
    String id, {
    String? title,
    String? description,
    EventType? eventType,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? classId,
    String? teacherId,
    List<String>? studentIds,
    List<String>? recurrenceDays,
    String? recurrenceEndDate,
    EventStatus? status,
    String? notes,
  });

  /// Delete an event.
  Future<Either<Failure, void>> deleteEvent(String id);

  /// Get sessions for a date range.
  Future<Either<Failure, List<Session>>> getSessions({
    required String organizationId,
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
    SessionType? type,
    String? classId,
    String? teacherId,
  });

  /// Get a specific session.
  Future<Either<Failure, Session>> getSession(String id);

  /// Create a session.
  Future<Either<Failure, Session>> createSession({
    required String organizationId,
    required String branchId,
    required String title,
    String? description,
    required SessionType type,
    required DateTime date,
    required String startTime,
    required String endTime,
    required String classId,
    required String teacherId,
    List<String>? studentIds,
    String? location,
  });

  /// Update a session.
  Future<Either<Failure, Session>> updateSession(
    String id, {
    String? title,
    String? description,
    SessionType? type,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? classId,
    String? teacherId,
    List<String>? studentIds,
    String? location,
    SessionStatus? status,
    String? notes,
  });

  /// Delete a session.
  Future<Either<Failure, void>> deleteSession(String id);
}
