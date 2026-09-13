// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParentStudentImpl _$$ParentStudentImplFromJson(Map<String, dynamic> json) =>
    _$ParentStudentImpl(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      fullName: json['full_name'] as String,
      preferredName: json['preferred_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      currentQuranLevel: json['current_quran_level'] as String?,
      memorizationLevel: json['memorization_level'] as String?,
      totalMemorizedPages:
          (json['total_memorized_pages'] as num?)?.toInt() ?? 0,
      totalSessions: (json['total_sessions'] as num?)?.toInt() ?? 0,
      attendedSessions:
          (json['attended_sessions'] as num?)?.toInt() ?? 0,
      missedSessions: (json['missed_sessions'] as num?)?.toInt() ?? 0,
      attendanceRate:
          (json['attendance_rate'] as num?)?.toDouble() ?? 0.0,
      tasmiPassCount: (json['tasmi_pass_count'] as num?)?.toInt() ?? 0,
      tasmiNeedsRevisionCount:
          (json['tasmi_needs_revision_count'] as num?)?.toInt() ?? 0,
      tasmiFailCount: (json['tasmi_fail_count'] as num?)?.toInt() ?? 0,
      lastSessionDate: json['last_session_date'] == null
          ? null
          : DateTime.parse(json['last_session_date'] as String),
    );

Map<String, dynamic> _$$ParentStudentImplToJson(
        _$ParentStudentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student_id': instance.studentId,
      'full_name': instance.fullName,
      'preferred_name': instance.preferredName,
      'avatar_url': instance.avatarUrl,
      'current_quran_level': instance.currentQuranLevel,
      'memorization_level': instance.memorizationLevel,
      'total_memorized_pages': instance.totalMemorizedPages,
      'total_sessions': instance.totalSessions,
      'attended_sessions': instance.attendedSessions,
      'missed_sessions': instance.missedSessions,
      'attendance_rate': instance.attendanceRate,
      'tasmi_pass_count': instance.tasmiPassCount,
      'tasmi_needs_revision_count': instance.tasmiNeedsRevisionCount,
      'tasmi_fail_count': instance.tasmiFailCount,
      'last_session_date': instance.lastSessionDate?.toIso8601String(),
    };

_$ParentStudentImpl _$ParentStudentFromJson(Map<String, dynamic> json) =>
    _$$ParentStudentImplFromJson(json);

Map<String, dynamic> _$ParentStudentToJson(_$ParentStudentImpl instance) =>
    _$$ParentStudentImplToJson(instance);

_$ParentAttendanceRecordImpl _$$ParentAttendanceRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$ParentAttendanceRecordImpl(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$ParentAttendanceRecordImplToJson(
        _$ParentAttendanceRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student_id': instance.studentId,
      'date': instance.date.toIso8601String(),
      'status': instance.status,
      'notes': instance.notes,
    };

_$ParentAttendanceRecordImpl _$ParentAttendanceRecordFromJson(
        Map<String, dynamic> json) =>
    _$$ParentAttendanceRecordImplFromJson(json);

Map<String, dynamic> _$ParentAttendanceRecordToJson(
        _$ParentAttendanceRecordImpl instance) =>
    _$$ParentAttendanceRecordImplToJson(instance);

_$ParentTasmiSummaryImpl _$$ParentTasmiSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$ParentTasmiSummaryImpl(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      studentName: json['student_name'] as String,
      sessionType: json['session_type'] as String,
      outcome: json['outcome'] as String,
      overallRating: (json['overall_rating'] as num?)?.toInt(),
      teacherNotes: json['teacher_notes'] as String?,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
    );

Map<String, dynamic> _$$ParentTasmiSummaryImplToJson(
        _$ParentTasmiSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student_id': instance.studentId,
      'student_name': instance.studentName,
      'session_type': instance.sessionType,
      'outcome': instance.outcome,
      'overall_rating': instance.overallRating,
      'teacher_notes': instance.teacherNotes,
      'recorded_at': instance.recordedAt.toIso8601String(),
    };

_$ParentTasmiSummaryImpl _$ParentTasmiSummaryFromJson(
        Map<String, dynamic> json) =>
    _$$ParentTasmiSummaryImplFromJson(json);

Map<String, dynamic> _$ParentTasmiSummaryToJson(
        _$ParentTasmiSummaryImpl instance) =>
    _$$ParentTasmiSummaryImplToJson(instance);

_$ParentUpcomingSessionImpl _$$ParentUpcomingSessionImplFromJson(
        Map<String, dynamic> json) =>
    _$ParentUpcomingSessionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      location: json['location'] as String?,
      studentName: json['student_name'] as String,
    );

Map<String, dynamic> _$$ParentUpcomingSessionImplToJson(
        _$ParentUpcomingSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'date': instance.date.toIso8601String(),
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'location': instance.location,
      'student_name': instance.studentName,
    };

_$ParentUpcomingSessionImpl _$ParentUpcomingSessionFromJson(
        Map<String, dynamic> json) =>
    _$$ParentUpcomingSessionImplFromJson(json);

Map<String, dynamic> _$ParentUpcomingSessionToJson(
        _$ParentUpcomingSessionImpl instance) =>
    _$$ParentUpcomingSessionImplToJson(instance);
