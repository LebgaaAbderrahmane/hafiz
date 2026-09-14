import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/drawer_icon_button.dart';
import '../../../auth/domain/repositories/auth_provider.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_provider.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserProvider)?.id ?? '';
    final notificationsAsync = ref.watch(userNotificationsProvider(userId));

    return Scaffold(
      appBar: AppBar(
        leading: const DrawerIconButton(),
        title: const Text('الإشعارات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'تحديد الكل كمقروء',
            onPressed: () {
              ref
                  .read(notificationNotifierProvider.notifier)
                  .markAllAsRead(userId);
              ref.invalidate(userNotificationsProvider(userId));
              ref.invalidate(unreadNotificationCountProvider(userId));
            },
          ),
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'deleteAll',
                child: Text('حذف الكل'),
              ),
            ],
            onSelected: (value) {
              if (value == 'deleteAll') {
                _confirmDeleteAll(context, ref, userId);
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/notifications/create'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return _buildEmptyState(context);
          }

          final grouped = _groupByDate(notifications);

          return ListView(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.l,
              vertical: AppSpacing.s,
            ),
            children: [
              if (grouped.$1.isNotEmpty) ...[
                _buildSectionHeader('اليوم'),
                ...grouped.$1.map(
                  (n) => _buildNotificationCard(context, ref, n, userId),
                ),
              ],
              if (grouped.$2.isNotEmpty) ...[
                _buildSectionHeader('أمس'),
                ...grouped.$2.map(
                  (n) => _buildNotificationCard(context, ref, n, userId),
                ),
              ],
              if (grouped.$3.isNotEmpty) ...[
                _buildSectionHeader('أقدم'),
                ...grouped.$3.map(
                  (n) => _buildNotificationCard(context, ref, n, userId),
                ),
              ],
              const SizedBox(height: 80),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildErrorState(e),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: AppSpacing.l,
        bottom: AppSpacing.s,
      ),
      child: Text(
        title,
        style: AppTextStyles.label.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    WidgetRef ref,
    AppNotification notification,
    String userId,
  ) {
    final type = notification.type;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsetsDirectional.only(bottom: AppSpacing.s),
        padding: EdgeInsetsDirectional.only(start: AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: AppSpacing.radiusMD,
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('حذف الإشعار'),
            content: const Text('هل أنت متأكد من حذف هذا الإشعار؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.white,
                ),
                child: const Text('حذف'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        ref
            .read(notificationNotifierProvider.notifier)
            .deleteNotification(notification.id);
        ref.invalidate(userNotificationsProvider(userId));
        ref.invalidate(unreadNotificationCountProvider(userId));
      },
      child: GestureDetector(
        onTap: () {
          if (!notification.isRead) {
            ref
                .read(notificationNotifierProvider.notifier)
                .markAsRead(notification.id);
            ref.invalidate(userNotificationsProvider(userId));
            ref.invalidate(unreadNotificationCountProvider(userId));
          }
          if (notification.actionUrl != null) {
            context.push(notification.actionUrl!);
          }
        },
        child: Dismissible(
          key: ValueKey('mark_read_${notification.id}'),
          direction: notification.isRead
              ? DismissDirection.none
              : DismissDirection.startToEnd,
          background: Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsetsDirectional.only(bottom: AppSpacing.s),
            padding: EdgeInsetsDirectional.only(end: AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: AppSpacing.radiusMD,
            ),
            child: const Icon(Icons.mark_email_read, color: AppColors.white),
          ),
          onDismissed: (_) {
            ref
                .read(notificationNotifierProvider.notifier)
                .markAsRead(notification.id);
            ref.invalidate(userNotificationsProvider(userId));
            ref.invalidate(unreadNotificationCountProvider(userId));
          },
          child: Container(
            margin: EdgeInsetsDirectional.only(bottom: AppSpacing.s),
            decoration: BoxDecoration(
              color: notification.isRead
                  ? AppColors.surface
                  : AppColors.primarySurface.withValues(alpha: 0.3),
              borderRadius: AppSpacing.radiusMD,
              border: Border.all(
                color: notification.isRead
                    ? AppColors.border
                    : AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.all(AppSpacing.m),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTypeIcon(type, notification.isRead),
                  SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: notification.isRead
                                      ? FontWeight.normal
                                      : FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                margin: EdgeInsetsDirectional.only(
                                  start: AppSpacing.s,
                                ),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          notification.body,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          _formatTime(notification.createdAt),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon(NotificationType type, bool isRead) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isRead
            ? AppColors.surfaceVariant
            : _getTypeColor(type).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.s),
      ),
      child: Icon(
        _getTypeIconData(type),
        size: 20,
        color: isRead ? AppColors.textTertiary : _getTypeColor(type),
      ),
    );
  }

  IconData _getTypeIconData(NotificationType type) {
    return switch (type) {
      NotificationType.attendance => Icons.check_circle_outline,
      NotificationType.memorization => Icons.menu_book_outlined,
      NotificationType.tasmi => Icons.mic_none,
      NotificationType.assignment => Icons.assignment_outlined,
      NotificationType.schedule => Icons.calendar_today_outlined,
      NotificationType.report => Icons.bar_chart_outlined,
      NotificationType.system => Icons.settings_outlined,
      NotificationType.reminder => Icons.notifications_active_outlined,
    };
  }

  Color _getTypeColor(NotificationType type) {
    return switch (type) {
      NotificationType.attendance => AppColors.success,
      NotificationType.memorization => AppColors.primary,
      NotificationType.tasmi => AppColors.accent,
      NotificationType.assignment => AppColors.warning,
      NotificationType.schedule => AppColors.info,
      NotificationType.report => AppColors.secondary,
      NotificationType.system => AppColors.textSecondary,
      NotificationType.reminder => AppColors.error,
    };
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

  (List<AppNotification>, List<AppNotification>, List<AppNotification>)
      _groupByDate(List<AppNotification> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayList = <AppNotification>[];
    final yesterdayList = <AppNotification>[];
    final olderList = <AppNotification>[];

    for (final n in notifications) {
      final date = DateTime(
        n.createdAt.year,
        n.createdAt.month,
        n.createdAt.day,
      );
      if (date.isAtSameMomentAs(today)) {
        todayList.add(n);
      } else if (date.isAtSameMomentAs(yesterday)) {
        yesterdayList.add(n);
      } else {
        olderList.add(n);
      }
    }

    return (todayList, yesterdayList, olderList);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_off_outlined,
                size: 40,
                color: AppColors.textTertiary,
              ),
            ),
            AppSpacing.gapLG,
            Text(
              'لا توجد إشعارات',
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapSM,
            Text(
              'ستظهر هنا الإشعارات الجديدة عند وصولها',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    final isConnectionError = error.toString().contains('Connection refused') ||
        error.toString().contains('SocketException');
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isConnectionError ? Icons.wifi_off : Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
            AppSpacing.gapLG,
            Text(
              isConnectionError
                  ? 'تعذر الاتصال بالخادم'
                  : 'خطأ في تحميل الإشعارات',
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            if (isConnectionError) ...[
              AppSpacing.gapSM,
              Text(
                'تأكد من اتصالك بالإنترنت',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmDeleteAll(BuildContext context, WidgetRef ref, String userId) {
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
              ref
                  .read(notificationNotifierProvider.notifier)
                  .deleteAllNotifications(userId);
              ref.invalidate(userNotificationsProvider(userId));
              ref.invalidate(unreadNotificationCountProvider(userId));
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
