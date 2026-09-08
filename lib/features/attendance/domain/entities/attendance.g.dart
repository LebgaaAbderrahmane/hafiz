// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttendanceImpl _$$AttendanceImplFromJson(Map<String, dynamic> json) =>
    _$AttendanceImpl(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      branchId: json['branch_id'] as String,
      studentId: json['student_id'] as String,
      sessionId: json['session_id'] as String,
      classId: json['class_id'] as String,
      status: $enumDecode(_$AttendanceStatusEnumMap, json['status']),
      checkInTime: json['check_in_time'] as String?,
      checkOutTime: json['check_out_time'] as String?,
      notes: json['notes'] as String?,
      markedBy: json['marked_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$AttendanceImplToJson(_$AttendanceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organization_id': instance.organizationId,
      'branch_id': instance.branchId,
      'student_id': instance.studentId,
      'session_id': instance.sessionId,
      'class_id': instance.classId,
      'status': _$AttendanceStatusEnumMap[instance.status]!,
      'check_in_time': instance.checkInTime,
      'check_out_time': instance.checkOutTime,
      'notes': instance.notes,
      'marked_by': instance.markedBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.present: 'present',
  AttendanceStatus.late: 'late',
  AttendanceStatus.absent: 'absent',
  AttendanceStatus.excused: 'excused',
  AttendanceStatus.leftEarly: 'left_early',
};
