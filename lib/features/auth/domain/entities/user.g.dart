// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(Map<String, dynamic> json) =>
    _$AppUserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      fullName: (json['full_name'] ?? json['fullName']) as String,
      preferredName: (json['preferred_name'] ?? json['preferredName']) as String?,
      avatarUrl: (json['avatar_url'] ?? json['avatarUrl']) as String?,
      language: (json['language'] as String?) ?? 'ar',
      isActive: (json['is_active'] ?? json['isActive'] as bool?) ?? true,
      createdAt: DateTime.parse((json['created_at'] ?? json['createdAt']) as String),
      updatedAt: (json['updated_at'] ?? json['updatedAt']) == null
          ? null
          : DateTime.parse((json['updated_at'] ?? json['updatedAt']) as String),
    );

Map<String, dynamic> _$$AppUserImplToJson(_$AppUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone': instance.phone,
      'fullName': instance.fullName,
      'preferredName': instance.preferredName,
      'avatarUrl': instance.avatarUrl,
      'language': instance.language,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$UserRoleImpl _$$UserRoleImplFromJson(Map<String, dynamic> json) =>
    _$UserRoleImpl(
      id: json['id'] as String,
      userId: (json['user_id'] ?? json['userId']) as String,
      organizationId: (json['organization_id'] ?? json['organizationId']) as String,
      branchId: (json['branch_id'] ?? json['branchId']) as String?,
      role: Role.values.firstWhere(
          (e) => e.name == (json['role'] as String).toLowerCase(),
          orElse: () => Role.owner),
      createdAt: DateTime.parse((json['created_at'] ?? json['createdAt']) as String),
    );

Map<String, dynamic> _$$UserRoleImplToJson(_$UserRoleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'organizationId': instance.organizationId,
      'branchId': instance.branchId,
      'role': _$RoleEnumMap[instance.role]!,
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

_$AppUserImpl _$AppUserFromJson(Map<String, dynamic> json) => _$$AppUserImplFromJson(json);
Map<String, dynamic> _$AppUserToJson(_$AppUserImpl instance) => _$$AppUserImplToJson(instance);

_$UserRoleImpl _$UserRoleFromJson(Map<String, dynamic> json) => _$$UserRoleImplFromJson(json);
Map<String, dynamic> _$UserRoleToJson(_$UserRoleImpl instance) => _$$UserRoleImplToJson(instance);
