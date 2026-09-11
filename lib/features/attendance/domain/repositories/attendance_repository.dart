import 'package:hafiz/features/attendance/domain/entities/attendance.dart';

/// Abstract repository for attendance operations.
abstract class AttendanceRepository {
  /// Get attendance for a session.
  Future<List<Attendance>> getSessionAttendance(String sessionId);

  /// Get attendance for a student.
  Future<List<Attendance>> getStudentAttendance(
    String studentId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get attendance for a class on a date.
  Future<List<Attendance>> getClassAttendance(
    String classId,
    DateTime date,
  );

  /// Mark attendance for a student.
  Future<Attendance> markAttendance({
    required String organizationId,
    required String branchId,
    required String studentId,
    required String sessionId,
    required String classId,
    required AttendanceStatus status,
    String? notes,
    String? markedBy,
  });

  /// Update attendance.
  Future<Attendance> updateAttendance(
    String id, {
    AttendanceStatus? status,
    String? notes,
  });

  /// Bulk mark attendance for a session.
  Future<List<Attendance>> bulkMarkAttendance({
    required String sessionId,
    required String classId,
    required Map<String, AttendanceStatus> studentStatuses,
    String? markedBy,
  });

  /// Delete attendance record.
  Future<void> deleteAttendance(String id);
}
