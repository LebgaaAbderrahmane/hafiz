import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:hafiz/features/attendance/domain/entities/attendance.dart';
import 'package:hafiz/features/attendance/domain/repositories/attendance_repository.dart';

/// Attendance repository provider.
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepositoryImpl();
});

/// Session attendance provider.
final sessionAttendanceProvider = FutureProvider.autoDispose
    .family<List<Attendance>, String>((ref, sessionId) async {
  final result = await ref
      .read(attendanceRepositoryProvider)
      .getSessionAttendance(sessionId);
  return result.fold(
    (failure) => throw failure,
    (records) => records,
  );
});

/// Class attendance for a date provider.
final classAttendanceProvider = FutureProvider.autoDispose
    .family<List<Attendance>, ({String classId, DateTime date})>(
        (ref, params) async {
  final result = await ref
      .read(attendanceRepositoryProvider)
      .getClassAttendance(params.classId, params.date);
  return result.fold(
    (failure) => throw failure,
    (records) => records,
  );
});

/// Student attendance provider.
final studentAttendanceProvider = FutureProvider.autoDispose
    .family<List<Attendance>, String>((ref, studentId) async {
  final result = await ref
      .read(attendanceRepositoryProvider)
      .getStudentAttendance(studentId);
  return result.fold(
    (failure) => throw failure,
    (records) => records,
  );
});
