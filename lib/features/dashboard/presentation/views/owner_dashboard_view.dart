import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/domain/repositories/auth_provider.dart';
import '../../domain/repositories/dashboard_provider.dart';
import '../../../notifications/domain/repositories/notification_provider.dart';
import '../../../notifications/domain/entities/notification.dart';

/// Owner dashboard — main control center.
class OwnerDashboardView extends ConsumerWidget {
  const OwnerDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, currentUser?.fullName ?? 'المالك'),
              Gap.l,
              _buildQuickStats(context, ref),
              Gap.xl,
              _buildQuickActions(context),
              Gap.xl,
              _buildRecentActivity(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحباً، $name',
                style: AppTextStyles.headlineMedium,
              ),
              Gap.xs,
              Text(
                'لوحة التحكم',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => context.push('/notifications'),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('نظرة عامة', style: AppTextStyles.titleLarge),
        Gap.m,
        statsAsync.when(
          data: (stats) => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'الطلاب',
                      stats.totalStudents.toString(),
                      Icons.people,
                      AppColors.primary,
                    ),
                  ),
                  Gap.m,
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'المعلمون',
                      stats.totalTeachers.toString(),
                      Icons.person,
                      AppColors.accent,
                    ),
                  ),
                ],
              ),
              Gap.m,
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'الفصول',
                      stats.totalClasses.toString(),
                      Icons.class_,
                      AppColors.success,
                    ),
                  ),
                  Gap.m,
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'التعيينات المعلقة',
                      stats.pendingAssignments.toString(),
                      Icons.assignment,
                      AppColors.warning,
                    ),
                  ),
                ],
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('خطأ: $e')),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.s),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.s),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            Gap.m,
            Text(
              value,
              style: AppTextStyles.headlineLarge.copyWith(color: color),
            ),
            Gap.xs,
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('إجراءات سريعة', style: AppTextStyles.titleLarge),
        Gap.m,
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'إضافة طالب',
                Icons.person_add,
                AppColors.primary,
                () => context.push('/students/add'),
              ),
            ),
            Gap.m,
            Expanded(
              child: _buildActionButton(
                context,
                'إضافة معلم',
                Icons.person_add,
                AppColors.accent,
                () => context.push('/teachers/add'),
              ),
            ),
          ],
        ),
        Gap.m,
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'إنشاء فصل',
                Icons.add_box,
                AppColors.success,
                () => context.push('/classes/add'),
              ),
            ),
            Gap.m,
            Expanded(
              child: _buildActionButton(
                context,
                'جدولة حصة',
                Icons.event,
                AppColors.warning,
                () => context.push('/schedule'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppBorderRadius.m),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.m),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              Gap.s,
              Text(
                title,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final notificationsAsync = user != null
        ? ref.watch(userNotificationsProvider(user.id))
        : const AsyncValue.data([]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('النشاط الأخير', style: AppTextStyles.titleLarge),
            const Spacer(),
            TextButton(
              onPressed: () => context.push('/notifications'),
              child: const Text('عرض الكل'),
            ),
          ],
        ),
        Gap.m,
        notificationsAsync.when(
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (e, _) => Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.l),
              child: Text('خطأ في تحميل النشاط: $e'),
            ),
          ),
          data: (notifications) {
            if (notifications.isEmpty) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.l),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.history, size: 48, color: AppColors.textHint),
                        Gap.m,
                        Text(
                          'لا يوجد نشاط حديث',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Card(
              child: Column(
                children: notifications.take(5).map((notification) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Icon(
                        _getNotificationIcon(notification.type),
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      notification.title,
                      style: AppTextStyles.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      notification.body,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      _formatTimeAgo(notification.createdAt),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.m,
                      vertical: 2,
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    return switch (type) {
      NotificationType.attendance => Icons.check_circle,
      NotificationType.tasmi => Icons.mic,
      NotificationType.assignment => Icons.book,
      NotificationType.reminder => Icons.alarm,
      NotificationType.memorization => Icons.book,
      NotificationType.schedule => Icons.calendar_today,
      NotificationType.report => Icons.assessment,
      NotificationType.system => Icons.settings,
    };
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return '${diff.inMinutes} د';
    if (diff.inHours < 24) return '${diff.inHours} س';
    if (diff.inDays < 7) return '${diff.inDays} ي';
    return '${(diff.inDays / 7).floor()} أ';
  }
}
