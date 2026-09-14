import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/report.dart';
import '../../domain/repositories/report_provider.dart';

/// Report detail view — shows summary stats and data table for a report category.
class ReportDetailView extends ConsumerStatefulWidget {
  const ReportDetailView({super.key, required this.category});

  final String category;

  @override
  ConsumerState<ReportDetailView> createState() => _ReportDetailViewState();
}

class _ReportDetailViewState extends ConsumerState<ReportDetailView> {
  ReportCategory get _category {
    return ReportCategory.values.firstWhere(
      (c) => c.name == widget.category,
      orElse: () => ReportCategory.students,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_category.displayNameAr),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _pickDateRange,
            tooltip: 'اختيار الفترة',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
            tooltip: 'تصدير',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final dateRange = ref.watch(reportDateRangeProvider);

    return Column(
      children: [
        _buildDateRangeHeader(dateRange),
        Expanded(child: _buildReportContent()),
      ],
    );
  }

  Widget _buildDateRangeHeader(ReportDateRange dateRange) {
    final dateFormat = DateFormat('yyyy/MM/dd', 'ar');
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
          Gap.s,
          Text(
            '${dateFormat.format(dateRange.startDate)} — ${dateFormat.format(dateRange.endDate)}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent() {
    final provider = _getProviderForCategory();
    if (provider == null) {
      return AppEmptyState(
        title: 'لا توجد بيانات',
        description: 'لم يتم العثور على بيانات لهذا التقرير',
        icon: Icons.assessment_outlined,
      );
    }

    final asyncData = ref.watch(provider);

    return asyncData.when(
      loading: () => const AppLoading(message: 'جاري تحميل التقرير...'),
      error: (e, st) => AppErrorWidget(
        message: 'حدث خطأ أثناء تحميل التقرير',
        title: 'خطأ',
        onRetry: () => ref.invalidate(provider),
      ),
      data: (data) {
        if (data == null || data.isEmpty) {
          return AppEmptyState(
            title: 'لا توجد بيانات',
            description: 'لم يتم العثور على بيانات للفترة المحددة',
            icon: Icons.assessment_outlined,
          );
        }
        return _buildReportBody(data);
      },
    );
  }

  Widget _buildReportBody(Map<String, dynamic> data) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(data),
          Gap.xl,
          _buildDataTable(data),
          Gap.xl,
          _buildExportSection(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(Map<String, dynamic> data) {
    final cards = _getSummaryCards(data);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ملخص', style: AppTextStyles.titleLarge),
        Gap.m,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.m,
            crossAxisSpacing: AppSpacing.m,
            childAspectRatio: 1.6,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return AppMetricCard(
              label: card['label'] as String,
              value: card['value'].toString(),
              icon: card['icon'] as IconData,
              color: card['color'] as Color,
            );
          },
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getSummaryCards(Map<String, dynamic> data) {
    return switch (_category) {
      ReportCategory.attendance => [
        {
          'label': 'الإجمالي',
          'value': data['total'] ?? 0,
          'icon': Icons.people,
          'color': AppColors.primary,
        },
        {
          'label': 'حاضرون',
          'value': data['present'] ?? 0,
          'icon': Icons.check_circle,
          'color': AppColors.success,
        },
        {
          'label': 'غائبون',
          'value': data['absent'] ?? 0,
          'icon': Icons.cancel,
          'color': AppColors.error,
        },
        {
          'label': 'متأخرون',
          'value': data['late'] ?? 0,
          'icon': Icons.watch_later,
          'color': AppColors.warning,
        },
      ],
      ReportCategory.quran || ReportCategory.students => [
        {
          'label': 'الإجمالي',
          'value': data['total'] ?? 0,
          'icon': Icons.book,
          'color': AppColors.primary,
        },
        {
          'label': 'مكتمل',
          'value': data['completed'] ?? 0,
          'icon': Icons.check_circle,
          'color': AppColors.success,
        },
        {
          'label': 'قيد التنفيذ',
          'value': data['inProgress'] ?? 0,
          'icon': Icons.pending,
          'color': AppColors.info,
        },
        {
          'label': 'النسبة',
          'value': _calcPercentage(
            data['completed'] ?? 0,
            data['total'] ?? 1,
          ),
          'icon': Icons.percent,
          'color': AppColors.warning,
        },
      ],
      ReportCategory.teachers => [
        {
          'label': 'الإجمالي',
          'value': data['total'] ?? 0,
          'icon': Icons.person,
          'color': AppColors.primary,
        },
        {
          'label': 'نشطون',
          'value': data['active'] ?? 0,
          'icon': Icons.check_circle,
          'color': AppColors.success,
        },
      ],
      ReportCategory.classes => [
        {
          'label': 'الإجمالي',
          'value': data['total'] ?? 0,
          'icon': Icons.class_,
          'color': AppColors.primary,
        },
        {
          'label': 'نشطون',
          'value': data['active'] ?? 0,
          'icon': Icons.check_circle,
          'color': AppColors.success,
        },
      ],
    };
  }

  Widget _buildDataTable(Map<String, dynamic> data) {
    final rows = _getDataRows(data);
    if (rows.isEmpty) {
      return AppEmptyState(
        title: 'لا توجد سجلات',
        icon: Icons.table_chart_outlined,
      );
    }

    final columns = rows.first.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('البيانات', style: AppTextStyles.titleLarge),
        Gap.m,
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: columns
                  .map((col) => DataColumn(
                        label: Text(
                          col,
                          style: AppTextStyles.label,
                        ),
                      ))
                  .toList(),
              rows: rows
                  .map((row) => DataRow(
                        cells: columns
                            .map((col) => DataCell(
                                  Text(
                                    row[col]?.toString() ?? '—',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ))
                            .toList(),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getDataRows(Map<String, dynamic> data) {
    final records = (data['records'] ?? data['assignments'] ?? data['sessions'] ?? []) as List;
    if (records.isEmpty) return [];

    return switch (_category) {
      ReportCategory.attendance => records.map((r) {
          return {
            'التاريخ': r['date']?.toString().substring(0, 10) ?? '—',
            'الحالة': _translateStatus(r['status']?.toString()),
            'الملاحظات': r['notes'] ?? '—',
          };
        }).toList(),
      ReportCategory.quran || ReportCategory.students => records.map((r) {
          return {
            'السورة': r['surah_name'] ?? '—',
            'الآيات': '${r['start_ayah'] ?? ''}-${r['end_ayah'] ?? ''}',
            'الحالة': _translateStatus(r['status']?.toString()),
            'التقييم': r['evaluation'] ?? '—',
          };
        }).toList(),
      ReportCategory.teachers => records.map((r) {
          return {
            'المعلم': r['teacher_name'] ?? '—',
            'الفصل': r['class_name'] ?? '—',
            'الحصص': '${r['sessions_count'] ?? 0}',
            'النسبة': _calcPercentage(
              r['completed'] ?? 0,
              r['total'] ?? 1,
            ),
          };
        }).toList(),
      ReportCategory.classes => records.map((r) {
          return {
            'الفصل': r['class_name'] ?? '—',
            'المعلم': r['teacher_name'] ?? '—',
            'الطلاب': '${r['students_count'] ?? 0}',
            'معدل الحضور': r['attendance_rate'] ?? '—',
          };
        }).toList(),
    };
  }

  String _translateStatus(String? status) {
    return switch (status) {
      'present' => 'حاضر',
      'absent' => 'غائب',
      'late' => 'متأخر',
      'completed' => 'مكتمل',
      'in_progress' => 'قيد التنفيذ',
      'passed' => 'ناجح',
      'needs_review' => 'يحتاج مراجعة',
      'active' => 'نشط',
      _ => status ?? '—',
    };
  }

  String _calcPercentage(int part, int total) {
    if (total == 0) return '0%';
    return '${((part / total) * 100).toStringAsFixed(1)}%';
  }

  Future<void> _pickDateRange() async {
    final dateRange = ref.read(reportDateRangeProvider);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: dateRange.startDate,
        end: dateRange.endDate,
      ),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      ref.read(reportDateRangeProvider.notifier).state = ReportDateRange(
        startDate: picked.start,
        endDate: picked.end,
      );
    }
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم إضافة التصدير قريباً'),
      ),
    );
  }

  Widget _buildExportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('تصدير', style: AppTextStyles.titleLarge),
        Gap.m,
        Row(
          children: [
            Expanded(
              child: AppCard(
                onTap: _exportReport,
                child: Column(
                  children: [
                    Icon(Icons.picture_as_pdf, color: AppColors.error, size: 32),
                    Gap.s,
                    Text('PDF', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
            ),
            Gap.m,
            Expanded(
              child: AppCard(
                onTap: _exportReport,
                child: Column(
                  children: [
                    Icon(Icons.table_chart, color: AppColors.success, size: 32),
                    Gap.s,
                    Text('CSV', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
            ),
            Gap.m,
            Expanded(
              child: AppCard(
                onTap: _exportReport,
                child: Column(
                  children: [
                    Icon(Icons.grid_on, color: AppColors.info, size: 32),
                    Gap.s,
                    Text('Excel', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  AutoDisposeFutureProvider<Map<String, dynamic>?>? _getProviderForCategory() {
    return switch (_category) {
      ReportCategory.attendance => attendanceReportProvider,
      ReportCategory.quran || ReportCategory.students => memorizationReportProvider,
      ReportCategory.teachers => null,
      ReportCategory.classes => null,
    };
  }
}
