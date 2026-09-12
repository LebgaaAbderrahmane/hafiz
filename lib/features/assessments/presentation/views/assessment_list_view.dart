import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/domain/repositories/user_role_provider.dart';
import '../../domain/entities/assessment.dart';
import '../../domain/repositories/assessment_provider.dart';

/// Assessment list view.
class AssessmentListView extends ConsumerStatefulWidget {
  const AssessmentListView({super.key});

  @override
  ConsumerState<AssessmentListView> createState() => _AssessmentListViewState();
}

class _AssessmentListViewState extends ConsumerState<AssessmentListView> {
  AssessmentType? _selectedType;

  @override
  Widget build(BuildContext context) {
    final branchId = ref.watch(activeBranchIdProvider) ?? '';
    final assessmentsAsync = ref.watch(branchAssessmentsProvider(branchId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('التقييمات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: assessmentsAsync.when(
        data: (assessments) {
          final filtered = _selectedType != null
              ? assessments.where((a) => a.type == _selectedType).toList()
              : assessments;

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assessment_outlined, size: 64, color: AppColors.textHint),
                  Gap.l,
                  Text('لا توجد تقييمات', style: AppTextStyles.bodyLarge),
                  Gap.s,
                  Text(
                    'اضغط + لإنشاء تقييم جديد',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.s),
            itemCount: filtered.length,
            itemBuilder: (context, index) =>
                _buildAssessmentCard(context, filtered[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('خطأ: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/assessments/create'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAssessmentCard(BuildContext context, Assessment assessment) {
    final typeColor = switch (assessment.type) {
      AssessmentType.quiz => AppColors.primary,
      AssessmentType.exam => AppColors.error,
      AssessmentType.memorization => AppColors.success,
      AssessmentType.tajwid => AppColors.warning,
      AssessmentType.reading => AppColors.accent,
      AssessmentType.participation => AppColors.textSecondary,
    };

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: typeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.s),
          ),
          child: Center(
            child: Text(
              assessment.type.displayNameAr[0],
              style: AppTextStyles.titleLarge.copyWith(color: typeColor),
            ),
          ),
        ),
        title: Text(assessment.title, style: AppTextStyles.titleSmall),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap.xs,
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppBorderRadius.s),
                  ),
                  child: Text(
                    assessment.type.displayNameAr,
                    style: AppTextStyles.labelSmall.copyWith(color: typeColor),
                  ),
                ),
                Gap.s,
                Text(
                  DateFormat('dd/MM/yyyy').format(assessment.assessmentDate),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_left),
        onTap: () => context.push('/assessments/${assessment.id}'),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.filter_list),
              title: const Text('تصفية حسب النوع'),
            ),
            ListTile(
              title: const Text('الكل'),
              onTap: () {
                setState(() => _selectedType = null);
                Navigator.pop(context);
              },
            ),
            ...AssessmentType.values.map(
              (type) => ListTile(
                title: Text(type.displayNameAr),
                onTap: () {
                  setState(() => _selectedType = type);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
