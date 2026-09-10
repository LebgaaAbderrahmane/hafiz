// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionImpl _$$SessionImplFromJson(Map<String, dynamic> json) =>
    _$SessionImpl(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      branchId: json['branch_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: $enumDecode(_$SessionTypeEnumMap, json['type']),
      date: DateTime.parse(json['date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      classId: json['class_id'] as String,
      teacherId: json['teacher_id'] as String,
      studentIds: (json['student_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      location: json['location'] as String?,
      status: $enumDecodeNullable(_$SessionStatusEnumMap, json['status']) ??
          SessionStatus.scheduled,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SessionImplToJson(_$SessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organization_id': instance.organizationId,
      'branch_id': instance.branchId,
      'title': instance.title,
      'description': instance.description,
      'type': _$SessionTypeEnumMap[instance.type]!,
      'date': instance.date.toIso8601String(),
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'class_id': instance.classId,
      'teacher_id': instance.teacherId,
      'student_ids': instance.studentIds,
      'location': instance.location,
      'status': _$SessionStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$SessionTypeEnumMap = {
  SessionType.classSession: 'class_session',
  SessionType.tasmi: 'tasmi',
  SessionType.revision: 'revision',
  SessionType.exam: 'exam',
  SessionType.makeup: 'makeup',
  SessionType.other: 'other',
};

const _$SessionStatusEnumMap = {
  SessionStatus.scheduled: 'scheduled',
  SessionStatus.inProgress: 'in_progress',
  SessionStatus.completed: 'completed',
  SessionStatus.cancelled: 'cancelled',
  SessionStatus.rescheduled: 'rescheduled',
};

_$SessionImpl _$SessionFromJson(Map<String, dynamic> json) => _$$SessionImplFromJson(json);
Map<String, dynamic> _$SessionToJson(_$SessionImpl instance) => _$$SessionImplToJson(instance);
