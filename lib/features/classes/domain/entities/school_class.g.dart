// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SchoolClassImpl _$$SchoolClassImplFromJson(Map<String, dynamic> json) =>
    _$SchoolClassImpl(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      branchId: json['branch_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      roomId: json['room_id'] as String?,
      teacherId: json['teacher_id'] as String?,
      level: $enumDecode(_$ClassLevelEnumMap, json['level']),
      daysOfWeek: (json['days_of_week'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      maxCapacity: (json['max_capacity'] as num?)?.toInt() ?? 30,
      status: $enumDecodeNullable(_$ClassStatusEnumMap, json['status']) ??
          ClassStatus.active,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SchoolClassImplToJson(_$SchoolClassImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organization_id': instance.organizationId,
      'branch_id': instance.branchId,
      'name': instance.name,
      'description': instance.description,
      'room_id': instance.roomId,
      'teacher_id': instance.teacherId,
      'level': _$ClassLevelEnumMap[instance.level]!,
      'days_of_week': instance.daysOfWeek,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'max_capacity': instance.maxCapacity,
      'status': _$ClassStatusEnumMap[instance.status]!,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$ClassLevelEnumMap = {
  ClassLevel.beginner: 'beginner',
  ClassLevel.elementary: 'elementary',
  ClassLevel.intermediate: 'intermediate',
  ClassLevel.advanced: 'advanced',
  ClassLevel.hafiz: 'hafiz',
};

const _$ClassStatusEnumMap = {
  ClassStatus.active: 'active',
  ClassStatus.inactive: 'inactive',
  ClassStatus.completed: 'completed',
  ClassStatus.cancelled: 'cancelled',
};

_$SchoolClassImpl _$SchoolClassFromJson(Map<String, dynamic> json) => _$$SchoolClassImplFromJson(json);
Map<String, dynamic> _$SchoolClassToJson(_$SchoolClassImpl instance) => _$$SchoolClassImplToJson(instance);
