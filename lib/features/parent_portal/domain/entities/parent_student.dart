import 'package:freezed_annotation/freezed_annotation.dart';

part 'parent_student.freezed.dart';
part 'parent_student.g.dart';

/// ParentStudent entity.
///
/// Combines student info with parent-facing progress summary.
/// Used in the parent portal to display a child's overview.
@freezed
abstract class ParentStudent with _$ParentStudent {
  factory ParentStudent({
    required String id,
    required String studentId,
    required String fullName,
    String? preferredName,
    String? avatarUrl,
    String? currentQuranLevel,
    String? memorizationLevel,
    @Default(0) int totalMemorizedPages,
    @Default(0) int totalSessions,
    @Default(0) int attendedSessions,
    @Default(0) int missedSessions,
    @Default(0.0) double attendanceRate,
    @Default(0) int tasmiPassCount,
    @Default(0) int tasmiNeedsRevisionCount,
    @Default(0) int tasmiFailCount,
    DateTime? lastSessionDate,
  }) = _ParentStudent;

  factory ParentStudent.fromJson(Map<String, dynamic> json) =>
      _$ParentStudentFromJson(json);
}

/// Attendance record summary for calendar view.
@freezed
abstract class ParentAttendanceRecord with _$ParentAttendanceRecord {
  factory ParentAttendanceRecord({
    required String id,
    required String studentId,
    required DateTime date,
    required String status,
    String? notes,
  }) = _ParentAttendanceRecord;

  factory ParentAttendanceRecord.fromJson(Map<String, dynamic> json) =>
      _$ParentAttendanceRecordFromJson(json);
}

/// Recent tasmi session summary for parent view.
@freezed
abstract class ParentTasmiSummary with _$ParentTasmiSummary {
  factory ParentTasmiSummary({
    required String id,
    required String studentId,
    required String studentName,
    required String sessionType,
    required String outcome,
    int? overallRating,
    String? teacherNotes,
    required DateTime recordedAt,
  }) = _ParentTasmiSummary;

  factory ParentTasmiSummary.fromJson(Map<String, dynamic> json) =>
      _$ParentTasmiSummaryFromJson(json);
}

/// Upcoming session summary for schedule tab.
@freezed
abstract class ParentUpcomingSession with _$ParentUpcomingSession {
  factory ParentUpcomingSession({
    required String id,
    required String title,
    required String type,
    required DateTime date,
    required String startTime,
    required String endTime,
    String? location,
    required String studentName,
  }) = _ParentUpcomingSession;

  factory ParentUpcomingSession.fromJson(Map<String, dynamic> json) =>
      _$ParentUpcomingSessionFromJson(json);
}
