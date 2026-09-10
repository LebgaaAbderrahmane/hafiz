import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final SupabaseClient _client;

  NotificationRepositoryImpl(this._client);

  SupabaseClient get _supabase => _client;

  @override
  Future<List<AppNotification>> getUserNotifications({
    required String userId,
    bool? isRead,
    NotificationType? type,
  }) async {
    var query = _supabase
        .from('notifications')
        .select()
        .eq('user_id', userId);

    if (isRead != null) {
      query = query.eq('is_read', isRead);
    }
    if (type != null) {
      query = query.eq('type', type.name);
    }

    final data = await query.order('created_at', ascending: false);
    return (data as List)
        .map((json) => AppNotification.fromJson(json))
        .toList();
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    final data = await _supabase
        .from('notifications')
        .select('id')
        .eq('user_id', userId)
        .eq('is_read', false)
        .count();
    return data.count;
  }

  @override
  Future<AppNotification?> getNotificationById(String notificationId) async {
    final data = await _supabase
        .from('notifications')
        .select()
        .eq('id', notificationId)
        .maybeSingle();
    return data != null ? AppNotification.fromJson(data) : null;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _supabase.from('notifications').update({
      'is_read': true,
      'read_at': DateTime.now().toIso8601String(),
    }).eq('id', notificationId);
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    await _supabase.from('notifications').update({
      'is_read': true,
      'read_at': DateTime.now().toIso8601String(),
    }).eq('user_id', userId).eq('is_read', false);
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await _supabase.from('notifications').delete().eq('id', notificationId);
  }

  @override
  Future<void> deleteAllNotifications(String userId) async {
    await _supabase.from('notifications').delete().eq('user_id', userId);
  }

  @override
  Future<AppNotification> createNotification({
    required String organizationId,
    required String branchId,
    required String userId,
    required NotificationType type,
    required String title,
    required String body,
    Map<String, dynamic>? data,
    String? actionUrl,
  }) async {
    final notification = AppNotification(
      id: '',
      organizationId: organizationId,
      branchId: branchId,
      userId: userId,
      type: type,
      title: title,
      body: body,
      data: data,
      actionUrl: actionUrl,
      createdAt: DateTime.now(),
    );

    final result = await _supabase
        .from('notifications')
        .insert(notification.toJson()..remove('id'))
        .select()
        .single();
    return AppNotification.fromJson(result);
  }
}
