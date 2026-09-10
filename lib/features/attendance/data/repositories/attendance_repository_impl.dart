import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/exceptions.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/core/network/supabase_client.dart';
import 'package:hafiz/features/attendance/domain/entities/attendance.dart';
import 'package:hafiz/features/attendance/domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  @override
  Future<Either<Failure, List<Attendance>>> getSessionAttendance(
    String sessionId,
  ) async {
    try {
      final data = await supabase
          .from('attendance')
          .select()
          .eq('session_id', sessionId)
          .order('created_at', ascending: true);
      final records =
          data.map((json) => Attendance.fromJson(json)).toList();
      return Right(records);
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Attendance>>> getStudentAttendance(
    String studentId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = supabase
          .from('attendance')
          .select()
          .eq('student_id', studentId)
          .order('created_at', ascending: false);

      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }

      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
      }

      final data = await query;
      final records =
          data.map((json) => Attendance.fromJson(json)).toList();
      return Right(records);
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Attendance>>> getClassAttendance(
    String classId,
    DateTime date,
  ) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final data = await supabase
          .from('attendance')
          .select()
          .eq('class_id', classId)
          .gte('created_at', startOfDay.toIso8601String())
          .lt('created_at', endOfDay.toIso8601String())
          .order('created_at', ascending: true);

      final records =
          data.map((json) => Attendance.fromJson(json)).toList();
      return Right(records);
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Attendance>> markAttendance({
    required String studentId,
    required String sessionId,
    required String classId,
    required AttendanceStatus status,
    String? notes,
    String? markedBy,
  }) async {
    try {
      final data = await supabase
          .from('attendance')
          .insert({
            'student_id': studentId,
            'session_id': sessionId,
            'class_id': classId,
            'status': status.name,
            'notes': notes,
            'marked_by': markedBy,
          })
          .select()
          .single();
      return Right(Attendance.fromJson(data));
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Attendance>> updateAttendance(
    String id, {
    AttendanceStatus? status,
    String? checkInTime,
    String? checkOutTime,
    String? notes,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (status != null) updates['status'] = status.name;
      if (checkInTime != null) updates['check_in_time'] = checkInTime;
      if (checkOutTime != null) updates['check_out_time'] = checkOutTime;
      if (notes != null) updates['notes'] = notes;

      final data = await supabase
          .from('attendance')
          .update(updates)
          .eq('id', id)
          .select()
          .single();
      return Right(Attendance.fromJson(data));
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Attendance>>> bulkMarkAttendance({
    required String sessionId,
    required String classId,
    required Map<String, AttendanceStatus> studentStatuses,
    String? markedBy,
  }) async {
    try {
      final records = <Map<String, dynamic>>[];
      for (final entry in studentStatuses.entries) {
        records.add({
          'student_id': entry.key,
          'session_id': sessionId,
          'class_id': classId,
          'status': entry.value.name,
          'marked_by': markedBy,
        });
      }

      final data = await supabase
          .from('attendance')
          .upsert(records, onConflict: 'student_id,session_id')
          .select();

      final attendance =
          data.map((json) => Attendance.fromJson(json)).toList();
      return Right(attendance);
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAttendance(String id) async {
    try {
      await supabase.from('attendance').delete().eq('id', id);
      return const Right(null);
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
