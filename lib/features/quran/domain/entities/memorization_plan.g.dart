// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memorization_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemorizationPlanImpl _$$MemorizationPlanImplFromJson(
        Map<String, dynamic> json) =>
    _$MemorizationPlanImpl(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      teacherId: json['teacher_id'] as String,
      organizationId: json['organization_id'] as String,
      classId: json['class_id'] as String?,
      status: $enumDecode(_$MemorizationStatusEnumMap, json['status']),
      priority: $enumDecode(_$MemorizationPriorityEnumMap, json['priority']),
      currentSurah: (json['current_surah'] as num).toInt(),
      currentAyah: (json['current_ayah'] as num).toInt(),
      targetSurah: (json['target_surah'] as num).toInt(),
      targetAyah: (json['target_ayah'] as num).toInt(),
      checkpoints: (json['checkpoints'] as List<dynamic>?)
              ?.map((e) =>
                  MemorizationCheckpoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      sessions: (json['sessions'] as List<dynamic>?)
              ?.map((e) =>
                  MemorizationSession.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );

Map<String, dynamic> _$$MemorizationPlanImplToJson(
        _$MemorizationPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student_id': instance.studentId,
      'teacher_id': instance.teacherId,
      'organization_id': instance.organizationId,
      'class_id': instance.classId,
      'status': _$MemorizationStatusEnumMap[instance.status]!,
      'priority': _$MemorizationPriorityEnumMap[instance.priority]!,
      'current_surah': instance.currentSurah,
      'current_ayah': instance.currentAyah,
      'target_surah': instance.targetSurah,
      'target_ayah': instance.targetAyah,
      'checkpoints': instance.checkpoints,
      'sessions': instance.sessions,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
    };

const _$MemorizationStatusEnumMap = {
  MemorizationStatus.notStarted: 'not_started',
  MemorizationStatus.inProgress: 'in_progress',
  MemorizationStatus.paused: 'paused',
  MemorizationStatus.completed: 'completed',
  MemorizationStatus.cancelled: 'cancelled',
};

const _$MemorizationPriorityEnumMap = {
  MemorizationPriority.low: 'low',
  MemorizationPriority.medium: 'medium',
  MemorizationPriority.high: 'high',
};

_$MemorizationCheckpointImpl _$$MemorizationCheckpointImplFromJson(
        Map<String, dynamic> json) =>
    _$MemorizationCheckpointImpl(
      id: json['id'] as String,
      surahNumber: (json['surah_number'] as num).toInt(),
      startAyah: (json['start_ayah'] as num).toInt(),
      endAyah: (json['end_ayah'] as num).toInt(),
      status: $enumDecode(_$CheckpointStatusEnumMap, json['status']),
      qualityScore: (json['quality_score'] as num?)?.toInt(),
      teacherNotes: json['teacher_notes'] as String?,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );

Map<String, dynamic> _$$MemorizationCheckpointImplToJson(
        _$MemorizationCheckpointImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'surah_number': instance.surahNumber,
      'start_ayah': instance.startAyah,
      'end_ayah': instance.endAyah,
      'status': _$CheckpointStatusEnumMap[instance.status]!,
      'quality_score': instance.qualityScore,
      'teacher_notes': instance.teacherNotes,
      'completed_at': instance.completedAt?.toIso8601String(),
    };

const _$CheckpointStatusEnumMap = {
  CheckpointStatus.pending: 'pending',
  CheckpointStatus.inProgress: 'in_progress',
  CheckpointStatus.completed: 'completed',
  CheckpointStatus.needsRevision: 'needs_revision',
};

_$MemorizationSessionImpl _$$MemorizationSessionImplFromJson(
        Map<String, dynamic> json) =>
    _$MemorizationSessionImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      fromSurah: json['from_surah'] as String,
      fromAyah: (json['from_ayah'] as num).toInt(),
      toSurah: json['to_surah'] as String,
      toAyah: (json['to_ayah'] as num).toInt(),
      qualityScore: (json['quality_score'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$MemorizationSessionImplToJson(
        _$MemorizationSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'duration_minutes': instance.durationMinutes,
      'from_surah': instance.fromSurah,
      'from_ayah': instance.fromAyah,
      'to_surah': instance.toSurah,
      'to_ayah': instance.toAyah,
      'quality_score': instance.qualityScore,
      'notes': instance.notes,
    };

_$MemorizationPlanImpl _$MemorizationPlanFromJson(Map<String, dynamic> json) => _$$MemorizationPlanImplFromJson(json);
Map<String, dynamic> _$MemorizationPlanToJson(_$MemorizationPlanImpl instance) => _$$MemorizationPlanImplToJson(instance);
