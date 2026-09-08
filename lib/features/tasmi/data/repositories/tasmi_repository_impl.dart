import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/exceptions.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/core/network/supabase_client.dart';
import 'package:hafiz/features/tasmi/domain/entities/tasmi_session.dart';
import 'package:hafiz/features/tasmi/domain/repositories/tasmi_repository.dart';

class TasmiRepositoryImpl implements TasmiRepository {
  @override
  Future<Either<Failure, List<TasmiSession>>> getStudentSessions(
    String studentId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final data = await supabase
          .from('tasmi_sessions')
          .select()
          .eq('student_id', studentId)
          .order('recorded_at', ascending: false)
          .range(offset, offset + limit - 1);
      final sessions =
          data.map((json) => TasmiSession.fromJson(json)).toList();
      return Right(sessions);
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<TasmiSession>>> getTeacherSessions(
    String teacherId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = supabase
          .from('tasmi_sessions')
          .select()
          .eq('teacher_id', teacherId)
          .order('recorded_at', ascending: false);

      if (startDate != null) {
        query = query.gte('recorded_at', startDate.toIso8601String());
      }

      if (endDate != null) {
        query = query.lte('recorded_at', endDate.toIso8601String());
      }

      final data = await query;
      final sessions =
          data.map((json) => TasmiSession.fromJson(json)).toList();
      return Right(sessions);
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, TasmiSession>> getSession(String id) async {
    try {
      final data = await supabase
          .from('tasmi_sessions')
          .select()
          .eq('id', id)
          .single();
      return Right(TasmiSession.fromJson(data));
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, TasmiSession>> createSession({
    required String studentId,
    required String teacherId,
    required String sessionId,
    String? classId,
    required int startSurah,
    required int startAyah,
    required int endSurah,
    required int endAyah,
    required TasmiSessionType sessionType,
    required TasmiOutcome outcome,
    int? accuracyScore,
    int? tajwidScore,
    int? fluencyScore,
    int? overallRating,
    String? teacherNotes,
  }) async {
    try {
      final data = await supabase
          .from('tasmi_sessions')
          .insert({
            'student_id': studentId,
            'teacher_id': teacherId,
            'session_id': sessionId,
            'class_id': classId,
            'start_surah': startSurah,
            'start_ayah': startAyah,
            'end_surah': endSurah,
            'end_ayah': endAyah,
            'session_type': sessionType.name,
            'outcome': outcome.name,
            'accuracy_score': accuracyScore,
            'tajwid_score': tajwidScore,
            'fluency_score': fluencyScore,
            'overall_rating': overallRating,
            'teacher_notes': teacherNotes,
            'recorded_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();
      return Right(TasmiSession.fromJson(data));
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, TasmiSession>> updateSession(
    String id, {
    TasmiOutcome? outcome,
    int? accuracyScore,
    int? tajwidScore,
    int? fluencyScore,
    int? overallRating,
    String? teacherNotes,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (outcome != null) updates['outcome'] = outcome.name;
      if (accuracyScore != null) updates['accuracy_score'] = accuracyScore;
      if (tajwidScore != null) updates['tajwid_score'] = tajwidScore;
      if (fluencyScore != null) updates['fluency_score'] = fluencyScore;
      if (overallRating != null) updates['overall_rating'] = overallRating;
      if (teacherNotes != null) updates['teacher_notes'] = teacherNotes;

      final data = await supabase
          .from('tasmi_sessions')
          .update(updates)
          .eq('id', id)
          .select()
          .single();
      return Right(TasmiSession.fromJson(data));
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<TasmiError>>> addErrors(
    String sessionId, {
    required List<TasmiError> errors,
  }) async {
    try {
      final records = errors
          .map((e) => {
                'session_id': sessionId,
                'surah_number': e.surahNumber,
                'ayah_number': e.ayahNumber,
                'word_location': e.wordLocation,
                'error_type': e.errorType.name,
                'severity': e.severity?.name,
                'notes': e.notes,
              })
          .toList();

      final data = await supabase
          .from('tasmi_errors')
          .insert(records)
          .select();

      final savedErrors =
          data.map((json) => TasmiError.fromJson(json)).toList();
      return Right(savedErrors);
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSession(String id) async {
    try {
      await supabase.from('tasmi_sessions').delete().eq('id', id);
      return const Right(null);
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
