import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/assessment.dart';

/// Assessment repository.
class AssessmentRepository {
  final SupabaseClient _client;

  AssessmentRepository(this._client);

  /// Get assessments for a branch.
  Future<List<Assessment>> getBranchAssessments({
    required String branchId,
    String? classId,
    AssessmentType? type,
  }) async {
    var query = _client
        .from('assessments')
        .select()
        .eq('branch_id', branchId);

    if (classId != null) {
      query = query.eq('class_id', classId);
    }
    if (type != null) {
      query = query.eq('type', type.name);
    }

    final data = await query.order('assessment_date', ascending: false);
    return (data as List)
        .map((json) => Assessment.fromJson(json))
        .toList();
  }

  /// Get a single assessment.
  Future<Assessment> getAssessment(String id) async {
    final data = await _client
        .from('assessments')
        .select()
        .eq('id', id)
        .single();
    return Assessment.fromJson(data);
  }

  /// Create an assessment.
  Future<Assessment> createAssessment(Assessment assessment) async {
    final data = await _client
        .from('assessments')
        .insert(assessment.toJson()..remove('id'))
        .select()
        .single();
    return Assessment.fromJson(data);
  }

  /// Update an assessment.
  Future<Assessment> updateAssessment(Assessment assessment) async {
    final data = await _client
        .from('assessments')
        .update(assessment.toJson())
        .eq('id', assessment.id)
        .select()
        .single();
    return Assessment.fromJson(data);
  }

  /// Delete an assessment.
  Future<void> deleteAssessment(String id) async {
    await _client.from('assessments').delete().eq('id', id);
  }

  /// Get results for an assessment.
  Future<List<AssessmentResult>> getAssessmentResults(
      String assessmentId) async {
    final data = await _client
        .from('assessment_results')
        .select()
        .eq('assessment_id', assessmentId)
        .order('created_at', ascending: true);
    return (data as List)
        .map((json) => AssessmentResult.fromJson(json))
        .toList();
  }

  /// Save a result for an assessment.
  Future<AssessmentResult> saveResult(AssessmentResult result) async {
    final data = await _client
        .from('assessment_results')
        .upsert(result.toJson())
        .select()
        .single();
    return AssessmentResult.fromJson(data);
  }

  /// Get student's assessment results.
  Future<List<AssessmentResult>> getStudentResults(String studentId) async {
    final data = await _client
        .from('assessment_results')
        .select()
        .eq('student_id', studentId)
        .order('created_at', ascending: false);
    return (data as List)
        .map((json) => AssessmentResult.fromJson(json))
        .toList();
  }
}
