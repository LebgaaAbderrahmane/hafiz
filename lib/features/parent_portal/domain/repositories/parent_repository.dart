import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/features/parent_portal/domain/entities/parent_student.dart';

abstract class ParentRepository {
  /// Get students linked to the current parent via student_guardians table.
  Future<Either<Failure, List<ParentStudent>>> getLinkedStudents({
    required String parentId,
    required String organizationId,
  });

  /// Get attendance records for a student within a date range.
  Future<Either<Failure, List<ParentAttendanceRecord>>> getStudentAttendance({
    required String studentId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get recent tasmi sessions for a student.
  Future<Either<Failure, List<ParentTasmiSummary>>> getRecentTasmiSessions({
    required String studentId,
    int limit = 10,
  });

  /// Get upcoming sessions for a student.
  Future<Either<Failure, List<ParentUpcomingSession>>> getUpcomingSessions({
    required String studentId,
    required String organizationId,
  });
}
