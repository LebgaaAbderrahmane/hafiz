import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/revision.dart';
import '../repositories/revision_repository.dart';

class RevisionRepositoryImpl implements RevisionRepository {
  final SupabaseClient _client;

  RevisionRepositoryImpl(this._client);

  SupabaseClient get _supabase => _client;

  @override
  Future<List<Revision>> getStudentRevisions({
    required String studentId,
    String? status,
    String? priority,
  }) async {
    var query = _supabase
        .from('revisions')
        .select()
        .eq('student_id', studentId);

    if (status != null) {
      query = query.eq('status', status);
    }
    if (priority != null) {
      query = query.eq('priority', priority);
    }

    final data = await query.order('due_date', ascending: true);
    return (data as List).map((json) => Revision.fromJson(json)).toList();
  }

  @override
  Future<List<Revision>> getTeacherRevisions({
    required String teacherId,
    String? status,
    String? priority,
  }) async {
    var query = _supabase
        .from('revisions')
        .select()
        .eq('teacher_id', teacherId);

    if (status != null) {
      query = query.eq('status', status);
    }
    if (priority != null) {
      query = query.eq('priority', priority);
    }

    final data = await query.order('due_date', ascending: true);
    return (data as List).map((json) => Revision.fromJson(json)).toList();
  }

  @override
  Future<List<Revision>> getClassRevisions({
    required String classId,
    String? status,
    String? priority,
  }) async {
    var query = _supabase
        .from('revisions')
        .select()
        .eq('class_id', classId);

    if (status != null) {
      query = query.eq('status', status);
    }
    if (priority != null) {
      query = query.eq('priority', priority);
    }

    final data = await query.order('due_date', ascending: true);
    return (data as List).map((json) => Revision.fromJson(json)).toList();
  }

  @override
  Future<List<Revision>> getBranchRevisions({
    required String branchId,
    String? status,
    String? priority,
  }) async {
    var query = _supabase
        .from('revisions')
        .select()
        .eq('branch_id', branchId);

    if (status != null) {
      query = query.eq('status', status);
    }
    if (priority != null) {
      query = query.eq('priority', priority);
    }

    final data = await query.order('due_date', ascending: true);
    return (data as List).map((json) => Revision.fromJson(json)).toList();
  }

  @override
  Future<Revision?> getRevisionById(String revisionId) async {
    final data = await _supabase
        .from('revisions')
        .select()
        .eq('id', revisionId)
        .maybeSingle();
    return data != null ? Revision.fromJson(data) : null;
  }

  @override
  Future<Revision> createRevision(Revision revision) async {
    final data = await _supabase
        .from('revisions')
        .insert(revision.toJson())
        .select()
        .single();
    return Revision.fromJson(data);
  }

  @override
  Future<Revision> updateRevision(Revision revision) async {
    final data = await _supabase
        .from('revisions')
        .update(revision.toJson())
        .eq('id', revision.id)
        .select()
        .single();
    return Revision.fromJson(data);
  }

  @override
  Future<void> deleteRevision(String revisionId) async {
    await _supabase.from('revisions').delete().eq('id', revisionId);
  }

  @override
  Future<Revision> completeRevision({
    required String revisionId,
    required int qualityScore,
  }) async {
    final data = await _supabase
        .from('revisions')
        .update({
          'status': RevisionStatus.completed.name,
          'quality_score': qualityScore,
          'completed_date': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', revisionId)
        .select()
        .single();
    return Revision.fromJson(data);
  }

  @override
  Future<List<Revision>> getOverdueRevisions(String studentId) async {
    final now = DateTime.now().toIso8601String();
    final data = await _supabase
        .from('revisions')
        .select()
        .eq('student_id', studentId)
        .lt('due_date', now)
        .not('status', 'eq', RevisionStatus.completed.name)
        .order('due_date', ascending: true);
    return (data as List).map((json) => Revision.fromJson(json)).toList();
  }

  @override
  Future<List<Revision>> getUpcomingRevisions(String studentId) async {
    final now = DateTime.now().toIso8601String();
    final data = await _supabase
        .from('revisions')
        .select()
        .eq('student_id', studentId)
        .gte('due_date', now)
        .order('due_date', ascending: true);
    return (data as List).map((json) => Revision.fromJson(json)).toList();
  }

  @override
  Future<Map<String, dynamic>> getStudentRevisionStats(String studentId) async {
    final revisions = await getStudentRevisions(studentId: studentId);
    final now = DateTime.now();

    final completed = revisions.where(
        (r) => r.status == RevisionStatus.completed).length;
    final pending = revisions.where(
        (r) => r.status == RevisionStatus.pending).length;
    final overdue = revisions.where((r) =>
        r.dueDate != null &&
        r.dueDate!.isBefore(now) &&
        r.status != RevisionStatus.completed).length;
    final inProgress = revisions.where(
        (r) => r.status == RevisionStatus.inProgress).length;

    final avgScore = revisions
        .where((r) => r.qualityScore != null)
        .fold<double>(0, (sum, r) => sum + r.qualityScore!) /
        (revisions.where((r) => r.qualityScore != null).length.clamp(1, 999));

    return {
      'total': revisions.length,
      'completed': completed,
      'pending': pending,
      'overdue': overdue,
      'inProgress': inProgress,
      'averageScore': avgScore.round(),
      'completionRate': revisions.isNotEmpty
          ? ((completed / revisions.length) * 100).round()
          : 0,
    };
  }
}
