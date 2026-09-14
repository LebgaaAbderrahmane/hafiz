# Reports & Analytics Module — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign the Reports module from a flat list into a category-based analytics hub with report detail views, date range filtering, and summary statistics.

**Architecture:** Rewrite `reports_view.dart` as a category selector (Students, Qur'an, Attendance, Teachers, Classes). Each category shows available report types. Tapping a report type navigates to a new `report_detail_view.dart` with summary cards + data table. New providers power each report type's data. All Arabic RTL, using existing theme tokens.

**Tech Stack:** Flutter, Riverpod, GoRouter, Freezed, Supabase

**Spec:** `lib/features/reports/` existing files + AGENTS.md conventions

## Global Constraints

- Flutter 3.47.2 stable, Dart 3.13.2
- Arabic is primary language (RTL) — use `EdgeInsetsDirectional`, `AlignmentDirectional`
- All user-facing strings in Arabic
- Use existing theme tokens from `core/theme/theme.dart`
- Use existing widgets: `AppCard`, `AppMetricCard`, `AppButton`, `AppEmptyState`, `AppErrorWidget`, `AppLoading`, `AppBadge`
- Riverpod for state management (`ConsumerWidget` / `ConsumerStatefulWidget`)
- GoRouter for navigation (`context.push`)
- Freezed for models

---

## File Map

| Action | File | Purpose |
|--------|------|---------|
| Modify | `lib/features/reports/presentation/views/reports_view.dart` | Category-based report hub |
| Create | `lib/features/reports/presentation/views/report_detail_view.dart` | Report detail with stats + data table |
| Modify | `lib/features/reports/domain/repositories/report_provider.dart` | Add providers for each report type |
| Modify | `lib/core/router/app_router.dart` | Add `/reports/:category` route |
| Modify | `lib/features/reports/domain/entities/report.dart` | Add report category enum |

---

## Task 1: Add Report Category Enum to Entity

**Files:**
- Modify: `lib/features/reports/domain/entities/report.dart:31-39`

**Interfaces:**
- Consumes: existing `ReportType` enum
- Produces: new `ReportCategory` enum with `displayNameAr` and `icon` getters, `reportTypes` getter

- [ ] **Step 1: Add `ReportCategory` enum and extension after `ReportType` enum**

```dart
/// Report category for grouping.
enum ReportCategory {
  students,
  quran,
  attendance,
  teachers,
  classes,
}

/// Extension for display names.
extension ReportCategoryExtension on ReportCategory {
  String get displayNameAr {
    return switch (this) {
      ReportCategory.students => 'الطلاب',
      ReportCategory.quran => 'القرآن والحفظ',
      ReportCategory.attendance => 'الحضور',
      ReportCategory.teachers => 'المعلمون',
      ReportCategory.classes => 'الفصول',
    };
  }

  String get icon {
    return switch (this) {
      ReportCategory.students => '👨‍🎓',
      ReportCategory.quran => '📖',
      ReportCategory.attendance => '✓',
      ReportCategory.teachers => '👨‍🏫',
      ReportCategory.classes => '🏫',
    };
  }

  List<ReportType> get reportTypes {
    return switch (this) {
      ReportCategory.students => [
        ReportType.studentPerformance,
      ],
      ReportCategory.quran => [
        ReportType.memorizationProgress,
        ReportType.tasmiSummary,
      ],
      ReportCategory.attendance => [
        ReportType.attendance,
      ],
      ReportCategory.teachers => [
        ReportType.teacherPerformance,
      ],
      ReportCategory.classes => [
        ReportType.classOverview,
      ],
    };
  }
}
```

- [ ] **Step 2: Run code generation**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: Success (no changes to .g.dart needed — enum is not serialized)

- [ ] **Step 3: Commit**

```bash
git add lib/features/reports/domain/entities/report.dart
git commit -m "feat(reports): add ReportCategory enum for category-based grouping"
```

---

## Task 2: Add Report Type Providers

**Files:**
- Modify: `lib/features/reports/domain/repositories/report_provider.dart:1-74`

**Interfaces:**
- Consumes: `reportRepositoryProvider` (existing), `activeBranchIdProvider` (existing)
- Produces: `studentProgressReportProvider`, `attendanceReportProvider`, `memorizationReportProvider`

- [ ] **Step 1: Add three new providers after `branchReportsProvider`**

```dart
/// Date range state for reports.
class ReportDateRange {
  final DateTime startDate;
  final DateTime endDate;

  const ReportDateRange({
    required this.startDate,
    required this.endDate,
  });
}

/// Default date range: last 30 days.
final reportDateRangeProvider = StateProvider<ReportDateRange>((ref) {
  final now = DateTime.now();
  return ReportDateRange(
    startDate: now.subtract(const Duration(days: 30)),
    endDate: now,
  );
});

/// Student progress report data.
final studentProgressReportProvider =
    FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final repo = ref.watch(reportRepositoryProvider);
  final branchId = ref.watch(activeBranchIdProvider);
  final dateRange = ref.watch(reportDateRangeProvider);
  if (branchId == null) return null;
  return repo.getMemorizationProgressData(
    branchId: branchId,
    startDate: dateRange.startDate,
    endDate: dateRange.endDate,
  );
});

/// Attendance report data.
final attendanceReportProvider =
    FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final repo = ref.watch(reportRepositoryProvider);
  final branchId = ref.watch(activeBranchIdProvider);
  final dateRange = ref.watch(reportDateRangeProvider);
  if (branchId == null) return null;
  return repo.getAttendanceReportData(
    branchId: branchId,
    startDate: dateRange.startDate,
    endDate: dateRange.endDate,
  );
});

/// Memorization report data.
final memorizationReportProvider =
    FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final repo = ref.watch(reportRepositoryProvider);
  final branchId = ref.watch(activeBranchIdProvider);
  final dateRange = ref.watch(reportDateRangeProvider);
  if (branchId == null) return null;
  return repo.getMemorizationProgressData(
    branchId: branchId,
    startDate: dateRange.startDate,
    endDate: dateRange.endDate,
  );
});
```

- [ ] **Step 2: Verify imports are correct** — file already imports all needed dependencies

- [ ] **Step 3: Commit**

```bash
git add lib/features/reports/domain/repositories/report_provider.dart
git commit -m "feat(reports): add providers for student, attendance, and memorization reports"
```

---

## Task 3: Add Route for Report Detail

**Files:**
- Modify: `lib/core/router/app_router.dart:39` (add import)
- Modify: `lib/core/router/app_router.dart:258-261` (add child route)

**Interfaces:**
- Consumes: `ReportDetailView` (created in Task 4)
- Produces: `/reports/:category` route accessible via `context.push('/reports/attendance')`

- [ ] **Step 1: Add import at top of router file**

After line 39 (`import 'package:hafiz/features/reports/presentation/views/reports_view.dart';`), add:

```dart
import 'package:hafiz/features/reports/presentation/views/report_detail_view.dart';
```

- [ ] **Step 2: Replace the reports route (lines 258-261) with nested routes**

Replace:
```dart
GoRoute(
  path: '/reports',
  builder: (context, state) => const ReportsView(),
),
```

With:
```dart
GoRoute(
  path: '/reports',
  builder: (context, state) => const ReportsView(),
  routes: [
    GoRoute(
      path: ':category',
      builder: (context, state) => ReportDetailView(
        category: state.pathParameters['category']!,
      ),
    ),
  ],
),
```

- [ ] **Step 3: Verify no duplicate imports**

- [ ] **Step 4: Commit**

```bash
git add lib/core/router/app_router.dart
git commit -m "feat(reports): add report detail route with category parameter"
```

---

## Task 4: Create Report Detail View

**Files:**
- Create: `lib/features/reports/presentation/views/report_detail_view.dart`

**Interfaces:**
- Consumes: `ReportCategory` (from Task 1), report providers (from Task 2), theme tokens, `AppCard`, `AppMetricCard`, `AppBadge`, `AppErrorWidget`, `AppLoading`, `AppEmptyState`
- Produces: navigable detail view at `/reports/:category`

- [ ] **Step 1: Create the file**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_button.dart';
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
        onRetry: () => ref.invalidate(provider!),
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
      _ => [],
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

  FutureProvider<Map<String, dynamic>?>? _getProviderForCategory() {
    return switch (_category) {
      ReportCategory.attendance => attendanceReportProvider,
      ReportCategory.quran || ReportCategory.students => memorizationReportProvider,
      _ => null,
    };
  }
}
```

- [ ] **Step 2: Verify no analysis errors**

Run: `flutter analyze lib/features/reports/presentation/views/report_detail_view.dart`
Expected: No errors (warnings acceptable for unused imports if any)

- [ ] **Step 3: Fix any issues from analysis**

- [ ] **Step 4: Commit**

```bash
git add lib/features/reports/presentation/views/report_detail_view.dart
git commit -m "feat(reports): create report detail view with summary cards and data table"
```

---

## Task 5: Redesign Reports View as Category Hub

**Files:**
- Rewrite: `lib/features/reports/presentation/views/reports_view.dart:1-220`

**Interfaces:**
- Consumes: `ReportCategory` (from Task 1), `branchReportsProvider` (existing), theme tokens, `AppCard`, `AppEmptyState`, `AppErrorWidget`
- Produces: category-based hub that navigates to `/reports/:category`

- [ ] **Step 1: Rewrite the file**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/drawer_icon_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
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
        title: const Text('التقارير'),
      ),
      body: reportsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Text(
            'خطأ في تحميل التقارير',
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
          _buildHeader(),
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('التقارير والإحصائيات', style: AppTextStyles.headlineMedium),
        Gap.xs,
        Text(
          'اختر تصنيفاً لعرض التقارير المتاحة',
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
        Text('التصنيفات', style: AppTextStyles.titleLarge),
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
            '${category.reportTypes.length} تقارير',
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
            Text('التقارير الأخيرة', style: AppTextStyles.titleLarge),
            const Spacer(),
          ],
        ),
        Gap.m,
        ...recent.map((report) => _buildRecentReportItem(report)),
      ],
    );
  }

  Widget _buildRecentReportItem(Report report) {
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
          _formatDate(report.createdAt),
          style: AppTextStyles.caption,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 7) return '${date.day}/${date.month}';
    if (diff.inDays > 0) return '${diff.inDays} يوم';
    if (diff.inHours > 0) return '${diff.inHours} ساعة';
    return 'الآن';
  }
}
```

- [ ] **Step 2: Run full analysis**

Run: `flutter analyze lib/features/reports/`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add lib/features/reports/presentation/views/reports_view.dart
git commit -m "feat(reports): redesign reports view as category-based hub"
```

---

## Task 6: Verify Full Module

**Files:** All modified/created files

- [ ] **Step 1: Run flutter analyze on the whole project**

Run: `flutter analyze`
Expected: No new errors (existing warnings acceptable)

- [ ] **Step 2: Verify the route works**

Check that `app_router.dart` imports both views and has the nested route.

- [ ] **Step 3: Verify code generation**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: No conflicts

- [ ] **Step 4: Final commit with all fixes if needed**

```bash
git add -A
git commit -m "chore(reports): verify reports module compiles cleanly"
```
