import '../entities/revision.dart';

/// Abstract repository for revision operations.
abstract class RevisionRepository {
  /// Get all revisions for a student.
  Future<List<Revision>> getStudentRevisions({
    required String studentId,
    String? status,
    String? priority,
  });

  /// Get all revisions for a teacher.
  Future<List<Revision>> getTeacherRevisions({
    required String teacherId,
    String? status,
    String? priority,
  });

  /// Get all revisions for a class.
  Future<List<Revision>> getClassRevisions({
    required String classId,
    String? status,
    String? priority,
  });

  /// Get all revisions for a branch.
  Future<List<Revision>> getBranchRevisions({
    required String branchId,
    String? status,
    String? priority,
  });

  /// Get a single revision by ID.
  Future<Revision?> getRevisionById(String revisionId);

  /// Create a new revision.
  Future<Revision> createRevision(Revision revision);

  /// Update an existing revision.
  Future<Revision> updateRevision(Revision revision);

  /// Delete a revision.
  Future<void> deleteRevision(String revisionId);

  /// Mark a revision as completed.
  Future<Revision> completeRevision({
    required String revisionId,
    required int qualityScore,
  });

  /// Get overdue revisions for a student.
  Future<List<Revision>> getOverdueRevisions(String studentId);

  /// Get upcoming revisions for a student.
  Future<List<Revision>> getUpcomingRevisions(String studentId);

  /// Get revision statistics for a student.
  Future<Map<String, dynamic>> getStudentRevisionStats(String studentId);
}
