// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppNotificationImpl _$$AppNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$AppNotificationImpl(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      branchId: json['branch_id'] as String,
      userId: json['user_id'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      title: json['title'] as String,
      body: json['body'] as String,
      data: json['data'] as Map<String, dynamic>?,
      actionUrl: json['action_url'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$AppNotificationImplToJson(
        _$AppNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organization_id': instance.organizationId,
      'branch_id': instance.branchId,
      'user_id': instance.userId,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
      'action_url': instance.actionUrl,
      'is_read': instance.isRead,
      'read_at': instance.readAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.attendance: 'attendance',
  NotificationType.memorization: 'memorization',
  NotificationType.tasmi: 'tasmi',
  NotificationType.assignment: 'assignment',
  NotificationType.schedule: 'schedule',
  NotificationType.report: 'report',
  NotificationType.system: 'system',
  NotificationType.reminder: 'reminder',
};
