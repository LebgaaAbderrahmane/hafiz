import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/exceptions.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/core/network/supabase_client.dart';
import 'package:hafiz/features/quran/domain/entities/surah.dart';
import 'package:hafiz/features/quran/domain/entities/juz.dart';
import 'package:hafiz/features/quran/domain/entities/memorization_plan.dart';
import 'package:hafiz/features/quran/domain/repositories/curriculum_repository.dart';

class CurriculumRepositoryImpl implements CurriculumRepository {
  @override
  Future<Either<Failure, List<Surah>>> getSurahs() async {
    try {
      final data = await supabase
          .from('quran_surahs')
          .select()
          .order('number', ascending: true);
      final surahs = data.map((json) => Surah.fromJson(json)).toList();
      return Right(surahs);
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Surah>> getSurah(int number) async {
    try {
      final data = await supabase
          .from('quran_surahs')
          .select()
          .eq('number', number)
          .single();
      return Right(Surah.fromJson(data));
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Juz>>> getJuzs() async {
    try {
      final data = await supabase
          .from('quran_juzs')
          .select()
          .order('number', ascending: true);
      final juzs = data.map((json) => Juz.fromJson(json)).toList();
      return Right(juzs);
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Juz>> getJuz(int number) async {
    try {
      final data = await supabase
          .from('quran_juzs')
          .select()
          .eq('number', number)
          .single();
      return Right(Juz.fromJson(data));
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MemorizationPlan>>> getStudentPlans(
    String studentId,
  ) async {
    try {
      final data = await supabase
          .from('memorization_plans')
          .select()
          .eq('student_id', studentId)
          .order('created_at', ascending: false);
      final plans =
          data.map((json) => MemorizationPlan.fromJson(json)).toList();
      return Right(plans);
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MemorizationPlan>>> getTeacherPlans(
    String teacherId,
  ) async {
    try {
      final data = await supabase
          .from('memorization_plans')
          .select()
          .eq('teacher_id', teacherId)
          .order('created_at', ascending: false);
      final plans =
          data.map((json) => MemorizationPlan.fromJson(json)).toList();
      return Right(plans);
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MemorizationPlan>> getPlan(String id) async {
    try {
      final data = await supabase
          .from('memorization_plans')
          .select()
          .eq('id', id)
          .single();
      return Right(MemorizationPlan.fromJson(data));
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final data = await supabase
          .from('memorization_plans')
          .insert({
            'student_id': studentId,
            'teacher_id': teacherId,
            'organization_id': organizationId,
            'class_id': classId,
            'status': MemorizationStatus.notStarted.name,
            'priority': priority.name,
            'current_surah': startSurah,
            'current_ayah': startAyah,
            'target_surah': targetSurah,
            'target_ayah': targetAyah,
          })
          .select()
          .single();
      return Right(MemorizationPlan.fromJson(data));
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MemorizationPlan>> updatePlan(
    String id, {
    MemorizationStatus? status,
    MemorizationPriority? priority,
    int? currentSurah,
    int? currentAyah,
    int? targetSurah,
    int? targetAyah,
    String? notes,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (status != null) updates['status'] = status.name;
      if (priority != null) updates['priority'] = priority.name;
      if (currentSurah != null) updates['current_surah'] = currentSurah;
      if (currentAyah != null) updates['current_ayah'] = currentAyah;
      if (targetSurah != null) updates['target_surah'] = targetSurah;
      if (targetAyah != null) updates['target_ayah'] = targetAyah;
      if (notes != null) updates['notes'] = notes;

      if (status == MemorizationStatus.completed) {
        updates['completed_at'] = DateTime.now().toIso8601String();
      }

      final data = await supabase
          .from('memorization_plans')
          .update(updates)
          .eq('id', id)
          .select()
          .single();
      return Right(MemorizationPlan.fromJson(data));
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MemorizationCheckpoint>> addCheckpoint(
    String planId, {
    required int surahNumber,
    required int startAyah,
    required int endAyah,
  }) async {
    try {
      final data = await supabase
          .from('memorization_checkpoints')
          .insert({
            'plan_id': planId,
            'surah_number': surahNumber,
            'start_ayah': startAyah,
            'end_ayah': endAyah,
            'status': CheckpointStatus.pending.name,
          })
          .select()
          .single();
      return Right(MemorizationCheckpoint.fromJson(data));
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MemorizationCheckpoint>> updateCheckpoint(
    String checkpointId, {
    required CheckpointStatus status,
    int? qualityScore,
    String? teacherNotes,
  }) async {
    try {
      final updates = <String, dynamic>{
        'status': status.name,
      };

      if (qualityScore != null) updates['quality_score'] = qualityScore;
      if (teacherNotes != null) updates['teacher_notes'] = teacherNotes;
      if (status == CheckpointStatus.completed) {
        updates['completed_at'] = DateTime.now().toIso8601String();
      }

      final data = await supabase
          .from('memorization_checkpoints')
          .update(updates)
          .eq('id', checkpointId)
          .select()
          .single();
      return Right(MemorizationCheckpoint.fromJson(data));
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final data = await supabase
          .from('memorization_sessions')
          .insert({
            'plan_id': planId,
            'date': date.toIso8601String(),
            'duration_minutes': durationMinutes,
            'from_surah': fromSurah,
            'from_ayah': fromAyah,
            'to_surah': toSurah,
            'to_ayah': toAyah,
            'quality_score': qualityScore,
            'notes': notes,
          })
          .select()
          .single();
      return Right(MemorizationSession.fromJson(data));
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePlan(String id) async {
    try {
      await supabase.from('memorization_plans').delete().eq('id', id);
      return const Right(null);
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
