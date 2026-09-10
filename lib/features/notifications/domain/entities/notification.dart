import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

/// Notification entity.
///
/// Represents an in-app notification.
@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String organizationId,
    required String branchId,
    required String userId,
    required NotificationType type,
    required String title,
    required String body,
    Map<String, dynamic>? data,
    String? actionUrl,
    @Default(false) bool isRead,
    DateTime? readAt,
    required DateTime createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}

/// Notification type.
enum NotificationType {
  attendance,
  memorization,
  tasmi,
  assignment,
  schedule,
  report,
  system,
  reminder,
}

/// Extension for display names.
extension NotificationTypeExtension on NotificationType {
  String get displayNameAr {
    return switch (this) {
      NotificationType.attendance => 'الحصور',
      NotificationType.memorization => 'الحفظ',
      NotificationType.tasmi => 'التسميع',
      NotificationType.assignment => 'المهمات',
      NotificationType.schedule => 'الجدول',
      NotificationType.report => 'التقارير',
      NotificationType.system => 'النظام',
      NotificationType.reminder => 'تذكير',
    };
  }

  String get icon {
    return switch (this) {
      NotificationType.attendance => '✓',
      NotificationType.memorization => '📖',
      NotificationType.tasmi => '🎤',
      NotificationType.assignment => '📋',
      NotificationType.schedule => '📅',
      NotificationType.report => '📊',
      NotificationType.system => '⚙️',
      NotificationType.reminder => '🔔',
    };
  }
}
