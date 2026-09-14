// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizationImpl _$$OrganizationImplFromJson(Map<String, dynamic> json) =>
    _$OrganizationImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      logoUrl: (json['logo_url'] ?? json['logoUrl']) as String?,
      createdAt: DateTime.parse((json['created_at'] ?? json['createdAt']) as String),
      updatedAt: (json['updated_at'] ?? json['updatedAt']) == null
          ? null
          : DateTime.parse((json['updated_at'] ?? json['updatedAt']) as String),
    );

Map<String, dynamic> _$$OrganizationImplToJson(_$OrganizationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'logoUrl': instance.logoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$OrganizationImpl _$OrganizationFromJson(Map<String, dynamic> json) =>
    _$$OrganizationImplFromJson(json);
Map<String, dynamic> _$OrganizationToJson(_$OrganizationImpl instance) =>
    _$$OrganizationImplToJson(instance);
