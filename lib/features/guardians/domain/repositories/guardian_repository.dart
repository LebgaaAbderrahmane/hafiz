import '../entities/guardian.dart';

/// Abstract repository for guardian operations.
abstract class GuardianRepository {
  /// Get all guardians for a branch.
  Future<List<Guardian>> getBranchGuardians({
    required String branchId,
    String? search,
  });

  /// Get all guardians for a student.
  Future<List<Guardian>> getStudentGuardians(String studentId);

  /// Get a single guardian by ID.
  Future<Guardian?> getGuardianById(String guardianId);

  /// Create a new guardian.
  Future<Guardian> createGuardian(Guardian guardian);

  /// Update an existing guardian.
  Future<Guardian> updateGuardian(Guardian guardian);

  /// Delete a guardian.
  Future<void> deleteGuardian(String guardianId);

  /// Link a guardian to a student.
  Future<void> linkGuardianToStudent({
    required String guardianId,
    required String studentId,
    required String relationship,
  });

  /// Unlink a guardian from a student.
  Future<void> unlinkGuardianFromStudent({
    required String guardianId,
    required String studentId,
  });

  /// Get student-guardian relationships.
  Future<List<Map<String, dynamic>>> getStudentGuardianRelationships(
      String studentId);
}
