import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/revision.dart';
import '../../domain/repositories/revision_provider.dart';

/// Revision tracking view — shows revision schedule and progress.
class RevisionTrackingView extends ConsumerWidget {
  final String studentId;

  const RevisionTrackingView({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final revisionsAsync = ref.watch(studentRevisionsProvider(studentId));
    final statsAsync = ref.watch(studentRevisionStatsProvider(studentId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quranProgress),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Stats overview
          statsAsync.when(
            data: (stats) => _buildStatsBar(context, stats),
            loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
            error: (e, st) => SizedBox(height: 100, child: Center(child: Text('Error: $e'))),
          ),

          // Revision list
          Expanded(
            child: revisionsAsync.when(
              data: (revisions) {
                if (revisions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book, size: 64, color: AppColors.textHint),
                        Gap.l,
                        Text('لا توجد مراجعات', style: AppTextStyles.bodyLarge),
                      ],
                    ),
                  );
                }

                final overdue = revisions.where((r) =>
                    r.dueDate != null &&
                    r.dueDate!.isBefore(DateTime.now()) &&
                    r.status != RevisionStatus.completed).toList();
                final upcoming = revisions.where((r) =>
                    r.dueDate != null && r.dueDate!.isAfter(DateTime.now())).toList();
                final completed = revisions.where(
                    (r) => r.status == RevisionStatus.completed).toList();

                return ListView(
                  padding: EdgeInsets.all(AppSpacing.l),
                  children: [
                    if (overdue.isNotEmpty) ...[
                      _buildSectionHeader(context, 'متأخرة', overdue.length, AppColors.error),
                      ...overdue.map((r) => _buildRevisionCard(context, ref, r)),
                      Gap.m,
                    ],
                    if (upcoming.isNotEmpty) ...[
                      _buildSectionHeader(context, 'القادمة', upcoming.length, AppColors.primary),
                      ...upcoming.map((r) => _buildRevisionCard(context, ref, r)),
                      Gap.m,
                    ],
                    if (completed.isNotEmpty) ...[
                      _buildSectionHeader(context, 'مكتملة', completed.length, AppColors.success),
                      ...completed.map((r) => _buildRevisionCard(context, ref, r)),
                    ],
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar(BuildContext context, Map<String, dynamic> stats) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Row(
        children: [
          _buildStatItem(context, 'الإجمالي', stats['total'] ?? 0, AppColors.primary),
          _buildStatItem(context, 'مكتمل', stats['completed'] ?? 0, AppColors.success),
          _buildStatItem(context, 'متأخر', stats['overdue'] ?? 0, AppColors.error),
          _buildStatItem(context, 'المعدل', stats['averageScore'] ?? 0, AppColors.accent),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, int value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value.toString(),
            style: AppTextStyles.headlineMedium.copyWith(color: color),
          ),
          Gap.xs,
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.s),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Gap.s,
          Text(title, style: AppTextStyles.titleMedium),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppBorderRadius.s),
            ),
            child: Text(
              count.toString(),
              style: AppTextStyles.bodySmall.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevisionCard(BuildContext context, WidgetRef ref, Revision revision) {
    final statusColor = Color(revision.status.colorValue);
    final isOverdue = revision.dueDate != null &&
        revision.dueDate!.isBefore(DateTime.now()) &&
        revision.status != RevisionStatus.completed;

    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.s),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppBorderRadius.m),
        onTap: () => _showRevisionDetail(context, ref, revision),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.m),
          child: Row(
            children: [
              // Status indicator
              Container(
                width: 8,
                height: 48,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Gap.m,

              // Revision info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'سورة ${revision.surahNumber}',
                          style: AppTextStyles.titleSmall,
                        ),
                        Gap.s,
                        Text(
                          'آية ${revision.startAyah}-${revision.endAyah}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Gap.xs,
                    Row(
                      children: [
                        _buildStatusChip(revision.status),
                        Gap.s,
                        if (revision.qualityScore != null) ...[
                          Icon(Icons.star, size: 14, color: AppColors.accent),
                          Gap.xs,
                          Text(
                            revision.qualityScore.toString(),
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Due date
              if (revision.dueDate != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('dd/MM').format(revision.dueDate!),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isOverdue ? AppColors.error : AppColors.textSecondary,
                      ),
                    ),
                    if (isOverdue)
                      Text(
                        'متأخر',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(RevisionStatus status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Color(status.colorValue).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.s),
      ),
      child: Text(
        status.displayNameAr,
        style: AppTextStyles.labelSmall.copyWith(
          color: Color(status.colorValue),
        ),
      ),
    );
  }

  void _showRevisionDetail(BuildContext context, WidgetRef ref, Revision revision) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Gap.l,
                Text(
                  'تفاصيل المراجعة',
                  style: AppTextStyles.headlineSmall,
                ),
                Gap.m,
                _buildDetailRow('السورة', 'سورة ${revision.surahNumber}'),
                _buildDetailRow('الآيات', '${revision.startAyah} - ${revision.endAyah}'),
                _buildDetailRow('الحالة', revision.status.displayNameAr),
                _buildDetailRow('الأولوية', revision.priority.displayNameAr),
                if (revision.dueDate != null)
                  _buildDetailRow('موعد المراجعة', DateFormat('yyyy-MM-dd').format(revision.dueDate!)),
                if (revision.qualityScore != null)
                  _buildDetailRow('الجودة', '${revision.qualityScore}/10'),
                if (revision.reviewCount != null)
                  _buildDetailRow('عدد المراجعات', revision.reviewCount.toString()),
                if (revision.notes != null && revision.notes!.isNotEmpty) ...[
                  Gap.m,
                  Text('ملاحظات', style: AppTextStyles.titleSmall),
                  Gap.s,
                  Text(revision.notes!, style: AppTextStyles.bodyMedium),
                ],
                Gap.xl,
                if (revision.status != RevisionStatus.completed)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showCompleteDialog(context, ref, revision);
                      },
                      child: const Text('تسجيل المراجعة'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.s),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          Text(value, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  void _showCompleteDialog(BuildContext context, WidgetRef ref, Revision revision) {
    int qualityScore = 7;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل المراجعة'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('جودة المراجعة: $qualityScore/10'),
                Slider(
                  value: qualityScore.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (value) => setState(() => qualityScore = value.round()),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(revisionNotifierProvider.notifier).completeRevision(
                    revisionId: revision.id,
                    qualityScore: qualityScore,
                  );
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('تسجيل'),
          ),
        ],
      ),
    );
  }
}
