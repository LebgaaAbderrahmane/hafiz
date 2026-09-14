import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/drawer_icon_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../auth/domain/repositories/user_role_provider.dart';
import '../../domain/entities/report.dart';
import '../../domain/repositories/report_provider.dart';

/// Reports hub view — category-based report browser.
class ReportsView extends ConsumerWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchId = ref.watch(activeBranchIdProvider);
    final reportsAsync = ref.watch(branchReportsProvider(branchId));

    return Scaffold(
      appBar: AppBar(
        leading: const DrawerIconButton(),
        title: Text(context.l.reportsTitle),
      ),
      body: reportsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Text(
            context.l.reportsErrorLoading,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
          ),
        ),
        data: (reports) => _buildBody(context, reports),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<Report> reports) {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Gap.l,
          _buildCategoriesGrid(context),
          if (reports.isNotEmpty) ...[
            Gap.xxl,
            _buildRecentReports(context, reports),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l.reportsStatistics, style: AppTextStyles.headlineMedium),
        Gap.xs,
        Text(
          context.l.reportsSubtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l.reportsCategories, style: AppTextStyles.titleLarge),
        Gap.m,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.m,
            crossAxisSpacing: AppSpacing.m,
            childAspectRatio: 1.4,
          ),
          itemCount: ReportCategory.values.length,
          itemBuilder: (context, index) {
            final category = ReportCategory.values[index];
            return _buildCategoryCard(context, category);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, ReportCategory category) {
    return AppCard(
      onTap: () => context.push('/reports/${category.name}'),
      padding: EdgeInsetsDirectional.all(AppSpacing.l),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                category.icon,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          Gap.m,
          Text(
            category.displayNameAr,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          Gap.xs,
          Text(
            '${category.reportTypes.length} ${context.l.reportsReportCount}',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReports(BuildContext context, List<Report> reports) {
    final recent = reports.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(context.l.reportsRecent, style: AppTextStyles.titleLarge),
            const Spacer(),
          ],
        ),
        Gap.m,
        ...recent.map((report) => _buildRecentReportItem(context, report)),
      ],
    );
  }

  Widget _buildRecentReportItem(BuildContext context, Report report) {
    return Card(
      margin: EdgeInsetsDirectional.only(bottom: AppSpacing.s),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.s),
          ),
          child: Center(
            child: Text(
              report.type.icon,
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
        title: Text(
          report.title,
          style: AppTextStyles.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          report.type.displayNameAr,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Text(
          _formatDate(context, report.createdAt),
          style: AppTextStyles.caption,
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 7) return '${date.day}/${date.month}';
    if (diff.inDays > 0) return '${diff.inDays} ${context.l.reportsDaysAgo}';
    if (diff.inHours > 0) return '${diff.inHours} ${context.l.reportsHoursAgo}';
    return context.l.reportsNow;
  }
}
