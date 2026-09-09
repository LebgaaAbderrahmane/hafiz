import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../auth/domain/repositories/auth_provider.dart';

/// Parent portal — view for guardians to track their children.
class ParentPortalView extends ConsumerWidget {
  const ParentPortalView({super.key});

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
              _buildHeader(context, currentUser?.name ?? 'ولي الأمر'),
              Gap.l,

              // Children list
              _buildChildrenSection(context),
              Gap.xl,

              // Quick actions
              _buildQuickActions(context),
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
          onPressed: () {},
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
                'الحصور',
                'متابعة الحصور اليومية',
                Icons.check_circle,
                AppColors.success,
                () {},
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
                () {},
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
                () {},
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
                () {},
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
