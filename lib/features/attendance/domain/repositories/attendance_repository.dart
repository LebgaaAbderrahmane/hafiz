import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/features/attendance/domain/entities/attendance.dart';

abstract class AttendanceRepository {
  /// Get attendance for a session.
  Future<Either<Failure, List<Attendance>>> getSessionAttendance(
    String sessionId,
  );

  /// Get attendance for a student.
  Future<Either<Failure, List<Attendance>>> getStudentAttendance(
    String studentId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get attendance for a class on a date.
  Future<Either<Failure, List<Attendance>>> getClassAttendance(
    String classId,
    DateTime date,
  );

  /// Mark attendance for a student.
  Future<Either<Failure, Attendance>> markAttendance({
    required String studentId,
    required String sessionId,
    required String classId,
    required AttendanceStatus status,
    String? notes,
    String? markedBy,
  });

  /// Update attendance.
  Future<Either<Failure, Attendance>> updateAttendance(
    String id, {
    AttendanceStatus? status,
    String? checkInTime,
    String? checkOutTime,
    String? notes,
  });

  /// Bulk mark attendance for a session.
  Future<Either<Failure, List<Attendance>>> bulkMarkAttendance({
    required String sessionId,
    required String classId,
    required Map<String, AttendanceStatus> studentStatuses,
    String? markedBy,
  });

  /// Delete attendance record.
  Future<Either<Failure, void>> deleteAttendance(String id);
}
