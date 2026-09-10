import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hafiz/features/tasmi/domain/entities/tasmi_session.dart';
import 'package:hafiz/features/tasmi/domain/repositories/tasmi_repository.dart';

class TasmiRepositoryImpl implements TasmiRepository {
  final SupabaseClient _client;

  TasmiRepositoryImpl(this._client);

  SupabaseClient get _supabase => _client;

  @override
  Future<List<TasmiSession>> getStudentSessions(String studentId) async {
    final data = await _supabase
        .from('tasmi_sessions')
        .select()
        .eq('student_id', studentId)
        .order('recorded_at', ascending: false);
    return (data as List)
        .map((json) => TasmiSession.fromJson(json))
        .toList();
  }

  @override
  Future<List<TasmiSession>> getTeacherSessions(String teacherId) async {
    final data = await _supabase
        .from('tasmi_sessions')
        .select()
        .eq('teacher_id', teacherId)
        .order('recorded_at', ascending: false);
    return (data as List)
        .map((json) => TasmiSession.fromJson(json))
        .toList();
  }

  @override
  Future<TasmiSession?> getSession(String id) async {
    final data = await _supabase
        .from('tasmi_sessions')
        .select()
        .eq('id', id)
        .maybeSingle();
    return data != null ? TasmiSession.fromJson(data) : null;
  }

  @override
  Future<TasmiSession> createSession(TasmiSession session) async {
    final data = await _supabase
        .from('tasmi_sessions')
        .insert(session.toJson()..remove('id'))
        .select()
        .single();
    return TasmiSession.fromJson(data);
  }

  @override
  Future<TasmiSession> updateSession(TasmiSession session) async {
    final data = await _supabase
        .from('tasmi_sessions')
        .update(session.toJson())
        .eq('id', session.id)
        .select()
        .single();
    return TasmiSession.fromJson(data);
  }

  @override
  Future<void> deleteSession(String id) async {
    await _supabase.from('tasmi_sessions').delete().eq('id', id);
  }

  @override
  Future<void> addErrors({
    required String sessionId,
    required List<TasmiError> errors,
  }) async {
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

    await _supabase.from('tasmi_errors').insert(records);
  }
}
