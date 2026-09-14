import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hafiz/features/reports/domain/entities/report.dart';
import 'package:hafiz/features/reports/domain/repositories/report_repository.dart';
import 'package:hafiz/features/reports/data/repositories/report_repository_impl.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';

/// Report repository provider.
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepositoryImpl(Supabase.instance.client);
});

/// Branch reports provider.
final branchReportsProvider =
    FutureProvider.autoDispose.family<List<Report>, String?>((ref, branchId) async {
  final repo = ref.watch(reportRepositoryProvider);
  if (branchId != null) return repo.getBranchReports(branchId: branchId);
  final orgId = ref.watch(activeOrganizationIdProvider);
  if (orgId == null) return [];
  return repo.getOrgReports(organizationId: orgId);
});

/// Report notifier for generating reports.
class ReportNotifier extends StateNotifier<AsyncValue<void>> {
  final ReportRepository _repository;

  ReportNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<Report> generateReport({
    required String organizationId,
    required String branchId,
    required String generatedById,
    required ReportType type,
    required String title,
    Map<String, dynamic>? parameters,
    ReportFormat? format,
  }) async {
    state = const AsyncValue.loading();
    try {
      final report = await _repository.generateReport(
        organizationId: organizationId,
        branchId: branchId,
        generatedById: generatedById,
        type: type,
        title: title,
        parameters: parameters,
        format: format,
      );
      state = const AsyncValue.data(null);
      return report;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deleteReport(String reportId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteReport(reportId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

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

/// Report notifier provider.
final reportNotifierProvider =
    StateNotifierProvider<ReportNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(reportRepositoryProvider);
  return ReportNotifier(repo);
});
