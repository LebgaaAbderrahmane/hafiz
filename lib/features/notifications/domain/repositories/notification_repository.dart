import '../entities/notification.dart';

/// Abstract repository for notification operations.
abstract class NotificationRepository {
  /// Get all notifications for a user.
  Future<List<AppNotification>> getUserNotifications({
    required String userId,
    bool? isRead,
    NotificationType? type,
  });

  /// Get unread notification count.
  Future<int> getUnreadCount(String userId);

  /// Get a single notification by ID.
  Future<AppNotification?> getNotificationById(String notificationId);

  /// Mark notification as read.
  Future<void> markAsRead(String notificationId);

  /// Mark all notifications as read.
  Future<void> markAllAsRead(String userId);

  /// Delete a notification.
  Future<void> deleteNotification(String notificationId);

  /// Delete all notifications for a user.
  Future<void> deleteAllNotifications(String userId);

  /// Create a notification (admin/system use).
  Future<AppNotification> createNotification({
    required String organizationId,
    required String branchId,
    required String userId,
    required NotificationType type,
    required String title,
    required String body,
    Map<String, dynamic>? data,
    String? actionUrl,
  });
}
