// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guardian.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GuardianImpl _$$GuardianImplFromJson(Map<String, dynamic> json) =>
    _$GuardianImpl(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      branchId: json['branch_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      address: json['address'] as String?,
      occupation: json['occupation'] as String?,
      type: $enumDecodeNullable(_$GuardianTypeEnumMap, json['type']),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$GuardianImplToJson(_$GuardianImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organization_id': instance.organizationId,
      'branch_id': instance.branchId,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'occupation': instance.occupation,
      'type': _$GuardianTypeEnumMap[instance.type],
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$GuardianTypeEnumMap = {
  GuardianType.father: 'father',
  GuardianType.mother: 'mother',
  GuardianType.brother: 'brother',
  GuardianType.sister: 'sister',
  GuardianType.uncle: 'uncle',
  GuardianType.aunt: 'aunt',
  GuardianType.grandfather: 'grandfather',
  GuardianType.grandmother: 'grandmother',
  GuardianType.other: 'other',
};
