import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/teacher.dart';
import '../domain/repositories/teacher_repository.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  final SupabaseClient _client;

  TeacherRepositoryImpl(this._client);

  SupabaseClient get _supabase => _client;

  @override
  Future<List<Teacher>> getBranchTeachers({
    required String branchId,
    String? search,
  }) async {
    var query = _supabase
        .from('teachers')
        .select()
        .eq('branch_id', branchId);

    if (search != null && search.isNotEmpty) {
      query = query.or('full_name.ilike.%$search%,email.ilike.%$search%');
    }

    final data = await query.order('full_name');
    return (data as List).map((json) => Teacher.fromJson(json)).toList();
  }

  @override
  Future<Teacher?> getTeacherById(String teacherId) async {
    final data = await _supabase
        .from('teachers')
        .select()
        .eq('id', teacherId)
        .maybeSingle();
    return data != null ? Teacher.fromJson(data) : null;
  }

  @override
  Future<Teacher> createTeacher(Teacher teacher) async {
    final data = await _supabase
        .from('teachers')
        .insert(teacher.toJson()..remove('id'))
        .select()
        .single();
    return Teacher.fromJson(data);
  }

  @override
  Future<Teacher> updateTeacher(Teacher teacher) async {
    final data = await _supabase
        .from('teachers')
        .update(teacher.toJson())
        .eq('id', teacher.id)
        .select()
        .single();
    return Teacher.fromJson(data);
  }

  @override
  Future<void> deleteTeacher(String teacherId) async {
    await _supabase.from('teachers').delete().eq('id', teacherId);
  }
}
