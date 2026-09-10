import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../auth/domain/repositories/auth_provider.dart';
import '../../../students/domain/repositories/student_provider.dart';
import '../../../teachers/domain/repositories/teacher_provider.dart';
import '../../../classes/domain/repositories/class_provider.dart';

/// Owner dashboard — main control center.
class OwnerDashboardView extends ConsumerWidget {
  const OwnerDashboardView({super.key});

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
              _buildHeader(context, currentUser?.fullName ?? 'المالك'),
              Gap.l,

              // Quick stats
              _buildQuickStats(context, ref),
              Gap.xl,

              // Quick actions
              _buildQuickActions(context),
              Gap.xl,

              // Recent activity
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
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(branchStudentsProvider(''));
    final teachersAsync = ref.watch(branchTeachersProvider(''));
    final classesAsync = ref.watch(branchClassesProvider(''));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('نظرة عامة', style: AppTextStyles.titleLarge),
        Gap.m,
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'الطلاب',
                studentsAsync.when(
                  data: (s) => s.length.toString(),
                  loading: () => '...',
                  error: (_, __) => '0',
                ),
                Icons.people,
                AppColors.primary,
              ),
            ),
            Gap.m,
            Expanded(
              child: _buildStatCard(
                context,
                'المعلمون',
                teachersAsync.when(
                  data: (t) => t.length.toString(),
                  loading: () => '...',
                  error: (_, __) => '0',
                ),
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
                classesAsync.when(
                  data: (c) => c.length.toString(),
                  loading: () => '...',
                  error: (_, __) => '0',
                ),
                Icons.class_,
                AppColors.success,
              ),
            ),
            Gap.m,
            Expanded(
              child: _buildStatCard(
                context,
                'الحصص اليوم',
                '0',
                Icons.schedule,
                AppColors.warning,
              ),
            ),
          ],
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
                () {},
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
                () {},
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('النشاط الأخير', style: AppTextStyles.titleLarge),
        Gap.m,
        Card(
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
        ),
      ],
    );
  }
}
