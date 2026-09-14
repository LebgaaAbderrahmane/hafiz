// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizationUserImpl _$$OrganizationUserImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizationUserImpl(
      id: json['id'] as String,
      userId: (json['user_id'] ?? json['userId']) as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: Role.values.firstWhere(
        (e) => e.name == (json['role'] as String).toLowerCase(),
        orElse: () => Role.teacher,
      ),
      branchId: (json['branch_id'] ?? json['branchId']) as String?,
      branchName: (json['branch_name'] ?? json['branchName']) as String?,
      isActive: (json['is_active'] ?? json['isActive'] as bool?) ?? true,
      createdAt: DateTime.parse((json['created_at'] ?? json['createdAt']) as String),
    );

Map<String, dynamic> _$$OrganizationUserImplToJson(
        _$OrganizationUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'role': _$RoleEnumMap[instance.role]!,
      'branchId': instance.branchId,
      'branchName': instance.branchName,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$RoleEnumMap = {
  Role.owner: 'owner',
  Role.superAdmin: 'super_admin',
  Role.branchManager: 'branch_manager',
  Role.supervisor: 'supervisor',
  Role.teacher: 'teacher',
  Role.assistant: 'assistant',
  Role.reception: 'reception',
  Role.finance: 'finance',
  Role.parent: 'parent',
  Role.student: 'student',
};

_$OrganizationUserImpl _$OrganizationUserFromJson(Map<String, dynamic> json) =>
    _$$OrganizationUserImplFromJson(json);
Map<String, dynamic> _$OrganizationUserToJson(_$OrganizationUserImpl instance) =>
    _$$OrganizationUserImplToJson(instance);
