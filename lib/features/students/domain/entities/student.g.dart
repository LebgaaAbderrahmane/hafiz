// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentImpl _$$StudentImplFromJson(Map<String, dynamic> json) =>
    _$StudentImpl(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      branchId: json['branch_id'] as String,
      studentId: json['student_id'] as String?,
      fullName: json['full_name'] as String,
      preferredName: json['preferred_name'] as String?,
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      avatarUrl: json['avatar_url'] as String?,
      nationality: json['nationality'] as String?,
      language: json['language'] as String? ?? 'ar',
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      status: $enumDecodeNullable(_$StudentStatusEnumMap, json['status']) ??
          StudentStatus.active,
      previousQuranEducation: json['previous_quran_education'] as String?,
      currentQuranLevel: json['current_quran_level'] as String?,
      readingLevel: json['reading_level'] as String?,
      tajwidLevel: json['tajwid_level'] as String?,
      memorizationLevel: json['memorization_level'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$StudentImplToJson(_$StudentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organization_id': instance.organizationId,
      'branch_id': instance.branchId,
      'student_id': instance.studentId,
      'full_name': instance.fullName,
      'preferred_name': instance.preferredName,
      'gender': _$GenderEnumMap[instance.gender],
      'date_of_birth': instance.dateOfBirth?.toIso8601String(),
      'avatar_url': instance.avatarUrl,
      'nationality': instance.nationality,
      'language': instance.language,
      'phone': instance.phone,
      'email': instance.email,
      'status': _$StudentStatusEnumMap[instance.status]!,
      'previous_quran_education': instance.previousQuranEducation,
      'current_quran_level': instance.currentQuranLevel,
      'reading_level': instance.readingLevel,
      'tajwid_level': instance.tajwidLevel,
      'memorization_level': instance.memorizationLevel,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
};

const _$StudentStatusEnumMap = {
  StudentStatus.lead: 'lead',
  StudentStatus.applicant: 'applicant',
  StudentStatus.active: 'active',
  StudentStatus.suspended: 'suspended',
  StudentStatus.graduated: 'graduated',
  StudentStatus.withdrawn: 'withdrawn',
  StudentStatus.archived: 'archived',
};

_$StudentImpl _$StudentFromJson(Map<String, dynamic> json) => _$$StudentImplFromJson(json);
Map<String, dynamic> _$StudentToJson(_$StudentImpl instance) => _$$StudentImplToJson(instance);
