import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/notifications/domain/entities/notification.dart';
import 'package:hafiz/features/notifications/domain/repositories/notification_repository.dart';
import 'package:hafiz/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:hafiz/core/network/supabase_client.dart';

/// Notification repository provider.
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return NotificationRepositoryImpl(client);
});

/// User notifications provider.
final userNotificationsProvider =
    FutureProvider.autoDispose.family<List<AppNotification>, String>((ref, userId) async {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.getUserNotifications(userId: userId);
});

/// Unread notification count provider.
final unreadNotificationCountProvider =
    FutureProvider.autoDispose.family<int, String>((ref, userId) async {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.getUnreadCount(userId);
});

/// Notification notifier for CRUD operations.
class NotificationNotifier extends StateNotifier<AsyncValue<void>> {
  final NotificationRepository _repository;

  NotificationNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> markAsRead(String notificationId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.markAsRead(notificationId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> markAllAsRead(String userId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.markAllAsRead(userId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteNotification(notificationId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deleteAllNotifications(String userId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteAllNotifications(userId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

/// Notification notifier provider.
final notificationNotifierProvider =
    StateNotifierProvider<NotificationNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return NotificationNotifier(repo);
});
