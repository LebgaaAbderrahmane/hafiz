import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/domain/repositories/auth_provider.dart';
import '../../../auth/domain/repositories/user_role_provider.dart';
import '../../../schedule/domain/repositories/schedule_provider.dart';

class ParentPortalView extends ConsumerWidget {
  const ParentPortalView({super.key});

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
              _buildHeader(context, ref),
              Gap.l,
              _buildChildrenSection(context),
              Gap.xl,
              _buildQuickActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحباً، ${user?.fullName ?? 'ولي الأمر'}',
                style: AppTextStyles.headlineMedium,
              ),
              Gap.xs,
              Text(
                'بوابة ولي الأمر',
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

  Widget _buildChildrenSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('أبنائي', style: AppTextStyles.titleLarge),
        Gap.m,
        Card(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.l),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.child_care, size: 64, color: AppColors.textHint),
                  Gap.m,
                  Text(
                    'لم يتم ربط أي أطفال بعد',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Gap.m,
                  Text(
                    'سيظهر أبناؤك هنا بعد ربطهم بحسابك',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textHint,
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

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('إجراءات سريعة', style: AppTextStyles.titleLarge),
        Gap.m,
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                'الحضور',
                'متابعة الحصور اليومية',
                Icons.check_circle,
                AppColors.success,
                () => context.push('/attendance'),
              ),
            ),
            Gap.m,
            Expanded(
              child: _buildActionCard(
                context,
                'التقييمات',
                'متابعة التقييمات والدرجات',
                Icons.star,
                AppColors.accent,
                () => context.push('/assessments'),
              ),
            ),
          ],
        ),
        Gap.m,
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                'المراجعة',
                'جدول المراجعات',
                Icons.book,
                AppColors.primary,
                () => context.push('/revision/me'),
              ),
            ),
            Gap.m,
            Expanded(
              child: _buildActionCard(
                context,
                'التواصل',
                'التواصل مع المعلم',
                Icons.chat,
                AppColors.warning,
                () => context.push('/notifications'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppBorderRadius.m),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              Gap.s,
              Text(title, style: AppTextStyles.titleSmall),
              Gap.xs,
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
