// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hifz_assignment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HifzAssignmentImpl _$$HifzAssignmentImplFromJson(
        Map<String, dynamic> json) =>
    _$HifzAssignmentImpl(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      branchId: json['branch_id'] as String,
      studentId: json['student_id'] as String,
      teacherId: json['teacher_id'] as String,
      classId: json['class_id'] as String?,
      startSurah: (json['start_surah'] as num).toInt(),
      startAyah: (json['start_ayah'] as num).toInt(),
      endSurah: (json['end_surah'] as num).toInt(),
      endAyah: (json['end_ayah'] as num).toInt(),
      type: $enumDecode(_$AssignmentTypeEnumMap, json['type']),
      status: $enumDecode(_$AssignmentStatusEnumMap, json['status']),
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      notes: json['notes'] as String?,
      qualityTarget: (json['quality_target'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );

Map<String, dynamic> _$$HifzAssignmentImplToJson(
        _$HifzAssignmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organization_id': instance.organizationId,
      'branch_id': instance.branchId,
      'student_id': instance.studentId,
      'teacher_id': instance.teacherId,
      'class_id': instance.classId,
      'start_surah': instance.startSurah,
      'start_ayah': instance.startAyah,
      'end_surah': instance.endSurah,
      'end_ayah': instance.endAyah,
      'type': _$AssignmentTypeEnumMap[instance.type]!,
      'status': _$AssignmentStatusEnumMap[instance.status]!,
      'due_date': instance.dueDate?.toIso8601String(),
      'notes': instance.notes,
      'quality_target': instance.qualityTarget,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
    };

const _$AssignmentTypeEnumMap = {
  AssignmentType.newMemorization: 'new_memorization',
  AssignmentType.revision: 'revision',
  AssignmentType.comprehensiveRevision: 'comprehensive_revision',
};

const _$AssignmentStatusEnumMap = {
  AssignmentStatus.pending: 'pending',
  AssignmentStatus.inProgress: 'in_progress',
  AssignmentStatus.completed: 'completed',
  AssignmentStatus.overdue: 'overdue',
  AssignmentStatus.cancelled: 'cancelled',
};
