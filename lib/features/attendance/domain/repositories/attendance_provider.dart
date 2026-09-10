import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/attendance.dart';
import '../domain/repositories/attendance_repository.dart';
import '../data/repositories/attendance_repository_impl.dart';
import '../../../core/network/supabase_client.dart';

/// Attendance repository provider.
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AttendanceRepositoryImpl(client);
});

/// Session attendance provider.
final sessionAttendanceProvider = FutureProvider.autoDispose
    .family<List<Attendance>, String>((ref, sessionId) async {
  final repo = ref.read(attendanceRepositoryProvider);
  return repo.getSessionAttendance(sessionId);
});

/// Class attendance for a date provider.
final classAttendanceProvider = FutureProvider.autoDispose
    .family<List<Attendance>, ({String classId, DateTime date})>(
        (ref, params) async {
  final repo = ref.read(attendanceRepositoryProvider);
  return repo.getClassAttendance(params.classId, params.date);
});

/// Student attendance provider.
final studentAttendanceProvider = FutureProvider.autoDispose
    .family<List<Attendance>, String>((ref, studentId) async {
  final repo = ref.read(attendanceRepositoryProvider);
  return repo.getStudentAttendance(studentId);
});
