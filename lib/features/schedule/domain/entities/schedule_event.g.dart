// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleEventImpl _$$ScheduleEventImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleEventImpl(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      branchId: json['branch_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      eventType: $enumDecode(_$EventTypeEnumMap, json['event_type']),
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      location: json['location'] as String?,
      classId: json['class_id'] as String?,
      teacherId: json['teacher_id'] as String?,
      studentIds: (json['student_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      recurrenceDays: (json['recurrence_days'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      recurrenceEndDate: json['recurrence_end_date'] as String?,
      status: $enumDecodeNullable(_$EventStatusEnumMap, json['status']) ??
          EventStatus.scheduled,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ScheduleEventImplToJson(
        _$ScheduleEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organization_id': instance.organizationId,
      'branch_id': instance.branchId,
      'title': instance.title,
      'description': instance.description,
      'event_type': _$EventTypeEnumMap[instance.eventType]!,
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime.toIso8601String(),
      'location': instance.location,
      'class_id': instance.classId,
      'teacher_id': instance.teacherId,
      'student_ids': instance.studentIds,
      'recurrence_days': instance.recurrenceDays,
      'recurrence_end_date': instance.recurrenceEndDate,
      'status': _$EventStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$EventTypeEnumMap = {
  EventType.classSession: 'class_session',
  EventType.tasmi: 'tasmi',
  EventType.exam: 'exam',
  EventType.meeting: 'meeting',
  EventType.holiday: 'holiday',
  EventType.other: 'other',
};

const _$EventStatusEnumMap = {
  EventStatus.scheduled: 'scheduled',
  EventStatus.inProgress: 'in_progress',
  EventStatus.completed: 'completed',
  EventStatus.cancelled: 'cancelled',
  EventStatus.rescheduled: 'rescheduled',
};
