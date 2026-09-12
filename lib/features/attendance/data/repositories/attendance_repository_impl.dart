import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hafiz/features/attendance/domain/entities/attendance.dart';
import 'package:hafiz/features/attendance/domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final SupabaseClient _client;

  AttendanceRepositoryImpl(this._client);

  SupabaseClient get _supabase => _client;

  @override
  Future<List<Attendance>> getSessionAttendance(String sessionId) async {
    final data = await _supabase
        .from('attendance')
        .select()
        .eq('session_id', sessionId)
        .order('created_at', ascending: true);
    return (data as List)
        .map((json) => Attendance.fromJson(json))
        .toList();
  }

  @override
  Future<List<Attendance>> getStudentAttendance(
    String studentId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var query = _supabase
        .from('attendance')
        .select()
        .eq('student_id', studentId);

    if (startDate != null) {
      query = query.gte('date', startDate.toIso8601String());
    }
    if (endDate != null) {
      query = query.lte('date', endDate.toIso8601String());
    }

    final data = await query.order('date', ascending: false);
    return (data as List)
        .map((json) => Attendance.fromJson(json))
        .toList();
  }

  @override
  Future<List<Attendance>> getClassAttendance(
    String classId,
    DateTime date,
  ) async {
    final data = await _supabase
        .from('attendance')
        .select()
        .eq('class_id', classId)
        .eq('date', date.toIso8601String().split('T')[0])
        .order('created_at', ascending: true);
    return (data as List)
        .map((json) => Attendance.fromJson(json))
        .toList();
  }

  @override
  Future<Attendance> markAttendance({
    required String organizationId,
    required String branchId,
    required String studentId,
    required String sessionId,
    required String classId,
    required AttendanceStatus status,
    String? notes,
    String? markedBy,
  }) async {
    final attendance = Attendance(
      id: '',
      organizationId: organizationId,
      branchId: branchId,
      studentId: studentId,
      sessionId: sessionId,
      classId: classId,
      status: status,
      notes: notes,
      markedBy: markedBy,
      createdAt: DateTime.now(),
    );

    final data = await _supabase
        .from('attendance')
        .insert(attendance.toJson()..remove('id'))
        .select()
        .single();
    return Attendance.fromJson(data);
  }

  @override
  Future<Attendance> updateAttendance(
    String id, {
    AttendanceStatus? status,
    String? notes,
  }) async {
    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (status != null) updates['status'] = status.name;
    if (notes != null) updates['notes'] = notes;

    final data = await _supabase
        .from('attendance')
        .update(updates)
        .eq('id', id)
        .select()
        .single();
    return Attendance.fromJson(data);
  }

  @override
  Future<List<Attendance>> bulkMarkAttendance({
    required String organizationId,
    required String branchId,
    required String sessionId,
    required String classId,
    required Map<String, AttendanceStatus> studentStatuses,
    String? markedBy,
  }) async {
    final records = studentStatuses.entries
        .map((entry) => {
              'organization_id': organizationId,
              'branch_id': branchId,
              'student_id': entry.key,
              'session_id': sessionId,
              'class_id': classId,
              'status': entry.value.name,
              'marked_by': markedBy,
            })
        .toList();

    final data = await _supabase
        .from('attendance')
        .insert(records)
        .select();
    return (data as List)
        .map((json) => Attendance.fromJson(json))
        .toList();
  }

  @override
  Future<void> deleteAttendance(String id) async {
    await _supabase.from('attendance').delete().eq('id', id);
  }
}
