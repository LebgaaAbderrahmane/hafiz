import '../entities/hifz_assignment.dart';

/// Abstract repository for hifz assignment operations.
abstract class HifzAssignmentRepository {
  /// Get all assignments for a student.
  Future<List<HifzAssignment>> getStudentAssignments({
    required String studentId,
    String? status,
  });

  /// Get all assignments for a teacher.
  Future<List<HifzAssignment>> getTeacherAssignments({
    required String teacherId,
    String? status,
  });

  /// Get all assignments for a class.
  Future<List<HifzAssignment>> getClassAssignments({
    required String classId,
    String? status,
  });

  /// Get all assignments for a branch.
  Future<List<HifzAssignment>> getBranchAssignments({
    required String branchId,
    String? status,
  });

  /// Get a single assignment by ID.
  Future<HifzAssignment?> getAssignmentById(String assignmentId);

  /// Create a new assignment.
  Future<HifzAssignment> createAssignment(HifzAssignment assignment);

  /// Update an existing assignment.
  Future<HifzAssignment> updateAssignment(HifzAssignment assignment);

  /// Delete an assignment.
  Future<void> deleteAssignment(String assignmentId);

  /// Mark assignment as completed.
  Future<HifzAssignment> completeAssignment({
    required String assignmentId,
    int? qualityTarget,
  });

  /// Get overdue assignments for a student.
  Future<List<HifzAssignment>> getOverdueAssignments(String studentId);
}
