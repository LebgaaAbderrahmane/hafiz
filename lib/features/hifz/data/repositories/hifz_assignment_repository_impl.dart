import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hafiz/features/hifz/domain/entities/hifz_assignment.dart';
import 'package:hafiz/features/hifz/domain/repositories/hifz_assignment_repository.dart';

class HifzAssignmentRepositoryImpl implements HifzAssignmentRepository {
  final SupabaseClient _client;

  HifzAssignmentRepositoryImpl(this._client);

  SupabaseClient get _supabase => _client;

  @override
  Future<List<HifzAssignment>> getStudentAssignments({
    required String studentId,
    String? status,
  }) async {
    var query = _supabase
        .from('hifz_assignments')
        .select()
        .eq('student_id', studentId);

    if (status != null) {
      query = query.eq('status', status);
    }

    final data = await query.order('created_at', ascending: false);
    return (data as List)
        .map((json) => HifzAssignment.fromJson(json))
        .toList();
  }

  @override
  Future<List<HifzAssignment>> getTeacherAssignments({
    required String teacherId,
    String? status,
  }) async {
    var query = _supabase
        .from('hifz_assignments')
        .select()
        .eq('teacher_id', teacherId);

    if (status != null) {
      query = query.eq('status', status);
    }

    final data = await query.order('created_at', ascending: false);
    return (data as List)
        .map((json) => HifzAssignment.fromJson(json))
        .toList();
  }

  @override
  Future<List<HifzAssignment>> getClassAssignments({
    required String classId,
    String? status,
  }) async {
    var query = _supabase
        .from('hifz_assignments')
        .select()
        .eq('class_id', classId);

    if (status != null) {
      query = query.eq('status', status);
    }

    final data = await query.order('created_at', ascending: false);
    return (data as List)
        .map((json) => HifzAssignment.fromJson(json))
        .toList();
  }

  @override
  Future<List<HifzAssignment>> getBranchAssignments({
    required String branchId,
    String? status,
  }) async {
    var query = _supabase
        .from('hifz_assignments')
        .select()
        .eq('branch_id', branchId);

    if (status != null) {
      query = query.eq('status', status);
    }

    final data = await query.order('created_at', ascending: false);
    return (data as List)
        .map((json) => HifzAssignment.fromJson(json))
        .toList();
  }

  @override
  Future<HifzAssignment?> getAssignmentById(String assignmentId) async {
    final data = await _supabase
        .from('hifz_assignments')
        .select()
        .eq('id', assignmentId)
        .maybeSingle();
    return data != null ? HifzAssignment.fromJson(data) : null;
  }

  @override
  Future<HifzAssignment> createAssignment(HifzAssignment assignment) async {
    final data = await _supabase
        .from('hifz_assignments')
        .insert(assignment.toJson()..remove('id'))
        .select()
        .single();
    return HifzAssignment.fromJson(data);
  }

  @override
  Future<HifzAssignment> updateAssignment(HifzAssignment assignment) async {
    final data = await _supabase
        .from('hifz_assignments')
        .update(assignment.toJson())
        .eq('id', assignment.id)
        .select()
        .single();
    return HifzAssignment.fromJson(data);
  }

  @override
  Future<void> deleteAssignment(String assignmentId) async {
    await _supabase.from('hifz_assignments').delete().eq('id', assignmentId);
  }

  @override
  Future<HifzAssignment> completeAssignment({
    required String assignmentId,
    int? qualityTarget,
  }) async {
    final data = await _supabase
        .from('hifz_assignments')
        .update({
          'status': AssignmentStatus.completed.name,
          'quality_target': qualityTarget,
          'completed_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', assignmentId)
        .select()
        .single();
    return HifzAssignment.fromJson(data);
  }

  @override
  Future<List<HifzAssignment>> getOverdueAssignments(String studentId) async {
    final now = DateTime.now().toIso8601String();
    final data = await _supabase
        .from('hifz_assignments')
        .select()
        .eq('student_id', studentId)
        .lt('due_date', now)
        .not('status', 'eq', AssignmentStatus.completed.name)
        .order('due_date', ascending: true);
    return (data as List)
        .map((json) => HifzAssignment.fromJson(json))
        .toList();
  }
}
