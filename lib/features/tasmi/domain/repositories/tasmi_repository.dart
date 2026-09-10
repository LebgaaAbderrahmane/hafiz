import '../entities/tasmi_session.dart';

/// Abstract repository for tasmi operations.
abstract class TasmiRepository {
  /// Get tasmi sessions for a student.
  Future<List<TasmiSession>> getStudentSessions(String studentId);

  /// Get tasmi sessions by a teacher.
  Future<List<TasmiSession>> getTeacherSessions(String teacherId);

  /// Get a specific tasmi session.
  Future<TasmiSession?> getSession(String id);

  /// Create a tasmi session.
  Future<TasmiSession> createSession(TasmiSession session);

  /// Update a tasmi session.
  Future<TasmiSession> updateSession(TasmiSession session);

  /// Delete a tasmi session.
  Future<void> deleteSession(String id);

  /// Add errors to a session.
  Future<void> addErrors({
    required String sessionId,
    required List<TasmiError> errors,
  });
}
