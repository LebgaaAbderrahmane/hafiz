import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/features/quran/domain/entities/surah.dart';
import 'package:hafiz/features/quran/domain/entities/juz.dart';
import 'package:hafiz/features/quran/domain/entities/memorization_plan.dart';

abstract class CurriculumRepository {
  /// Get all Surahs.
  Future<Either<Failure, List<Surah>>> getSurahs();

  /// Get a specific Surah.
  Future<Either<Failure, Surah>> getSurah(int number);

  /// Get all Juz.
  Future<Either<Failure, List<Juz>>> getJuzs();

  /// Get a specific Juz.
  Future<Either<Failure, Juz>> getJuz(int number);

  /// Get memorization plans for a student.
  Future<Either<Failure, List<MemorizationPlan>>> getStudentPlans(
    String studentId,
  );

  /// Get memorization plans for a teacher.
  Future<Either<Failure, List<MemorizationPlan>>> getTeacherPlans(
    String teacherId,
  );

  /// Get a specific memorization plan.
  Future<Either<Failure, MemorizationPlan>> getPlan(String id);

  /// Create a memorization plan.
  Future<Either<Failure, MemorizationPlan>> createPlan({
    required String studentId,
    required String teacherId,
    required String organizationId,
    String? classId,
    required MemorizationPriority priority,
    required int startSurah,
    required int startAyah,
    required int targetSurah,
    required int targetAyah,
  });

  /// Update a memorization plan.
  Future<Either<Failure, MemorizationPlan>> updatePlan(
    String id, {
    MemorizationStatus? status,
    MemorizationPriority? priority,
    int? currentSurah,
    int? currentAyah,
    int? targetSurah,
    int? targetAyah,
    String? notes,
  });

  /// Add a checkpoint to a plan.
  Future<Either<Failure, MemorizationCheckpoint>> addCheckpoint(
    String planId, {
    required int surahNumber,
    required int startAyah,
    required int endAyah,
  });

  /// Update checkpoint status.
  Future<Either<Failure, MemorizationCheckpoint>> updateCheckpoint(
    String checkpointId, {
    required CheckpointStatus status,
    int? qualityScore,
    String? teacherNotes,
  });

  /// Add a session to a plan.
  Future<Either<Failure, MemorizationSession>> addSession(
    String planId, {
    required DateTime date,
    required int durationMinutes,
    required String fromSurah,
    required int fromAyah,
    required String toSurah,
    required int toAyah,
    int? qualityScore,
    String? notes,
  });

  /// Delete a plan.
  Future<Either<Failure, void>> deletePlan(String id);
}
