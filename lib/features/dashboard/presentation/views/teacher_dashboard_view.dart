import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../auth/domain/repositories/auth_provider.dart';
import '../../../students/domain/repositories/student_provider.dart';
import '../../../classes/domain/repositories/class_provider.dart';
import '../../../revision/domain/repositories/revision_provider.dart';

/// Teacher dashboard — daily view.
class TeacherDashboardView extends ConsumerWidget {
  const TeacherDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context, currentUser?.name ?? 'المعلم'),
              Gap.l,

              // Today's schedule
              _buildTodaySchedule(context, ref),
              Gap.xl,

              // Quick stats
              _buildQuickStats(context, ref),
              Gap.xl,

              // Pending revisions
              _buildPendingRevisions(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name) {
    final now = DateTime.now();
    final hour = now.hour;
    String greeting;
    if (hour < 12) {
      greeting = 'صباح الخير';
    } else if (hour < 17) {
      greeting = 'مساء الخير';
    } else {
      greeting = 'مساء الخير';
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting، $name',
                style: AppTextStyles.headlineMedium,
              ),
              Gap.xs,
              Text(
                'يومك المبارك',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildTodaySchedule(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('جدول اليوم', style: AppTextStyles.titleLarge),
        Gap.m,
        Card(
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
                  Gap.m,
                  OutlinedButton(
                    onPressed: () => context.push('/schedule'),
                    child: const Text('عرض الجدول'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'طلابي',
            '0',
            Icons.people,
            AppColors.primary,
          ),
        ),
        Gap.m,
        Expanded(
          child: _buildStatCard(
            context,
            'فصولي',
            '0',
            Icons.class_,
            AppColors.accent,
          ),
        ),
        Gap.m,
        Expanded(
          child: _buildStatCard(
            context,
            'المراجعات',
            '0',
            Icons.book,
            AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.m),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            Gap.s,
            Text(value, style: AppTextStyles.headlineSmall.copyWith(color: color)),
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

  Widget _buildPendingRevisions(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('المراجعات المعلقة', style: AppTextStyles.titleLarge),
            const Spacer(),
            TextButton(
              onPressed: () => context.push('/quran-progress'),
              child: const Text('عرض الكل'),
            ),
          ],
        ),
        Gap.m,
        Card(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.l),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline, size: 48, color: AppColors.success),
                  Gap.m,
                  Text(
                    'لا توجد مراجعات معلقة',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
