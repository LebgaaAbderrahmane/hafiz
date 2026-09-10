import '../entities/teacher.dart';

/// Abstract repository for teacher operations.
abstract class TeacherRepository {
  /// Get all teachers for a branch.
  Future<List<Teacher>> getBranchTeachers({
    required String branchId,
    String? search,
  });

  /// Get a single teacher by ID.
  Future<Teacher?> getTeacherById(String teacherId);

  /// Create a new teacher.
  Future<Teacher> createTeacher(Teacher teacher);

  /// Update an existing teacher.
  Future<Teacher> updateTeacher(Teacher teacher);

  /// Delete a teacher.
  Future<void> deleteTeacher(String teacherId);
}
