import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/features/tasmi/domain/entities/tasmi_session.dart';

abstract class TasmiRepository {
  /// Get tasmi sessions for a student.
  Future<Either<Failure, List<TasmiSession>>> getStudentSessions(
    String studentId, {
    int limit = 50,
    int offset = 0,
  });

  /// Get tasmi sessions by a teacher.
  Future<Either<Failure, List<TasmiSession>>> getTeacherSessions(
    String teacherId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get a specific tasmi session.
  Future<Either<Failure, TasmiSession>> getSession(String id);

  /// Create a tasmi session (record evaluation).
  Future<Either<Failure, TasmiSession>> createSession({
    required String studentId,
    required String teacherId,
    required String sessionId,
    String? classId,
    required int startSurah,
    required int startAyah,
    required int endSurah,
    required int endAyah,
    required TasmiSessionType sessionType,
    required TasmiOutcome outcome,
    int? accuracyScore,
    int? tajwidScore,
    int? fluencyScore,
    int? overallRating,
    String? teacherNotes,
  });

  /// Update a tasmi session.
  Future<Either<Failure, TasmiSession>> updateSession(
    String id, {
    TasmiOutcome? outcome,
    int? accuracyScore,
    int? tajwidScore,
    int? fluencyScore,
    int? overallRating,
    String? teacherNotes,
  });

  /// Add errors to a session.
  Future<Either<Failure, List<TasmiError>>> addErrors(
    String sessionId, {
    required List<TasmiError> errors,
  });

  /// Delete a tasmi session.
  Future<Either<Failure, void>> deleteSession(String id);
}
