import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/report.dart';
import '../../domain/repositories/report_provider.dart';

/// Reports view.
class ReportsView extends ConsumerWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final reportsAsync = ref.watch(branchReportsProvider(''));

    return Scaffold(
      appBar: AppBar(
        title: Text('التقارير'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showGenerateReportDialog(context, ref),
          ),
        ],
      ),
      body: reportsAsync.when(
        data: (reports) {
          if (reports.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assessment, size: 64, color: AppColors.textHint),
                  Gap.l,
                  Text('لا توجد تقارير', style: AppTextStyles.bodyLarge),
                  Gap.m,
                  ElevatedButton.icon(
                    onPressed: () => _showGenerateReportDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('إنشاء تقرير'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(AppSpacing.m),
            itemCount: reports.length,
            itemBuilder: (context, index) =>
                _buildReportCard(context, reports[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, Report report) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.s),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.s),
          ),
          child: Center(
            child: Text(
              report.type.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(report.title, style: AppTextStyles.titleSmall),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              report.type.displayNameAr,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Gap.xs,
            Text(
              DateFormat('yyyy-MM-dd HH:mm').format(report.createdAt),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'download',
              child: Text('تحميل'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('حذف'),
            ),
          ],
          onSelected: (value) {
            if (value == 'delete') {
              _confirmDelete(context, report);
            }
          },
        ),
      ),
    );
  }

  void _showGenerateReportDialog(BuildContext context, WidgetRef ref) {
    ReportType selectedType = ReportType.attendance;
    String title = '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('إنشاء تقرير'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<ReportType>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'نوع التقرير',
                  ),
                  items: ReportType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.displayNameAr),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedType = value);
                    }
                  },
                ),
                Gap.m,
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'عنوان التقرير',
                  ),
                  onChanged: (value) => title = value,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (title.isNotEmpty) {
                    Navigator.of(context).pop();
                    // TODO: Generate report
                  }
                },
                child: const Text('إنشاء'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, Report report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف التقرير'),
        content: Text('هل أنت متأكد من حذف "${report.title}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Delete report
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
