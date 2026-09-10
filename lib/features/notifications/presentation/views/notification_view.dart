import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_provider.dart';

/// Notification view.
class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notificationsAsync = ref.watch(userNotificationsProvider(''));

    return Scaffold(
      appBar: AppBar(
        title: Text('الإشعارات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              ref.read(notificationNotifierProvider.notifier).markAllAsRead('');
              ref.invalidate(userNotificationsProvider(''));
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'deleteAll',
                child: Text('حذف الكل'),
              ),
            ],
            onSelected: (value) {
              if (value == 'deleteAll') {
                _confirmDeleteAll(context, ref);
              }
            },
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 64, color: AppColors.textHint),
                  Gap.l,
                  Text('لا توجد إشعارات', style: AppTextStyles.bodyLarge),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.s),
            itemCount: notifications.length,
            itemBuilder: (context, index) =>
                _buildNotificationTile(context, ref, notifications[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildNotificationTile(
      BuildContext context, WidgetRef ref, AppNotification notification) {
    final type = notification.type;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: AppSpacing.l),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: AppColors.white),
      ),
      onDismissed: (direction) {
        ref.read(notificationNotifierProvider.notifier).deleteNotification(notification.id);
        ref.invalidate(userNotificationsProvider(''));
      },
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: notification.isRead
                ? AppColors.textHint.withValues(alpha: 0.1)
                : AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.s),
          ),
          child: Center(
            child: Text(
              type.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(
          notification.title,
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.body,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Gap.xs,
            Text(
              _formatTime(notification.createdAt),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
        trailing: !notification.isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          if (!notification.isRead) {
            ref.read(notificationNotifierProvider.notifier).markAsRead(notification.id);
            ref.invalidate(userNotificationsProvider(''));
          }
          if (notification.actionUrl != null) {
            context.push(notification.actionUrl!);
          }
        },
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) {
      return 'الآن';
    } else if (diff.inHours < 1) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inDays < 1) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} يوم';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  void _confirmDeleteAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف جميع الإشعارات'),
        content: const Text('هل أنت متأكد من حذف جميع الإشعارات؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(notificationNotifierProvider.notifier).deleteAllNotifications('');
              ref.invalidate(userNotificationsProvider(''));
              Navigator.of(context).pop();
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
