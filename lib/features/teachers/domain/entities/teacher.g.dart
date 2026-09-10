// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeacherImpl _$TeacherImplFromJson(Map<String, dynamic> json) =>
    _$TeacherImpl(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      branchId: json['branch_id'] as String,
      userId: json['user_id'] as String,
      employeeId: json['employee_id'] as String?,
      fullName: json['full_name'] as String,
      preferredName: json['preferred_name'] as String?,
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      avatarUrl: json['avatar_url'] as String?,
      nationality: json['nationality'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      specialization: json['specialization'] as String?,
      qualifications: (json['qualifications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      languagesSpoken: (json['languages_spoken'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status: $enumDecodeNullable(_$TeacherStatusEnumMap, json['status']) ??
          TeacherStatus.active,
      hireDate: json['hire_date'] == null
          ? null
          : DateTime.parse(json['hire_date'] as String),
      terminationDate: json['termination_date'] == null
          ? null
          : DateTime.parse(json['termination_date'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$TeacherImplToJson(_$TeacherImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organization_id': instance.organizationId,
      'branch_id': instance.branchId,
      'user_id': instance.userId,
      'employee_id': instance.employeeId,
      'full_name': instance.fullName,
      'preferred_name': instance.preferredName,
      'gender': _$GenderEnumMap[instance.gender],
      'date_of_birth': instance.dateOfBirth?.toIso8601String(),
      'avatar_url': instance.avatarUrl,
      'nationality': instance.nationality,
      'phone': instance.phone,
      'email': instance.email,
      'specialization': instance.specialization,
      'qualifications': instance.qualifications,
      'certifications': instance.certifications,
      'languages_spoken': instance.languagesSpoken,
      'status': _$TeacherStatusEnumMap[instance.status]!,
      'hire_date': instance.hireDate?.toIso8601String(),
      'termination_date': instance.terminationDate?.toIso8601String(),
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
};

const _$TeacherStatusEnumMap = {
  TeacherStatus.active: 'active',
  TeacherStatus.onLeave: 'on_leave',
  TeacherStatus.inactive: 'inactive',
  TeacherStatus.terminated: 'terminated',
};
