// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revision.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RevisionImpl _$$RevisionImplFromJson(Map<String, dynamic> json) =>
    _$RevisionImpl(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      branchId: json['branch_id'] as String,
      studentId: json['student_id'] as String,
      teacherId: json['teacher_id'] as String,
      classId: json['class_id'] as String?,
      surahNumber: (json['surah_number'] as num).toInt(),
      startAyah: (json['start_ayah'] as num).toInt(),
      endAyah: (json['end_ayah'] as num).toInt(),
      status: $enumDecode(_$RevisionStatusEnumMap, json['status']),
      priority: $enumDecode(_$RevisionPriorityEnumMap, json['priority']),
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      completedDate: json['completed_date'] == null
          ? null
          : DateTime.parse(json['completed_date'] as String),
      qualityScore: (json['quality_score'] as num?)?.toInt(),
      reviewCount: (json['review_count'] as num?)?.toInt(),
      lastReviewedAt: json['last_reviewed_at'] == null
          ? null
          : DateTime.parse(json['last_reviewed_at'] as String),
      nextReviewAt: json['next_review_at'] == null
          ? null
          : DateTime.parse(json['next_review_at'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$RevisionImplToJson(_$RevisionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organization_id': instance.organizationId,
      'branch_id': instance.branchId,
      'student_id': instance.studentId,
      'teacher_id': instance.teacherId,
      'class_id': instance.classId,
      'surah_number': instance.surahNumber,
      'start_ayah': instance.startAyah,
      'end_ayah': instance.endAyah,
      'status': _$RevisionStatusEnumMap[instance.status]!,
      'priority': _$RevisionPriorityEnumMap[instance.priority]!,
      'due_date': instance.dueDate?.toIso8601String(),
      'completed_date': instance.completedDate?.toIso8601String(),
      'quality_score': instance.qualityScore,
      'review_count': instance.reviewCount,
      'last_reviewed_at': instance.lastReviewedAt?.toIso8601String(),
      'next_review_at': instance.nextReviewAt?.toIso8601String(),
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$RevisionStatusEnumMap = {
  RevisionStatus.pending: 'pending',
  RevisionStatus.due: 'due',
  RevisionStatus.overdue: 'overdue',
  RevisionStatus.inProgress: 'in_progress',
  RevisionStatus.completed: 'completed',
  RevisionStatus.needsRevision: 'needs_revision',
};

const _$RevisionPriorityEnumMap = {
  RevisionPriority.low: 'low',
  RevisionPriority.medium: 'medium',
  RevisionPriority.high: 'high',
  RevisionPriority.urgent: 'urgent',
};
