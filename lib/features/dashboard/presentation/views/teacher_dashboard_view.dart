import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/domain/repositories/auth_provider.dart';
import '../../../schedule/domain/repositories/schedule_provider.dart';
import '../../../schedule/domain/entities/session.dart';

class TeacherDashboardView extends ConsumerWidget {
  const TeacherDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final sessionsAsync = ref.watch(sessionsProvider((
      start: todayStart,
      end: todayEnd,
    )));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, user?.fullName ?? 'المعلم'),
              Gap.xl,
              _buildTodaySchedule(context, ref, sessionsAsync),
              Gap.xl,
              _buildPendingTasks(context),
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
              Text('مرحباً، $name', style: AppTextStyles.headlineMedium),
              Gap.xs,
              Text(
                'لوحة تحكم المعلم',
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

  Widget _buildTodaySchedule(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Session>> sessionsAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('جدول اليوم', style: AppTextStyles.titleLarge),
            const Spacer(),
            TextButton(
              onPressed: () => context.push('/schedule'),
              child: const Text('عرض الكل'),
            ),
          ],
        ),
        Gap.m,
        sessionsAsync.when(
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (e, _) => Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.l),
              child: Text('خطأ في تحميل الجدول: $e'),
            ),
          ),
          data: (sessions) {
            if (sessions.isEmpty) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.l),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.event_busy, size: 48, color: AppColors.textHint),
                        Gap.m,
                        Text(
                          'لا توجد حصص اليوم',
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

            return Column(
              children: sessions.take(5).map((session) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Icon(Icons.book, color: AppColors.primary, size: 20),
                    ),
                    title: Text(session.title),
                    subtitle: Text(
                      '${session.startTime} - ${session.endTime}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPendingTasks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('مهام معلقة', style: AppTextStyles.titleLarge),
        Gap.m,
        Card(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.l),
            child: Column(
              children: [
                _buildTaskItem(
                  'تقييم طلاب الحفظ',
                  '5 طلاب بانتظار التقييم',
                  Icons.star,
                  AppColors.accent,
                ),
                const Divider(),
                _buildTaskItem(
                  'مراجعة التسميع',
                  '3 تسميعات بانتظار المراجعة',
                  Icons.mic,
                  AppColors.primary,
                ),
                const Divider(),
                _buildTaskItem(
                  'تحديث الحصور',
                  '2 حصة بانتظار التحديث',
                  Icons.check_circle,
                  AppColors.success,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskItem(String title, String subtitle, IconData icon, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.1),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: AppTextStyles.bodyMedium),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
