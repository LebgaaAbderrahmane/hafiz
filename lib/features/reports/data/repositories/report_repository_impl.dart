import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final SupabaseClient _client;

  ReportRepositoryImpl(this._client);

  SupabaseClient get _supabase => _client;

  @override
  Future<List<Report>> getBranchReports({
    required String branchId,
    ReportType? type,
  }) async {
    var query = _supabase
        .from('reports')
        .select()
        .eq('branch_id', branchId);

    if (type != null) {
      query = query.eq('type', type.name);
    }

    final data = await query.order('created_at', ascending: false);
    return (data as List).map((json) => Report.fromJson(json)).toList();
  }

  @override
  Future<Report?> getReportById(String reportId) async {
    final data = await _supabase
        .from('reports')
        .select()
        .eq('id', reportId)
        .maybeSingle();
    return data != null ? Report.fromJson(data) : null;
  }

  @override
  Future<Report> generateReport({
    required String organizationId,
    required String branchId,
    required String generatedById,
    required ReportType type,
    required String title,
    Map<String, dynamic>? parameters,
    ReportFormat? format,
  }) async {
    final now = DateTime.now();
    final report = Report(
      id: '',
      organizationId: organizationId,
      branchId: branchId,
      generatedById: generatedById,
      type: type,
      title: title,
      parameters: parameters,
      format: format ?? ReportFormat.pdf,
      generatedAt: now,
      createdAt: now,
    );

    final data = await _supabase
        .from('reports')
        .insert(report.toJson()..remove('id'))
        .select()
        .single();
    return Report.fromJson(data);
  }

  @override
  Future<void> deleteReport(String reportId) async {
    await _supabase.from('reports').delete().eq('id', reportId);
  }

  @override
  Future<Map<String, dynamic>> getAttendanceReportData({
    required String branchId,
    required DateTime startDate,
    required DateTime endDate,
    String? classId,
    String? studentId,
  }) async {
    var query = _supabase
        .from('attendance')
        .select()
        .eq('branch_id', branchId)
        .gte('date', startDate.toIso8601String())
        .lte('date', endDate.toIso8601String());

    if (classId != null) {
      query = query.eq('class_id', classId);
    }
    if (studentId != null) {
      query = query.eq('student_id', studentId);
    }

    final data = await query;
    return {
      'records': data,
      'total': data.length,
      'present': (data as List).where((r) => r['status'] == 'present').length,
      'absent': data.where((r) => r['status'] == 'absent').length,
      'late': data.where((r) => r['status'] == 'late').length,
    };
  }

  @override
  Future<Map<String, dynamic>> getMemorizationProgressData({
    required String branchId,
    required DateTime startDate,
    required DateTime endDate,
    String? classId,
    String? studentId,
  }) async {
    var query = _supabase
        .from('hifz_assignments')
        .select()
        .eq('branch_id', branchId)
        .gte('created_at', startDate.toIso8601String())
        .lte('created_at', endDate.toIso8601String());

    if (studentId != null) {
      query = query.eq('student_id', studentId);
    }

    final data = await query;
    return {
      'assignments': data,
      'total': (data as List).length,
      'completed': data.where((r) => r['status'] == 'completed').length,
      'inProgress': data.where((r) => r['status'] == 'in_progress').length,
    };
  }

  @override
  Future<Map<String, dynamic>> getTasmiSummaryData({
    required String branchId,
    required DateTime startDate,
    required DateTime endDate,
    String? classId,
    String? studentId,
  }) async {
    var query = _supabase
        .from('tasmi_sessions')
        .select()
        .eq('branch_id', branchId)
        .gte('created_at', startDate.toIso8601String())
        .lte('created_at', endDate.toIso8601String());

    if (studentId != null) {
      query = query.eq('student_id', studentId);
    }

    final data = await query;
    return {
      'sessions': data,
      'total': (data as List).length,
      'passed': data.where((r) => r['outcome'] == 'passed').length,
      'needsReview': data.where((r) => r['outcome'] == 'needs_review').length,
    };
  }
}
